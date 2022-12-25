# Guardians allow renewable generation of prismarine shards and crystals
AR_SpawnerCore_Guardian:
  debug: false
  type: item
  material: prismarine_crystals
  display name: <&e>Guardian Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  lore:
  - <&f>Mob Type: <&6>Guardian
  - <&f>Shard Tier: <&6>3
  - <empty>
  - Used to craft a Guardian spawner
  - <&f>[<&d>Epic<&f>]
AR_SpawnerCore_Guardian_Register:
  type: world
  debug: false
  events:
    on custom event id:ar_register_spawner_modules:
      - run AR_Spawners_registerCore def:GUARDIAN|AR_SpawnerCore_Guardian
    on ELDER_GUARDIAN dies by:player:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[128]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<context.damager>]>:
        - flag server SpawnerDrops.Cores.Guardian:++
        - determine <context.drops.include_single[AR_SpawnerCore_Guardian]>
    on player kills GUARDIAN:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[512]>  <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Guardian:++
        - drop AR_SpawnerCore_Guardian <context.entity.location>