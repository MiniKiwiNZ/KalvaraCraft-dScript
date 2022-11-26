# Polar bears can drop cod or salmon
AR_SpawnerCore_PolarBear:
  debug: false
  type: item
  material: snowball
  display name: "<&e>Polar Bear Essence"
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  flags:
    PreventUse: true
  enchantments:
  - unbreaking:10
  lore:
  - "<&f>Mob Type: <&6>Polar Bear"
  - "<&f>Shard Tier: <&6>1"
  - ""
  - "Used to craft a Polar Bear spawner"
  - "<&f>[<&a>Uncommon<&f>]"
AR_SpawnerCore_PolarBear_Register:
  type: world
  debug: false
  events:
    on custom event id:ar_register_spawner_modules:
      - run AR_Spawners_registerCore def:POLAR_BEAR|AR_SpawnerCore_PolarBear
      - run AR_Spawners_registerCore def:POLARBEAR|AR_SpawnerCore_PolarBear
    on player kills POLAR_BEAR:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[128]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.PolarBear:++
        - drop AR_SpawnerCore_PolarBear <context.entity.location>