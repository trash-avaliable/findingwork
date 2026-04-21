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
- `weapon_slots`: 武器槽位 (上限 10)
- 经验系统：`current_exp`, `exp_to_next_level`, `exp_multiplier`

#### 武器数据 (`weapon_data.gd`)
- `damage_percent`: 暴击率 (0.0-1.0)
- `damage`: 暴击伤害倍数
- `normal_range_x/y`: 普通攻击范围
- `normal_target`: 目标人数
- `normal_extra_attack`: 附加攻击力
- `normal_cold_time`: 冷却时间
- `weapon_skill`: 大招技能场景路径
- `bullets`: 持有的子弹 ID 列表

#### 子弹数据 (`bullet_data.gd`)
- `attack`: 基础攻击力
- `category`: 伤害类型
	* `normal`: 普通伤害
	* `constant`: 持续伤害 (DOT)
	* `speed_down`: 减速
	* `defense_down`: 震颤 (降低防御)
	* `explosion`: 爆炸 (必定暴击)
	* `truehurt`: 真伤 (无视防御)
- `modifier`: 类型特定参数字典

#### 敌人数据 (`enemy_data.gd`)
- `id`: 敌人ID
- `ai_type`: AI 行为模式 (CHASING, RANGED, SPAWNER, FLEEING, STATIONARY)
- `attack/defense/speed/hp`: 基础属性
- `danger_level`: 威胁等级
- `spawn_weight`: 出现权重
- `cost`: 击败奖励金币
- `can_split`: 是否分裂

### 2. **战斗系统** (`damage_calculator.gd`)

#### 伤害计算公式

| 伤害类型 | 计算公式 | 说明 |
|---------|---------|------|
| normal | max(0, (基础伤害 * 暴击倍数 - 防御力)) | 标准伤害 |
| constant | (每层伤害 - 防御力) × 段数 | 分段显示伤害 |
| speed_down | 减速数值 | 降低移速 |
| defense_down | 防御力 × 降低百分比 | 降低防御力 |
| explosion | 基础伤害 × 暴击倍数 - 防御力 | 必定暴击 |
| truehurt | 基础伤害 | 无视防御 |

**基础伤害 = 子弹攻击力 + 武器附加攻击力 + 角色攻击力 + 技能附加攻击力**

### 3. **波次系统** (`core/wave_manager.gd`, `core/enemy_database.gd`)

- **EnemyDatabase**: 负责加载 `res://data/enemies/` 下的 `.tres` 资源以及 `res://config/waves.json`。
- **WaveManager**: 
    - 根据游戏时间控制波次切换。
    - 动态难度调整 (DDA)：根据玩家等级和游戏时间调整生成权重。
    - 动态生成速率：根据场上怪物数量自动调整生成间隔。
    - 生成位置：在相机视野外的随机边缘生成。

### 4. **策略升级系统** (`strategy_buff.gd`, `strategy_manager.gd`)

#### 升级机制
- 玩家每升一级触发「三选一」升级选项。
- 选项稀有度比例随等级动态调整：
    - 1-20级: [普通 0.8, 稀有 0.15, 传奇 0.05]
    - 81-100级: [普通 0.1, 21-40: 0.2, 传奇 0.7]

#### Buff 效果
- 获得新武器/子弹。
- 属性百分比或固定值提升 (攻击、防御、移速、金币、能量等)。
- 武器槽位扩充。

### 5. **核心游戏管理器** (`game_manager.gd`)

协调所有子系统：
- 游戏流程控制（开始/暂停/结束）。
- 升级系统触发。
- 波次管理与金币奖励处理。

## 使用流程

### 初始化
```gdscript
# 1. 确保 SaveSystem, GameManager, EnemyDatabase 作为 AutoLoad 运行
# 2. GameManager 会初始化并加载数据
```

### 战斗流程
1. `WaveManager` 定时在屏幕外生成敌人。
2. 敌人根据 `ai_type` 追踪或攻击玩家。
3. 玩家使用武器发射子弹，触发 `DamageCalculator` 计算伤害并应用效果。
4. 敌人死亡产生经验，玩家升级触发 `StrategyManager` 的 Buff 选择。
