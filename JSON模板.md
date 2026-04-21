武器模板：
[
  {
    "id": "weapon_001",
    "weapon_name": "脉冲步枪",
    "damage_percent": 0.15,
    "damage": 1.8,
    "normal_range_x": 400.0,
    "normal_range_y": 100.0,
    "normal_target": 3,
    "normal_extra_attack": 5.0,
    "normal_cold_time": 0.3,
    "extra_energy_cost": 1,
    "power": 0.5,
    "weapon_level": 1
  },
  {
    "id": "weapon_002",
    "weapon_name": "霰弹炮",
    "damage_percent": 0.05,
    "damage": 2.5,
    "normal_range_x": 200.0,
    "normal_range_y": 200.0,
    "normal_target": 5,
    "normal_extra_attack": 12.0,
    "normal_cold_time": 1.2,
    "extra_energy_cost": 2,
    "power": 2.0,
    "weapon_level": 1
  },
  {
    "id": "weapon_003",
    "weapon_name": "激光发射器",
    "damage_percent": 0.25,
    "damage": 2.0,
    "normal_range_x": 600.0,
    "normal_range_y": 50.0,
    "normal_target": 1,
    "normal_extra_attack": 8.0,
    "normal_cold_time": 0.1,
    "extra_energy_cost": 0,
    "power": 0.0,
    "weapon_level": 1
  },
  {
    "id": "weapon_004",
    "weapon_name": "等离子球",
    "damage_percent": 0.1,
    "damage": 1.6,
    "normal_range_x": 300.0,
    "normal_range_y": 300.0,
    "normal_target": 4,
    "normal_extra_attack": 4.0,
    "normal_cold_time": 0.8,
    "extra_energy_cost": 1,
    "power": 0.2,
    "weapon_level": 1
  },
  {
    "id": "weapon_005",
    "weapon_name": "电磁弩",
    "damage_percent": 0.4,
    "damage": 1.9,
    "normal_range_x": 500.0,
    "normal_range_y": 20.0,
    "normal_target": 2,
    "normal_extra_attack": 15.0,
    "normal_cold_time": 0.9,
    "extra_energy_cost": 2,
    "power": 1.5,
    "weapon_level": 1
  },
  {
    "id": "weapon_006",
    "weapon_name": "火焰喷射器",
    "damage_percent": 0.0,
    "damage": 1.0,
    "normal_range_x": 250.0,
    "normal_range_y": 80.0,
    "normal_target": 6,
    "normal_extra_attack": 2.0,
    "normal_cold_time": 0.05,
    "extra_energy_cost": 1,
    "power": 0.1,
    "weapon_level": 1
  },
  {
    "id": "weapon_007",
    "weapon_name": "重力手雷",
    "damage_percent": 0.2,
    "damage": 2.2,
    "normal_range_x": 180.0,
    "normal_range_y": 180.0,
    "normal_target": 3,
    "normal_extra_attack": 20.0,
    "normal_cold_time": 2.0,
    "extra_energy_cost": 3,
    "power": 0.8,
    "weapon_level": 1
  },
  {
    "id": "weapon_008",
    "weapon_name": "特斯拉线圈",
    "damage_percent": 0.08,
    "damage": 1.7,
    "normal_range_x": 350.0,
    "normal_range_y": 350.0,
    "normal_target": 4,
    "normal_extra_attack": 6.0,
    "normal_cold_time": 0.6,
    "extra_energy_cost": 2,
    "power": 0.3,
    "weapon_level": 1
  }
]
子弹模板：
[
  {
    "id": "bullet_001",
    "bullet_scene": "res://scenes/bullets/bullet_normal.tscn",
    "attack": 12.0,
    "category": "normal",
    "duration": 0.0,
    "modifier": {}
  },
  {
    "id": "bullet_002",
    "bullet_scene": "res://scenes/bullets/bullet_dot.tscn",
    "attack": 8.0,
    "category": "constant",
    "duration": 3.0,
    "modifier": {
      "dot_damage": 4.0,
      "tick_interval": 0.5
    }
  },
  {
    "id": "bullet_003",
    "bullet_scene": "res://scenes/bullets/bullet_slow.tscn",
    "attack": 5.0,
    "category": "speed_down",
    "duration": 2.5,
    "modifier": {
      "slow_amount": 30.0
    }
  },
  {
    "id": "bullet_004",
    "bullet_scene": "res://scenes/bullets/bullet_defense_down.tscn",
    "attack": 6.0,
    "category": "defense_down",
    "duration": 4.0,
    "modifier": {
      "defense_reduce_percent": 0.2
    }
  },
  {
    "id": "bullet_005",
    "bullet_scene": "res://scenes/bullets/bullet_explosion.tscn",
    "attack": 20.0,
    "category": "explosion",
    "duration": 0.0,
    "modifier": {}
  },
  {
    "id": "bullet_006",
    "bullet_scene": "res://scenes/bullets/bullet_truehurt.tscn",
    "attack": 15.0,
    "category": "truehurt",
    "duration": 0.0,
    "modifier": {}
  }
]
敌人模板：
[
  {
    "id": "spider_basic",
    "name": "小型蜘蛛",
    "ai_type": "CHASING",
    "hp": 30.0,
    "attack": 5.0,
    "defense": 2.0,
    "speed": 80.0,
    "danger_level": 1,
    "spawn_weight": 100.0,
    "cost": 5,
    "attack_range": 15.0,
    "can_split": false,
    "split_into": [],
    "split_count": 0
  },
  {
    "id": "spider_elite",
    "name": "剧毒蜘蛛",
    "ai_type": "CHASING",
    "hp": 120.0,
    "attack": 12.0,
    "defense": 8.0,
    "speed": 60.0,
    "danger_level": 3,
    "spawn_weight": 30.0,
    "cost": 20,
    "attack_range": 25.0,
    "can_split": true,
    "split_into": ["spider_basic", "spider_basic"],
    "split_count": 2
  },
  {
    "id": "three_body_soldier",
    "name": "三体战士",
    "ai_type": "RANGED",
    "hp": 80.0,
    "attack": 10.0,
    "defense": 10.0,
    "speed": 50.0,
    "danger_level": 2,
    "spawn_weight": 60.0,
    "cost": 15,
    "attack_range": 200.0
  },
  {
    "id": "three_body_commander",
    "name": "三体指挥官",
    "ai_type": "SPAWNER",
    "hp": 200.0,
    "attack": 15.0,
    "defense": 20.0,
    "speed": 30.0,
    "danger_level": 4,
    "spawn_weight": 10.0,
    "cost": 50,
    "attack_range": 0.0,
    "can_split": false
  },
  {
    "id": "fleeing_drone",
    "name": "逃离无人机",
    "ai_type": "FLEEING",
    "hp": 50.0,
    "attack": 0.0,
    "defense": 5.0,
    "speed": 120.0,
    "danger_level": 1,
    "spawn_weight": 20.0,
    "cost": 8,
    "attack_range": 0.0
  },
  {
    "id": "stationary_turret",
    "name": "固定炮台",
    "ai_type": "STATIONARY",
    "hp": 150.0,
    "attack": 20.0,
    "defense": 25.0,
    "speed": 0.0,
    "danger_level": 3,
    "spawn_weight": 15.0,
    "cost": 30,
    "attack_range": 300.0
  }
]
波次模板：
{
  "max_enemies_on_screen": 60,
  "base_spawn_interval": 0.8,
  "player_dps_baseline": 50.0,
  "waves": [
    {
      "start_time": 0,
      "end_time": 60,
      "spawn_configs": [
        {
          "enemy_id": "spider_basic",
          "weight": 100.0,
          "min_spawn": 1,
          "max_spawn": 3,
          "elite_chance": 0.0
        },
        {
          "enemy_id": "fleeing_drone",
          "weight": 30.0,
          "min_spawn": 1,
          "max_spawn": 2,
          "elite_chance": 0.0
        }
      ]
    },
    {
      "start_time": 60,
      "end_time": 120,
      "spawn_configs": [
        {
          "enemy_id": "spider_basic",
          "weight": 80.0,
          "min_spawn": 2,
          "max_spawn": 4,
          "elite_chance": 0.05
        },
        {
          "enemy_id": "spider_elite",
          "weight": 20.0,
          "min_spawn": 1,
          "max_spawn": 1,
          "elite_chance": 0.1
        },
        {
          "enemy_id": "three_body_soldier",
          "weight": 50.0,
          "min_spawn": 1,
          "max_spawn": 3,
          "elite_chance": 0.1
        },
        {
          "enemy_id": "stationary_turret",
          "weight": 15.0,
          "min_spawn": 1,
          "max_spawn": 1,
          "elite_chance": 0.0
        }
      ]
    },
    {
      "start_time": 120,
      "end_time": 200,
      "spawn_configs": [
        {
          "enemy_id": "spider_basic",
          "weight": 60.0,
          "min_spawn": 3,
          "max_spawn": 5,
          "elite_chance": 0.1
        },
        {
          "enemy_id": "spider_elite",
          "weight": 40.0,
          "min_spawn": 1,
          "max_spawn": 2,
          "elite_chance": 0.15
        },
        {
          "enemy_id": "three_body_soldier",
          "weight": 80.0,
          "min_spawn": 2,
          "max_spawn": 4,
          "elite_chance": 0.15
        },
        {
          "enemy_id": "three_body_commander",
          "weight": 10.0,
          "min_spawn": 1,
          "max_spawn": 1,
          "elite_chance": 0.2
        },
        {
          "enemy_id": "stationary_turret",
          "weight": 25.0,
          "min_spawn": 1,
          "max_spawn": 2,
          "elite_chance": 0.0
        }
      ]
    },
    {
      "start_time": 200,
      "end_time": 300,
      "spawn_configs": [
        {
          "enemy_id": "spider_elite",
          "weight": 60.0,
          "min_spawn": 2,
          "max_spawn": 4,
          "elite_chance": 0.2
        },
        {
          "enemy_id": "three_body_soldier",
          "weight": 100.0,
          "min_spawn": 3,
          "max_spawn": 5,
          "elite_chance": 0.2
        },
        {
          "enemy_id": "three_body_commander",
          "weight": 30.0,
          "min_spawn": 1,
          "max_spawn": 2,
          "elite_chance": 0.3
        },
        {
          "enemy_id": "stationary_turret",
          "weight": 40.0,
          "min_spawn": 2,
          "max_spawn": 3,
          "elite_chance": 0.1
        }
      ]
    }
  ]
}
策略模板：
[
  {
    "id": "strat_atk_001",
    "name": "锋刃",
    "category": "normal",
    "part_description": "攻击力小幅提升",
    "full_description": "角色攻击力提高 %s%%",
    "type_replace": ["attack_mult"],
    "value_replace": [10.0],
    "modifier_value": {
      "attack_mult": 0.1
    }
  },
  {
    "id": "strat_atk_002",
    "name": "狂战",
    "category": "rare",
    "part_description": "攻击力显著提升",
    "full_description": "角色攻击力提高 %s%%",
    "type_replace": ["attack_mult"],
    "value_replace": [25.0],
    "modifier_value": {
      "attack_mult": 0.25
    }
  },
  {
    "id": "strat_atk_003",
    "name": "弑神之力",
    "category": "legend",
    "part_description": "攻击力巨幅提升",
    "full_description": "角色攻击力提高 %s%%",
    "type_replace": ["attack_mult"],
    "value_replace": [50.0],
    "modifier_value": {
      "attack_mult": 0.5
    }
  },
  {
    "id": "strat_def_001",
    "name": "铁皮",
    "category": "normal",
    "part_description": "防御力小幅提升",
    "full_description": "角色防御力提高 %s%%",
    "type_replace": ["defense_mult"],
    "value_replace": [10.0],
    "modifier_value": {
      "defense_mult": 0.1
    }
  },
  {
    "id": "strat_def_002",
    "name": "坚盾",
    "category": "rare",
    "part_description": "防御力显著提升",
    "full_description": "角色防御力提高 %s%%",
    "type_replace": ["defense_mult"],
    "value_replace": [25.0],
    "modifier_value": {
      "defense_mult": 0.25
    }
  },
  {
    "id": "strat_def_003",
    "name": "不破之壁",
    "category": "legend",
    "part_description": "防御力巨幅提升",
    "full_description": "角色防御力提高 %s%%",
    "type_replace": ["defense_mult"],
    "value_replace": [50.0],
    "modifier_value": {
      "defense_mult": 0.5
    }
  },
  {
    "id": "strat_spd_001",
    "name": "疾步",
    "category": "normal",
    "part_description": "移动速度提升",
    "full_description": "移动速度增加 %s 点",
    "type_replace": ["speed_add"],
    "value_replace": [20],
    "modifier_value": {
      "speed_add": 20
    }
  },
  {
    "id": "strat_spd_002",
    "name": "风行者",
    "category": "rare",
    "part_description": "移动速度大幅提升",
    "full_description": "移动速度增加 %s 点",
    "type_replace": ["speed_add"],
    "value_replace": [50],
    "modifier_value": {
      "speed_add": 50
    }
  },
  {
    "id": "strat_spd_003",
    "name": "瞬光",
    "category": "legend",
    "part_description": "移动速度极大幅提升",
    "full_description": "移动速度增加 %s 点",
    "type_replace": ["speed_add"],
    "value_replace": [100],
    "modifier_value": {
      "speed_add": 100
    }
  },
  {
    "id": "strat_energy_001",
    "name": "充能",
    "category": "normal",
    "part_description": "能量条上限提高",
    "full_description": "能量条上限增加 %s 点",
    "type_replace": ["energy_max_add"],
    "value_replace": [1],
    "modifier_value": {
      "energy_max_add": 1
    }
  },
  {
    "id": "strat_energy_002",
    "name": "能量充盈",
    "category": "rare",
    "part_description": "能量条上限提高",
    "full_description": "能量条上限增加 %s 点",
    "type_replace": ["energy_max_add"],
    "value_replace": [2],
    "modifier_value": {
      "energy_max_add": 2
    }
  },
  {
    "id": "strat_energy_003",
    "name": "无限核心",
    "category": "legend",
    "part_description": "能量条上限大幅提高",
    "full_description": "能量条上限增加 %s 点",
    "type_replace": ["energy_max_add"],
    "value_replace": [5],
    "modifier_value": {
      "energy_max_add": 5
    }
  },
  {
    "id": "strat_gold_001",
    "name": "淘金",
    "category": "normal",
    "part_description": "获得额外金币",
    "full_description": "立刻获得 %s 金币",
    "type_replace": ["gold_add"],
    "value_replace": [50],
    "modifier_value": {
      "gold_add": 50
    }
  },
  {
    "id": "strat_gold_002",
    "name": "意外之财",
    "category": "rare",
    "part_description": "获得大量金币",
    "full_description": "立刻获得 %s 金币",
    "type_replace": ["gold_add"],
    "value_replace": [150],
    "modifier_value": {
      "gold_add": 150
    }
  },
  {
    "id": "strat_gold_003",
    "name": "宝藏",
    "category": "legend",
    "part_description": "获得巨额金币",
    "full_description": "立刻获得 %s 金币",
    "type_replace": ["gold_add"],
    "value_replace": [400],
    "modifier_value": {
      "gold_add": 400
    }
  },
  {
    "id": "strat_weapon_crit_001",
    "name": "精准",
    "category": "normal",
    "part_description": "武器暴击率提高",
    "full_description": "武器暴击率提高 %s%%",
    "type_replace": ["weapon_crit_rate_mult"],
    "value_replace": [10.0],
    "modifier_value": {
      "weapon_crit_rate_mult": 0.1
    }
  },
  {
    "id": "strat_weapon_crit_002",
    "name": "致命节奏",
    "category": "rare",
    "part_description": "武器暴击率显著提高",
    "full_description": "武器暴击率提高 %s%%",
    "type_replace": ["weapon_crit_rate_mult"],
    "value_replace": [25.0],
    "modifier_value": {
      "weapon_crit_rate_mult": 0.25
    }
  },
  {
    "id": "strat_weapon_crit_003",
    "name": "必杀预感",
    "category": "legend",
    "part_description": "武器暴击率巨幅提高",
    "full_description": "武器暴击率提高 %s%%",
    "type_replace": ["weapon_crit_rate_mult"],
    "value_replace": [50.0],
    "modifier_value": {
      "weapon_crit_rate_mult": 0.5
    }
  },
  {
    "id": "strat_weapon_critdmg_001",
    "name": "重击",
    "category": "normal",
    "part_description": "武器暴击伤害提高",
    "full_description": "武器暴击伤害提高 %s%%",
    "type_replace": ["weapon_crit_damage_mult"],
    "value_replace": [15.0],
    "modifier_value": {
      "weapon_crit_damage_mult": 0.15
    }
  },
  {
    "id": "strat_weapon_critdmg_002",
    "name": "毁灭打击",
    "category": "rare",
    "part_description": "武器暴击伤害显著提高",
    "full_description": "武器暴击伤害提高 %s%%",
    "type_replace": ["weapon_crit_damage_mult"],
    "value_replace": [35.0],
    "modifier_value": {
      "weapon_crit_damage_mult": 0.35
    }
  },
  {
    "id": "strat_weapon_critdmg_003",
    "name": "终末审判",
    "category": "legend",
    "part_description": "武器暴击伤害巨幅提高",
    "full_description": "武器暴击伤害提高 %s%%",
    "type_replace": ["weapon_crit_damage_mult"],
    "value_replace": [70.0],
    "modifier_value": {
      "weapon_crit_damage_mult": 0.7
    }
  },
  {
    "id": "strat_weapon_atk_001",
    "name": "打磨",
    "category": "normal",
    "part_description": "武器附加攻击力提升",
    "full_description": "武器附加攻击力提高 %s%%",
    "type_replace": ["weapon_extra_attack_mult"],
    "value_replace": [10.0],
    "modifier_value": {
      "weapon_extra_attack_mult": 0.1
    }
  },
  {
    "id": "strat_weapon_atk_002",
    "name": "精工",
    "category": "rare",
    "part_description": "武器附加攻击力显著提升",
    "full_description": "武器附加攻击力提高 %s%%",
    "type_replace": ["weapon_extra_attack_mult"],
    "value_replace": [25.0],
    "modifier_value": {
      "weapon_extra_attack_mult": 0.25
    }
  },
  {
    "id": "strat_weapon_atk_003",
    "name": "神匠之触",
    "category": "legend",
    "part_description": "武器附加攻击力巨幅提升",
    "full_description": "武器附加攻击力提高 %s%%",
    "type_replace": ["weapon_extra_attack_mult"],
    "value_replace": [50.0],
    "modifier_value": {
      "weapon_extra_attack_mult": 0.5
    }
  },
  {
    "id": "strat_bullet_atk_001",
    "name": "火药升级",
    "category": "normal",
    "part_description": "子弹攻击力提升",
    "full_description": "子弹攻击力提高 %s%%",
    "type_replace": ["bullet_attack_mult"],
    "value_replace": [10.0],
    "modifier_value": {
      "bullet_attack_mult": 0.1
    }
  },
  {
    "id": "strat_bullet_atk_002",
    "name": "穿甲弹",
    "category": "rare",
    "part_description": "子弹攻击力显著提升",
    "full_description": "子弹攻击力提高 %s%%",
    "type_replace": ["bullet_attack_mult"],
    "value_replace": [25.0],
    "modifier_value": {
      "bullet_attack_mult": 0.25
    }
  },
  {
    "id": "strat_bullet_atk_003",
    "name": "湮灭弹头",
    "category": "legend",
    "part_description": "子弹攻击力巨幅提升",
    "full_description": "子弹攻击力提高 %s%%",
    "type_replace": ["bullet_attack_mult"],
    "value_replace": [50.0],
    "modifier_value": {
      "bullet_attack_mult": 0.5
    }
  },
  {
    "id": "strat_slot_001",
    "name": "扩充武装",
    "category": "rare",
    "part_description": "解锁武器槽",
    "full_description": "增加 %s 个武器槽位",
    "type_replace": ["weapon_slot_add"],
    "value_replace": [1],
    "modifier_value": {
      "weapon_slot_add": 1
    }
  },
  {
    "id": "strat_slot_002",
    "name": "军火库",
    "category": "legend",
    "part_description": "解锁多个武器槽",
    "full_description": "增加 %s 个武器槽位",
    "type_replace": ["weapon_slot_add"],
    "value_replace": [2],
    "modifier_value": {
      "weapon_slot_add": 2
    }
  },
  {
    "id": "strat_weapon_gain_001",
    "name": "战利品·武器",
    "category": "normal",
    "part_description": "随机获得一把武器",
    "full_description": "从武器池中获得一把随机武器",
    "type_replace": ["gain_weapon"],
    "value_replace": [1],
    "modifier_value": {
      "gain_weapon": 1
    }
  },
  {
    "id": "strat_bullet_gain_001",
    "name": "战利品·子弹",
    "category": "normal",
    "part_description": "随机获得一类子弹",
    "full_description": "从子弹池中获得一类随机子弹",
    "type_replace": ["gain_bullet"],
    "value_replace": [1],
    "modifier_value": {
      "gain_bullet": 1
    }
  }
]