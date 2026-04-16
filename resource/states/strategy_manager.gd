## 升级策略管理器
class_name StrategyManager
extends RefCounted

## Buff 类型枚举（复制自 StrategyBuff）
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

## 升级选项
class UpgradeOption:
	var buff
	var index: int = 0
	func _to_string() -> String:
		var rarity_names: Array = ["普通", "稀有", "传奇"]
		var rarity_name: String = rarity_names[buff.rarity] if buff else "未知"
		return "%s (稀有度: %s)" % [buff.buff_name if buff else "无", rarity_name]

## 升级权重配置（基于玩家等级）
const LEVEL_WEIGHTS := {
	"1-20": [0.8, 0.15, 0.05],
	"21-40": [0.6, 0.3, 0.1],
	"41-60": [0.3, 0.5, 0.2],
	"61-80": [0.1, 0.4, 0.5],
	"81-100": [0.1, 0.2, 0.7],
}

## 所有可用的 Buff 库
var buff_library: Array = []

## 生成升级选项（三选一）
func generate_upgrade_options(player_level: int, count: int = 3) -> Array:
	var options: Array = []
	var selected_rarities: Array = []
	
	# 根据玩家等级选择稀有度权重
	var weights := _get_weights_for_level(player_level)
	
	# 生成三个选项，每个选项随机一个稀有度
	for i in range(count):
		var rarity := _pick_rarity_by_weight(weights)
		selected_rarities.append(rarity)
	
	# 从相应稀有度的 Buff 中随机选择
	for rarity in selected_rarities:
		var matching_buffs = buff_library.filter(func(b): return b.rarity == rarity)
		if matching_buffs.is_empty():
			continue
		var buff = matching_buffs[randi() % matching_buffs.size()]
		var option := UpgradeOption.new()
		option.buff = buff
		option.index = options.size()
		options.append(option)
	
	return options

## 应用 Buff 到角色
func apply_buff(character, buff) -> void:
	match buff.buff_type:
		BuffType.ATTACK_UP:
			character.apply_buff("attack", buff.value)
		BuffType.SPEED_UP:
			character.apply_buff("speed", buff.value)
		BuffType.DEFENSE_UP:
			character.apply_buff("defense", buff.value)
		BuffType.ENERGY_UP:
			character.apply_buff("energy", buff.value)
		BuffType.CRIT_RATE_UP:
			character.apply_buff("crit_rate", buff.value)
		BuffType.CRIT_DAMAGE_UP:
			character.apply_buff("crit_damage", buff.value)
		BuffType.GOLD_UP:
			character.gold = int(float(character.gold) * (1.0 + buff.value))
		BuffType.WEAPON:
			if buff.item_id not in character.owned_weapons:
				character.owned_weapons.append(buff.item_id)
		BuffType.BULLET:
			if buff.item_id not in character.owned_bullets:
				character.owned_bullets.append(buff.item_id)

## 注册一个 Buff
func register_buff(buff) -> void:
	if buff not in buff_library:
		buff_library.append(buff)

## 清空 Buff 库
func clear_buffs() -> void:
	buff_library.clear()

# ──────────────────────────────────────────────
# 内部方法
# ──────────────────────────────────────────────

func _get_weights_for_level(player_level: int) -> Array:
	if player_level <= 20:
		return [0.8, 0.15, 0.05]
	elif player_level <= 40:
		return [0.6, 0.3, 0.1]
	elif player_level <= 60:
		return [0.3, 0.5, 0.2]
	elif player_level <= 80:
		return [0.1, 0.4, 0.5]
	else:
		return [0.1, 0.2, 0.7]

func _pick_rarity_by_weight(weights: Array) -> int:
	var rand_val := randf()
	var cumulative := 0.0
	
	# 根据权重选择稀有度
	for i in range(weights.size()):
		cumulative += weights[i]
		if rand_val <= cumulative:
			return i  # 0=普通, 1=稀有, 2=传奇
	
	return 0  # 默认普通
