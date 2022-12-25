dSpawners_SpawnerCore_Axolotl:
  debug: false
  type: item
  material: axolotl_bucket
  display name: <&e>Axolotl Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  flags:
    PreventUse: true
  lore:
  - <&f>Mob Type: <&6>Axolotl
  - <&f>Shard Tier: <&6>2
  - <empty>
  - Used to craft an Axolotl spawner
  - <&f>[<&9>Rare<&f>]
dSpawners_SpawnerCore_Axolotl_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_spawner_modules:
      - run dSpawners_Spawners_registerCore def:AXOLOTL|dSpawners_SpawnerCore_Axolotl
    on AXOLOTL dies by:player:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[512]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<context.damager>]>:
        - flag server SpawnerDrops.Cores.Axolotl:++
        - determine <context.drops.include_single[dSpawners_SpawnerCore_Axolotl]>
    on AXOLOTL spawns because EGG|BREEDING:
      - flag <context.entity> from_spawner