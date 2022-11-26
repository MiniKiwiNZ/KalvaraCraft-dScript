dutils_sit_world:
    type: world
    debug: false
    events:
        on player right clicks *_stairs|*_slab flagged:dUtils.sitEnabled:
        - stop if:<player.is_sneaking>
        - stop if:<player.item_in_hand.advanced_matches[air].not>
        - stop if:<player.item_in_offhand.advanced_matches[air].not>
        - if <context.location.material.advanced_matches[*_stairs]> && <context.location.material.half> != BOTTOM:
            - stop
        - if <context.location.material.advanced_matches[*_slab]> && <context.location.material.type> != BOTTOM:
            - stop
        - if <player.has_flag[dutils.sit]>:
            - mount <player>|armor_stand[is_small=true;gravity=false;marker=true;visible=false;flag_map=<map[sit=true]>] <context.location.center.with_yaw[<context.location.direction[<context.location.sub[<context.location.block_facing>]>].yaw>].down[0.2]>
            - flag <player> dutils.sit:!
        - else:
            - flag <player> dutils.sit expire:1s
        on player exits entity_flagged:sit:
        - teleport <player> <context.vehicle.location.above[0.5].forward[0.3]>
        - remove <context.vehicle>

dutils_sit_cmd:
    type: command
    debug: false
    name: sit
    description: Toggle the ability to sit
    usage: /sit
    script:
    - if <player.has_flag[dUtils.sitEnabled]>:
        - flag <player> dUtils.sitEnabled:!
        - narrate "Disabled sitting"
    - else:
        - flag <player> dUtils.sitEnabled
        - narrate "Enabled sitting"