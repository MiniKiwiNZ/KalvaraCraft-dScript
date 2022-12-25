dSpawners_Spawner_Spider:
  debug: false
  type: item
  material: spawner
  data:
    Placeable: true
    Recharge:
      MaxDuration: 7d
      Cost:
      - dSpawners_SpawnerShard_2
      CostDuration: 1d
    BaseStats:
      spawner_max_nearby_entities: 2
      spawner_delay_data: 300|300|300
      spawner_player_range: 8
      spawner_count: 2
      spawner_range: 12
    Upgrades:
      Speed:
        MaxLevel: 15
        Cost:
          1:
          - dSpawners_SpawnerShard_2[quantity=2]
          2:
          - dSpawners_SpawnerShard_2[quantity=2]
          3:
          - dSpawners_SpawnerShard_2[quantity=2]
          - dSpawners_SpawnerShard_1[quantity=1]
          4:
          - dSpawners_SpawnerShard_2[quantity=2]
          - dSpawners_SpawnerShard_1[quantity=1]
          5:
          - dSpawners_SpawnerShard_2[quantity=3]
          6:
          - dSpawners_SpawnerShard_2[quantity=3]
          7:
          - dSpawners_SpawnerShard_2[quantity=3]
          - dSpawners_SpawnerShard_1[quantity=1]
          8:
          - dSpawners_SpawnerShard_2[quantity=3]
          - dSpawners_SpawnerShard_1[quantity=1]
          9:
          - dSpawners_SpawnerShard_2[quantity=4]
          10:
          - dSpawners_SpawnerShard_2[quantity=4]
          11:
          - dSpawners_SpawnerShard_2[quantity=5]
          12:
          - dSpawners_SpawnerShard_2[quantity=5]
          13:
          - dSpawners_SpawnerShard_2[quantity=6]
          14:
          - dSpawners_SpawnerShard_2[quantity=6]
          15:
          - dSpawners_SpawnerShard_2[quantity=8]
          16:
          - dSpawners_SpawnerShard_3[quantity=2]
          17:
          - dSpawners_SpawnerShard_3[quantity=2]
          - dSpawners_SpawnerShard_1[quantity=2]
          18:
          - dSpawners_SpawnerShard_3[quantity=2]
          - dSpawners_SpawnerShard_2[quantity=1]
          19:
          - dSpawners_SpawnerShard_3[quantity=2]
          - dSpawners_SpawnerShard_2[quantity=1]
          - dSpawners_SpawnerShard_1[quantity=2]
          20:
          - dSpawners_SpawnerShard_3[quantity=2]
          - dSpawners_SpawnerShard_2[quantity=2]
      ActivationRange:
        MaxLevel: 7
        Cost:
          1:
          - dSpawners_SpawnerShard_2[quantity=2]
          2:
          - dSpawners_SpawnerShard_2[quantity=2]
          3:
          - dSpawners_SpawnerShard_2[quantity=3]
          4:
          - dSpawners_SpawnerShard_2[quantity=3]
          5:
          - dSpawners_SpawnerShard_2[quantity=4]
          6:
          - dSpawners_SpawnerShard_3[quantity=1]
          - dSpawners_SpawnerShard_2[quantity=2]
          7:
          - dSpawners_SpawnerShard_3[quantity=2]
      EntityCap:
        MaxLevel: 3
        Cost:
          1:
          - dSpawners_SpawnerShard_2[quantity=8]
          2:
          - dSpawners_SpawnerShard_2[quantity=8]
          3:
          - dSpawners_SpawnerShard_2[quantity=8]
          4:
          - dSpawners_SpawnerShard_2[quantity=8]
      LootMultiplier:
        MaxLevel: 4
        Cost:
          1:
          - dSpawners_SpawnerShard_4[quantity=2]
          - dSpawners_SpawnerCore_Spider
          - string[quantity=64]
          2:
          - dSpawners_SpawnerShard_4[quantity=2]
          - dSpawners_SpawnerCore_Spider
          - string[quantity=128]
          3:
          - dSpawners_SpawnerShard_4[quantity=4]
          - dSpawners_SpawnerCore_Spider
          - string[quantity=256]
          4:
          - dSpawners_SpawnerShard_4[quantity=4]
          - dSpawners_SpawnerCore_Spider
          - string[quantity=512]
  display name: <&e>Spider <&a>Spawner
  lore:
  - <&f>Mob Type: <&6> Spider
  mechanisms:
    spawner_type: SPIDER
  recipes:
    1:
      type: shaped
      input:
      - dSpawners_SpawnerShard_2|air|dSpawners_SpawnerShard_2
      - dSpawners_SpawnerShard_2|dSpawners_SpawnerCore_Spider|dSpawners_SpawnerShard_2
      - dSpawners_SpawnerShard_2|air|dSpawners_SpawnerShard_2
    2:
      type: shaped
      input:
      - dSpawners_SpawnerShard_2|dSpawners_SpawnerShard_2|dSpawners_SpawnerShard_2
      - air|dSpawners_SpawnerCore_Spider|air
      - dSpawners_SpawnerShard_2|dSpawners_SpawnerShard_2|dSpawners_SpawnerShard_2
dSpawners_Spawner_Spider_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_spawner_modules:
      - run dSpawners_Spawners_registerSpawner def:SPIDER|dSpawners_Spawner_Spider