# Pandas can drop bamboo, but are a sought after mob
AR_SpawnerCore_Panda:
  debug: false
  type: item
  material: bamboo
  display name: "<&e>Panda Essence"
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  flags:
    PreventPlace: true
    PreventEntityUse: true
  enchantments:
  - unbreaking:10
  lore:
  - "<&f>Mob Type: <&6>Panda"
  - "<&f>Shard Tier: <&6>2"
  - ""
  - "Used to craft a Panda spawner"
  - "<&f>[<&9>Rare<&f>]"
AR_SpawnerCore_Panda_Register:
  type: world
  debug: false
  events:
    on custom event id:ar_register_spawner_modules:
      - run AR_Spawners_registerCore def:PANDA|AR_SpawnerCore_Panda
    on player kills PANDA:
      - stop if:<context.entity.has_flag[from_spawner]>
      - stop if:<context.breeder.exists.not>
      - if <util.random.int[1].to[86]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Panda:++
        - drop AR_SpawnerCore_Panda <context.entity.location>
    on PANDA breeds:
      - flag <context.child> from_spawner
      - stop if:<context.mother.has_flag[from_spawner]>
      - stop if:<context.father.has_flag[from_spawner]>
      - if <util.random.int[1].to[86]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Panda:++
        - drop AR_SpawnerCore_Panda <context.child.location>