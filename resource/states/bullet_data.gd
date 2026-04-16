## 子弹数据结构
class_name BulletData
extends SaveResource

## 子弹基本信息
var id: String = ""
var bullet_name: String = ""

## 攻击力
var attack: float = 10.0

## 能量消耗
var energy_cost: float = 10.0

## 伤害类型枚举
enum DamageType { NORMAL, DOT, SLOW, TREMOR, EXPLOSION, TRUE_DAMAGE }

## 伤害类型
var damage_type: DamageType = DamageType.NORMAL

## 伤害类型数值
## - DOT: 每层伤害量
## - SLOW: 减速量
## - TREMOR: 防御力降低百分比 (0.0~1.0)
## - EXPLOSION: 无额外参数（已包含在公式中）
## - TRUE_DAMAGE: 无额外参数（已包含在公式中）
## - NORMAL: 无额外参数
var damage_value: float = 0.0

## 持续时间（秒，仅对 DOT/SLOW/TREMOR 有效）
var duration: float = 3.0

## 段数（仅对 DOT 有效，表示伤害分多少次显示）
var segments: int = 3

# ──────────────────────────────────────────────
# SaveResource 接口
# ──────────────────────────────────────────────

func get_type_id() -> String:
	return "BulletData"

func to_dict() -> Dictionary:
	return {
		"id": id,
		"bullet_name": bullet_name,
		"attack": attack,
		"energy_cost": energy_cost,
		"damage_type": damage_type,
		"damage_value": damage_value,
		"duration": duration,
		"segments": segments,
	}

func from_dict(data: Dictionary) -> void:
	id = str(data.get("id", ""))
	bullet_name = str(data.get("bullet_name", ""))
	attack = float(data.get("attack", 10.0))
	energy_cost = float(data.get("energy_cost", 10.0))
	damage_type = int(data.get("damage_type", DamageType.NORMAL)) as DamageType
	damage_value = float(data.get("damage_value", 0.0))
	duration = float(data.get("duration", 3.0))
	segments = int(data.get("segments", 3))

## 获取伤害类型字符串
func get_damage_type_string() -> String:
	match damage_type:
		DamageType.DOT:
			return "持续伤害"
		DamageType.SLOW:
			return "减速"
		DamageType.TREMOR:
			return "震颤"
		DamageType.EXPLOSION:
			return "爆炸"
		DamageType.TRUE_DAMAGE:
			return "真伤"
		DamageType.NORMAL:
			return "普通"
	return "未知"
