dSpawners_SpawnerCore_Cow:
  debug: false
  type: item
  material: beef
  display name: <yellow>Cow Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  flags:
    PreventEat: true
  lore:
  - <white>Mob Type: <gold>Cow
  - <white>Shard Tier: <gold>2
  - <empty>
  - Used to craft a Cow spawner
  - <white>[<blue>Rare<white>]
dSpawners_SpawnerCore_Cow_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_cores:
      - determine OUTPUT:<map[COW=dSpawners_SpawnerCore_Cow]>
    on player kills cow:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[768]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Cow:++
        - drop dSpawners_SpawnerCore_Cow <context.entity.location>
    on cow spawns because BREEDING:
      - flag <context.entity> from_spawner