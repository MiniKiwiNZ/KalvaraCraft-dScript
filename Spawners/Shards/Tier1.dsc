dSpawners_SpawnerShard_1:
  debug: false
  type: item
  material: prismarine_shard
  display name: <yellow>Spawner Shard (<gray>Tier 1<yellow>)
  lore:
  - <white>A <gray>Tier 1<white> spawner shard
  - <empty>
  - <gray>Used to craft and upgrade
  - <gray>common mob spawners
  - <white>[<gray>Common<white>]
  enchantments:
  - luck_of_the_sea:2
  flags:
    UpgradeSpawner: true
  mechanisms:
    hides:
    - ENCHANTS
    custom_model_data: 1
  recipes:
    1:
      type: shapeless
      input: dSpawners_SpawnerShard_2
      output_quantity: 2
dSpawners_SpawnerShard_1_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_spawner_modules:
      - run dSpawners_Spawners_registerShard def:1|dSpawners_SpawnerShard_1
    on loot generates for:chest:
      - define id <context.loot_table_id.substring[<context.loot_table_id.last_index_of[/].add[1]>]>
      - stop if:<[id].equals[jungle_temple_dispenser]>
      - if <[id].starts_with[village_]>:
        # Village chests are much more common so the shards should be rarer and drop in lower quantities
        - if <util.random.int[1].to[65]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Shards|<player>]>:
          - determine LOOT:<context.items.include_single[dSpawners_SpawnerShard_1[quantity=<util.random.int[1].to[2]>]]>
        - stop
      - if <[id].equals[bastion_treasure]>:
        # Bastion treasure chests will always contain shards
        - determine LOOT:<context.items.include_single[dSpawners_SpawnerShard_1[quantity=<util.random.int[1].to[5]>]]>
        - stop
      - if <util.random.int[1].to[52]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Shards|<player>]>:
        - determine LOOT:<context.items.include_single[dSpawners_SpawnerShard_1[quantity=3]]>
        - stop
      - if <util.random.int[1].to[36]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Shards|<player>]>:
        - determine LOOT:<context.items.include_single[dSpawners_SpawnerShard_1[quantity=2]]>
        - stop
      - if <util.random.int[1].to[17]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Shards|<player>]>:
        - determine LOOT:<context.items.include_single[dSpawners_SpawnerShard_1]>
        - stop
    on loot generates:
      - if <context.loot_table_id.starts_with[minecraft:gameplay/hero_of_the_village]>:
        - if <util.random.int[1].to[32]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Shards|<player>]>:
          - determine LOOT:dSpawners_SpawnerShard_1[quantity=<util.random.int[1].to[4]>]