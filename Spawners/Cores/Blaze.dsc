# Blazes can be used to infinitely fuel furnaces
# This justifies quite a high cost on their spawners
AR_SpawnerCore_Blaze:
  debug: false
  type: item
  material: blaze_powder
  display name: "<&e>Blaze Essence"
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  lore:
  - <&f>Mob Type: <&6>Blaze
  - <&f>Shard Tier: <&6>3
  - <empty>
  - Used to craft a Blaze spawner
  - <&f>[<&d>Epic<&f>]
AR_SpawnerCore_Blaze_Register:
  type: world
  debug: false
  events:
    on custom event id:ar_register_spawner_modules:
      - run AR_Spawners_registerCore def:BLAZE|AR_SpawnerCore_Blaze
    on BLAZE dies by:player:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[256]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<context.damager>]>:
        - flag server SpawnerDrops.Cores.Blaze:++
        - determine <context.drops.include_single[AR_SpawnerCore_Blaze]>
    on player breaks spawner:
      - stop if:<context.location.has_flag[spawner]>
      - stop if:<context.location.spawner_type.advanced_matches[BLAZE].not>
      - if <util.random.int[1].to[340]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Blaze:++
        - drop AR_SpawnerCore_Blaze <context.location>