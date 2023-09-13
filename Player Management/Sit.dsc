##########################################
## dUtils:Sit                      v1.0 ##
## Created by MiniKiwiNZ                ##
## Made available under the MIT License ##
## Copyright 2023 MiniKiwiNZ            ##
##########################################
dutils_sit_cmd:
    type: command
    debug: false
    name: sit
    description: Toggle the ability to sit
    permission: dutils.command.sit
    usage: /sit
    script:
    # Toggle the sitting flag
    - if <player.has_flag[dUtils.sitEnabled]>:
        - flag <player> dUtils.sitEnabled:!
        - narrate "Disabled sitting"
    - else:
        - flag <player> dUtils.sitEnabled
        - narrate "Enabled sitting"

dutils_sit_world:
    type: world
    debug: false
    events:
        ## Handle players attempting to sit
        on player right clicks *_stairs|*_slab flagged:dUtils.sitEnabled:
        # Don't sit if the player is sneaking
        - stop if:<player.is_sneaking>
        # Don't sit if the player was holding something in either hand
        - stop if:<player.item_in_hand.advanced_matches[air].not>
        - stop if:<player.item_in_offhand.advanced_matches[air].not>
        # Stairs use the "half" property, slabs use "type". Either way it must be "bottom" to continue
        - if <context.location.material.advanced_matches[*_stairs]> && <context.location.material.half> != BOTTOM:
            - stop
        - if <context.location.material.advanced_matches[*_slab]> && <context.location.material.type> != BOTTOM:
            - stop
        # If the player has clicked to sit twice within a second, sit them down
        - if <player.has_flag[dutils.sit]>:
            # Stairs are directional, so we should have added handling to ensure the armor stand faces the right way
            - if <context.location.material.advanced_matches[*_stairs]>:
                - mount <player>|armor_stand[is_small=true;gravity=false;marker=true;visible=false;flag_map=<map[sit=true]>] <context.location.center.with_yaw[<context.location.direction[<context.location.sub[<context.location.block_facing>]>].yaw>].down[0.2]>
            - else:
                - mount <player>|armor_stand[is_small=true;gravity=false;marker=true;visible=false;flag_map=<map[sit=true]>] <context.location.center>
            - flag <player> dutils.sit:!
        - else:
            # Mark the player as beginning to sit
            - flag <player> dutils.sit expire:1s
        ## Handle players leaving their sit entity
        on player exits entity_flagged:sit:
        # The teleport ensures that players do not get stuck inside the block they're sitting on
        - teleport <player> <context.vehicle.location.above[0.5].forward[0.3]>
        # Remove the armor stand that the player was mounted to
        - remove <context.vehicle>