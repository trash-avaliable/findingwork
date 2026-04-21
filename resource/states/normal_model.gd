## 角色数据模板
class_name CharacterTemplate
extends Resource

## 基础属性
@export var attack: float = 10.0
@export var defense: float = 5.0
@export var speed: float = 200.0
@export var energy: int = 100 # 能量条当前值
@export var max_energy: int = 100 # 能量条上限
@export var level: int = 1
@export var gold: int = 0

## 武器槽位
@export var weapon_slots: int = 3
@export var max_weapon_slots: int = 10

## 当前获得的所有武器和子弹 (ID 列表)
var owned_weapons: Array[String] = []
var owned_bullets: Array[String] = []

## 经验值系统 (可选，架构图中提到过等级)
var current_exp: float = 0.0
var exp_to_next_level: float = 100.0
var exp_multiplier: float = 1.0

## 升级逻辑
func gain_exp(amount: float) -> bool:
	current_exp += amount * exp_multiplier
	if current_exp >= exp_to_next_level:
		level_up()
		return true
	return false

func level_up() -> void:
	level += 1
	current_exp -= exp_to_next_level
	exp_to_next_level *= 1.2 # 简单的经验曲线
	
	# 每升5级，能量条上限加1
	if level % 5 == 0:
		max_energy += 1
		energy += 1
	
	# 发出信号 (由管理器处理)
	if GameManager.instance:
		GameManager.instance.emit_signal("level_up", level)

## 使用金币升级 (手动升级)
func upgrade_with_gold() -> bool:
	var upgrade_cost = level * 50
	if gold >= upgrade_cost:
		gold -= upgrade_cost
		# 每升一级提升基础攻击力，防御力，移速
		attack += 2.0
		defense += 1.0
		speed += 5.0
		level += 1
		return true
	return false

## 应用策略 Buff
func apply_strategy_modifier(type: String, value_float: float, value_int: int) -> void:
	match type:
		"attack_up":
			attack = attack * (1.0 + value_float) + value_int
		"defense_up":
			defense = defense * (1.0 + value_float) + value_int
		"speed_up":
			speed += value_int
		"gold_up":
			gold = int(float(gold) * (1.0 + value_float) + value_int)
		"energy_up":
			max_energy += value_int
			energy += value_int
		"weapon_slot":
			weapon_slots = clampi(weapon_slots + value_int, 1, max_weapon_slots)
		# 武器相关的属性（暴击等）通常在武器实例或全局计算中处理

## 重置为初始状态
func reset() -> void:
	attack = 10.0
	defense = 5.0
	speed = 200.0
	energy = 100
	max_energy = 100
	level = 1
	gold = 0
	weapon_slots = 3
	owned_weapons.clear()
	owned_bullets.clear()
	current_exp = 0.0
	exp_to_next_level = 100.0
	exp_multiplier = 1.0
