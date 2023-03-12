# Guardians allow renewable generation of prismarine shards and crystals
dSpawners_SpawnerCore_Guardian:
  debug: false
  type: item
  material: prismarine_crystals
  display name: <yellow>Guardian Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  lore:
  - <white>Mob Type: <gold>Guardian
  - <white>Shard Tier: <gold>3
  - <empty>
  - Used to craft a Guardian spawner
  - <white>[<light_purple>Epic<white>]
dSpawners_SpawnerCore_Guardian_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_spawner_modules:
      - run dSpawners_Spawners_registerCore def:GUARDIAN|dSpawners_SpawnerCore_Guardian
    on ELDER_GUARDIAN dies by:player:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[128]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<context.damager>]>:
        - flag server SpawnerDrops.Cores.Guardian:++
        - determine <context.drops.include_single[dSpawners_SpawnerCore_Guardian]>
    on player kills GUARDIAN:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[512]>  <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Guardian:++
        - drop dSpawners_SpawnerCore_Guardian <context.entity.location>