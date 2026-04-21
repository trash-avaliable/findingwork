# wave_manager.gd
extends Node

@onready var player = get_tree().get_first_node_in_group("player")
var current_wave_index: int = 0
var wave_start_time: float = 0.0
var spawn_timer: float = 0.0
var enemies_on_screen: Array[Node] = []   # 用于数量控制

func _ready():
	# 确保玩家在 player 组中
	if not player:
		player = get_tree().get_first_node_in_group("player")

func _process(delta):
	if not player: 
		player = get_tree().get_first_node_in_group("player")
		return
		
	var current_time = Time.get_ticks_msec() / 1000.0  # 秒为单位
	
	# 1. 更新当前波次索引
	update_current_wave(current_time)
	
	# 2. 生成定时器
	var wave = get_current_wave_config()
	var wave_config_global = EnemyDatabase.wave_config
	
	if wave and wave_config_global:
		var max_enemies = wave_config_global.get("max_enemies_on_screen", 60)
		if enemies_on_screen.size() < max_enemies:
			spawn_timer += delta
			var interval = get_dynamic_spawn_interval(wave_config_global.get("base_spawn_interval", 0.8))
			if spawn_timer >= interval:
				spawn_timer = 0
				try_spawn_enemies(wave)
	
	# 3. 清理已死亡的敌人
	enemies_on_screen = enemies_on_screen.filter(func(e): return is_instance_valid(e) and not e.is_queued_for_deletion())

func update_current_wave(current_time):
	var config = EnemyDatabase.wave_config
	if not config or not config.has("waves"): return
	
	var waves = config["waves"]
	for i in range(waves.size()):
		var w = waves[i]
		if current_time >= w["start_time"] and current_time < w["end_time"]:
			current_wave_index = i
			break

func get_current_wave_config():
	var config = EnemyDatabase.wave_config
	if config and config.has("waves") and current_wave_index < config["waves"].size():
		return config["waves"][current_wave_index]
	return null

func try_spawn_enemies(wave):
	# 计算本次要生成的总怪物数量
	var spawn_count = randi_range(1, 3)
	for i in range(spawn_count):
		var spawn_configs = wave.get("spawn_configs", [])
		if spawn_configs.size() > 0:
			var spawn_config = pick_spawn_config_by_weight(spawn_configs)
			if spawn_config:
				var count = randi_range(spawn_config.get("min_spawn", 1), spawn_config.get("max_spawn", 1))
				for j in range(count):
					spawn_single_enemy(spawn_config)

func pick_spawn_config_by_weight(spawn_configs: Array) -> Dictionary:
	var total_weight = 0.0
	var difficulty_factor = get_difficulty_factor()
	
	# 临时存储修改后的权重
	var temp_configs = []
	for cfg in spawn_configs:
		var enemy_id = cfg["enemy_id"]
		var enemy_data = EnemyDatabase.enemies.get(enemy_id)
		var current_weight = cfg["weight"]
		
		if enemy_data:
			# 威胁越高的怪物，在高难度下权重提升越多
			var weight_mod = 1.0 + enemy_data.danger_level * (difficulty_factor - 1.0)
			current_weight *= weight_mod
			
		total_weight += current_weight
		var new_cfg = cfg.duplicate()
		new_cfg["_temp_weight"] = current_weight
		temp_configs.append(new_cfg)
		
	var r = randf() * total_weight
	var accum = 0.0
	for cfg in temp_configs:
		accum += cfg["_temp_weight"]
		if r <= accum:
			return cfg
	return spawn_configs[0]

func spawn_single_enemy(spawn_config: Dictionary):
	var enemy_id = spawn_config["enemy_id"]
	var enemy_data = EnemyDatabase.enemies.get(enemy_id)
	if not enemy_data: return
	
	# 精英怪判定
	var is_elite = randf() < spawn_config.get("elite_chance", 0.0)
	
	# 实例化场景
	var scene_path = enemy_data.monster_scene
	if scene_path == "": return
	
	var scene = load(scene_path)
	if not scene: return
	
	var enemy = scene.instantiate()
	
	# 设置敌人数据
	if enemy.has_method("set_enemy_data"):
		enemy.set_enemy_data(enemy_data, is_elite)
	
	# 设置生成位置
	var spawn_pos = get_spawn_position_outside_camera()
	enemy.global_position = spawn_pos
	
	# 添加到场景
	get_tree().current_scene.add_child(enemy)
	enemies_on_screen.append(enemy)

func get_spawn_position_outside_camera() -> Vector2:
	var camera = get_viewport().get_camera_2d()
	var cam_center = Vector2.ZERO
	if camera:
		cam_center = camera.get_screen_center_position()
	else:
		# 如果没有相机，默认使用视口中心
		cam_center = get_viewport().get_visible_rect().size / 2.0
		
	var view_size = get_viewport().get_visible_rect().size
	var side = randi_range(0, 3)   # 0左 1右 2上 3下
	var offset = 100.0
	match side:
		0: return cam_center + Vector2(-view_size.x/2 - offset, randf_range(-view_size.y/2, view_size.y/2))
		1: return cam_center + Vector2(view_size.x/2 + offset, randf_range(-view_size.y/2, view_size.y/2))
		2: return cam_center + Vector2(randf_range(-view_size.x/2, view_size.x/2), -view_size.y/2 - offset)
		3: return cam_center + Vector2(randf_range(-view_size.x/2, view_size.x/2), view_size.y/2 + offset)
	return cam_center

func get_difficulty_factor() -> float:
	var player_level = 1
	if player and player.playerstates:
		player_level = player.playerstates.level
		
	var time = Time.get_ticks_msec() / 1000.0
	# 基础系数 1.0，随时间增加，随等级增加
	return 1.0 + time / 300.0 + player_level / 50.0

func get_dynamic_spawn_interval(base_interval: float) -> float:
	var max_enemies = EnemyDatabase.wave_config.get("max_enemies_on_screen", 60)
	var ratio = float(enemies_on_screen.size()) / max_enemies
	# 怪物越多，生成越慢
	return base_interval + ratio * 0.5
