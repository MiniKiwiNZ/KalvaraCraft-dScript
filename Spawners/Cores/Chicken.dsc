dSpawners_SpawnerCore_Chicken:
  debug: false
  type: item
  material: feather
  display name: <&e>Chicken Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  lore:
  - <&f>Mob Type: <&6>Chicken
  - <&f>Shard Tier: <&6>2
  - <empty>
  - Used to craft a Chicken spawner
  - <&f>[<&9>Rare<&f>]
dSpawners_SpawnerCore_Chicken_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_spawner_modules:
      - run dSpawners_Spawners_registerCore def:CHICKEN|dSpawners_SpawnerCore_Chicken
    on CHICKEN dies by:player:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[512]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<context.damager>]>:
        - flag server SpawnerDrops.Cores.Chicken:++
        - determine <context.drops.include_single[dSpawners_SpawnerCore_Chicken]>
    on CHICKEN spawns because EGG|BREEDING:
      - flag <context.entity> from_spawner