AR_Spawner_Ocelot:
  debug: false
  type: item
  material: spawner
  data:
    Placeable: true
    Recharge:
      MaxDuration: 7d
      Cost:
      - AR_SpawnerShard_1
      CostDuration: 1d
    BaseStats:
      # How many entities can be in range before spawner stops spawning
      spawner_max_nearby_entities: 2
      # initial spawn delay|minimum spawn delay|maximum spawn delay
      spawner_delay_data: 300|300|300
      # Player must be within this distance to spawn mobs
      spawner_player_range: 8
      # The number of mobs spawned by this spawner
      spawner_count: 2
      # The distance away that the spawner will attempt to spawn mobs
      # Also the distance away it looks for mobs for spawner_max_nearby_entities
      spawner_range: 12
    Upgrades:
      # Speed decreases maximum and minimum spawn time by 10 ticks
      Speed:
        # 20 levels are defined, but only 10 are obtainable right now
        MaxLevel: 15
        Cost:
          1:
          - AR_SpawnerShard_1[quantity=2]
          2:
          - AR_SpawnerShard_1[quantity=2]
          3:
          - AR_SpawnerShard_1[quantity=3]
          4:
          - AR_SpawnerShard_1[quantity=3]
          5:
          - AR_SpawnerShard_1[quantity=4]
          6:
          - AR_SpawnerShard_1[quantity=4]
          7:
          - AR_SpawnerShard_1[quantity=4]
          8:
          - AR_SpawnerShard_1[quantity=5]
          9:
          - AR_SpawnerShard_1[quantity=5]
          10:
          - AR_SpawnerShard_1[quantity=5]
          11:
          - AR_SpawnerShard_1[quantity=6]
          12:
          - AR_SpawnerShard_2[quantity=6]
          13:
          - AR_SpawnerShard_2[quantity=6]
          14:
          - AR_SpawnerShard_2[quantity=7]
          15:
          - AR_SpawnerShard_2[quantity=8]
          16:
          - AR_SpawnerShard_2[quantity=3]
          17:
          - AR_SpawnerShard_2[quantity=4]
          18:
          - AR_SpawnerShard_2[quantity=4]
          19:
          - AR_SpawnerShard_2[quantity=4]
          20:
          - AR_SpawnerShard_2[quantity=4]
      # Activation range increases required player distance by one block
      ActivationRange:
        MaxLevel: 7
        Cost:
          1:
          - AR_SpawnerShard_1[quantity=3]
          2:
          - AR_SpawnerShard_1[quantity=3]
          3:
          - AR_SpawnerShard_1[quantity=4]
          4:
          - AR_SpawnerShard_1[quantity=4]
          5:
          - AR_SpawnerShard_1[quantity=6]
          6:
          - AR_SpawnerShard_1[quantity=6]
          7:
          - AR_SpawnerShard_1[quantity=8]
      # Allows one additional mob to be within range of the spawner before it stops
      EntityCap:
        MaxLevel: 3
        Cost:
          1:
          - AR_SpawnerShard_2[quantity=4]
          2:
          - AR_SpawnerShard_2[quantity=4]
          3:
          - AR_SpawnerShard_2[quantity=4]
          4:
          - AR_SpawnerShard_3[quantity=1]
  display name: "<&e>Ocelot <&a>Spawner"
  lore:
  - "<&f>Mob Type: <&6>Ocelot"
  mechanisms:
    spawner_type: Ocelot
  recipes:
    1:
      type: shaped
      input:
      - AR_SpawnerShard_1|AR_SpawnerShard_1|AR_SpawnerShard_1
      - AR_SpawnerShard_1|AR_SpawnerCore_Ocelot|AR_SpawnerShard_1
      - AR_SpawnerShard_1|AR_SpawnerShard_1|AR_SpawnerShard_1
AR_Spawner_Ocelot_Register:
  type: world
  debug: false
  events:
    on custom event id:ar_register_spawner_modules:
      - run AR_Spawners_registerSpawner def:OCELOT|AR_Spawner_Ocelot