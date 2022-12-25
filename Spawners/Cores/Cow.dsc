AR_SpawnerCore_Cow:
  debug: false
  type: item
  material: beef
  display name: <&e>Cow Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  flags:
    PreventEat: true
  lore:
  - <&f>Mob Type: <&6>Cow
  - <&f>Shard Tier: <&6>2
  - <empty>
  - Used to craft a Cow spawner
  - <&f>[<&9>Rare<&f>]
AR_SpawnerCore_Cow_Register:
  type: world
  debug: false
  events:
    on custom event id:ar_register_spawner_modules:
      - run AR_Spawners_registerCore def:COW|AR_SpawnerCore_Cow
    on player kills cow:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[768]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Cow:++
        - drop AR_SpawnerCore_Cow <context.entity.location>
    on cow spawns because BREEDING:
      - flag <context.entity> from_spawner