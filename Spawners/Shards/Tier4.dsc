dSpawners_SpawnerShard_4:
  debug: false
  type: item
  material: prismarine_shard
  display name: <&e>Spawner Shard (<&d>Tier 4<&e>)
  lore:
  - <&f>A <&d>Tier 4<&f> spawner shard
  - <empty>
  - <&7>Used to craft and upgrade
  - <&7>rare mob spawners
  - <&f>[<&d>Epic<&f>]
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