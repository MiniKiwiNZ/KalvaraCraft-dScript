AR_SpawnerCore_Axolotl:
  debug: false
  type: item
  material: axolotl_bucket
  display name: "<&e>Axolotl Essence"
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  flags:
    PreventUse: true
  lore:
  - "<&f>Mob Type: <&6>Axolotl"
  - "<&f>Shard Tier: <&6>2"
  - ""
  - "Used to craft an Axolotl spawner"
  - "<&f>[<&9>Rare<&f>]"
AR_SpawnerCore_Axolotl_Register:
  type: world
  debug: false
  events:
    on custom event id:ar_register_spawner_modules:
      - run AR_Spawners_registerCore def:AXOLOTL|AR_SpawnerCore_Axolotl
    on AXOLOTL dies by:player:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[512]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<context.damager>]>:
        - flag server SpawnerDrops.Cores.Axolotl:++
        - determine <context.drops.include_single[AR_SpawnerCore_Axolotl]>
    on AXOLOTL spawns because EGG|BREEDING:
      - flag <context.entity> from_spawner