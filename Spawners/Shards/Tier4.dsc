dSpawners_SpawnerShard_4:
  debug: false
  type: item
  material: prismarine_shard
  display name: <yellow>Spawner Shard (<light_purple>Tier 4<yellow>)
  lore:
  - <white>A <light_purple>Tier 4<white> spawner shard
  - <empty>
  - <gray>Used to craft and upgrade
  - <gray>rare mob spawners
  - <white>[<light_purple>Epic<white>]
  enchantments:
  - luck_of_the_sea:2
  flags:
    UpgradeSpawner: true
  mechanisms:
    hides:
    - ENCHANTS
    custom_model_data: 4
  recipes:
    1:
      type: shapeless
      input: dSpawners_SpawnerShard_3|dSpawners_SpawnerShard_3
dSpawners_SpawnerShard_4_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_spawner_modules:
      - run dSpawners_Spawners_registerShard def:4|dSpawners_SpawnerShard_4