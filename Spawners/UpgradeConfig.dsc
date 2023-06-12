dspawners_upgradeconfig:
    type: data
    Upgrades:
      # Speed upgrade makes spawning faster by 0.5 seconds per level
      Speed:
        Material: GOLD_INGOT
        Name: <gold><bold>Spawning Speed
        Description:
        - <gray>Decreases delay between
        - <gray> spawns by 0.5 seconds
        Actions:
          OnPlace:
          - define delay <[location].spawner_maximum_spawn_delay.sub[<[level].mul[10]>]>
          - adjust <[location]> spawner_delay_data:<[delay]>|<[delay]>|<[delay]>
      # Activation range lets players be one block further away from the spawner per level
      ActivationRange:
        Material: tripwire_hook
        Name: <aqua><bold>Activation Range
        Description:
        - <gray>Increases distance to player
        - <gray> at which mobs will spawn by
        - <gray> one block
        Actions:
          OnPlace:
          - adjust <[location]> spawner_player_range:<[location].spawner_player_range.add[<[level]>]>
      # Spawn range narrows the spawn range of spawners to make mobs spawn closer to the spawner
      # This range is also used when checking the entity cap so smaller range = better spawning
      SpawnRange:
        Material: beacon
        Name: <red><bold>Spawn Range
        Description:
        - <gray>Decreases distance that
        - <gray> mobs spawn away from the
        - <gray> spawner by one block
        Actions:
          OnPlace:
          - adjust <[location]> spawner_range:<[location].spawner_range.sub[<[level]>]>
      # Entity cap controls how many mobs can be near the spawner before it won't spawn any more
      EntityCap:
        Material: bat_spawn_egg
        Name: <light_purple><bold>Max Entities
        Description:
        - <gray>Increase the number of mobs
        - <gray> that can be near this
        - <gray> spawner before it stops
        - <gray> spawning by one
        Actions:
          OnPlace:
          - adjust <[location]> spawner_max_nearby_entities:<[location].spawner_max_nearby_entities.add[<[level]>]>
      # Loot multiplier increases both XP and item drops from mobs spawned by a spawner
      # Multiplier increases by 1 for each level
      LootMultiplier:
        Material: hopper
        Name: <dark_green><bold>Loot Upgrade
        Description:
        - <gray>Increase the amount of
        - <gray> loot that mobs from this
        - <gray> spawner will drop
        Actions:
          OnSpawn:
          - adjust <[entity]> health_data:<[entity].health_max.mul[<[level].add[1]>]>/<[entity].health_max.mul[<[level].add[1]>]>
          OnDeath:
          - foreach <[drops]> as:drop:
            - define drops[<[loop_index]>]:<[drop].with[quantity=<[drop].quantity.mul[<[level].add[1]>]>]>
          - define xp <[xp].mul[<[level].add[1]>]>