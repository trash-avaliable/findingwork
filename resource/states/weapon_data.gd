## 武器数据结构
class_name WeaponData
extends SaveResource

## 武器基本信息
var id: String = ""
var weapon_name: String = ""

## 暴击属性 (对应文档中的 damage_percent 和 damage)
var damage_percent: float = 0.0      # 暴击率
var damage: float = 1.5              # 暴击伤害倍数

## 普通攻击范围 (X, Y方向半径)
var normal_range_x: float = 100.0
var normal_range_y: float = 100.0

## 攻击范围图
var normal_attack_image: String = ""

## 攻击目标人数
var normal_target: int = 1

## 附加攻击力
var normal_extra_attack: float = 0.0

## 冷却时间（秒）
var normal_cold_time: float = 0.5

## 额外能量消耗
var extra_energy_cost: int = 0

## 后坐力
var power: float = 0.0

## 武器等级
var weapon_level: int = 1

## 大招（对应 skillscene，存储路径或ID）
var weapon_skill: String = ""

## 持有的子弹类型（对应 bullet_id）
var bullets: Array[String] = []

# ──────────────────────────────────────────────
# SaveResource 接口
# ──────────────────────────────────────────────

func get_type_id() -> String:
	return "WeaponData"

func to_dict() -> Dictionary:
	return {
		"id": id,
		"weapon_name": weapon_name,
		"damage_percent": damage_percent,
		"damage": damage,
		"normal_range_x": normal_range_x,
		"normal_range_y": normal_range_y,
		"normal_attack_image": normal_attack_image,
		"normal_target": normal_target,
		"normal_extra_attack": normal_extra_attack,
		"normal_cold_time": normal_cold_time,
		"extra_energy_cost": extra_energy_cost,
		"power": power,
		"weapon_level": weapon_level,
		"weapon_skill": weapon_skill,
		"bullets": bullets,
	}

func from_dict(data: Dictionary) -> void:
	id = str(data.get("id", ""))
	weapon_name = str(data.get("weapon_name", ""))
	damage_percent = float(data.get("damage_percent", 0.0))
	damage = float(data.get("damage", 1.5))
	normal_range_x = float(data.get("normal_range_x", 100.0))
	normal_range_y = float(data.get("normal_range_y", 100.0))
	normal_attack_image = str(data.get("normal_attack_image", ""))
	normal_target = int(data.get("normal_target", 1))
	normal_extra_attack = float(data.get("normal_extra_attack", 0.0))
	normal_cold_time = float(data.get("normal_cold_time", 0.5))
	extra_energy_cost = int(data.get("extra_energy_cost", 0))
	power = float(data.get("power", 0.0))
	weapon_level = int(data.get("weapon_level", 1))
	weapon_skill = str(data.get("weapon_skill", ""))
	bullets = data.get("bullets", [])
