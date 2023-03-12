# Sheep can be used to obtain wool, but without awareness they won't be infinite wool
dSpawners_SpawnerCore_Sheep:
  type: item
  material: white_wool
  display name: <yellow>Sheep Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  flags:
    PreventPlace: true
  lore:
  - <white>Mob Type: <gold>Sheep
  - <white>Shard Tier: <gold>2
  - <empty>
  - Used to craft a Sheep spawner
  - <white>[<blue>Rare<white>]
dSpawners_SpawnerCore_Sheep_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_spawner_modules:
      - run dSpawners_Spawners_registerCore def:SHEEP|dSpawners_SpawnerCore_Sheep
    on player kills sheep:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[512]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Sheep:++
        - drop dSpawners_SpawnerCore_Sheep <context.entity.location>
    on sheep spawns because BREEDING:
      - flag <context.entity> from_spawner