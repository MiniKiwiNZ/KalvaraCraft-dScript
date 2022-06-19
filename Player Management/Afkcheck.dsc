##########################################
## dUtils:Afkcheck                 v1.0 ##
## Created by MiniMuleNZ                ##
## Made available under the MIT License ##
## Copyright 2022 MiniMuleNZ            ##
##########################################
dUtils_afkcheck_cmd:
    type: command
    name: afkcheck
    description: Check the afk status of players
    usage: /afkcheck [<&lt>name<&gt>]
    debug: false
    permission: dutils.afkcheck
    script:
    # If there aren't any players online, we can't do anything
    - if <server.online_players.size> == 0:
        - define message "<&c>There are no players online"
        - inject dutils_utils_commandfeedback
        - stop
    # If a target player was specified, select that specific player
    - if <context.args.size> > 0:
        - define targetPlayer <server.match_player[<context.args.get[1]>].if_null[]>
        # Break out if the specified player doesn't exist, or isn't online
        - if <[targetPlayer]> == <empty>:
            - define message "<&c>The specified player is not online"
        # If the player is AFK, tell the sender how long they've been AFK for
        - else if <[targetPlayer].is_afk>:
            - define message "<&f><[targetPlayer].name> has been afk for <[targetPlayer].flag[dutils.temp.afkstarted].from_now.formatted>"
        # Otherwise say that they're not AFK
        - else:
            - define message "<&f><[targetPlayer].name> is not AFK"
        # Send the stored message to the command sender
        - inject dutils_utils_commandfeedback
        - stop
    # If there wasn't a player, loop through the online players and check if any are online
    - define afk_player <proc[dutils_utils_visibleplayers].filter[is_afk]>
    # We still want to have some feedback even if noone was AFK
    - if <[afk_player].size> == 0:
        - define message "<&f>There are no AFK players online"
        - inject dutils_utils_commandfeedback
        - stop
    # For each AFK player, tell the sender how long they've been AFK
    - foreach <[afk_player]> as:targetPlayer:
        - define message "<&f><[targetPlayer].name> has been afk for <[targetPlayer].flag[dutils.temp.afkstarted].from_now.formatted>"
        - inject dutils_utils_commandfeedback

dUtils_afkcheck_world:
    type: world
    debug: false
    events:
        ## Track when the player goes AFK
        on player goes afk:
        - flag <player> dutils.temp.afkstarted:<util.time_now>
        ## Remove tracking when the player returns from AFK
        on player returns from afk:
        - flag <player> dutils.temp.afkstarted:!