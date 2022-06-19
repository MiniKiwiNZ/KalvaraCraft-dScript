##########################################
## dUtils:Playtime                 v1.0 ##
## Created by MiniMuleNZ                ##
## Made available under the MIT License ##
## Copyright 2022 MiniMuleNZ            ##
##########################################

dUtils_playtime_world:
    type: world
    debug: false
    events:
        ## When a player goes AFK, their playtime should stop increasing
        on player goes afk:
        - define playTimeAdd <player.flag[dUtils.temp.timeSinceJoinAfk].from_now>
        - flag <player> dUtils.totalPlayTime:<[playTimeAdd].add[<player.flag[dUtils.totalPlayTime]>]>
        - flag <player> dUtils.temp.timeSinceJoinAfk:!
        ## When players come back from AFK we can mark when they start gaining playtime again
        on player returns from afk:
        - flag <player> dUtils.temp.timeSinceJoinAfk:<util.time_now>
        ## Set the last seen time when a player joins
        on player joins:
        # If this player doesn't have any playtime recorded, set it to zero initially
        - if <player.has_flag[dUtils.totalPlayTime].not>:
            - flag <player> dUtils.totalPlayTime:<duration[0s]>
        # Initially temp.timeSinceJoinAfk will be the same as the last seen time
        # If the player goes AFK they will split so that the playtime doesn't 
        - flag <player> dUtils.temp.timeSinceJoinAfk:<util.time_now>
        ## When players quit, update when they were last seen and add any remaining playtime
        on player quits:
        # If the player was AFK when they disconnected, there will be no additional playtime to add
        - if <player.has_flag[dUtils.temp.timeSinceJoinAfk].not>:
            - stop
        # Otherwise calculate how much playtime we should add and add it
        - define playTimeAdd <player.flag[dUtils.temp.timeSinceJoinAfk].from_now>
        - flag <player> dUtils.totalPlayTime:<[playTimeAdd].add[<player.flag[dUtils.totalPlayTime]>]>

dUtils_playtime_command:
    type: command
    name: playtime
    description: View a player's playtime on the server
    usage: /playtime <&lt>arg<&gt>
    debug: false
    tab completions:
        1: <proc[dutils_utils_visibleplayers].parse_tag[<[parse_value].name>]>
    permission: dutils.playtime
    script:
    # If there are no arguments, or the user doesn't have permission to view others playtime, show their own
    - if <context.source_type> == player && ( <context.args.size> == 0 || <player.has_permission[dutils.playtime.others].not> ):
        - narrate "<player.name> has played for <player.flag[dUtils.totalPlayTime].if_null[<duration[0s]>].add[<player.flag[dUtils.temp.timeSinceJoinAfk].from_now.if_null[0]>].formatted_words>"
        - stop
    - define targetPlayer <server.match_offline_player[<context.args.get[1]>].if_null[]> if:<context.args.size.is_more_than[0]>
    - if <[targetPlayer].equals[<empty>].if_null[true]>:
        - narrate "<&c>Could not find specified player."
        - stop
    - if <[targetPlayer].is_online>:
        - narrate "<[targetPlayer].name> has played for <[targetPlayer].flag[dUtils.totalPlayTime].if_null[<duration[0s]>].add[<[targetPlayer].flag[dUtils.temp.timeSinceJoinAfk].from_now.if_null[0]>].formatted_words>"
    - else:
        - narrate "<[targetPlayer].name> has played for <[targetPlayer].flag[dUtils.totalPlayTime].if_null[<duration[0s]>].formatted_words>"

dUtils_adjplaytime_command:
    type: command
    name: adjplaytime
    debug: false
    description: Does something
    usage: /adjplaytime <&lt>player<&gt> <&lt>set|add|remove<&gt> <&lt>unit:amount<&gt>
    tab completions:
        1: <proc[dutils_utils_visibleplayers].parse_tag[<[parse_value].name>]>
        2: add|remove|set
        default: "second:|hour:|day:|week:"
    permission: dutils.playtime.adjust
    script:
    # There needs to be at least 3 arguments
    - if <context.args.size> < 3:
        - narrate "<&c>Too few parameters specified."
        - stop
    # Get the specified player from the command
    - define targetPlayer <server.match_offline_player[<context.args.get[1]>].if_null[]>
    # Handle the case that the target player doesn't exist
    - if <[targetPlayer]> == <empty>:
        - narrate "<&c>Could not find specified player."
        - stop
    # Deal with all of the expected duration modifiers
    - define completeDuration <duration[0s]>
    - foreach <context.args.remove[1].to[2]> as:modifier:
        - define splitModifier <[modifier].split[:]>
        - if <[splitModifier].size> < 2 || <[splitModifier].get[2].is_decimal.not>:
            - narrate "<&c>Duration modifier '<[modifier]>' is malformed."
            - stop
        - choose <[splitModifier].get[1]>:
            - case s second seconds sec:
                - define completeDuration <[completeDuration].add[<[splitModifier].get[2]>s]>
            - case m minute minutes min:
                - define completeDuration <[completeDuration].add[<[splitModifier].get[2]>m]>
            - case h hour hours hr:
                - define completeDuration <[completeDuration].add[<[splitModifier].get[2]>h]>
            - case d day days:
                - define completeDuration <[completeDuration].add[<[splitModifier].get[2]>d]>
            - case w week weeks wk:
                - define completeDuration <[completeDuration].add[<[splitModifier].get[2].mul[7]>d]>
            - default:
                - narrate "<&c>Duration modifier '<[modifier]>' is malformed."
                - stop
    # Work through performing the change
    - choose <context.args.get[2]>:
        - case set:
            - flag <[targetPlayer]> dUtils.totalPlayTime:<[completeDuration]>
            - narrate "Set player <[targetPlayer].name> play time to <[completeDuration].formatted>"
        - case add:
            - flag <[targetPlayer]> dUtils.totalPlayTime:<[targetPlayer].flag[dUtils.totalPlayTime].add[<[completeDuration]>]>
            - narrate "Added <[completeDuration].formatted> of play time to player <[targetPlayer].name>"
        - case remove:
            - if <[completeDuration].is_more_than[<[targetPlayer].flag[dUtils.totalPlayTime]>]>:
                - flag <[targetPlayer]> dUtils.totalPlayTime:<duration[0s]>
                - narrate "Set player <[targetPlayer].name> play time to zero because input time was greater than total play time"
            - else:
                - flag <[targetPlayer]> dUtils.totalPlayTime:<[targetPlayer].flag[dUtils.totalPlayTime].sub[<[completeDuration]>]>
                - narrate "Reduced play time for player <[targetPlayer].name> by <[completeDuration].formatted>"
        - default:
            - narrate "<&c>Action '<context.args.get[2]>' is not valid."
