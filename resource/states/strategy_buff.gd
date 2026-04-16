## 升级策略/Buff系统
class_name StrategyBuff
extends SaveResource

## Buff 类型枚举
enum BuffType {
	WEAPON,          # 获得新武器
	BULLET,          # 获得新子弹
	ATTACK_UP,       # 攻击力提升
	SPEED_UP,        # 移速提升
	DEFENSE_UP,      # 防御力提升
	GOLD_UP,         # 金币倍增
	ENERGY_UP,       # 能量上限提高
	CRIT_RATE_UP,    # 暴击率提高
	CRIT_DAMAGE_UP,  # 暴击伤害提高
}

## 稀有度
enum Rarity { NORMAL, RARE, LEGEND }

## Buff 基本信息
var id: String = ""
var buff_name: String = ""
var description: String = ""

## Buff 类型
var buff_type: BuffType = BuffType.ATTACK_UP

## 稀有度
var rarity: Rarity = Rarity.NORMAL

## Buff 数值（根据类型决定含义）
var value: float = 0.0

## 武器/子弹ID（仅对WEAPON/BULLET类型有效）
var item_id: String = ""

# ──────────────────────────────────────────────
# SaveResource 接口
# ──────────────────────────────────────────────

func get_type_id() -> String:
	return "StrategyBuff"

func to_dict() -> Dictionary:
	return {
		"id": id,
		"buff_name": buff_name,
		"description": description,
		"buff_type": buff_type,
		"rarity": rarity,
		"value": value,
		"item_id": item_id,
	}

func from_dict(data: Dictionary) -> void:
	id = str(data.get("id", ""))
	buff_name = str(data.get("buff_name", ""))
	description = str(data.get("description", ""))
	buff_type = int(data.get("buff_type", BuffType.ATTACK_UP)) as BuffType
	rarity = int(data.get("rarity", Rarity.NORMAL)) as Rarity
	value = float(data.get("value", 0.0))
	item_id = str(data.get("item_id", ""))

## 获取稀有度字符串
func get_rarity_string() -> String:
	match rarity:
		Rarity.NORMAL:
			return "普通"
		Rarity.RARE:
			return "稀有"
		Rarity.LEGEND:
			return "传奇"
	return "未知"
