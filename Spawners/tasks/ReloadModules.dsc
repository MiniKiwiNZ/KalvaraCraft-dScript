dspawners_task_reloadmodules:
  type: task
  debug: false
  script:
  - announce to_console "<script[dspawners_spawnerconfig].parsed_key[data.prefix]><gray>Reloading spawner modules..."
  - flag server dspawners.shards:!
  - flag server dspawners.cores:!
  - flag server dspawners.spawners:!
  # Register all the shards
  - customevent id:dspawners_register_shards save:shards
  - if <entry[shards].determination_list.is_empty.if_null[true]>:
    - announce to_console "<script[dspawners_spawnerconfig].parsed_key[data.prefix]><red>No spawner shards were registered during module reload"
  - else:
    - define shards <map>
    - foreach <entry[shards].determination_list> as:entry:
      - foreach <[entry]> as:item key:id:
        - if <[item].as[item].if_null[false]>:
          - define shards.<[id]>:<[item]>
        - else:
          - announce to_console "<script[dspawners_spawnerconfig].parsed_key[data.prefix]><dark_gray>Spawner shard '<[id]>' did not register a valid ItemTag and has been skipped"
    - flag server dspawners.shards:<[shards]>
    - announce to_console "<script[dspawners_spawnerconfig].parsed_key[data.prefix]><gray>Registered <green><server.flag[dspawners.shards].size.if_null[0]> <gray>spawner shards"
  # Register all of the cores
  - customevent id:dspawners_register_cores save:cores
  - if <entry[cores].determination_list.is_empty.if_null[true]>:
    - announce to_console "<script[dspawners_spawnerconfig].parsed_key[data.prefix]><red>No spawner cores were registered during module reload"
  - else:
    - define cores <map>
    - foreach <entry[cores].determination_list> as:entry:
      - foreach <[entry]> as:item key:id:
        - if <[item].as[item].if_null[false]>:
          - define cores.<[id]>:<[item]>
        - else:
          - announce to_console "<script[dspawners_spawnerconfig].parsed_key[data.prefix]><dark_gray>Spawner core '<[id]>' did not register a valid ItemTag and has been skipped"
    - flag server dspawners.cores:<[cores]>
    - announce to_console "<script[dspawners_spawnerconfig].parsed_key[data.prefix]><gray>Registered <green><server.flag[dspawners.cores].size.if_null[0]> <gray>spawner cores"
  # Register all of the spawners
  - customevent id:dspawners_register_spawners save:spawners
  - if <entry[spawners].determination_list.is_empty.if_null[true]>:
    - announce to_console "<script[dspawners_spawnerconfig].parsed_key[data.prefix]><red>No spawners were registered during module reload"
  - else:
    - define spawners <map>
    - foreach <entry[spawners].determination_list> as:entry:
      - foreach <[entry]> as:item key:id:
        - if <[item].as[item].if_null[false]>:
          - define spawners.<[id]>:<[item]>
        - else:
          - announce to_console "<script[dspawners_spawnerconfig].parsed_key[data.prefix]><dark_gray>Spawner '<[id]>' did not register a valid ItemTag and has been skipped"
    - flag server dspawners.spawners:<[spawners]>
    - announce to_console "<script[dspawners_spawnerconfig].parsed_key[data.prefix]><gray>Registered <green><server.flag[dspawners.spawners].size.if_null[0]> <gray>spawners"