# 项目配置指南

## 项目结构

```
equidistant/
├── core/
│   ├── game_manager.gd              # 核心游戏管理器
│   └── ...
├── Modules/
│   ├── game_state_module.gd         # 游戏状态保存模块
│   ├── keybinding_module.gd         # 按键绑定模块
│   ├── settings_module.gd           # 设置模块
│   └── ...
├── resource/
│   └── states/
│       ├── normal_model.gd          # 角色模板
│       ├── weapon_data.gd           # 武器数据
│       ├── bullet_data.gd           # 子弹数据
│       ├── skill_data.gd            # 技能数据
│       ├── enemy_data.gd            # 敌人数据
│       ├── strategy_buff.gd         # Buff数据
│       ├── strategy_manager.gd      # 升级系统
│       └── damage_calculator.gd     # 伤害计算
├── data/                            # 游戏数据资源
│   ├── weapons/                     # 武器资源
│   ├── bullets/                     # 子弹资源
│   ├── skills/                      # 技能资源
│   ├── enemies/                     # 敌人资源
│   └── buffs/                       # Buff资源
├── Fighting/
│   ├── fighting_scene.tscn
│   └── ...
├── Player/
│   ├── player.gd
│   └── player.tscn
├── GAME_ARCHITECTURE.md             # 架构文档
└── QUICK_REFERENCE.md               # 快速参考
```

## 初始化步骤

### 1. 配置 AutoLoad

编辑 `project.godot` 或通过编辑器：

```
项目 → 项目设置 → 自动加载
```

添加以下 AutoLoad：
- **SaveSystem** → `res://addons/enhance_save_system/core/save_system.gd`
- **GameManager** → `res://core/game_manager.gd`

### 2. 注册资源类型

在游戏启动脚本中（如 `_ready()` 或专用初始化脚本）：

```gdscript
# res://autoload/game_initializer.gd
extends Node

func _ready() -> void:
    # 注册所有可序列化资源类型
    ResourceSerializer.register(WeaponData)
    ResourceSerializer.register(BulletData)
    ResourceSerializer.register(SkillData)
    ResourceSerializer.register(EnemyData)
    ResourceSerializer.register(StrategyBuff)
    
    # 配置存档系统
    SaveSystem.max_slots = 8
    SaveSystem.encryption_enabled = false  # 开发时关闭加密，便于调试
    SaveSystem.compression_enabled = false
    
    # 初始化游戏管理器
    if GameManager.instance:
        GameManager.instance.strategy_manager = StrategyManager.new()
        _setup_buff_library()
    
    print("游戏初始化完成")

func _setup_buff_library() -> void:
    # 这里预加载或创建所有可用的 Buff
    var buffs = []
    
    # 从资源目录加载所有 Buff
    var buff_dir = DirAccess.open("res://data/buffs/")
    if buff_dir:
        buff_dir.list_dir_begin()
        var file = buff_dir.get_next()
        while file != "":
            if file.ends_with(".tres"):
                var buff = load("res://data/buffs/" + file)
                if buff:
                    GameManager.instance.strategy_manager.register_buff(buff)
            file = buff_dir.get_next()
```

将此脚本添加到 AutoLoad：`GameInitializer` → `res://autoload/game_initializer.gd`

### 3. 创建数据资源

#### 创建武器资源
1. 在编辑器中创建新资源：右键 → 新建资源
2. 选择 `WeaponData`
3. 填写属性：
   - id: `sword_01`
   - weapon_name: `长剑`
   - crit_rate: `0.25`
   - crit_damage: `1.8`
   - normal_extra_attack: `5.0`
   - normal_cold_time: `0.8`
   - skill_id: `slash_skill`
4. 保存到 `res://data/weapons/sword_01.tres`

#### 创建子弹资源
类似步骤，选择 `BulletData`：
- id: `arrow_normal`
- bullet_name: `普通箭`
- attack: `15.0`
- energy_cost: `5.0`
- damage_type: `0` (NORMAL)

