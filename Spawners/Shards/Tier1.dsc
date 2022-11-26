AR_SpawnerShard_1:
  debug: false
  type: item
  material: prismarine_shard
  display name: "<&e>Spawner Shard (<&7>Tier 1<&e>)"
  lore:
  - "<&f>A <&7>Tier 1<&f> spawner shard"
  - ""
  - "<&7>Used to craft and upgrade"
  - "<&7>common mob spawners"
  - "<&f>[<&7>Common<&f>]"
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
      input: AR_SpawnerShard_2
      output_quantity: 2
AR_SpawnerShard_1_Register:
  type: world
  debug: false
  events:
    on custom event id:ar_register_spawner_modules:
      - run AR_Spawners_registerShard def:1|AR_SpawnerShard_1
    on loot generates for:chest:
      - define id <context.loot_table_id.substring[<context.loot_table_id.last_index_of[/].add[1]>]>
      - stop if:<[id].equals[jungle_temple_dispenser]>
      - if <[id].starts_with[village_]>:
        # Village chests are much more common so the shards should be rarer and drop in lower quantities
        - if <util.random.int[1].to[65]> <= <proc[AR_Spawners_BoostThreshold].context[1|Shards|<player>]>:
          - determine LOOT:<context.items.include_single[AR_SpawnerShard_1[quantity=<util.random.int[1].to[2]>]]>
        - stop
      - if <[id].equals[bastion_treasure]>:
        # Bastion treasure chests will always contain shards
        - determine LOOT:<context.items.include_single[AR_SpawnerShard_1[quantity=<util.random.int[1].to[5]>]]>
        - stop
      - if <util.random.int[1].to[52]> <= <proc[AR_Spawners_BoostThreshold].context[1|Shards|<player>]>:
        - determine LOOT:<context.items.include_single[AR_SpawnerShard_1[quantity=3]]>
        - stop
      - if <util.random.int[1].to[36]> <= <proc[AR_Spawners_BoostThreshold].context[1|Shards|<player>]>:
        - determine LOOT:<context.items.include_single[AR_SpawnerShard_1[quantity=2]]>
        - stop
      - if <util.random.int[1].to[17]> <= <proc[AR_Spawners_BoostThreshold].context[1|Shards|<player>]>:
        - determine LOOT:<context.items.include_single[AR_SpawnerShard_1]>
        - stop
    on loot generates:
      - if <context.loot_table_id.starts_with[minecraft:gameplay/hero_of_the_village]>:
        - if <util.random.int[1].to[32]> <= <proc[AR_Spawners_BoostThreshold].context[1|Shards|<player>]>:
          - determine LOOT:AR_SpawnerShard_1[quantity=<util.random.int[1].to[4]>]