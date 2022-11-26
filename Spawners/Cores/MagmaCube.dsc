# Magma cubes drop magma cream
AR_SpawnerCore_MagmaCube:
  debug: false
  type: item
  material: magma_cream
  display name: "<&e>Magma Cube Essence"
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  lore:
  - "<&f>Mob Type: <&6>Magma Cube"
  - "<&f>Shard Tier: <&6>2"
  - ""
  - "Used to craft a Magma Cube spawner"
  - "<&f>[<&9>Rare<&f>]"
AR_SpawnerCore_MagmaCube_Register:
  type: world
  debug: false
  events:
    on custom event id:ar_register_spawner_modules:
      - run AR_Spawners_registerCore def:MAGMA_CUBE|AR_SpawnerCore_MagmaCube
      - run AR_Spawners_registerCore def:MAGMACUBE|AR_SpawnerCore_MagmaCube
    on MAGMA_CUBE spawns because SLIME_SPLIT:
      - flag <context.entity> from_spawner
    on MAGMA_CUBE dies by:player:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[192]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<context.damager>]>:
        - flag server SpawnerDrops.Cores.MagmaCube:++
        - determine <context.drops.include_single[AR_SpawnerCore_MagmaCube]>
    on player breaks spawner:
      - stop if:<context.location.has_flag[spawner]>
      - stop if:<context.location.spawner_type.advanced_matches[MAGMA_CUBE].not>
      - if <util.random.int[1].to[64]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.MagmaCube:++
        - drop AR_SpawnerCore_MagmaCube <context.location>