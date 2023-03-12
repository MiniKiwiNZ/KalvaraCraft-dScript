# Mules are similar to horses
dSpawners_SpawnerCore_Mule:
  debug: false
  type: item
  material: mule_spawn_egg
  display name: <yellow>Mule Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  flags:
    PreventUse: true
  enchantments:
  - unbreaking:10
  lore:
  - <white>Mob Type: <gold>Mule
  - <white>Shard Tier: <gold>2
  - <empty>
  - Used to craft a Mule spawner
  - <white>[<blue>Rare<white>]
dSpawners_SpawnerCore_Mule_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_spawner_modules:
      - run dSpawners_Spawners_registerCore def:Mule|dSpawners_SpawnerCore_Mule
    on player tames MULE:
      - if <util.random.int[1].to[128]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Mule:++
        - drop dSpawners_SpawnerCore_Mule <context.entity.location>
    on MULE spawns because BREEDING:
      - if <util.random.int[1].to[64]> <= 1:
        - flag server SpawnerDrops.Cores.Mule:++
        - drop dSpawners_SpawnerCore_Mule <context.entity.location>