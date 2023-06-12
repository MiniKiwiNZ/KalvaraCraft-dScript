# Mooshrooms can provide unlimited food
#  renewable mushrooms, and leather
dSpawners_SpawnerCore_MushroomCow:
  debug: false
  type: item
  material: mooshroom_spawn_egg
  display name: <yellow>Mooshroom Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  flags:
    PreventUse: true
  enchantments:
  - unbreaking:10
  lore:
  - <white>Mob Type: <gold>Mooshroom
  - <white>Shard Tier: <gold>3
  - <empty>
  - Used to craft a Mooshroom spawner
  - <white>[<light_purple>Epic<white>]
dSpawners_SpawnerCore_MushroomCow_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_cores:
      - determine OUTPUT:<map[MOOSHROOM=dSpawners_SpawnerCore_MushroomCow;MUSHROOMCOW=dSpawners_SpawnerCore_MushroomCow;MUSHROOM_COW=dSpawners_SpawnerCore_MushroomCow]>
    on player shears MUSHROOM_COW:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[164]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.MushroomCow:++
        - drop dSpawners_SpawnerCore_MushroomCow <context.entity.location>
    on player kills MUSHROOM_COW:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[164]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.MushroomCow:++
        - drop dSpawners_SpawnerCore_MushroomCow <context.entity.location>
    on MUSHROOM_COW spawns because BREEDING:
      - flag <context.entity> from_spawner