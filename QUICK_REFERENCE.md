# 快速参考指南

## 数据创建示例

### 创建武器数据 (WeaponData)
```gdscript
var weapon = WeaponData.new()
weapon.id = "weapon_001"
weapon.weapon_name = "脉冲步枪"
weapon.damage_percent = 0.15 # 暴击率
weapon.damage = 1.8         # 暴击伤害
weapon.normal_range_x = 400.0
weapon.normal_range_y = 100.0
weapon.normal_target = 3
weapon.normal_extra_attack = 5.0
weapon.normal_cold_time = 0.3
weapon.bullets = ["bullet_001"]

# 保存为资源
ResourceSaver.save(weapon, "res://data/weapons/weapon_pulse.tres")
```

### 创建子弹数据 (BulletData)
```gdscript
var bullet = BulletData.new()
bullet.id = "bullet_001"
bullet.category = "normal"
bullet.attack = 12.0

# 持续伤害子弹示例
var dot_bullet = BulletData.new()
dot_bullet.id = "bullet_002"
dot_bullet.category = "constant"
dot_bullet.attack = 8.0
dot_bullet.modifier = {
    "dot_damage": 4.0,
    "segments": 5
}
```

### 创建敌人数据 (EnemyData)
```gdscript
var enemy = EnemyData.new()
enemy.id = "spider_basic"
enemy.name = "小型蜘蛛"
enemy.monster_scene = "res://scenes/enemies/spider_basic.tscn"
enemy.ai_type = EnemyData.EnemyAIType.CHASING
enemy.hp = 30.0
enemy.attack = 5.0
enemy.defense = 2.0
enemy.speed = 80.0
enemy.danger_level = 1
enemy.spawn_weight = 100.0
```

## 伤害计算示例

```gdscript
# 计算并应用伤害
var result = DamageCalculator.calculate_damage(player, bullet, weapon, enemy)
print("伤害: %.1f, 暴击: %s" % [result.damage, result.is_crit])

if result.category == "constant":
    for segment_dmg in result.segments:
        print("分段伤害: %.1f" % segment_dmg)
```

## 波次配置 (waves.json)

```json
{
  "max_enemies_on_screen": 60,
  "base_spawn_interval": 0.8,
  "waves": [
    {
      "start_time": 0,
      "end_time": 60,
      "spawn_configs": [
        { "enemy_id": "spider_basic", "weight": 100, "min_spawn": 1, "max_spawn": 3, "elite_chance": 0.05 }
      ]
    }
  ]
}
```

## 升级 Buff (StrategyBuff)

```gdscript
var buff = StrategyBuff.new()
buff.id = "strat_atk_001"
buff.name = "锋刃"
buff.category = "normal"
buff.full_description = "角色攻击力提高 %s%%"
buff.value_replace = [10.0]
buff.modifier_value = { "attack_mult": 0.1 }
```
