## 游戏初始化管理器
## 自动在游戏启动时注册所有资源和设置
class_name GameInitializer
extends Node

## 单例
static var instance: GameInitializer

func _ready() -> void:
	if instance != null:
		queue_free()
		return
	instance = self
	
	print("\n═══════════════════════════════════════")
	print("  游戏初始化开始")
	print("═══════════════════════════════════════\n")
	
	_register_resources()
	_setup_save_system()
	_setup_game_manager()
	_load_data_files()
	
	print("\n═══════════════════════════════════════")
	print("  游戏初始化完成")
	print("═══════════════════════════════════════\n")

# ──────────────────────────────────────────────
# 资源注册
# ──────────────────────────────────────────────

func _register_resources() -> void:
	print("[✓] 注册可序列化资源类型...")
	
	# 注册数据资源 - 使用动态加载避免循环依赖
	var resource_types = [
		"res://resource/states/weapon_data.gd",
		"res://resource/states/bullet_data.gd",
		"res://resource/states/skill_data.gd",
		"res://resource/states/enemy_data.gd",
		"res://resource/states/strategy_buff.gd",
	]
	
	for type_path in resource_types:
		var script = load(type_path)
		if script:
			ResourceSerializer.register(script)
			var type_name: String = type_path.get_file().trim_suffix(".gd")
			print("  - %s" % type_name)
		else:
			print("  ⚠ 无法加载: %s" % type_path)

# ──────────────────────────────────────────────
# SaveSystem 配置
# ──────────────────────────────────────────────

func _setup_save_system() -> void:
	print("\n[✓] 配置存档系统...")
	
	var ss = get_tree().root.get_node_or_null("SaveSystem")
	if not ss:
		print("  ⚠ 警告：SaveSystem 未找到，请添加到 AutoLoad")
		return
	
	# 基础配置
	ss.max_slots = 8
	ss.game_version = "1.0.0"
	ss.auto_register = true
	ss.auto_load_global = true
	
	# 开发配置（发布前改为 true）
	ss.encryption_enabled = false
	ss.compression_enabled = false
	ss.atomic_write_enabled = true
	ss.backup_enabled = true
	
	print("  - 最大槽位: 8")
	print("  - 游戏版本: 1.0.0")
	print("  - 自动注册: true")
	print("  - 加密: %s" % str(ss.encryption_enabled))
	print("  - 压缩: %s" % str(ss.compression_enabled))

# ──────────────────────────────────────────────
# GameManager 配置
# ──────────────────────────────────────────────

func _setup_game_manager() -> void:
	print("\n[✓] 初始化游戏管理器...")
	
	# 延后初始化，避免循环依赖
	print("  - 游戏管理器将在运行时初始化")

# ──────────────────────────────────────────────
# 加载数据文件
# ──────────────────────────────────────────────

func _load_data_files() -> void:
	print("\n[✓] 加载游戏数据...")
	
	# 注意：GameManager.instance 会在游戏运行时可用
	# 这里只处理文件验证
	
	var loaded_count := 0
	
	# 验证 Buff 库
	var buff_dir = "res://data/buffs/"
	if DirAccess.dir_exists_absolute(buff_dir):
		loaded_count = _count_tres_files(buff_dir)
		print("  - 找到 %d 个 Buff 数据文件" % loaded_count)
	
	# 验证武器库
	var weapon_dir = "res://data/weapons/"
	if DirAccess.dir_exists_absolute(weapon_dir):
		loaded_count = _count_tres_files(weapon_dir)
		print("  - 找到 %d 个武器数据文件" % loaded_count)
	
	# 验证敌人库
	var enemy_dir = "res://data/enemies/"
	if DirAccess.dir_exists_absolute(enemy_dir):
		loaded_count = _count_tres_files(enemy_dir)
		print("  - 找到 %d 个敌人模板文件" % loaded_count)

func _count_tres_files(path: String) -> int:
	var count := 0
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			if file.ends_with(".tres"):
				count += 1
			file = dir.get_next()
	return count

# ──────────────────────────────────────────────
# 信号回调（用于调试）
# ──────────────────────────────────────────────

func _on_player_level_up(new_level: int) -> void:
	print("[游戏] 玩家升级到 %d 级" % new_level)

func _on_buff_selection_needed(options: Array) -> void:
	print("[游戏] 升级选项生成，玩家有 %d 个选择" % options.size())
	for i in range(options.size()):
		var opt = options[i]
		print("  %d. %s (稀有度: %s)" % [i + 1, opt.buff.buff_name if opt.buff else "未知", 
			["普通", "稀有", "传奇"][opt.buff.rarity] if opt.buff else "?"])

func _on_game_over(is_victory: bool) -> void:
	print("[游戏] 游戏结束 - %s" % ("胜利" if is_victory else "失败"))
