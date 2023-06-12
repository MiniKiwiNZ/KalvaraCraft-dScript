# Donkeys can produce leather when killed
dSpawners_SpawnerCore_Donkey:
  debug: false
  type: item
  material: donkey_spawn_egg
  display name: <yellow>Donkey Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  flags:
    PreventUse: true
  lore:
  - <white>Mob Type: <gold>Donkey
  - <white>Shard Tier: <gold>2
  - <empty>
  - Used to craft a Donkey spawner
  - <white>[<blue>Rare<white>]
dSpawners_SpawnerCore_Donkey_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_cores:
      - determine OUTPUT:<map[DONKEY=dSpawners_SpawnerCore_Donkey]>
    on player tames DONKEY:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[128]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Donkey:++
        - drop dSpawners_SpawnerCore_Donkey <context.entity.location>
    on player kills DONKEY:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[128]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Donkey:++
        - drop dSpawners_SpawnerCore_Donkey <context.entity.location>
    on DONKEY spawns because BREEDING:
      - flag <context.entity> from_spawner