# Parrots can drop feathers
dSpawners_SpawnerCore_Parrot:
  debug: false
  type: item
  material: cookie
  display name: <yellow>Parrot Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  flags:
    PreventEat: true
    PreventEntityUse: true
  enchantments:
  - unbreaking:10
  lore:
  - <white>Mob Type: <gold>Parrot
  - <white>Shard Tier: <gold>1
  - <empty>
  - Used to craft a Parrot spawner
  - <white>[<green>Uncommon<white>]
dSpawners_SpawnerCore_Parrot_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_cores:
      - determine OUTPUT:<map[PARROT=dSpawners_SpawnerCore_Parrot]>
    on player right clicks PARROT with:COOKIE:
      - flag <context.entity> cookied:<player>
    on PARROT dies:
      - stop if:<context.entity.has_flag[from_spawner]>
      - stop if:<context.entity.has_flag[cookied].not>
      - if <util.random.int[1].to[128]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<context.entity.flag[cookied]>]>:
        - flag server SpawnerDrops.Cores.Parrot:++
        - determine <context.drops.include_single[dSpawners_SpawnerCore_Parrot]>
    on player tames PARROT:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[80]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Parrot:++
        - drop dSpawners_SpawnerCore_Parrot <context.entity.location>