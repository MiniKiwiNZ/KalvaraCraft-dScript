AR_SpawnerCore_Spider:
  type: item
  debug: false
  material: spider_eye
  display name: <&e>Spider Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  flags:
    PreventEat: true
  lore:
  - <&f>Mob Type: <&6>Spider
  - <&f>Shard Tier: <&6>2
  - <empty>
  - Used to craft a Spider spawner
  - <&f>[<&9>Rare<&f>]
AR_SpawnerCore_Spider_Register:
  type: world
  debug: false
  events:
    on custom event id:ar_register_spawner_modules:
      - run AR_Spawners_registerCore def:SPIDER|AR_SpawnerCore_Spider
    on player kills SPIDER:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[300]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Spider:++
        - drop AR_SpawnerCore_Spider <context.entity.location>
    on player breaks spawner:
      - stop if:<context.location.has_flag[spawner]>
      - stop if:<context.location.spawner_type.advanced_matches[SPIDER].not>
      - if <util.random.int[1].to[164]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Spider:++
        - drop AR_SpawnerCore_Spider <context.location>