# Polar bears can drop cod or salmon
dSpawners_SpawnerCore_PolarBear:
  debug: false
  type: item
  material: snowball
  display name: <yellow>Polar Bear Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  flags:
    PreventUse: true
  enchantments:
  - unbreaking:10
  lore:
  - <white>Mob Type: <gold>Polar Bear
  - <white>Shard Tier: <gold>1
  - <empty>
  - Used to craft a Polar Bear spawner
  - <white>[<green>Uncommon<white>]
dSpawners_SpawnerCore_PolarBear_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_spawner_modules:
      - run dSpawners_Spawners_registerCore def:POLAR_BEAR|dSpawners_SpawnerCore_PolarBear
      - run dSpawners_Spawners_registerCore def:POLARBEAR|dSpawners_SpawnerCore_PolarBear
    on player kills POLAR_BEAR:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[128]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.PolarBear:++
        - drop dSpawners_SpawnerCore_PolarBear <context.entity.location>