## 角色数据模板
class_name CharacterTemplate
extends Resource

## 基础属性
@export var attack: float = 10.0
@export var defense: float = 5.0
@export var speed: float = 200.0
@export var energy: float = 100.0
@export var max_energy: float = 100.0
@export var level: int = 1
@export var gold: int = 0

## 当前装备的武器和子弹
var equipped_weapon: String = ""  # weapon_id
var equipped_bullet: String = ""  # bullet_id

## 当前获得的所有武器（weapon_id list）
var owned_weapons: Array[String] = []
var owned_bullets: Array[String] = []

## 应用属性增强
func apply_buff(buff_type: String, value: float) -> void:
	match buff_type:
		"attack":
			attack += value
		"defense":
			defense += value
		"speed":
			speed += value
		"energy":
			max_energy += value
			energy = min(energy + value, max_energy)
		"crit_rate":
			# 由武器管理
			pass
		"crit_damage":
			# 由武器管理
			pass

## 重置为初始状态
func reset() -> void:
	attack = 10.0
	defense = 5.0
	speed = 200.0
	energy = 100.0
	max_energy = 100.0
	level = 1
	gold = 0
	equipped_weapon = ""
	equipped_bullet = ""
	owned_weapons.clear()
	owned_bullets.clear()
