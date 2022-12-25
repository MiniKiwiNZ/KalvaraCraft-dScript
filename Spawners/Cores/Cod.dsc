dSpawners_SpawnerCore_Cod:
  type: item
  debug: false
  material: cod
  display name: <&e>Cod Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  flags:
    PreventEat: true
  lore:
  - <&f>Mob Type: <&6>Cod
  - <&f>Shard Tier: <&6>2
  - <empty>
  - Used to craft a Cod spawner
  - <&f>[<&9>Rare<&f>]
dSpawners_SpawnerCore_Cod_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_spawner_modules:
      - run dSpawners_Spawners_registerCore def:COD|dSpawners_SpawnerCore_Cod
    on player fishes COD while CAUGHT_FISH:
      - if <util.random.int[1].to[5120]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Cod:++
        - determine CAUGHT:dSpawners_SpawnerCore_Cod
    on player kills cod:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[512]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Cod:++
        - drop dSpawners_SpawnerCore_Cod <context.entity.location>