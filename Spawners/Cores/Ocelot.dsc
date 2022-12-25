# Ocelots aren't that useful since they don't drop anything
dSpawners_SpawnerCore_Ocelot:
  debug: false
  type: item
  material: ocelot_spawn_egg
  display name: <&e>Ocelot Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  flags:
    PreventUse: true
  enchantments:
  - unbreaking:10
  lore:
  - <&f>Mob Type: <&6>Ocelot
  - <&f>Shard Tier: <&6>1
  - <empty>
  - Used to craft an Ocelot spawner
  - <&f>[<&a>Uncommon<&f>]
dSpawners_SpawnerCore_Ocelot_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_spawner_modules:
      - run dSpawners_Spawners_registerCore def:OCELOT|dSpawners_SpawnerCore_Ocelot
    on player tames OCELOT:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[128]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Ocelot:++
        - drop dSpawners_SpawnerCore_Ocelot <context.entity.location>
    on player kills OCELOT:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[128]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Ocelot:++
        - drop dSpawners_SpawnerCore_Ocelot <context.entity.location>