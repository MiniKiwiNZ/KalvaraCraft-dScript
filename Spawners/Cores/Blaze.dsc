# Blazes can be used to infinitely fuel furnaces
# This justifies quite a high cost on their spawners
dSpawners_SpawnerCore_Blaze:
  debug: false
  type: item
  material: blaze_powder
  display name: "<yellow>Blaze Essence"
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  lore:
  - <white>Mob Type: <gold>Blaze
  - <white>Shard Tier: <gold>3
  - <empty>
  - Used to craft a Blaze spawner
  - <white>[<light_purple>Epic<white>]
dSpawners_SpawnerCore_Blaze_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_spawner_modules:
      - run dSpawners_Spawners_registerCore def:BLAZE|dSpawners_SpawnerCore_Blaze
    on BLAZE dies by:player:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[256]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<context.damager>]>:
        - flag server SpawnerDrops.Cores.Blaze:++
        - determine <context.drops.include_single[dSpawners_SpawnerCore_Blaze]>
    on player breaks spawner:
      - stop if:<context.location.has_flag[spawner]>
      - stop if:<context.location.spawner_type.advanced_matches[BLAZE].not>
      - if <util.random.int[1].to[340]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Blaze:++
        - drop dSpawners_SpawnerCore_Blaze <context.location>