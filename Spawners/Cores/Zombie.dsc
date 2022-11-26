AR_SpawnerCore_Zombie:
  debug: false
  type: item
  material: rotten_flesh
  display name: "<&e>Zombie Essence"
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  flags:
    PreventEat: true
  lore:
  - "<&f>Mob Type: <&6>Zombie"
  - "<&f>Shard Tier: <&6>1"
  - ""
  - "Used to craft a Zombie spawner"
  - "<&f>[<&a>Uncommon<&f>]"
AR_SpawnerCore_Zombie_Register:
  type: world
  debug: false
  events:
    on custom event id:ar_register_spawner_modules:
      - run AR_Spawners_registerCore def:ZOMBIE|AR_SpawnerCore_Zombie
    on player breaks spawner:
      - stop if:<context.location.has_flag[spawner]>
      - stop if:<context.location.spawner_type.advanced_matches[ZOMBIE].not>
      - if <util.random.int[1].to[156]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Zombie:++
        - drop AR_SpawnerCore_Zombie <context.location>
    on player kills ZOMBIE:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[312]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Zombie:++
        - drop AR_SpawnerCore_Zombie <context.entity.location>