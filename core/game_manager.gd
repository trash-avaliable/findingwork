## 核心游戏管理器
class_name GameManager
extends Node

signal level_up(new_level: int)
signal game_over(is_victory: bool)
signal wave_complete(wave_number: int)
signal buff_selection_needed(options: Array)

## 单例
static var instance: GameManager

## 游戏状态
var is_running: bool = false
var is_paused: bool = false

## 数据管理
var game_state_module
var strategy_manager

## 内部状态
var current_player
var current_enemies: Array = []
var wave_enemies_remaining: int = 0

func _ready() -> void:
	if instance != null:
		queue_free()
		return
	instance = self
	
	# 初始化模块 - 动态加载避免循环依赖
	# game_state_module = GameStateModule.new()
	# strategy_manager = StrategyManager.new()
	
	# 注册到 SaveSystem
	var ss = get_tree().root.get_node_or_null("SaveSystem")
	if ss:
		ss.register_module(game_state_module)

func _process(delta: float) -> void:
	if not is_running or is_paused:
		return
	
	_update_game(delta)

# ──────────────────────────────────────────────
# 游戏流程控制
# ──────────────────────────────────────────────

## 开始新游戏
func start_new_game() -> void:
	if game_state_module:
		game_state_module.on_new_game()
	current_player = game_state_module.player if game_state_module else null
	is_running = true
	is_paused = false
	current_enemies.clear()

## 暂停/恢复游戏
func set_paused(paused: bool) -> void:
	is_paused = paused
	get_tree().paused = paused

## 结束游戏
func end_game(is_victory: bool) -> void:
	is_running = false
	game_over.emit(is_victory)
	
	# 保存进度
	var ss = get_tree().root.get_node_or_null("SaveSystem")
	if ss:
		ss.save_slot()

# ──────────────────────────────────────────────
# 升级系统
# ──────────────────────────────────────────────

## 玩家升级
func level_up_player() -> void:
	if not game_state_module or not game_state_module.player:
		return
	
	game_state_module.player["level"] += 1
	level_up.emit(game_state_module.player["level"])
	
	# 生成升级选项
	var options = strategy_manager.generate_upgrade_options(game_state_module.player["level"])
	buff_selection_needed.emit(options)

## 应用选中的 Buff
func apply_selected_buff(buff) -> void:
	if not game_state_module or not game_state_module.player:
		return
	
	# 这里需要手动应用，因为player是字典形式
	match buff.buff_type if buff else -1:
		0:  # WEAPON
			if buff.item_id not in game_state_module.player["owned_weapons"]:
				game_state_module.player["owned_weapons"].append(buff.item_id)
		1:  # BULLET
			if buff.item_id not in game_state_module.player["owned_bullets"]:
				game_state_module.player["owned_bullets"].append(buff.item_id)
		2:  # ATTACK_UP
			game_state_module.player["attack"] += buff.value
		3:  # SPEED_UP
			game_state_module.player["speed"] += buff.value
		4:  # DEFENSE_UP
			game_state_module.player["defense"] += buff.value
		5:  # GOLD_UP
			game_state_module.player["gold"] = int(float(game_state_module.player["gold"]) * (1.0 + buff.value))
		6:  # ENERGY_UP
			game_state_module.player["max_energy"] += buff.value
		7:  # CRIT_RATE_UP
			pass  # 暴击率由武器管理
		8:  # CRIT_DAMAGE_UP
			pass  # 暴击伤害由武器管理

# ──────────────────────────────────────────────
# 波次管理
# ──────────────────────────────────────────────

## 生成敌人波次
func spawn_wave(wave_number: int) -> void:
	game_state_module.current_wave = wave_number
	wave_enemies_remaining = 3 + wave_number  # 简单的难度递增

## 敌人被击败
func enemy_defeated(gold_reward: int) -> void:
	if game_state_module:
		game_state_module.player["gold"] += gold_reward
		game_state_module.enemies_killed += 1
	
	wave_enemies_remaining -= 1
	if wave_enemies_remaining <= 0:
		wave_complete.emit(game_state_module.current_wave if game_state_module else 0)
		# 自动进入下一波
		spawn_wave((game_state_module.current_wave if game_state_module else 0) + 1)

# ──────────────────────────────────────────────
# 内部
# ──────────────────────────────────────────────

func _update_game(_delta: float) -> void:
	# 更新敌人
	for enemy in current_enemies:
		if is_instance_valid(enemy):
			# 敌人AI更新将在敌人脚本中处理
			pass
	
	# 移除死亡的敌人
	current_enemies = current_enemies.filter(func(e): return is_instance_valid(e))
