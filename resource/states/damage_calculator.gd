## 伤害计算引擎
class_name DamageCalculator
extends RefCounted

## 伤害类型枚举
enum DamageType { NORMAL, DOT, SLOW, TREMOR, EXPLOSION, TRUE_DAMAGE }

## 伤害结果结构
class DamageResult:
	var damage: float = 0.0
	var is_crit: bool = false
	var damage_type: int = DamageType.NORMAL
	var segments: Array[float] = []  # DOT 分段伤害

## 计算伤害
static func calculate_damage(attacker, bullet, weapon, defender) -> DamageResult:
	var result := DamageResult.new()
	result.damage_type = bullet.damage_type

	# 基础伤害 = 子弹攻击力 + 武器附加攻击力 + 角色攻击力
	var base_damage: float = bullet.attack + weapon.normal_extra_attack + attacker.attack

	# 判断是否暴击
	result.is_crit = randf() < weapon.crit_rate
	var final_damage: float = base_damage
	if result.is_crit:
		final_damage *= weapon.crit_damage

	# 根据伤害类型计算最终伤害
	match bullet.damage_type:
		DamageType.NORMAL:
			result.damage = max(0.0, final_damage - defender.defense)

		DamageType.DOT:
			# 持续伤害：敌人血量 - (每层DOT伤害 - 敌人防御力) * 段数
			var dot_damage: float = bullet.damage_value
			var segment_damage: float = max(0.0, (dot_damage - defender.defense))
			result.damage = segment_damage * bullet.segments
			# 分段显示
			for i in range(bullet.segments):
				result.segments.append(segment_damage)

		DamageType.SLOW:
			# 减速不造成伤害，只返回数值用于状态应用
			result.damage = bullet.damage_value

		DamageType.TREMOR:
			# 震颤：防御力 * 防御力百分比 / 敌人防御力 - 减防
			var defense_reduction: float = defender.defense * bullet.damage_value
			result.damage = defense_reduction

		DamageType.EXPLOSION:
			# 爆炸：敌人血量+防御力-基础伤害*暴击伤害（必定暴击）
			result.is_crit = true
			result.damage = base_damage * weapon.crit_damage - defender.defense

		DamageType.TRUE_DAMAGE:
			# 真伤：敌人血量-基础伤害（无视防御）
			result.damage = base_damage

	result.damage = max(0.0, result.damage)
	return result

## 应用减速效果
static func apply_slow(current_speed: float, slow_value: float) -> float:
	return max(0.0, current_speed - slow_value)

## 应用震颤效果（降低防御）
static func apply_tremor(current_defense: float, defense_reduction: float) -> float:
	return max(0.0, current_defense - defense_reduction)
