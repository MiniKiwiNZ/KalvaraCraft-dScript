dSpawners_SpawnerCore_Creeper:
  debug: false
  type: item
  material: gunpowder
  display name: <&e>Creeper Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  lore:
  - <&f>Mob Type: <&6>Creeper
  - <&f>Shard Tier: <&6>3
  - <empty>
  - Used to craft a Creeper spawner
  - <&f>[<&d>Epic<&f>]
dSpawners_SpawnerCore_Creeper_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_spawner_modules:
      - run dSpawners_Spawners_registerCore def:CREEPER|dSpawners_SpawnerCore_Creeper
    on player kills creeper:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <context.entity.powered>:
        - if <util.random.int[1].to[128]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
          - flag server SpawnerDrops.Cores.Creeper:++
          - drop dSpawners_SpawnerCore_Creeper <context.entity.location>
      - else:
        - if <util.random.int[1].to[512]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<context.damager>]>:
          - flag server SpawnerDrops.Cores.Creeper:++
          - drop dSpawners_SpawnerCore_Creeper <context.entity.location>