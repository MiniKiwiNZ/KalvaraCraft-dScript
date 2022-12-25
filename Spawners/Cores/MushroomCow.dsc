# Mooshrooms can provide unlimited food
#  renewable mushrooms, and leather
dSpawners_SpawnerCore_MushroomCow:
  debug: false
  type: item
  material: mooshroom_spawn_egg
  display name: <&e>Mooshroom Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  flags:
    PreventUse: true
  enchantments:
  - unbreaking:10
  lore:
  - <&f>Mob Type: <&6>Mooshroom
  - <&f>Shard Tier: <&6>3
  - <empty>
  - Used to craft a Mooshroom spawner
  - <&f>[<&d>Epic<&f>]
dSpawners_SpawnerCore_MushroomCow_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_spawner_modules:
      - run dSpawners_Spawners_registerCore def:MUSHROOM_COW|dSpawners_SpawnerCore_MushroomCow
      - run dSpawners_Spawners_registerCore def:MUSHROOMCOW|dSpawners_SpawnerCore_MushroomCow
      - run dSpawners_Spawners_registerCore def:MOOSHROOM|dSpawners_SpawnerCore_MushroomCow
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