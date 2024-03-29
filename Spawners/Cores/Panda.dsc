# Pandas can drop bamboo, but are a sought after mob
dSpawners_SpawnerCore_Panda:
  debug: false
  type: item
  material: bamboo
  display name: <yellow>Panda Essence
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
  - <white>Mob Type: <gold>Panda
  - <white>Shard Tier: <gold>2
  - <empty>
  - Used to craft a Panda spawner
  - <white>[<blue>Rare<white>]
dSpawners_SpawnerCore_Panda_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_cores:
      - determine OUTPUT:<map[PANDA=dSpawners_SpawnerCore_Panda]>
    on player kills PANDA:
      - stop if:<context.entity.has_flag[from_spawner]>
      - stop if:<context.breeder.exists.not>
      - if <util.random.int[1].to[86]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Panda:++
        - drop dSpawners_SpawnerCore_Panda <context.entity.location>
    on PANDA breeds:
      - flag <context.child> from_spawner
      - stop if:<context.mother.has_flag[from_spawner]>
      - stop if:<context.father.has_flag[from_spawner]>
      - if <util.random.int[1].to[86]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Panda:++
        - drop dSpawners_SpawnerCore_Panda <context.child.location>
    # The core for pandas is bamboo. They will try and eat it.
    on PANDA picks up dSpawners_SpawnerCore_Panda:
    - determine cancelled