# 快速参考指南

## 常见操作

### 创建武器数据
```gdscript
var sword = WeaponData.new()
sword.id = "sword_01"
sword.weapon_name = "长剑"
sword.crit_rate = 0.25
sword.crit_damage = 1.8
sword.normal_extra_attack = 5.0
sword.normal_cold_time = 0.8
sword.skill_id = "slash_skill"

# 保存为资源
sword.resource_path = "res://data/weapons/sword_01.tres"
sword.take_over_path(sword.resource_path)
ResourceSaver.save(sword)
```

### 创建子弹数据
```gdscript
# 普通箭
var arrow = BulletData.new()
arrow.id = "arrow_normal"
arrow.bullet_name = "普通箭"
arrow.attack = 15.0
arrow.energy_cost = 5.0
arrow.damage_type = BulletData.DamageType.NORMAL

# DOT 箭（持续伤害）
var fire_arrow = BulletData.new()
fire_arrow.id = "arrow_fire"
fire_arrow.bullet_name = "火焰箭"
fire_arrow.attack = 10.0
fire_arrow.damage_type = BulletData.DamageType.DOT
fire_arrow.damage_value = 3.0  # 每层伤害
fire_arrow.segments = 5  # 5 段显示
fire_arrow.duration = 3.0

# 减速箭
var slow_arrow = BulletData.new()
slow_arrow.id = "arrow_slow"
slow_arrow.bullet_name = "冰冻箭"
slow_arrow.damage_type = BulletData.DamageType.SLOW
slow_arrow.damage_value = 50.0  # 减速 50
```

### 计算伤害
```gdscript
# 获取数据
var player_char = GameStateModule.instance.player
var weapon = preload("res://data/weapons/sword_01.tres")
var bullet = preload("res://data/bullets/arrow_normal.tres")
var enemy = preload("res://data/enemies/spider.tres")

# 计算伤害
var dmg_result = DamageCalculator.calculate_damage(player_char, bullet, weapon, enemy)

print("伤害: %.1f, 暴击: %s" % [dmg_result.damage, dmg_result.is_crit])

# 处理 DOT
if dmg_result.damage_type == DamageCalculator.DamageType.DOT:
    for segment_dmg in dmg_result.segments:
        print("- 伤害段: %.1f" % segment_dmg)
```

### 创建 Buff
```gdscript
# 攻击力提升 Buff
var attack_buff = StrategyBuff.new()
attack_buff.id = "buff_atk_up_5"
attack_buff.buff_name = "攻击强化"
attack_buff.buff_type = StrategyBuff.BuffType.ATTACK_UP
attack_buff.rarity = StrategyBuff.Rarity.RARE
attack_buff.value = 5.0

# 武器 Buff
var sword_buff = StrategyBuff.new()
sword_buff.id = "buff_get_sword"
sword_buff.buff_name = "获得长剑"
sword_buff.buff_type = StrategyBuff.BuffType.WEAPON
sword_buff.rarity = StrategyBuff.Rarity.NORMAL
sword_buff.item_id = "sword_01"
sword_buff.description = "获得一把强大的长剑"
```

### 升级系统
```gdscript
# 注册 Buff 到管理器
var strategy_mgr = StrategyManager.new()
strategy_mgr.register_buff(attack_buff)
strategy_mgr.register_buff(sword_buff)

# 玩家升级触发（30级）
var options = strategy_mgr.generate_upgrade_options(30, 3)
for opt in options:
    print("%d. %s (%s)" % [opt.index + 1, opt.buff.buff_name, opt.buff.get_rarity_string()])

# 玩家选择选项 0
if options.size() > 0:
    strategy_mgr.apply_buff(GameStateModule.instance.player, options[0].buff)
```

### 游戏流程
```gdscript
# 开始新游戏
GameManager.instance.start_new_game()

# 监听升级事件
GameManager.instance.level_up.connect(func(new_level):
    print("升级到 %d 级" % new_level)
)

# 监听 Buff 选择需求
GameManager.instance.buff_selection_needed.connect(func(options):
    # 显示 UI，让玩家选择
    show_buff_selection_ui(options)
)

# 玩家选择后应用
func on_buff_selected(buff):
    GameManager.instance.apply_selected_buff(buff)

# 敌人被击败
GameManager.instance.enemy_defeated(gold_amount)

# 游戏结束
GameManager.instance.end_game(is_victory)
```

## 扩展示例

### 自定义敌人
```gdscript
class_name CustomSpider
extends CharacterBody2D

var enemy_data: EnemyData
var health: float
var current_effects: Dictionary = {}  # 状态效果

func _ready() -> void:
    enemy_data = preload("res://data/enemies/spider.tres")
    health = float(enemy_data.get_scaled_max_hp())

func take_damage(result: DamageCalculator.DamageResult) -> void:
    # 应用伤害
    health -= result.damage
    
    # 应用特殊效果
    match result.damage_type:
        DamageCalculator.DamageType.SLOW:
            current_effects["slow"] = {
                "value": result.damage,
                "time": result.segments[0] if result.segments else 3.0,
            }
        DamageCalculator.DamageType.TREMOR:
            # 防御力降低
            pass
        DamageCalculator.DamageType.DOT:
            current_effects["dot"] = {
                "damage": result.damage / result.segments.size(),
                "remaining_segments": result.segments.size(),
                "tick": 0.3,
                "timer": 0.0,
            }
    
    if health <= 0:
        die()

func _process(delta: float) -> void:
    # 应用减速效果
    var current_speed = enemy_data.get_scaled_speed()
    if "slow" in current_effects:
        current_speed = DamageCalculator.apply_slow(
            current_speed,
            current_effects["slow"]["value"]
        )
    
    velocity = global_position.direction_to(player.global_position) * current_speed
    move_and_slide()
```

### 自定义 UI - 升级选择
```gdscript
extends Control

@onready var option_buttons = [$Option1, $Option2, $Option3]

func _ready() -> void:
    GameManager.instance.buff_selection_needed.connect(_on_buff_selection_needed)

func _on_buff_selection_needed(options: Array) -> void:
    show()
    
    for i in range(min(3, options.size())):
        var opt = options[i]
        var btn = option_buttons[i]
        btn.text = "%s\n(%s)" % [opt.buff.buff_name, opt.buff.get_rarity_string()]
        btn.pressed.connect(func():
            GameManager.instance.apply_selected_buff(opt.buff)
            hide()
        )
```

## 常见问题

**Q: 如何添加新的伤害类型？**
A: 在 `BulletData` 和 `DamageCalculator` 中添加新的枚举值和对应的计算公式。

**Q: 如何修改升级权重？**
A: 编辑 `StrategyManager.LEVEL_WEIGHTS` 常量。

**Q: 防御力如何运作？**
A: 普通伤害公式中 `max(0, 伤害 - 防御力)`，可以在 `DamageCalculator` 中调整。

**Q: 能量条如何恢复？**
A: 需要在主场景中定时恢复，如：`player["energy"] = min(player["energy"] + recovery_rate * delta, player["max_energy"])`
