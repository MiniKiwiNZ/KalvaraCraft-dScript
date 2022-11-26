# Horses drop leather, but you should also feel bad about killing them
AR_SpawnerCore_Horse:
  debug: false
  type: item
  material: hay_block
  display name: "<&e>Horse Essence"
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
  - "<&f>Mob Type: <&6>Horse"
  - "<&f>Shard Tier: <&6>2"
  - ""
  - "Used to craft a Horse spawner"
  - "<&f>[<&9>Rare<&f>]"
AR_SpawnerCore_Horse_Register:
  type: world
  debug: false
  events:
    on custom event id:ar_register_spawner_modules:
      - run AR_Spawners_registerCore def:HORSE|AR_SpawnerCore_Horse
    on player tames HORSE:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[128]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Horse:++
        - drop AR_SpawnerCore_Horse <context.entity.location>
    on player kills HORSE:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[128]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Horse:++
        - drop AR_SpawnerCore_Horse <context.entity.location>
    on HORSE spawns because BREEDING:
      - flag <context.entity> from_spawner