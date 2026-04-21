## 技能/大招数据结构
class_name SkillData
extends SaveResource

## 技能基本信息
var id: String = ""
var skill_name: String = ""

## 大招攻击范围 (X, Y方向半径)
var special_range_x: float = 150.0
var special_range_y: float = 150.0

## 攻击范围图
var attack_image: String = ""

## 攻击目标人数
var target: int = 5

## 附加攻击力
var extra_attack: float = 5.0

## 冷却时间（秒）
var cold_time: float = 2.0

## 额外能量消耗
var energy_cost: int = 30

## 修改数值（键对应类型，键值对应数值）
var modifier_type: Dictionary = {}

# ──────────────────────────────────────────────
# SaveResource 接口
# ──────────────────────────────────────────────

func get_type_id() -> String:
	return "SkillData"

func to_dict() -> Dictionary:
	return {
		"id": id,
		"skill_name": skill_name,
		"special_range_x": special_range_x,
		"special_range_y": special_range_y,
		"attack_image": attack_image,
		"target": target,
		"extra_attack": extra_attack,
		"cold_time": cold_time,
		"energy_cost": energy_cost,
		"modifier_type": modifier_type,
	}

func from_dict(data: Dictionary) -> void:
	id = str(data.get("id", ""))
	skill_name = str(data.get("skill_name", ""))
	special_range_x = float(data.get("special_range_x", 150.0))
	special_range_y = float(data.get("special_range_y", 150.0))
	attack_image = str(data.get("attack_image", ""))
	target = int(data.get("target", 5))
	extra_attack = float(data.get("extra_attack", 5.0))
	cold_time = float(data.get("cold_time", 2.0))
	energy_cost = int(data.get("energy_cost", 30))
	modifier_type = data.get("modifier_type", {})
