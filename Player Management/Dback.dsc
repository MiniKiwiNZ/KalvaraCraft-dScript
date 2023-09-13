##########################################
## dUtils:Dback                    v1.0 ##
## Created by MiniMuleNZ                ##
## Made available under the MIT License ##
## Copyright 2022 MiniMuleNZ            ##
##########################################
dUtils_dback_cmd:
    type: command
    data:
        warmup: 3
        cooldown: 60
    name: dback
    description: Return to the last place you died
    usage: /dback
    permission: dutils.command.dback
    script:
    # Exit if this wasn't executed by a player
    - if <context.source_type> != PLAYER:
        - announce to_console "<&c>This command must be run by a player"
        - stop
    # Exit if the player has no last death location
    - if <player.has_flag[dutils.dback.location].not>:
        - narrate "<&c>You have no previous death location to return to"
        - stop
    # Exit if the command is still on cooldown for this player and they don't have bypass
    - if <player.has_flag[dutils.dback.cooldown]> && <player.has_permission[dutils.dback.bypass.cooldown].not>:
    #- if <player.has_flag[dutils.dback.cooldown]>:
        - narrate "<&c>This command is on cooldown for <player.flag_expiration[dutils.dback.cooldown].from_now.formatted>"
        - stop
    # If there is a warmup, handle it unless the player has bypass
    - if <script.data_key[data.warmup].is_more_than[0]> && <player.has_permission[dutils.dback.bypass.warmup].not>:
    #- if <script.data_key[data.warmup].is_more_than[0]>:
        - flag <player> dutils.temp.dbacking
        # Track the current position of the player to cancel if they move
        - define startLocation <player.location.with_pose[0|0]>
        - title "title:<&f>Hold Still!" "subtitle:<&7>Transport in <script.data_key[data.warmup]> seconds"
        # Update the counter each second
        - repeat <script.data_key[data.warmup]>:
            - wait 1s
            - if <player.location.with_pose[0|0]> != <[startLocation]> || <player.has_flag[dutils.temp.dbacking].not>:
                - title "title:<&c>Teleport Cancelled" "subtitle:<&7>Stay still during teleport warmup!"
                - stop
            - title "title:<&f>Hold Still!" "subtitle:<&7>Transport in <script.data_key[data.warmup].sub[<[value]>]> seconds" fade_in:0 if:<[value].equals[<script.data_key[data.warmup]>].not>
        - title title:<empty>
    # If there is a cooldown, handle it
    - if <script.data_key[data.cooldown].is_more_than[0]>:
        - flag <player> dutils.dback.cooldown expire:<script.data_key[data.cooldown]>s
    # Teleport the player
    - teleport <player> <player.flag[dutils.dback.location]>

dUtils_dback_world:
    type: world
    events:
        # Manage when players jump during the warmup
        after player jumps flagged:dutils.temp.dbacking:
        - flag <player> dutils.temp.dbacking:!
        # Track where players die
        after player dies:
        - flag <player> dutils.dback.location:<player.location>