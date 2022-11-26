# Dolphins only produce cod when killed
AR_SpawnerCore_Dolphin:
  debug: false
  type: item
  material: cod
  display name: "<&e>Dolphin Essence"
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  lore:
  - "<&f>Mob Type: <&6>Dolphin"
  - "<&f>Shard Tier: <&6>1"
  - ""
  - "Used to craft a Dolphin spawner"
  - "<&f>[<&a>Uncommon<&f>]"
AR_SpawnerCore_Dolphin_Register:
  type: world
  debug: false
  events:
    on custom event id:ar_register_spawner_modules:
      - run AR_Spawners_registerCore def:DOLPHIN|AR_SpawnerCore_Dolphin
    on loot generates:
      - stop if:<context.loot_table_id.equals[minecraft:chests/buried_treasure].not>
      - if <util.random.int[1].to[160]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Dolphin:++
        - determine LOOT:<context.items.include_single[AR_SpawnerCore_Dolphin]>
    on player kills dolphin:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[256]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Dolphin:++
        - drop AR_SpawnerCore_Dolphin <context.entity.location>