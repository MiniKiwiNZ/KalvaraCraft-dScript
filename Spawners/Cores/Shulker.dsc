dSpawners_SpawnerCore_Shulker:
  type: item
  material: shulker_spawn_egg
  display name: <yellow>Shulker Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  flags:
    PreventUse: true
  lore:
  - <white>Mob Type: <gold>Shulker
  - <white>Shard Tier: <gold>4
  - <empty>
  - Used to craft a Shulker spawner
  - <white>[<gold><bold>Legendary<white>]
dSpawners_SpawnerCore_Shulker_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_spawner_modules:
      - run dSpawners_Spawners_registerCore def:SHULKER|dSpawners_SpawnerCore_Shulker
    on player kills SHULKER:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[1024]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - drop dSpawners_SpawnerCore_Shulker <context.entity.location>
    on loot generates:
      - stop if:<context.loot_table_id.equals[minecraft:chests/end_city_treasure].not>
      - if <util.random.int[1].to[768]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Shulker:++
        - determine LOOT:<context.items.include_single[dSpawners_SpawnerCore_Shulker]>
