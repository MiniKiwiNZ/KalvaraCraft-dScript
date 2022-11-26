# Sheep can be used to obtain wool, but without awareness they won't be infinite wool
AR_SpawnerCore_Rabbit:
  type: item
  material: rabbit_foot
  display name: "<&e>Rabbit Essence"
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  flags:
    PreventPlace: true
  lore:
  - "<&f>Mob Type: <&6>Rabbit"
  - "<&f>Shard Tier: <&6>2"
  - ""
  - "Used to craft a Rabbit spawner"
  - "<&f>[<&a>Rare<&f>]"
AR_SpawnerCore_Rabbit_Register:
  type: world
  debug: false
  events:
    on custom event id:ar_register_spawner_modules:
      - run AR_Spawners_registerCore def:RABBIT|AR_SpawnerCore_Rabbit
    on player kills rabbit:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[310]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Rabbit:++
        - drop AR_SpawnerCore_Rabbit <context.entity.location>
    on rabbit spawns because BREEDING:
      - flag <context.entity> from_spawner