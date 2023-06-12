dSpawners_Spawners_Command:
  debug: false
  type: command
  name: spawner
  description: Does something
  usage: /spawner <&lt>parameter<&gt>
  data:
    Messages:
      Help:
      - <gold><bold>Spawners Help<&co>
      - <&sp><dark_aqua><bold>/spawner [help] <aqua>- <white>Show this help menu
      - <&sp><dark_aqua><bold>/spawner upgrade <aqua>- <white>Upgrade the targeted spawner
      - <&sp><dark_aqua><bold>/spawner info <aqua>- <white>Show the upgrades of the
      - <&sp><&sp><&sp><white>spawner you are looking at
      - <&sp><dark_aqua><bold>/spawner boost <aqua>- <white>Show the spawner related boosts
      - <&sp><&sp><&sp><white>currently applied to you
      HelpAdmin:
      - <&sp><dark_aqua><bold>/spawner give <aqua><&lt>player<&gt> <&lt>type<&gt> [quantity] - <white>Give a
      - <&sp><&sp><&sp><white>spawner to the player
      - <&sp><dark_aqua><bold>/spawner giveshards <aqua><&lt>player<&gt> [tier] [amount] - <white>Give
      - <&sp><&sp><&sp><white>spawner shards to a player
      - <&sp><dark_aqua><bold>/spawner boost <aqua><&lt>player<&gt> <&lt>type<&gt> <&lt>amount<&gt> <&lt>duration<&gt>
      - <&sp><&sp><&sp><white>Give the specified player a greater drop chance to
      - <&sp><&sp><&sp><white>get the spawner drops specified by <aqua><&lt>type<&gt><white>. Using
      - <&sp><&sp><&sp><white>a boost of the same type overrides the existing one
      - <&sp><dark_aqua><bold>/spawner boost <aqua>-global <&lt>type<&gt> <&lt>amount<&gt> <&lt>duration<&gt>
      - <&sp><&sp><&sp><white>Give all players a greater drop chance to get the
      - <&sp><&sp><&sp><white>spawner drops specified by <aqua><&lt>type<&gt><white>. Activating
      - <&sp><&sp><&sp><white>multiple boosts will increase the duration.
      - <&sp><aqua><&lt>type<&gt><white> Can be <aqua>cores<white>, <aqua>shards<white>, or <aqua>all<white>.
    Injects:
      Help:
      - choose <context.source_type>:
        - case PLAYER:
          - foreach <script.parsed_key[data.Messages.Help]> as:msg:
            - narrate <[msg]>
          - if <player.has_permission[ApeironSpawners.Admin]>:
            - foreach <script.parsed_key[data.Messages.HelpAdmin]> as:msg:
              - narrate <[msg]>
        - default:
          - foreach <script.parsed_key[data.Messages.Help]> as:msg:
            - announce to_console <[msg]>
          - foreach <script.parsed_key[data.Messages.HelpAdmin]> as:msg:
            - announce to_console <[msg]>
      InvalidPlayer:
      - choose <context.source_type>:
        - case PLAYER:
          - narrate "<&c>The specified player is not online!"
        - default:
          - announce to_console "<&c>The specified player is not online!"
  tab complete:
    - define result <list>
    - choose <tern[<context.raw_args.ends_with[<&sp>]>].pass[<context.args.size.add[1]>].fail[<context.args.size.max[1]>]>:
      - case 1:
        - define result <[result].include[help|upgrade|boost|recipe]>
        - if <context.server> || <player.has_permission[ApeironSpawners.Admin]>:
          - define result <[result].include[give|giveshards]>
      - case 2:
        - choose <context.args.get[1]>:
          - case give giveshards:
            - if <context.server> || <player.has_permission[ApeironSpawners.Admin]>:
              - define result <[result].include[<server.online_players.parse[name]>]>
          - case boost:
            - if <context.server> || <player.has_permission[ApeironSpawners.Admin]>:
              - define result <[result].include[<server.online_players.parse[name]>].include[-global]>
          - case recipe:
            - define result <[result].include[<server.flag[dSpawners.Spawners].keys>]>
      - case 3:
        - choose <context.args.get[1]>:
          - case give:
            - if <context.server> || <player.has_permission[ApeironSpawners.Admin]>:
              - define result <[result].include[<server.flag[dSpawners.Spawners].keys>]>
          - case giveshards:
            - if <context.server> || <player.has_permission[ApeironSpawners.Admin]>:
              - define result <[result].include[<server.flag[dSpawners.Shards].keys>]>
          - case boost:
            - if <context.server> || <player.has_permission[ApeironSpawners.Admin]>:
              - define result <[result].include[cores|shards|all]>
      - case 4:
        - choose <context.args.get[1]>:
          - case give giveshards:
            - if <context.server> || <player.has_permission[ApeironSpawners.Admin]>:
              - define result <[result].include[[quantity]]>
          - case boost:
            - if <context.server> || <player.has_permission[ApeironSpawners.Admin]>:
              - define result <[result].include[[multiplier]]>
      - case 5:
        - choose <context.args.get[1]>:
          - case boost:
            - if <context.server> || <player.has_permission[ApeironSpawners.Admin]>:
              - define result <[result].include[[duration]]>
    - determine <[result].filter[contains[<context.args.last.if_null[]>]]>
  script:
  - choose <context.args.get[1].if_null[help]>:
    ## /spawner upgrade
    - case upgrade:
      - define upgradeBlock <player.cursor_on_solid[6]||null>
      - if <[upgradeBlock].material.name.equals[spawner].not.if_null[true]>:
        - narrate "<&c>You are not looking at a spawner"
        - stop
      - if <[upgradeBlock].has_flag[spawner].not>:
        - narrate "<&c>Natural spawners cannot be upgraded"
        - stop
      - inventory open d:<proc[dSpawners_Spawners_getUpgradeGui].context[<[upgradeBlock]>|<player>]>
    ## /spawner give <player> <&lt>type<&gt> [quantity]
    - case give:
      - if <context.source_type> == PLAYER && <player.has_permission[ApeironSpawners.Admin].not>:
        - narrate "<&c>You do not have permission to perform this action"
        - stop
      # Validate arg count
      - if <context.args.size> < 3:
        - inject <script> path:data.Injects.Help
        - stop
      # Validate the player
      - define targetPlayer <server.match_player[<context.args.get[2]>]||null>
      - if <[targetPlayer]> == null:
        - inject <script> path:data.Injects.InvalidPlayer
        - stop
      # Validate the spawner type
      - define spawnerType <server.flag[dSpawners.Spawners.<context.args.get[3].to_uppercase>]||null>
      - if <[spawnerType]> == null:
        - if <context.source_type> == PLAYER:
          - narrate "<&c>The specified spawner type is not valid or has not been configured correctly"
        - else:
          - announce to_console "<&c>The specified spawner type is not valid or has not been configured correctly"
        - stop
      # Set the quantity
      - define quantity <context.args.get[4].null_if_tag[<[null_if_value].is_integer.not>].if_null[1]>
      - give <[spawnerType]> to:<[targetPlayer].inventory> quantity:<[quantity]>
      - narrate "<script[dSpawners_SpawnerConfig].parsed_key[data.Prefix]><green>Received <[quantity]>x <[spawnerType].as[item].display.if_null[<[spawnerType]>]><green>!" targets:<[targetPlayer]>
      - if <context.source_type> == PLAYER:
        - if <player.equals[<[targetPlayer]>].not>:
          - narrate "<script[dSpawners_SpawnerConfig].parsed_key[data.Prefix]>Gave <[targetPlayer].name> <[quantity]>x <[spawnerType].as[item].display.if_null[<[spawnerType]>]>"
      - else:
        - announce to_console "<script[dSpawners_SpawnerConfig].parsed_key[data.Prefix]>Gave <[targetPlayer].name> <[quantity]>x <[spawnerType].as[item].display.if_null[<[spawnerType]>]>"
    ## /spawner giveshards <player> [tier] [quantity]
    - case giveshards:
      - if <context.source_type> == PLAYER && <player.has_permission[ApeironSpawners.Admin].not>:
        - narrate "<&c>You do not have permission to perform this action"
        - stop
      # Validate arg count
      - if <context.args.size> < 2:
        - inject <script> path:data.Injects.Help
        - stop
      # Validate the player
      - define targetPlayer <server.match_player[<context.args.get[2]>]||null>
      - if <[targetPlayer]> == null:
        - inject <script> path:data.Injects.InvalidPlayer
        - stop
      # Validate the shard type
      - define shardScript <server.flag[dSpawners.Shards.<context.args.get[3].if_null[1]>]||null>
      - if <[shardScript]> == null:
        - if <context.source_type> == PLAYER:
          - narrate "<&c>The specified shard tier is not valid or has not been configured correctly"
        - else:
          - announce to_console "<&c>The specified shard tier is not valid or has not been configured correctly"
      # Set the quantity
      - define quantity <context.args.get[4].null_if_tag[<[null_if_value].is_integer.not>].if_null[1]>
      - give <[shardScript]> to:<[targetPlayer].inventory> quantity:<[quantity]>
      - narrate "<script[dSpawners_SpawnerConfig].parsed_key[data.Prefix]><green>Received <[quantity]>x <[shardScript].as[item].display.if_null[<[shardScript]>]><green>!" targets:<[targetPlayer]>
      - if <context.source_type> == PLAYER:
        - if <player.equals[<[targetPlayer]>].not>:
          - narrate "<script[dSpawners_SpawnerConfig].parsed_key[data.Prefix]>Gave <[targetPlayer].name> <[quantity]>x <[shardScript].as[item].display.if_null[<[shardScript]>]>"
      - else:
        - announce to_console "<script[dSpawners_SpawnerConfig].parsed_key[data.Prefix]>Gave <[targetPlayer].name> <[quantity]>x <[shardScript].as[item].display.if_null[<[shardScript]>]>"
    ## /spawner boost [<player|-global> <all|cores|shards> <multiplier> <&lt>duration<&gt>]
    - case boost:
      # The second argument is always either a player or -global
      - if <context.args.size> >= 2 && <context.args.get[2]> != -global:
        - define targetPlayer <server.match_player[<context.args.get[2]>]||null>
        - if <[targetPlayer]> == null:
          - inject <script> path:data.Injects.InvalidPlayer
          - stop
      # If only "/spawner boost" was executed, the targeted player is the executor
      - if <context.args.size> == 1:
        - define targetPlayer <player>
      # If there are two arguments or less, we are responding with the boost info
      - if <context.args.size> <= 2:
        - if <[targetPlayer].exists.if_null[false].not>:
          - inject <script> path:data.Injects.InvalidPlayer
          - stop
        # Global boosts
        - narrate "<script[dSpawners_SpawnerConfig].parsed_key[data.Prefix]>Global Boost Info:"
        # Shards
        - if <server.has_flag[Spawners.ActiveBoosts.Shards].not>:
          - narrate " Shard Drops: Not Active"
        - else:
          - narrate " Shard Drops: <server.flag[Spawners.ActiveBoosts.Shards]>x (<server.flag_expiration[Spawners.ActiveBoosts.Shards].from_now.formatted>)"
        # Cores
        - if <server.has_flag[Spawners.ActiveBoosts.Cores].not>:
          - narrate " Core Drops: Not Active"
        - else:
          - narrate " Core Drops: <server.flag[Spawners.ActiveBoosts.Cores]>x (<server.flag_expiration[Spawners.ActiveBoosts.Cores].from_now.formatted>)"
        # Player boosts
        - narrate "<script[dSpawners_SpawnerConfig].parsed_key[data.Prefix]>Player Boost Info:"
        # Shards
        - if <[targetPlayer].has_flag[Spawners.Boosts.Shards]>:
          - narrate " Shard Drops: <[targetPlayer].flag[Spawners.Boosts.Shards].get[1]>x (<[targetPlayer].flag_expiration[Spawners.Boosts.Shards].from_now.formatted>)"
        - else:
          - narrate " Shard Drops: Not Active"
        # Cores
        - if <[targetPlayer].has_flag[Spawners.Boosts.Cores]>:
          - narrate " Core Drops: <[targetPlayer].flag[Spawners.Boosts.Cores].get[1]>x (<[targetPlayer].flag_expiration[Spawners.Boosts.Cores].from_now.formatted>)"
        - else:
          - narrate " Core Drops: Not Active"
        - stop
      # Perform a permissions check
      - if <context.source_type> == player && <player.has_permission[ApeironSpawners.Admin].not>:
        - narrate "<&c>You do not have permission to perform this action"
        - stop
      # All five arguments must be specified if not listing boosts
      - if <context.args.size> < 5:
        - inject <script> path:data.Injects.Help
        - stop
      # Validate the duration
      - define duration <context.args.get[5].as[duration].if_null[null]>
      - if <[duration]> == null:
        - if <context.source_type> == PLAYER:
          - narrate "<&c>Duration is not valid"
        - else:
          - announce to_console "<&c>Duration is not valid"
      # Validate the multiplier
      - if <context.args.get[4].is_decimal.not>:
        - if <context.source_type> == PLAYER:
          - narrate "<&c>Multiplier is not valid"
        - else:
          - announce to_console "<&c>Multiplier is not valid"
      # Validate the type
      - if <list[all|shards|cores].contains[<context.args.get[3]>].not>:
        - if <context.source_type> == PLAYER:
          - narrate "<&c>Type must be 'all', 'cores', or 'shards"
        - else:
          - announce to_console "<&c>Type must be 'all', 'cores', or 'shards"
      # Queue up the boost
      - ~run dSpawners_Spawners_queueOrActivateBoost def:<context.args.get[3]>|<[duration]>|<context.args.get[4]>|<[targetPlayer].if_null[-global]>
    ## /spawner recipe <&lt>type<&gt>
    - case recipe:
      # This command cannot be run from the console
      - if <context.source_type> != PLAYER:
          - announce to_console "<&c>This command must be run by a player"
          - stop
      # Validate the spawner type
      - define spawnerType <server.flag[dSpawners.Spawners.<context.args.get[2].to_uppercase>].as[item].recipe_ids||<list>>
      - if <[spawnerType].size> == 0:
        - narrate "<&c>The specified spawner type is not valid, has no recipe, or has not been configured correctly"
        - stop
      # Find the recipe for the spawner item
    ## Default path
    - default:
      - inject <script> path:data.Injects.Help
