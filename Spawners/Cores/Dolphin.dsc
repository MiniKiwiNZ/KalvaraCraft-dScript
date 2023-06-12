# Dolphins only produce cod when killed
dSpawners_SpawnerCore_Dolphin:
  debug: false
  type: item
  material: cod
  display name: <yellow>Dolphin Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  lore:
  - <white>Mob Type: <gold>Dolphin
  - <white>Shard Tier: <gold>1
  - <empty>
  - Used to craft a Dolphin spawner
  - <white>[<green>Uncommon<white>]
dSpawners_SpawnerCore_Dolphin_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_cores:
      - determine OUTPUT:<map[DOLPHIN=dSpawners_SpawnerCore_Dolphin]>
    on loot generates:
      - stop if:<context.loot_table_id.equals[minecraft:chests/buried_treasure].not>
      - if <util.random.int[1].to[160]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Dolphin:++
        - determine LOOT:<context.items.include_single[dSpawners_SpawnerCore_Dolphin]>
    on player kills dolphin:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[256]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Dolphin:++
        - drop dSpawners_SpawnerCore_Dolphin <context.entity.location>