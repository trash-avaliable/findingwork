## 伤害计算引擎
class_name DamageCalculator
extends RefCounted

## 伤害结果结构
class DamageResult:
	var damage: float = 0.0
	var is_crit: bool = false
	var category: String = "normal"
	var segments: Array[float] = []  # DOT 分段伤害

## 计算伤害
## attacker: CharacterTemplate 或类似对象
## bullet: BulletData
## weapon: WeaponData
## skill: SkillData (可选)
## defender: EnemyData 或类似对象
static func calculate_damage(attacker, bullet: BulletData, weapon: WeaponData, defender, skill: SkillData = null) -> DamageResult:
	var result := DamageResult.new()
	result.category = bullet.category

	# 基础伤害 = 子弹攻击力 + 武器附加攻击力 + 角色攻击力 + 技能附加攻击力
	var base_damage: float = bullet.attack + weapon.normal_extra_attack + attacker.attack
	if skill:
		base_damage += skill.extra_attack

	# 判断是否暴击 (除了爆炸和真伤外，根据暴击率触发)
	var crit_rate = weapon.damage_percent
	var crit_multiplier = weapon.damage
	
	result.is_crit = randf() < crit_rate
	
	# 根据伤害类型计算最终伤害
	match bullet.category:
		"normal":
			var final_damage = base_damage
			if result.is_crit:
				final_damage *= crit_multiplier
			result.damage = max(0.0, final_damage - defender.defense)

		"constant": # DOT
			# 持续伤害：(每层dot伤害 - 敌人防御力) * 段数
			# 假设 modifier 包含 dot_damage 和 segments (段数由 bullet.modifier 提供)
			var dot_damage: float = bullet.modifier.get("dot_damage", bullet.attack)
			var segments: int = int(bullet.modifier.get("segments", 3))
			var segment_damage: float = max(0.0, (dot_damage - defender.defense))
			result.damage = segment_damage * segments
			# 分段显示
			for i in range(segments):
				result.segments.append(segment_damage)

		"speed_down": # SLOW
			# 减速公式：敌人移速 - 减速，if小于0则为0
			# 减速数值存储在 modifier.slow_amount
			result.damage = bullet.modifier.get("slow_amount", 0.0)

		"defense_down": # TREMOR
			# 震颤公式：敌人防御力 * 防御力百分比
			# 百分比存储在 modifier.defense_reduce_percent
			var percent = bullet.modifier.get("defense_reduce_percent", 0.0)
			result.damage = defender.defense * percent

		"explosion":
			# 爆炸：必定暴击，计算伤害
			result.is_crit = true
			result.damage = max(0.0, base_damage * crit_multiplier - defender.defense)

		"truehurt":
			# 真伤：无视防御，不吃暴击
			result.is_crit = false
			result.damage = base_damage

	result.damage = max(0.0, result.damage)
	return result

## 应用减速效果
static func apply_slow(current_speed: float, slow_value: float) -> float:
	return max(0.0, current_speed - slow_value)

## 应用震颤效果（降低防御）
static func apply_tremor(current_defense: float, defense_reduction: float) -> float:
	return max(0.0, current_defense - defense_reduction)
