## 敌人数据模板
class_name EnemyData
extends SaveResource

## 敌人基本信息
var id: String = ""
var enemy_name: String = ""

## 基础属性
var attack: float = 5.0
var defense: float = 2.0
var speed: float = 150.0
var max_hp: int = 50

## 技能ID（敌人使用的技能）
var skill_id: String = ""

## 击败可获得的金币
var gold_reward: int = 10

## 敌人等级（影响属性倍数）
var level: int = 1

## 生成权重（策略模块中控制出现概率）
var spawn_weight: float = 1.0

# ──────────────────────────────────────────────
# SaveResource 接口
# ──────────────────────────────────────────────

func get_type_id() -> String:
	return "EnemyData"

func to_dict() -> Dictionary:
	return {
		"id": id,
		"enemy_name": enemy_name,
		"attack": attack,
		"defense": defense,
		"speed": speed,
		"max_hp": max_hp,
		"skill_id": skill_id,
		"gold_reward": gold_reward,
		"level": level,
		"spawn_weight": spawn_weight,
	}

func from_dict(data: Dictionary) -> void:
	id = str(data.get("id", ""))
	enemy_name = str(data.get("enemy_name", ""))
	attack = float(data.get("attack", 5.0))
	defense = float(data.get("defense", 2.0))
	speed = float(data.get("speed", 150.0))
	max_hp = int(data.get("max_hp", 50))
	skill_id = str(data.get("skill_id", ""))
	gold_reward = int(data.get("gold_reward", 10))
	level = int(data.get("level", 1))
	spawn_weight = float(data.get("spawn_weight", 1.0))

## 获取等级调整后的属性
func get_scaled_attack() -> float:
	return attack * (1.0 + (level - 1) * 0.1)

func get_scaled_defense() -> float:
	return defense * (1.0 + (level - 1) * 0.1)

func get_scaled_speed() -> float:
	return speed * (1.0 + (level - 1) * 0.05)

func get_scaled_max_hp() -> int:
	return int(float(max_hp) * (1.0 + (level - 1) * 0.15))
