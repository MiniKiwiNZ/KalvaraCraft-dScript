dSpawners_SpawnerCore_Skeleton:
  debug: false
  type: item
  material: bone
  display name: <yellow>Skeleton Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  lore:
  - <white>Mob Type: <gold>Skeleton
  - <white>Shard Tier: <gold>2
  - <empty>
  - Used to craft a Skeleton spawner
  - <white>[<blue>Rare<white>]
dSpawners_SpawnerCore_Skeleton_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_spawner_modules:
      - run dSpawners_Spawners_registerCore def:SKELETON|dSpawners_SpawnerCore_Skeleton
    on player kills SKELETON:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[512]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Skeleton:++
        - drop dSpawners_SpawnerCore_Skeleton <context.entity.location>
    on player breaks spawner:
      - stop if:<context.location.has_flag[spawner]>
      - stop if:<context.location.spawner_type.advanced_matches[SKELETON].not>
      - if <util.random.int[1].to[256]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Skeleton:++
        - drop dSpawners_SpawnerCore_Skeleton <context.location>