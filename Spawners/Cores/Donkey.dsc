# Donkeys can produce leather when killed
AR_SpawnerCore_Donkey:
  debug: false
  type: item
  material: donkey_spawn_egg
  display name: <&e>Donkey Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  flags:
    PreventUse: true
  lore:
  - <&f>Mob Type: <&6>Donkey
  - <&f>Shard Tier: <&6>2
  - <empty>
  - Used to craft a Donkey spawner
  - <&f>[<&9>Rare<&f>]
AR_SpawnerCore_Donkey_Register:
  type: world
  debug: false
  events:
    on custom event id:ar_register_spawner_modules:
      - run AR_Spawners_registerCore def:DONKEY|AR_SpawnerCore_Donkey
    on player tames DONKEY:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[128]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Donkey:++
        - drop AR_SpawnerCore_Donkey <context.entity.location>
    on player kills DONKEY:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[128]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Donkey:++
        - drop AR_SpawnerCore_Donkey <context.entity.location>
    on DONKEY spawns because BREEDING:
      - flag <context.entity> from_spawner