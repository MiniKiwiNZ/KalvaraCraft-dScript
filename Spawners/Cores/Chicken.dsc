AR_SpawnerCore_Chicken:
  debug: false
  type: item
  material: feather
  display name: "<&e>Chicken Essence"
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  lore:
  - "<&f>Mob Type: <&6>Chicken"
  - "<&f>Shard Tier: <&6>2"
  - ""
  - "Used to craft a Chicken spawner"
  - "<&f>[<&9>Rare<&f>]"
AR_SpawnerCore_Chicken_Register:
  type: world
  debug: false
  events:
    on custom event id:ar_register_spawner_modules:
      - run AR_Spawners_registerCore def:CHICKEN|AR_SpawnerCore_Chicken
    on CHICKEN dies by:player:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[512]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<context.damager>]>:
        - flag server SpawnerDrops.Cores.Chicken:++
        - determine <context.drops.include_single[AR_SpawnerCore_Chicken]>
    on CHICKEN spawns because EGG|BREEDING:
      - flag <context.entity> from_spawner