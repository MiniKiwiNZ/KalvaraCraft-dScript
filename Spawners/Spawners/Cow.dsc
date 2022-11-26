AR_Spawner_Cow:
  debug: false
  type: item
  material: spawner
  data:
    Placeable: true
    Recharge:
      MaxDuration: 7d
      Cost:
      - AR_SpawnerShard_2
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
          - AR_SpawnerShard_2[quantity=2]
          2:
          - AR_SpawnerShard_2[quantity=2]
          3:
          - AR_SpawnerShard_2[quantity=2]
          - AR_SpawnerShard_1[quantity=1]
          4:
          - AR_SpawnerShard_2[quantity=2]
          - AR_SpawnerShard_1[quantity=1]
          5:
          - AR_SpawnerShard_2[quantity=3]
          6:
          - AR_SpawnerShard_2[quantity=3]
          7:
          - AR_SpawnerShard_2[quantity=3]
          - AR_SpawnerShard_1[quantity=1]
          8:
          - AR_SpawnerShard_2[quantity=3]
          - AR_SpawnerShard_1[quantity=1]
          9:
          - AR_SpawnerShard_2[quantity=4]
          10:
          - AR_SpawnerShard_2[quantity=4]
          11:
          - AR_SpawnerShard_2[quantity=5]
          12:
          - AR_SpawnerShard_2[quantity=5]
          13:
          - AR_SpawnerShard_2[quantity=6]
          14:
          - AR_SpawnerShard_2[quantity=6]
          15:
          - AR_SpawnerShard_2[quantity=8]
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
      ActivationRange:
        MaxLevel: 7
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
          - AR_SpawnerShard_2[quantity=4]
          6:
          - AR_SpawnerShard_3[quantity=1]
          - AR_SpawnerShard_2[quantity=2]
          7:
          - AR_SpawnerShard_3[quantity=2]
      EntityCap:
        MaxLevel: 3
        Cost:
          1:
          - AR_SpawnerShard_2[quantity=8]
          2:
          - AR_SpawnerShard_2[quantity=8]
          3:
          - AR_SpawnerShard_2[quantity=8]
          4:
          - AR_SpawnerShard_2[quantity=8]
      LootMultiplier:
        MaxLevel: 4
        Cost:
          1:
          - AR_SpawnerShard_4[quantity=2]
          - AR_SpawnerCore_Cow
          - leather[quantity=64]
          2:
          - AR_SpawnerShard_4[quantity=2]
          - AR_SpawnerCore_Cow
          - leather[quantity=128]
          3:
          - AR_SpawnerShard_4[quantity=4]
          - AR_SpawnerCore_Cow
          - leather[quantity=256]
          4:
          - AR_SpawnerShard_4[quantity=4]
          - AR_SpawnerCore_Cow
          - leather[quantity=512]
  display name: "<&e>Cow <&a>Spawner"
  lore:
  - "<&f>Mob Type: <&6> Cow"
  mechanisms:
    spawner_type: Cow
  recipes:
    1:
      type: shaped
      input:
      - AR_SpawnerShard_2|air|AR_SpawnerShard_2
      - AR_SpawnerShard_2|AR_SpawnerCore_Cow|AR_SpawnerShard_2
      - AR_SpawnerShard_2|air|AR_SpawnerShard_2
    2:
      type: shaped
      input:
      - AR_SpawnerShard_2|AR_SpawnerShard_2|AR_SpawnerShard_2
      - air|AR_SpawnerCore_Cow|air
      - AR_SpawnerShard_2|AR_SpawnerShard_2|AR_SpawnerShard_2
AR_Spawner_Cow_Register:
  type: world
  debug: false
  events:
    on custom event id:ar_register_spawner_modules:
      - run AR_Spawners_registerSpawner def:COW|AR_Spawner_Cow