# Enderman drop ender pearls, but alone ender pearls aren't that useful
AR_SpawnerCore_Enderman:
  debug: false
  type: item
  material: ender_eye
  display name: "<&e>Enderman Essence"
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  flags:
    PreventUse: true
  lore:
  - "<&f>Mob Type: <&6>Enderman"
  - "<&f>Shard Tier: <&6>2"
  - ""
  - "Used to craft an Enderman spawner"
  - "<&f>[<&9>Rare<&f>]"
AR_SpawnerCore_Enderman_Register:
  type: world
  debug: false
  events:
    on custom event id:ar_register_spawner_modules:
      - run AR_Spawners_registerCore def:ENDERMAN|AR_SpawnerCore_Enderman
    on player kills ENDERMAN:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[512]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Enderman:++
        - drop AR_SpawnerCore_Enderman <context.entity.location>
    on loot generates:
      - stop if:<context.loot_table_id.equals[minecraft:chests/end_city_treasure].not>
      - if <util.random.int[1].to[256]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Enderman:++
        - determine LOOT:<context.items.include_single[AR_SpawnerCore_Enderman]>