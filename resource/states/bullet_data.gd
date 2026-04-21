## 子弹数据结构
class_name BulletData
extends SaveResource

## 子弹基本信息
var id: String = ""
var bullet_scene: String = "" # 路径
var attack: float = 10.0

## 伤害类型
## constant (DOT), speed_down (SLOW), defense_down (TREMOR), explosion, truehurt, normal
var category: String = "normal"

## 持续时间（秒）
var duration: float = 0.0

## 修改数值 (键对应 int 或 float，键值对应数值)
var modifier: Dictionary = {}

# ──────────────────────────────────────────────
# SaveResource 接口
# ──────────────────────────────────────────────

func get_type_id() -> String:
	return "BulletData"

func to_dict() -> Dictionary:
	return {
		"id": id,
		"bullet_scene": bullet_scene,
		"attack": attack,
		"category": category,
		"duration": duration,
		"modifier": modifier,
	}

func from_dict(data: Dictionary) -> void:
	id = str(data.get("id", ""))
	bullet_scene = str(data.get("bullet_scene", ""))
	attack = float(data.get("attack", 10.0))
	category = str(data.get("category", "normal"))
	duration = float(data.get("duration", 0.0))
	modifier = data.get("modifier", {})
