# 类吸血鬼生存者游戏框架文档

## 架构概述

本项目是一个完整的类吸血鬼生存者游戏系统，包括以下核心模块：

### 1. **数据系统** (`resource/states/`)

#### 基础角色模板 (`normal_model.gd`)
- `attack`: 攻击力
- `defense`: 防御力
- `speed`: 移动速度
- `energy`: 能量条当前值
- `max_energy`: 能量条上限
- `level`: 等级
- `gold`: 金币
- 装备管理：`owned_weapons`, `owned_bullets`

#### 武器数据 (`weapon_data.gd` - SaveResource)
```
WeaponData:
  - id: 武器唯一标识
  - weapon_name: 武器名称
  - crit_rate: 暴击率 (0.0-1.0)
  - crit_damage: 暴击伤害倍数 (通常 1.5-2.0)
  - normal_range_x/y: 普通攻击范围
  - normal_target: 目标人数
  - normal_extra_attack: 附加攻击力
  - normal_cold_time: 冷却时间
  - skill_id: 大招技能ID
```

#### 子弹数据 (`bullet_data.gd` - SaveResource)
```
BulletData:
  - id: 子弹唯一标识
  - attack: 基础攻击力
  - energy_cost: 能量消耗
  - damage_type: 伤害类型枚举
    * NORMAL: 普通伤害
    * DOT: 持续伤害（DoT）
    * SLOW: 减速
    * TREMOR: 震颤（降低防御）
    * EXPLOSION: 爆炸（必定暴击）
    * TRUE_DAMAGE: 真伤（无视防御）
  - damage_value: 类型特定参数
  - duration: 持续时间
  - segments: DOT分段数
```

#### 技能数据 (`skill_data.gd` - SaveResource)
```
SkillData:
  - id: 技能ID
  - skill_name: 技能名称
  - special_range_x/y: 大招范围
  - target: 目标人数
  - extra_attack: 附加攻击力
  - cold_time: 冷却时间
  - extra_energy_cost: 能量消耗
  - power: 后坐力
```

#### 敌人数据 (`enemy_data.gd` - SaveResource)
```
EnemyData:
  - id: 敌人ID
  - attack/defense/speed: 基础属性
  - max_hp: 最大血量
  - skill_id: 敌人技能
  - gold_reward: 击败奖励金币
  - level: 敌人等级（影响属性倍增）
  - spawn_weight: 出现权重
```

### 2. **战斗系统** (`damage_calculator.gd`)

#### 伤害计算公式

| 伤害类型 | 计算公式 | 说明 |
|---------|---------|------|
| NORMAL | max(0, (基础伤害 * 暴击倍数 - 防御力)) | 标准伤害 |
| DOT | (每层伤害 - 防御力) × 段数 | 分段显示伤害 |
| SLOW | 减速数值 | 直接降低移速 |
| TREMOR | 防御力 × 防御力百分比 | 降低防御力 |
| EXPLOSION | 基础伤害 × 暴击倍数 - 防御力 | 必定暴击 |
| TRUE_DAMAGE | 基础伤害 | 无视防御 |

**基础伤害 = 子弹攻击力 + 武器附加攻击力 + 角色攻击力**

**暴击触发：** `if rand() < 武器暴击率: 伤害 *= 暴击伤害倍数`

### 3. **升级策略系统** (`strategy_buff.gd`, `strategy_manager.gd`)

#### Buff 类型
- WEAPON: 获得新武器
- BULLET: 获得新子弹
- ATTACK_UP: 攻击力 +X
- SPEED_UP: 移速 +X
- DEFENSE_UP: 防御力 +X
- GOLD_UP: 金币倍增 ×(1+X)
- ENERGY_UP: 能量上限 +X
- CRIT_RATE_UP: 暴击率 +X
- CRIT_DAMAGE_UP: 暴击伤害 +X

#### 稀有度权重 (基于玩家等级)
```
等级 1-20:   [普通 0.8, 稀有 0.15, 传奇 0.05]
等级 21-40:  [普通 0.6, 稀有 0.3,  传奇 0.1]
等级 41-60:  [普通 0.3, 稀有 0.5,  传奇 0.2]
等级 61-80:  [普通 0.1, 稀有 0.4,  传奇 0.5]
等级 81-100: [普通 0.1, 稀有 0.2,  传奇 0.7]
```

**每升一级触发「三选一」升级选项**

### 4. **游戏状态管理** (`game_state_module.gd`)

属于**槽位存档模块** (is_global = false)，存储：
- 玩家角色数据
- 当前关卡/波次
- 击杀敌人计数
- 自定义游戏状态

### 5. **核心游戏管理器** (`game_manager.gd`)

协调所有子系统：
- 游戏流程控制（开始/暂停/结束）
- 升级系统触发
- 波次管理
- 金币奖励处理

## 使用流程

### 初始化
```gdscript
# 1. 确保 SaveSystem 作为 AutoLoad 运行
# 2. GameManager 会自动初始化游戏状态模块
# 3. 注册 Buff 库到 StrategyManager

var gm = GameManager.instance
gm.strategy_manager.register_buff(my_buff_data)
```

### 开始新游戏
```gdscript
GameManager.instance.start_new_game()
```

### 战斗示例
```gdscript
# 计算伤害
var result = DamageCalculator.calculate_damage(player, bullet, weapon, enemy)
enemy_hp -= result.damage

# 应用状态效果
if result.damage_type == DamageCalculator.DamageType.SLOW:
    enemy_speed = DamageCalculator.apply_slow(enemy_speed, result.damage)
```

### 升级触发
```gdscript
GameManager.instance.level_up_player()
# 信号 buff_selection_needed 触发
# 玩家选择后调用：
GameManager.instance.apply_selected_buff(selected_buff)
```

## 存档系统集成

所有数据类都继承 `SaveResource`，通过 `ResourceSerializer` 序列化：

```gdscript
# 注册资源类型（在项目启动时）
ResourceSerializer.register(WeaponData)
ResourceSerializer.register(BulletData)
ResourceSerializer.register(SkillData)
ResourceSerializer.register(EnemyData)
ResourceSerializer.register(StrategyBuff)

# 保存
SaveSystem.save_slot()

# 加载
SaveSystem.load_slot(1)
```

## 配置数据库

你可以通过编辑器创建以下资源文件：

```
res://data/
  ├── weapons/
  │   ├── sword_01.tres (WeaponData)
  │   └── bow_01.tres
  ├── bullets/
  │   ├── arrow_normal.tres (BulletData)
  │   └── arrow_fire.tres
  ├── skills/
  │   ├── slash_skill.tres (SkillData)
  │   └── rain_skill.tres
  ├── enemies/
  │   ├── spider.tres (EnemyData)
  │   └── goblin.tres
  └── buffs/
      ├── buff_atk_up.tres (StrategyBuff)
      └── buff_weapon_sword.tres
```

## 扩展建议

1. **UI 系统**：为升级选择、战斗信息、库存等创建 UI 节点
2. **敌人 AI**：创建具体的敌人行为树
3. **效果系统**：粒子特效和伤害飘字
4. **音频系统**：背景音乐和音效播放
5. **关卡设计**：波次配置和难度调整
