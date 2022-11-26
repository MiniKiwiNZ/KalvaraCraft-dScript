AR_SpawnerShard_2:
  debug: false
  type: item
  material: prismarine_shard
  display name: "<&e>Spawner Shard (<&a>Tier 2<&e>)"
  lore:
  - "<&f>A <&a>Tier 2<&f> spawner shard"
  - ""
  - "<&7>Used to craft and upgrade"
  - "<&7>uncommon mob spawners"
  - "<&f>[<&a>Uncommon<&f>]"
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
      input: AR_SpawnerShard_3
      output_quantity: 2
    2:
      type: shapeless
      input: AR_SpawnerShard_1|AR_SpawnerShard_1
AR_SpawnerShard_2_Register:
  type: world
  debug: false
  events:
    on custom event id:ar_register_spawner_modules:
      - run AR_Spawners_registerShard def:2|AR_SpawnerShard_2