# Horses drop leather, but you should also feel bad about killing them
dSpawners_SpawnerCore_Horse:
  debug: false
  type: item
  material: hay_block
  display name: <yellow>Horse Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  flags:
    PreventPlace: true
    PreventEntityUse: true
  enchantments:
  - unbreaking:10
  lore:
  - <white>Mob Type: <gold>Horse
  - <white>Shard Tier: <gold>2
  - <empty>
  - Used to craft a Horse spawner
  - <white>[<blue>Rare<white>]
dSpawners_SpawnerCore_Horse_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_spawner_modules:
      - run dSpawners_Spawners_registerCore def:HORSE|dSpawners_SpawnerCore_Horse
    on player tames HORSE:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[128]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Horse:++
        - drop dSpawners_SpawnerCore_Horse <context.entity.location>
    on player kills HORSE:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[128]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Horse:++
        - drop dSpawners_SpawnerCore_Horse <context.entity.location>
    on HORSE spawns because BREEDING:
      - flag <context.entity> from_spawner