dSpawners_Spawners_queueOrActivateBoost:
  type: task
  debug: false
  definitions: type|duration|multiplier|player
  script:
  # If this is a global boost..
  - if <[player]> == -global:
    # And the type includes shards..
    - if <[type]> == all || <[type]> == shards:
      # And the server has an active global shard boost with the same multiplier..
      - if <server.has_flag[Spawners.ActiveBoosts.Shards]> && <server.flag[Spawners.ActiveBoosts.Shards].get[1]> == <[multiplier]>:
        # Extend the current boost
        - flag server Spawners.ActiveBoosts.Shards:<[multiplier]>|<server.flag[Spawners.ActiveBoosts.Shards].get[2].add[<[duration]>]> expire:<server.flag_expiration[Spawners.ActiveBoosts.Shards].from_now.add[<[duration]>]>
      - else:
        # Add the boost to the queue
        - flag server Spawners.QueuedBoosts.Shards.<[multiplier]>:<[duration].add[<server.flag[Spawners.QueuedBoosts.Shards.<[multiplier]>].if_null[0]>]>
    # And the type includes cores..
    - if <[type]> == all || <[type]> == cores:
      # And the server has an active global core boost with the same multiplier..
      - if <server.has_flag[Spawners.ActiveBoosts.Cores]> && <server.flag[Spawners.ActiveBoosts.Cores]> == <[multiplier]>:
        # Extend the current boost
        - flag server Spawners.ActiveBoosts.Cores:<[multiplier]> expire:<server.flag_expiration[Spawners.ActiveBoosts.Cores].from_now.add[<[duration]>]>
      - else:
        # Add the boost to the queue
        - flag server Spawners.QueuedBoosts.Cores.<[multiplier]>:<[duration].add[<server.flag[Spawners.QueuedBoosts.Cores.<[multiplier]>].if_null[0]>]>
  # If it's a player boost, write the flags straight in
  - else:
    - if <[type]> == all || <[type]> == shards:
      - flag <[player]> Spawners.Boosts.Shards:<list[<[multiplier]>|<[duration]>]> expire:<[duration]>
    - if <[type]> == all || <[type]> == cores:
      - flag <[player]> Spawners.Boosts.Cores:<list[<[multiplier]>|<[duration]>]> expire:<[duration]>
