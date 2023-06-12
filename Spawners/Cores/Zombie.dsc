dSpawners_SpawnerCore_Zombie:
  debug: false
  type: item
  material: rotten_flesh
  display name: <yellow>Zombie Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  flags:
    PreventEat: true
  lore:
  - <white>Mob Type: <gold>Zombie
  - <white>Shard Tier: <gold>1
  - <empty>
  - Used to craft a Zombie spawner
  - <white>[<green>Uncommon<white>]
dSpawners_SpawnerCore_Zombie_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_cores:
      - determine OUTPUT:<map[ZOMBIE=dSpawners_SpawnerCore_Zombie]>
    on player breaks spawner:
      - stop if:<context.location.has_flag[spawner]>
      - stop if:<context.location.spawner_type.advanced_matches[ZOMBIE].not>
      - if <util.random.int[1].to[156]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Zombie:++
        - drop dSpawners_SpawnerCore_Zombie <context.location>
    on player kills ZOMBIE:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[312]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Zombie:++
        - drop dSpawners_SpawnerCore_Zombie <context.entity.location>