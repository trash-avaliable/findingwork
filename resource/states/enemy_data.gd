## 敌人数据模板
class_name EnemyData
extends SaveResource

enum EnemyAIType {
	CHASING,        # 直接追踪玩家
	RANGED,         # 远程射击
	SPAWNER,        # 召唤其他怪物
	FLEEING,        # 逃离玩家（用于辅助怪）
	STATIONARY      # 固定炮台
}

## 敌人基本信息
var id: String = ""
var name: String = "" # 对应文档中的 name

## 资源路径
var monster_scene: String = "" # 怪物场景路径

## AI 行为
var ai_type: EnemyAIType = EnemyAIType.CHASING
var attack_range: float = 20.0        # 近战碰撞距离
var projectile_scene: String = ""     # 远程怪物使用的子弹路径

## 基础属性
var attack: float = 5.0
var defense: float = 2.0
var speed: float = 150.0
var hp: float = 50.0 # 对应文档中的 hp

## 威胁与权重
var danger_level: int = 1 # 对应文档中的 danger_level
var spawn_weight: float = 1.0

## 技能
var skillscene: String = "" # 技能场景路径

## 击败奖励
var cost: int = 10 # 对应文档中的 cost (击败可获得金币)

## 特殊能力
var can_split: bool = false
var split_into: Array[String] = []      # 分裂出的子怪物数据ID
var split_count: int = 2

# ──────────────────────────────────────────────
# SaveResource 接口
# ──────────────────────────────────────────────

func get_type_id() -> String:
	return "EnemyData"

func to_dict() -> Dictionary:
	return {
		"id": id,
		"name": name,
		"monster_scene": monster_scene,
		"ai_type": ai_type,
		"attack_range": attack_range,
		"projectile_scene": projectile_scene,
		"attack": attack,
		"defense": defense,
		"speed": speed,
		"hp": hp,
		"danger_level": danger_level,
		"spawn_weight": spawn_weight,
		"skillscene": skillscene,
		"cost": cost,
		"can_split": can_split,
		"split_into": split_into,
		"split_count": split_count,
	}

func from_dict(data: Dictionary) -> void:
	id = str(data.get("id", ""))
	name = str(data.get("name", ""))
	monster_scene = str(data.get("monster_scene", ""))
	ai_type = int(data.get("ai_type", EnemyAIType.CHASING)) as EnemyAIType
	attack_range = float(data.get("attack_range", 20.0))
	projectile_scene = str(data.get("projectile_scene", ""))
	attack = float(data.get("attack", 5.0))
	defense = float(data.get("defense", 2.0))
	speed = float(data.get("speed", 150.0))
	hp = float(data.get("hp", 50.0))
	danger_level = int(data.get("danger_level", 1))
	spawn_weight = float(data.get("spawn_weight", 1.0))
	skillscene = str(data.get("skillscene", ""))
	cost = int(data.get("cost", 10))
	can_split = bool(data.get("can_split", false))
	split_into = data.get("split_into", [])
	split_count = int(data.get("split_count", 2))

## 获取等级调整后的属性 (可以保留这些逻辑)
func get_scaled_attack(level: int) -> float:
	return attack * (1.0 + (level - 1) * 0.1)

func get_scaled_defense(level: int) -> float:
	return defense * (1.0 + (level - 1) * 0.1)

func get_scaled_speed(level: int) -> float:
	return speed * (1.0 + (level - 1) * 0.05)

func get_scaled_max_hp(level: int) -> float:
	return hp * (1.0 + (level - 1) * 0.15)
