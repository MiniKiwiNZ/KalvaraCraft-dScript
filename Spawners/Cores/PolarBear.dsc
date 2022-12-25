# Polar bears can drop cod or salmon
dSpawners_SpawnerCore_PolarBear:
  debug: false
  type: item
  material: snowball
  display name: <&e>Polar Bear Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  flags:
    PreventUse: true
  enchantments:
  - unbreaking:10
  lore:
  - <&f>Mob Type: <&6>Polar Bear
  - <&f>Shard Tier: <&6>1
  - <empty>
  - Used to craft a Polar Bear spawner
  - <&f>[<&a>Uncommon<&f>]
dSpawners_SpawnerCore_PolarBedspawners_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_spawner_modules:
      - run dSpawners_Spawners_registerCore def:POLdSpawners_BEAR|dSpawners_SpawnerCore_PolarBear
      - run dSpawners_Spawners_registerCore def:POLARBEAR|dSpawners_SpawnerCore_PolarBear
    on player kills POLdSpawners_BEAR:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[128]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.PolarBear:++
        - drop dSpawners_SpawnerCore_PolarBear <context.entity.location>