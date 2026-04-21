## 升级策略管理器
class_name StrategyManager
extends RefCounted

## 升级选项
class UpgradeOption:
	var buff: StrategyBuff
	var index: int = 0
	func _to_string() -> String:
		return "%s (稀有度: %s)" % [buff.name if buff else "无", buff.category if buff else "未知"]

## 升级权重配置（基于玩家等级）
const LEVEL_WEIGHTS := {
	"1-20": [0.8, 0.15, 0.05],
	"21-40": [0.6, 0.3, 0.1],
	"41-60": [0.3, 0.5, 0.2],
	"61-80": [0.1, 0.4, 0.5],
	"81-100": [0.1, 0.2, 0.7],
}

## 所有可用的 Buff 库
var buff_library: Array[StrategyBuff] = []

## 生成升级选项（三选一）
func generate_upgrade_options(player_level: int, count: int = 3) -> Array:
	var options: Array = []
	var weights := _get_weights_for_level(player_level)
	
	# 为了避免重复，我们先过滤出所有可用的 buff
	var available_buffs = buff_library.duplicate()
	available_buffs.shuffle()
	
	for i in range(count):
		var category := _pick_category_by_weight(weights)
		var matching_buffs = available_buffs.filter(func(b): return b.category == category)
		
		if matching_buffs.is_empty():
			# 如果该稀有度没 buff 了，尝试其他稀有度
			matching_buffs = available_buffs
			
		if not matching_buffs.is_empty():
			var buff = matching_buffs[0]
			available_buffs.erase(buff) # 避免同一次选择中出现重复 buff
			
			var option := UpgradeOption.new()
			option.buff = buff
			option.index = options.size()
			options.append(option)
	
	return options

## 应用 Buff 到角色
func apply_buff(character: CharacterTemplate, buff: StrategyBuff) -> void:
	for key in buff.modifier_value.keys():
		var value = buff.modifier_value[key]
		var val_float = float(value) if value is float or value is int else 0.0
		var val_int = int(value) if value is float or value is int else 0
		
		match key:
			"gain_weapon":
				# 从武器池中获得一把随机武器 (这里需要一个全局武器池，暂时假设 character.owned_weapons 存储 ID)
				# 逻辑应由 GameManager 或专门的 Pool 管理器处理
				pass
			"gain_bullet":
				# 从子弹池中获得一类随机子弹
				pass
			"attack_mult":
				character.apply_strategy_modifier("attack_up", val_float, 0)
			"attack_add":
				character.apply_strategy_modifier("attack_up", 0.0, val_int)
			"speed_add":
				character.apply_strategy_modifier("speed_up", 0.0, val_int)
			"defense_mult":
				character.apply_strategy_modifier("defense_up", val_float, 0)
			"defense_add":
				character.apply_strategy_modifier("defense_up", 0.0, val_int)
			"gold_mult":
				character.apply_strategy_modifier("gold_up", val_float, 0)
			"gold_add":
				character.apply_strategy_modifier("gold_up", 0.0, val_int)
			"energy_max_add":
				character.apply_strategy_modifier("energy_up", 0.0, val_int)
			"weapon_slot_add":
				character.apply_strategy_modifier("weapon_slot", 0.0, val_int)
			"weapon_crit_rate_mult":
				# 武器暴击率提高
				pass
			"weapon_crit_damage_mult":
				# 武器暴击伤害提高
				pass

## 注册一个 Buff
func register_buff(buff: StrategyBuff) -> void:
	if buff not in buff_library:
		buff_library.append(buff)

## 清空 Buff 库
func clear_buffs() -> void:
	buff_library.clear()

# ──────────────────────────────────────────────
# 内部方法
# ──────────────────────────────────────────────

func _get_weights_for_level(level: int) -> Array:
	if level <= 20: return LEVEL_WEIGHTS["1-20"]
	if level <= 40: return LEVEL_WEIGHTS["21-40"]
	if level <= 60: return LEVEL_WEIGHTS["41-60"]
	if level <= 80: return LEVEL_WEIGHTS["61-80"]
	return LEVEL_WEIGHTS["81-100"]

func _pick_category_by_weight(weights: Array) -> String:
	var r = randf()
	if r < weights[0]: return "normal"
	if r < weights[0] + weights[1]: return "rare"
	return "legend"
