# Slimes drop slimeballs which are useful in redstone machines
AR_SpawnerCore_Slime:
  debug: false
  type: item
  material: slime_ball
  display name: "<&e>Slime Essence"
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  lore:
  - "<&f>Mob Type: <&6>Slime"
  - "<&f>Shard Tier: <&6>3"
  - ""
  - "Used to craft a Slime spawner"
  - "<&f>[<&d>Epic<&f>]"
AR_SpawnerCore_Slime_Register:
  type: world
  debug: false
  events:
    on custom event id:ar_register_spawner_modules:
      - run AR_Spawners_registerCore def:SLIME|AR_SpawnerCore_Slime
    on SLIME spawns because SLIME_SPLIT:
      - flag <context.entity> from_spawner
    on SLIME dies by:player:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[256]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<context.damager>]>:
        - flag server SpawnerDrops.Cores.Slime:++
        - determine <context.drops.include_single[AR_SpawnerCore_Slime]>
    on loot generates:
      - stop if:<context.loot_table_id.equals[minecraft:chests/abandoned_mineshaft].not>
      - if <util.random.int[1].to[512]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Slime:++
        - determine LOOT:<context.items.include_single[AR_SpawnerCore_Slime]>