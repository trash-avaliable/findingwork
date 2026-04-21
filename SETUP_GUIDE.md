# 项目配置指南

## 项目结构

```
equidistant/
├── core/
│   ├── game_manager.gd              # 核心游戏管理器
│   ├── enemy_database.gd            # 敌人与波次数据库 (AutoLoad)
│   └── wave_manager.gd              # 波次管理器
├── Modules/
│   ├── game_state_module.gd         # 游戏状态保存模块
│   └── ...
├── resource/
│   └── states/
│       ├── normal_model.gd          # 角色模板
│       ├── weapon_data.gd           # 武器数据
│       ├── bullet_data.gd           # 子弹数据
│       ├── skill_data.gd            # 技能数据
│       ├── enemy_data.gd            # 敌人数据
│       ├── strategy_buff.gd         # Buff 数据
│       ├── strategy_manager.gd      # 升级系统逻辑
│       └── damage_calculator.gd     # 伤害计算引擎
├── data/                            # 游戏数据资源 (.tres)
│   ├── weapons/
│   ├── bullets/
│   ├── skills/
│   ├── enemies/
│   └── buffs/
├── config/
│   └── waves.json                   # 全局波次配置
├── Fighting/                        # 战斗场景相关
├── Player/                          # 玩家相关
└── ...
```

## 初始化步骤

### 1. 配置 AutoLoad

在 `项目 -> 项目设置 -> 自动加载` 中添加以下单例：

1. **SaveSystem**: `res://addons/enhance_save_system/core/save_system.gd`
2. **EnemyDatabase**: `res://core/enemy_database.gd`
3. **GameManager**: `res://core/game_manager.gd`

### 2. 准备数据

1. **波次配置**: 编辑 `res://config/waves.json`，定义各阶段生成的怪物 ID、权重及精英概率。
2. **敌人资源**: 在 `res://data/enemies/` 下创建 `EnemyData` 资源，ID 需与 `waves.json` 中的 `enemy_id` 匹配。
3. **武器与子弹**: 在对应目录下创建 `.tres` 资源。

### 3. 配置战斗场景

1. 在 `FightingScene` 中添加 `WaveManager` 节点。
2. 确保玩家节点被添加到名为 `player` 的组中，以便 `WaveManager` 自动获取。

## 关键代码集成

### 伤害计算
```gdscript
var result = DamageCalculator.calculate_damage(player, bullet, weapon, enemy)
enemy.take_damage(result)
```

### 玩家移动与眼部偏移
玩家会自动跟随鼠标移动。眼部偏移逻辑已在 `player.gd` 中实现，会自动根据移动方向调整 X 轴偏移 (左移 6/10, 右移 -10/-6)。

### 升级系统
当玩家 `gain_exp` 触发 `level_up` 信号时，由 `GameManager` 调用 `StrategyManager.generate_upgrade_options()` 并弹出 UI。

## 调试工具建议

- **数据查看**: 使用 `EnemyDatabase.enemies` 检查所有已加载的怪物。
- **波次监控**: 在 `WaveManager` 中打印 `current_wave_index` 以确认波次进度。
- **伤害日志**: 在 `DamageCalculator` 中打印计算过程以验证公式。
