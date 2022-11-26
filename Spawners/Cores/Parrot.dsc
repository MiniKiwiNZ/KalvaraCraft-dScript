# Parrots can drop feathers
AR_SpawnerCore_Parrot:
  debug: false
  type: item
  material: cookie
  display name: "<&e>Parrot Essence"
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
  - "<&f>Mob Type: <&6>Parrot"
  - "<&f>Shard Tier: <&6>1"
  - ""
  - "Used to craft a Parrot spawner"
  - "<&f>[<&a>Uncommon<&f>]"
AR_SpawnerCore_Parrot_Register:
  type: world
  debug: false
  events:
    on custom event id:ar_register_spawner_modules:
      - run AR_Spawners_registerCore def:PARROT|AR_SpawnerCore_Parrot
    on player right clicks PARROT with:COOKIE:
      - flag <context.entity> cookied:<player>
    on PARROT dies:
      - stop if:<context.entity.has_flag[from_spawner]>
      - stop if:<context.entity.has_flag[cookied].not>
      - if <util.random.int[1].to[128]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<context.entity.flag[cookied]>]>:
        - flag server SpawnerDrops.Cores.Parrot:++
        - determine <context.drops.include_single[AR_SpawnerCore_Parrot]>
    on player tames PARROT:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[80]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Parrot:++
        - drop AR_SpawnerCore_Parrot <context.entity.location>