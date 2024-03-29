# Sheep can be used to obtain wool, but without awareness they won't be infinite wool
dSpawners_SpawnerCore_Rabbit:
  type: item
  material: rabbit_foot
  display name: <yellow>Rabbit Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  flags:
    PreventPlace: true
  lore:
  - <white>Mob Type: <gold>Rabbit
  - <white>Shard Tier: <gold>2
  - <empty>
  - Used to craft a Rabbit spawner
  - <white>[<green>Rare<white>]
dSpawners_SpawnerCore_Rabbit_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_cores:
      - determine OUTPUT:<map[RABBIT=dSpawners_SpawnerCore_Rabbit]>
    on player kills rabbit:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[310]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Rabbit:++
        - drop dSpawners_SpawnerCore_Rabbit <context.entity.location>
    on rabbit spawns because BREEDING:
      - flag <context.entity> from_spawner