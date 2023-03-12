# Cave spiders can be used to obtain string and spider eyes
# They are not in themselves that useful, but cave spider spawners are
# rare and cave spiders do not spawn naturally
dSpawners_SpawnerCore_CaveSpider:
  type: item
  material: cobweb
  display name: <yellow>Cave Spider Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  flags:
    PreventPlace: true
  lore:
  - <white>Mob Type: <gold>Cave Spider
  - <white>Shard Tier: <gold>3
  - <empty>
  - Used to craft a Cave Spider spawner
  - <white>[<light_purple>Epic<white>]
dSpawners_SpawnerCore_CaveSpider_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_spawner_modules:
      - run dSpawners_Spawners_registerCore def:CAVE_SPIDER|dSpawners_SpawnerCore_CaveSpider
      - run dSpawners_Spawners_registerCore def:CAVESPIDER|dSpawners_SpawnerCore_CaveSpider
    on player breaks spawner:
      - stop if:<context.location.has_flag[spawner]>
      - stop if:<context.location.spawner_type.advanced_matches[CAVE_SPIDER].not>
      - if <util.random.int[1].to[256]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.CaveSpider:++
        - drop dSpawners_SpawnerCore_CaveSpider <context.location>