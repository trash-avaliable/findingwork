## 游戏状态存档模块
class_name GameStateModule
extends ISaveModule

## 单例引用
static var instance: GameStateModule

## 玩家角色数据
var player

## 当前进度
var current_level: int = 1
var current_wave: int = 1
var enemies_killed: int = 0

## 自定义游戏状态
var custom_state: Dictionary = {}

func _init() -> void:
	instance = self
	# 延后初始化以避免循环依赖
	if player == null:
		player = {}
		player["attack"] = 10.0
		player["defense"] = 5.0
		player["speed"] = 200.0
		player["energy"] = 100.0
		player["max_energy"] = 100.0
		player["level"] = 1
		player["gold"] = 0
		player["equipped_weapon"] = ""
		player["equipped_bullet"] = ""
		player["owned_weapons"] = []
		player["owned_bullets"] = []

# ──────────────────────────────────────────────
# ISaveModule 接口
# ──────────────────────────────────────────────

func get_module_key() -> String:
	return "game_state"

func is_global() -> bool:
	return false

func collect_data() -> Dictionary:
	return {
		"player": {
			"attack": player.attack,
			"defense": player.defense,
			"speed": player.speed,
			"energy": player.energy,
			"max_energy": player.max_energy,
			"level": player.level,
			"gold": player.gold,
			"equipped_weapon": player.equipped_weapon,
			"equipped_bullet": player.equipped_bullet,
			"owned_weapons": player.owned_weapons.duplicate(),
			"owned_bullets": player.owned_bullets.duplicate(),
		},
		"current_level": current_level,
		"current_wave": current_wave,
		"enemies_killed": enemies_killed,
		"custom_state": custom_state.duplicate(true),
	}

func apply_data(data: Dictionary) -> void:
	var player_data: Dictionary = data.get("player", {}) as Dictionary
	if not player_data.is_empty():
		player.attack = float(player_data.get("attack", 10.0))
		player.defense = float(player_data.get("defense", 5.0))
		player.speed = float(player_data.get("speed", 200.0))
		player.energy = float(player_data.get("energy", 100.0))
		player.max_energy = float(player_data.get("max_energy", 100.0))
		player.level = int(player_data.get("level", 1))
		player.gold = int(player_data.get("gold", 0))
		player.equipped_weapon = str(player_data.get("equipped_weapon", ""))
		player.equipped_bullet = str(player_data.get("equipped_bullet", ""))
		var weapons = player_data.get("owned_weapons", []) as Array
		player.owned_weapons = Array(weapons).map(func(w): return str(w))
		var bullets = player_data.get("owned_bullets", []) as Array
		player.owned_bullets = Array(bullets).map(func(b): return str(b))

	current_level = int(data.get("current_level", 1))
	current_wave = int(data.get("current_wave", 1))
	enemies_killed = int(data.get("enemies_killed", 0))
	custom_state = (data.get("custom_state", {}) as Dictionary).duplicate(true)

func get_default_data() -> Dictionary:
	return {
		"player": {
			"attack": 10.0,
			"defense": 5.0,
			"speed": 200.0,
			"energy": 100.0,
			"max_energy": 100.0,
			"level": 1,
			"gold": 0,
			"equipped_weapon": "",
			"equipped_bullet": "",
			"owned_weapons": [],
			"owned_bullets": [],
		},
		"current_level": 1,
		"current_wave": 1,
		"enemies_killed": 0,
		"custom_state": {},
	}

func on_new_game() -> void:
	apply_data(get_default_data())
