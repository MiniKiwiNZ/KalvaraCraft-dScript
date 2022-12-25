AR_SpawnerCore_Shulker:
  type: item
  material: shulker_spawn_egg
  display name: <&e>Shulker Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  flags:
    PreventUse: true
  lore:
  - <&f>Mob Type: <&6>Shulker
  - <&f>Shard Tier: <&6>4
  - <empty>
  - Used to craft a Shulker spawner
  - <&f>[<&6><&l>Legendary<&f>]
AR_SpawnerCore_Shulker_Register:
  type: world
  debug: false
  events:
    on custom event id:ar_register_spawner_modules:
      - run AR_Spawners_registerCore def:SHULKER|AR_SpawnerCore_Shulker
    on player kills SHULKER:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[1024]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - drop AR_SpawnerCore_Shulker <context.entity.location>
    on loot generates:
      - stop if:<context.loot_table_id.equals[minecraft:chests/end_city_treasure].not>
      - if <util.random.int[1].to[768]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Shulker:++
        - determine LOOT:<context.items.include_single[AR_SpawnerCore_Shulker]>
