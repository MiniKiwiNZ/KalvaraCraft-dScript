dSpawners_SpawnerShard_3:
  debug: false
  type: item
  material: prismarine_shard
  display name: <yellow>Spawner Shard (<&b>Tier 3<yellow>)
  lore:
  - <white>A <&b>Tier 3<white> spawner shard
  - <empty>
  - <&7>Used to craft and upgrade
  - <&7>rare mob spawners
  - <white>[<&b>Rare<white>]
  enchantments:
  - luck_of_the_sea:2
  flags:
    UpgradeSpawner: true
  mechanisms:
    hides:
    - ENCHANTS
    custom_model_data: 3
  recipes:
    1:
      type: shapeless
      input: dSpawners_SpawnerShard_4
      output_quantity: 2
    2:
      type: shapeless
      input: dSpawners_SpawnerShard_2|dSpawners_SpawnerShard_2
dSpawners_SpawnerShard_3_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_spawner_modules:
      - run dSpawners_Spawners_registerShard def:3|dSpawners_SpawnerShard_3