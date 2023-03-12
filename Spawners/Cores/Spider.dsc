dSpawners_SpawnerCore_Spider:
  type: item
  debug: false
  material: spider_eye
  display name: <yellow>Spider Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  flags:
    PreventEat: true
  lore:
  - <white>Mob Type: <gold>Spider
  - <white>Shard Tier: <gold>2
  - <empty>
  - Used to craft a Spider spawner
  - <white>[<blue>Rare<white>]
dSpawners_SpawnerCore_Spider_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_spawner_modules:
      - run dSpawners_Spawners_registerCore def:SPIDER|dSpawners_SpawnerCore_Spider
    on player kills SPIDER:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[300]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Spider:++
        - drop dSpawners_SpawnerCore_Spider <context.entity.location>
    on player breaks spawner:
      - stop if:<context.location.has_flag[spawner]>
      - stop if:<context.location.spawner_type.advanced_matches[SPIDER].not>
      - if <util.random.int[1].to[164]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Spider:++
        - drop dSpawners_SpawnerCore_Spider <context.location>