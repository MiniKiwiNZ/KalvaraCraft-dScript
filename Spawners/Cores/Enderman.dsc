# Enderman drop ender pearls, but alone ender pearls aren't that useful
dSpawners_SpawnerCore_Enderman:
  debug: false
  type: item
  material: ender_eye
  display name: <yellow>Enderman Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  flags:
    PreventUse: true
  lore:
  - <white>Mob Type: <gold>Enderman
  - <white>Shard Tier: <gold>2
  - <empty>
  - Used to craft an Enderman spawner
  - <white>[<blue>Rare<white>]
dSpawners_SpawnerCore_Enderman_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_cores:
      - determine OUTPUT:<map[ENDERMAN=dSpawners_SpawnerCore_Enderman]>
    on player kills ENDERMAN:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[512]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Enderman:++
        - drop dSpawners_SpawnerCore_Enderman <context.entity.location>
    on loot generates:
      - stop if:<context.loot_table_id.equals[minecraft:chests/end_city_treasure].not>
      - if <util.random.int[1].to[256]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Enderman:++
        - determine LOOT:<context.items.include_single[dSpawners_SpawnerCore_Enderman]>