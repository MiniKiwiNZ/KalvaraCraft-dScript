##########################################
## dUtils:Seen                     v1.0 ##
## Created by MiniMuleNZ                ##
## Made available under the MIT License ##
## Copyright 2022 MiniMuleNZ            ##
##########################################

dUtils_seen_command:
    type: command
    debug: false
    name: seen
    description: Show when a player was last seen, or how long an online player has been online
    usage: /seen [<&lt>player<&gt>]
    permission: dutils.command.seen
    script:
    # If there are no arguments, or the user doesn't have permission to view others seen time, show their own
    - if <context.source_type> == player && ( <context.args.size> == 0 || <player.has_permission[dutils.command.seen.others].not> ):
        - narrate "You have been online for <player.flag[dUtils.lastSeenTime].from_now.formatted_words>"
        - stop
    # Otherwise find the player requested
    - define targetPlayer <server.match_offline_player[<context.args.get[1]>].if_null[]> if:<context.args.size.is_more_than[0]>
    - if <[targetPlayer].equals[<empty>].if_null[true]>:
        - narrate "<&c>Could not find specified player."
        - stop
    # If the player is online, we show how long they've been online, otherwise how long they've been offline
    - if <[targetPlayer].is_online>:
        - narrate "<[targetPlayer].name> has been online for <[targetPlayer].flag[dUtils.lastSeenTime].if_null[<util.time_now>].from_now.formatted_words>"
    - else:
        - narrate "<[targetPlayer].name> has been offline for <[targetPlayer].flag[dUtils.lastSeenTime].if_null[<util.time_now>].from_now.formatted_words>"

dUtils_seen_world:
    type: world
    events:
        ## Mark when players join so that /seen will show how long they've been online
        on player joins:
        - flag <player> dUtils.lastSeenTime:<util.time_now>
        ## Mark when players leave so that /seen will show when they last disconnected
        on player quits:
        - flag <player> dUtils.lastSeenTime:<util.time_now>