dSpawners_Spawners_BoostWatcher:
  type: world
  debug: false
  events:
    on delta time secondly:
      # If there's no active shard boost, check for a queued one
      - if <server.has_flag[Spawners.ActiveBoosts.Shards].not> && <server.flag[Spawners.QueuedBoosts.Shards].size.if_null[0]> > 0:
        - define nextMultiplier <server.flag[Spawners.QueuedBoosts.Shards].keys.first>
        - define nextDuration <server.flag[Spawners.QueuedBoosts.Shards.<[nextMultiplier]>]>
        - flag server Spawners.QueuedBoosts.Shards.<[nextMultiplier]>:!
        - flag server Spawners.ActiveBoosts.Shards:<[nextMultiplier]> expire:<[nextDuration]>
        - run dSpawners_Spawners_BoostBar def.players:<server.online_players> "def.message:Spawner shard drop chances are increased by <[nextMultiplier]>x for the next <[nextDuration].formatted>"
      # If there's no active core boost, check for a queued one
      - if <server.has_flag[Spawners.ActiveBoosts.Cores].not> && <server.flag[Spawners.QueuedBoosts.Cores].size.if_null[0]> > 0:
        - define nextMultiplier <server.flag[Spawners.QueuedBoosts.Cores].keys.first>
        - define nextDuration <server.flag[Spawners.QueuedBoosts.Cores.<[nextMultiplier]>]>
        - flag server Spawners.QueuedBoosts.Cores.<[nextMultiplier]>:!
        - flag server Spawners.ActiveBoosts.Cores:<[nextMultiplier]> expire:<[nextDuration]>
        - run dSpawners_Spawners_BoostBar def.players:<server.online_players> "def.message:Spawner core drop chances are increased by <[nextMultiplier]>x for the next <[nextDuration].formatted>"
dSpawners_Spawners_BoostBar:
  type: task
  debug: false
  definitions: players|message|color
  script:
    - define bossbar <util.random_uuid>
    - bossbar create <[bossbar]> players:<[players]> title:<[message]> style:SOLID color:<[color].if_null[<list[BLUE|GREEN|PINK|PURPLE|RED|WHITE|YELLOW].random>]> progress:0
    - wait 0.1s
    - repeat 150:
      - bossbar update <[bossbar]> progress:<[value].div[150]>
      - wait 0.1s
    - bossbar remove <[bossbar]>
dSpawners_Spawners_BoostThreshold:
  type: procedure
  debug: false
  definitions: inputChance|type|player
  script:
    - define multiplier <[player].flag[Spawners.Boosts.<[type]>].get[1].if_null[0].add[<server.flag[Spawners.ActiveBoosts.<[type]>].if_null[0]>].max[1]>
    - determine <[inputChance].mul[<[multiplier]>]>