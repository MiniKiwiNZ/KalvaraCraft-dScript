# Pigs for pork. More meat for the grinder
AR_SpawnerCore_Pig:
  debug: false
  type: item
  material: porkchop
  display name: "<&e>Pig Essence"
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  flags:
    PreventEat: true
  enchantments:
  - unbreaking:10
  lore:
  - "<&f>Mob Type: <&6>Pig"
  - "<&f>Shard Tier: <&6>2"
  - ""
  - "Used to craft a Pig spawner"
  - "<&f>[<&9>Rare<&f>]"
AR_SpawnerCore_Pig2:
  debug: false
  type: item
  material: porkchop
  display name: "<&e>Pig Essence"
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  flags:
    PreventEat: true
  enchantments:
  - unbreaking:10
  lore:
  - "<&f>Mob Type: <&6>Pig"
  - "<&f>Shard Tier: <&6>1"
  - ""
  - "Used to craft a Pig spawner"
  - "<&f>[<&a>Uncommon<&f>]"
  recipes:
    1:
      type: shapeless
      input: AR_SpawnerCore_Pig
AR_SpawnerCore_Pig_Register:
  type: world
  debug: false
  events:
    on custom event id:ar_register_spawner_modules:
      - run AR_Spawners_registerCore def:PIG|AR_SpawnerCore_Pig2
    on player kills PIG:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[512]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Pig:++
        - drop AR_SpawnerCore_Pig2 <context.entity.location>
    on PIG spawns because BREEDING:
      - flag <context.entity> from_spawner