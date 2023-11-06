##########################################
## dUtils:Patrol                   v1.0 ##
## Created by MiniMuleNZ                ##
## Made available under the MIT License ##
## Copyright 2022 MiniMuleNZ            ##
##########################################
dUtils_patrol_cmd:
    type: command
    name: patrol
    description: Cycle through all players to make sure they are behaving
    usage: /patrol
    permission: dutils.command.patrol
    script:
    # Find any online players that haven't been patrolled since they came online
    - define allEligible <server.online_players.filter_tag[<[filter_value].has_permission[dutils.patrol.exempt].not>]>
    # If noone eligible is online, don't do anything
    - if <[allEligible].size> == 0:
        - narrate "<&c>No patrollable players are currently online"
        - stop
    # Otherwise find anyone not patrolled since they logged on
    - define notPatrolled <[allEligible].filter_tag[<[filter_value].has_flag[dutils.temp.patrolled].not>]>
    # If there is someone who hasn't been patrolled, randomly select one
    - if <[notPatrolled].size> != 0:
        - define targetPlayer <[notPatrolled].random[1]>
        - narrate "Patrolling <[targetPlayer].name> (<[allEligible].size.sub[<[notPatrolled].size>]>/<[allEligible].size> patrolled)"
    # Otherwise, pick a random person from the all eligible list
    - else:
        - define targetPlayer <[allEligible].random[1]>
        - narrate "Patrolling <[targetPlayer].name> (last patrolled <[targetPlayer].flag[dutils.temp.patrolled].from_now.formatted>)"
    # Teleport the player
    - teleport <player> <[targetPlayer]>
    # Mark them as recently patrolled
    - flag <[targetPlayer]> dutils.temp.patrolled:<util.time_now>

dUtils_patrol_world:
    type: world
    events:
        ## When a player quits, clear the recently patrolled flag
        after player quit:
        - flag <player> dutils.temp.patrolled:!