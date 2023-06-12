# Magma cubes drop magma cream
dSpawners_SpawnerCore_MagmaCube:
  debug: false
  type: item
  material: magma_cream
  display name: <yellow>Magma Cube Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  lore:
  - <white>Mob Type: <gold>Magma Cube
  - <white>Shard Tier: <gold>2
  - <empty>
  - Used to craft a Magma Cube spawner
  - <white>[<blue>Rare<white>]
dSpawners_SpawnerCore_MagmaCube_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_cores:
      - determine OUTPUT:<map[MAGMACUBE=dSpawners_SpawnerCore_MagmaCube;MAGMA_CUBE=dSpawners_SpawnerCore_MagmaCube]>
    on MAGMA_CUBE spawns because SLIME_SPLIT:
      - flag <context.entity> from_spawner
    on MAGMA_CUBE dies by:player:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[192]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<context.damager>]>:
        - flag server SpawnerDrops.Cores.MagmaCube:++
        - determine <context.drops.include_single[dSpawners_SpawnerCore_MagmaCube]>
    on player breaks spawner:
      - stop if:<context.location.has_flag[spawner]>
      - stop if:<context.location.spawner_type.advanced_matches[MAGMA_CUBE].not>
      - if <util.random.int[1].to[64]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.MagmaCube:++
        - drop dSpawners_SpawnerCore_MagmaCube <context.location>