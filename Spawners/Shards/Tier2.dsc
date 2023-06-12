dSpawners_SpawnerShard_2:
  debug: false
  type: item
  material: prismarine_shard
  display name: <yellow>Spawner Shard (<green>Tier 2<yellow>)
  lore:
  - <white>A <green>Tier 2<white> spawner shard
  - <empty>
  - <gray>Used to craft and upgrade
  - <gray>uncommon mob spawners
  - <white>[<green>Uncommon<white>]
  enchantments:
  - luck_of_the_sea:2
  flags:
    UpgradeSpawner: true
  mechanisms:
    hides:
    - ENCHANTS
    custom_model_data: 2
  recipes:
    1:
      type: shapeless
      input: dSpawners_SpawnerShard_3
      output_quantity: 2
    2:
      type: shapeless
      input: dSpawners_SpawnerShard_1|dSpawners_SpawnerShard_1
dSpawners_SpawnerShard_2_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_shards:
      - determine OUTPUT:<map[2=dSpawners_SpawnerShard_2]>