# Pigs for pork. More meat for the grinder
dSpawners_SpawnerCore_Pig:
  debug: false
  type: item
  material: porkchop
  display name: <yellow>Pig Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  flags:
    PreventEat: true
  enchantments:
  - unbreaking:10
  lore:
  - <white>Mob Type: <gold>Pig
  - <white>Shard Tier: <gold>1
  - <empty>
  - Used to craft a Pig spawner
  - <white>[<green>Uncommon<white>]
dSpawners_SpawnerCore_Pig_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_cores:
      - determine OUTPUT:<map[PIG=dSpawners_SpawnerCore_Pig]>
    on player kills PIG:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[512]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Pig:++
        - drop dSpawners_SpawnerCore_Pig <context.entity.location>
    on PIG spawns because BREEDING:
      - flag <context.entity> from_spawner