## 升级策略/Buff系统
class_name StrategyBuff
extends SaveResource

## Buff 基本信息
var id: String = ""
var name: String = "" # 策略名
var category: String = "normal" # normal, rare, legend

## 描述信息
var part_description: String = "" # 粗略描述
var full_description: String = "" # 详细描述

## 替换逻辑
var type_replace: Array = [] # 类型替换描述（对应 modifier_value 里的键）
var value_replace: Array = [] # 数值替换描述（对应 modifier_value 里的值）

## 数值修改值
## 键可以是：gain_weapon, gain_bullet, attack_mult, speed_add, defense_mult, gold_add, 
## energy_max_add, weapon_crit_rate_mult, weapon_crit_damage_mult, weapon_slot_add, etc.
var modifier_value: Dictionary = {}

# ──────────────────────────────────────────────
# SaveResource 接口
# ──────────────────────────────────────────────

func get_type_id() -> String:
	return "StrategyBuff"

func to_dict() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"category": category,
		"part_description": part_description,
		"full_description": full_description,
		"type_replace": type_replace,
		"value_replace": value_replace,
		"modifier_value": modifier_value,
	}

func from_dict(data: Dictionary) -> void:
	id = str(data.get("id", ""))
	name = str(data.get("name", ""))
	category = str(data.get("category", "normal"))
	part_description = str(data.get("part_description", ""))
	full_description = str(data.get("full_description", ""))
	type_replace = data.get("type_replace", [])
	value_replace = data.get("value_replace", [])
	modifier_value = data.get("modifier_value", {})

## 获取格式化后的详细描述
func get_formatted_description() -> String:
	var desc = full_description
	for val in value_replace:
		desc = desc.replace("%s", str(val))
	return desc
