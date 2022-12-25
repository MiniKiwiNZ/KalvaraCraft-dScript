AR_Spawner_Blaze:
  debug: false
  type: item
  material: spawner
  data:
    Placeable: true
    Recharge:
      MaxDuration: 7d
      Cost:
      - AR_SpawnerShard_3
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
          - AR_SpawnerShard_2[quantity=2]
          2:
          - AR_SpawnerShard_2[quantity=2]
          3:
          - AR_SpawnerShard_2[quantity=3]
          4:
          - AR_SpawnerShard_2[quantity=3]
          5:
          - AR_SpawnerShard_3[quantity=2]
          6:
          - AR_SpawnerShard_3[quantity=2]
          7:
          - AR_SpawnerShard_3[quantity=2]
          - AR_SpawnerShard_2[quantity=1]
          8:
          - AR_SpawnerShard_3[quantity=2]
          - AR_SpawnerShard_2[quantity=1]
          9:
          - AR_SpawnerShard_3[quantity=3]
          10:
          - AR_SpawnerShard_3[quantity=3]
          11:
          - AR_SpawnerShard_3[quantity=4]
          12:
          - AR_SpawnerShard_3[quantity=4]
          13:
          - AR_SpawnerShard_3[quantity=5]
          14:
          - AR_SpawnerShard_3[quantity=5]
          15:
          - AR_SpawnerShard_3[quantity=6]
          16:
          - AR_SpawnerShard_3[quantity=2]
          17:
          - AR_SpawnerShard_3[quantity=2]
          - AR_SpawnerShard_1[quantity=2]
          18:
          - AR_SpawnerShard_3[quantity=2]
          - AR_SpawnerShard_2[quantity=1]
          19:
          - AR_SpawnerShard_3[quantity=2]
          - AR_SpawnerShard_2[quantity=1]
          - AR_SpawnerShard_1[quantity=2]
          20:
          - AR_SpawnerShard_3[quantity=2]
          - AR_SpawnerShard_2[quantity=2]
      # Activation range increases required player distance by one block
      ActivationRange:
        MaxLevel: 7
        Cost:
          1:
          - AR_SpawnerShard_2[quantity=2]
          2:
          - AR_SpawnerShard_2[quantity=2]
          3:
          - AR_SpawnerShard_3[quantity=1]
          4:
          - AR_SpawnerShard_3[quantity=1]
          5:
          - AR_SpawnerShard_3[quantity=1]
          - AR_SpawnerShard_2[quantity=2]
          6:
          - AR_SpawnerShard_3[quantity=1]
          - AR_SpawnerShard_2[quantity=2]
          7:
          - AR_SpawnerShard_3[quantity=2]
      # Allows one additional mob to be within range of the spawner before it stops
      EntityCap:
        MaxLevel: 3
        Cost:
          1:
          - AR_SpawnerShard_3[quantity=2]
          2:
          - AR_SpawnerShard_3[quantity=3]
          3:
          - AR_SpawnerShard_3[quantity=4]
          4:
          - AR_SpawnerShard_3[quantity=4]
      # Multiply loot drops from entities spawned from this spawner - each level
      #  adds 1 to the multiplier
      LootMultiplier:
        MaxLevel: 4
        Cost:
          1:
          - AR_SpawnerShard_4[quantity=3]
          - AR_SpawnerCore_Blaze
          - blaze_rod[quantity=64]
          2:
          - AR_SpawnerShard_4[quantity=3]
          - AR_SpawnerCore_Blaze
          - blaze_rod[quantity=128]
          3:
          - AR_SpawnerShard_4[quantity=6]
          - AR_SpawnerCore_Blaze
          - blaze_rod[quantity=256]
          4:
          - AR_SpawnerShard_4[quantity=6]
          - AR_SpawnerCore_Blaze
          - blaze_rod[quantity=512]
  display name: <&e>Blaze <&a>Spawner
  lore:
  - <&f>Mob Type: <&6>Blaze
  mechanisms:
    spawner_type: BLAZE
  recipes:
    1:
      type: shaped
      input:
      - air|AR_SpawnerShard_3|air
      - AR_SpawnerShard_3|AR_SpawnerCore_Blaze|AR_SpawnerShard_3
      - air|AR_SpawnerShard_3|air
AR_Spawner_Blaze_Register:
  type: world
  debug: false
  events:
    on custom event id:ar_register_spawner_modules:
      - run AR_Spawners_registerSpawner def:BLAZE|AR_Spawner_Blaze