#### 创建敌人资源
选择 `EnemyData`：
- id: `spider`
- enemy_name: `蜘蛛`
- attack: `3.0`
- defense: `1.0`
- speed: `150.0`
- max_hp: `30`
- gold_reward: `50`

### 4. 配置战斗场景

编辑 `fighting_scene.tscn`：

```
FightingScene (Node2D)
├── Background (CanvasLayer)
│   └── StarField (ColorRect) - 星空背景
├── Camera (Camera2D)
│   └── Vignette (ColorRect) - 白色到透明辉光
├── Enemies (Node)
├── Effects (CanvasLayer) - 伤害飘字和特效
└── UI (CanvasLayer)
    ├── HUD
    ├── LevelUpDialog
    └── GameOverScreen
```

### 5. 配置主场景

创建主游戏循环脚本：

```gdscript
# res://main.gd
extends Node

func _ready() -> void:
    GameManager.instance.start_new_game()

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("pause"):
        GameManager.instance.set_paused(!GameManager.instance.is_paused)
```

## 配置文件示例

### SaveSystem 配置
在项目设置中配置 SaveSystem：

```
SaveSystem:
  - max_slots: 8
  - auto_register: true
  - auto_load_global: true
  - auto_load_slot: 0
  - game_version: "1.0.0"
  - encryption_enabled: false  # 开发时关闭
  - compression_enabled: false # 开发时关闭
  - atomic_write_enabled: true
  - backup_enabled: true
```

### 输入映射配置

编辑 `project.godot` 添加输入事件：

```
input_map:
  move_left:
    - key: A
    - key: Left
  move_right:
    - key: D
    - key: Right
  move_up:
    - key: W
    - key: Up
  move_down:
    - key: S
    - key: Down
  use_skill_1:
    - key: 1
  use_skill_2:
    - key: 2
  ...
  use_skill_8:
    - key: 8
  pause:
    - key: Escape
  open_map:
    - key: M
  open_inventory:
    - key: B
  open_settings:
    - key: Escape
```

## 调试建议

### 1. 打印伤害计算结果
```gdscript
var result = DamageCalculator.calculate_damage(player, bullet, weapon, enemy)
print("基础伤害: %.1f, 暴击: %s, 最终伤害: %.1f" % [
    bullet.attack + weapon.normal_extra_attack + player["attack"],
    result.is_crit,
    result.damage
])
```

### 2. 检查升级权重
```gdscript
var weights = GameManager.instance.strategy_manager._get_weights_for_level(30)
print("30级权重: [%.1f, %.1f, %.1f]" % [weights[0], weights[1], weights[2]])
```

### 3. 验证 Buff 应用
```gdscript
var before_atk = GameStateModule.instance.player["attack"]
GameManager.instance.apply_selected_buff(buff)
var after_atk = GameStateModule.instance.player["attack"]
print("Buff前攻击: %.1f, Buff后: %.1f" % [before_atk, after_atk])
```

## 性能优化

1. **使用对象池管理敌人**：避免频繁的 `instantiate()` 和 `queue_free()`
2. **批量更新敌人**：使用单个循环而不是连接多个信号
3. **缓存计算结果**：不要每帧都重新计算伤害
4. **使用 MultiMesh**：大量相同敌人可以用 MultiMesh 渲染

## 常见问题

**Q: 如何调整游戏难度？**
A: 修改 `EnemyData` 的 `level` 字段，或在 `GameManager.spawn_wave()` 中调整敌人数量。

**Q: 如何添加新的输入快捷键？**
A: 在项目设置中添加新的输入事件，然后在脚本中使用 `Input.is_action_pressed()`。

**Q: 保存文件存储在哪里？**
A: 存储在 `user://saves/` 目录（用户数据目录）。

**Q: 如何导出游戏？**
A: 项目 → 导出，配置导出预设（Windows、Web、移动等）。
