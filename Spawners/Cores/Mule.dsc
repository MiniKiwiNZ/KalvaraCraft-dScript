# Mules are similar to horses
AR_SpawnerCore_Mule:
  debug: false
  type: item
  material: mule_spawn_egg
  display name: "<&e>Mule Essence"
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  flags:
    PreventUse: true
  enchantments:
  - unbreaking:10
  lore:
  - "<&f>Mob Type: <&6>Mule"
  - "<&f>Shard Tier: <&6>2"
  - ""
  - "Used to craft a Mule spawner"
  - "<&f>[<&9>Rare<&f>]"
AR_SpawnerCore_Mule_Register:
  type: world
  debug: false
  events:
    on custom event id:ar_register_spawner_modules:
      - run AR_Spawners_registerCore def:Mule|AR_SpawnerCore_Mule
    on player tames MULE:
      - if <util.random.int[1].to[128]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Mule:++
        - drop AR_SpawnerCore_Mule <context.entity.location>
    on MULE spawns because BREEDING:
      - if <util.random.int[1].to[64]> <= 1:
        - flag server SpawnerDrops.Cores.Mule:++
        - drop AR_SpawnerCore_Mule <context.entity.location>