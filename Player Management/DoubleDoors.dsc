##########################################
## dUtils:DoubleDoors              v1.0 ##
## Created by MiniKiwiNZ                ##
## Made available under the MIT License ##
## Copyright 2023 MiniKiwiNZ            ##
##########################################
dDoubleDoors_world:
    type: world
    debug: false
    events:
        on player right clicks vanilla_tagged:wooden_doors bukkit_priority:monitor:
        # Find where the other door *should* be based on the position of this one
        - choose <context.location.material.direction>:
            - case EAST WEST:
                - choose <context.location.material.hinge>:
                    - case RIGHT:
                        - define other_door <tern[<context.location.material.direction.equals[WEST]>].pass[<context.location.forward>].fail[<context.location.backward>]>
                    - case LEFT:
                        - define other_door <tern[<context.location.material.direction.equals[EAST]>].pass[<context.location.forward>].fail[<context.location.backward>]>
            - case NORTH SOUTH:
                - choose <context.location.material.hinge>:
                    - case LEFT:
                        - define other_door <tern[<context.location.material.direction.equals[NORTH]>].pass[<context.location.left>].fail[<context.location.right>]>
                    - case RIGHT:
                        - define other_door <tern[<context.location.material.direction.equals[SOUTH]>].pass[<context.location.left>].fail[<context.location.right>]>
        # Check that the other "door" is actually in fact a door
        - stop if:<[other_door].material.advanced_matches[vanilla_tagged:doors].not>
        # Check that the door next to us has the hinge on the opposite side
        - stop if:<[other_door].material.hinge.equals[<context.location.material.hinge>]>
        # Check that the door next to us is facing the same way
        - stop if:<[other_door].material.direction.equals[<context.location.material.direction>].not>
        # Check that the door next to us is on the same Y level
        - stop if:<[other_door].material.half.equals[<context.location.material.half>].not>
        # Check that the door next to us has the same switched state and isn't out of sync
        - stop if:<[other_door].material.switched.equals[<context.location.material.switched>].not>
        # Switch the door next to us
        - switch <[other_door]>
        on redstone recalculated:
        # We only want to know if a door was affected
        - if <context.location.material.advanced_matches[vanilla_tagged:doors].not>:
            - stop
        # We're going to switch every door block involved
        - define doorblocks <list>
        # Find where the other door *should* be based on the position of this one
        - choose <context.location.material.direction>:
            - case EAST WEST:
                - choose <context.location.material.hinge>:
                    - case RIGHT:
                        - define other_door <tern[<context.location.material.direction.equals[WEST]>].pass[<context.location.forward>].fail[<context.location.backward>]>
                    - case LEFT:
                        - define other_door <tern[<context.location.material.direction.equals[EAST]>].pass[<context.location.forward>].fail[<context.location.backward>]>
            - case NORTH SOUTH:
                - choose <context.location.material.hinge>:
                    - case LEFT:
                        - define other_door <tern[<context.location.material.direction.equals[NORTH]>].pass[<context.location.left>].fail[<context.location.right>]>
                    - case RIGHT:
                        - define other_door <tern[<context.location.material.direction.equals[SOUTH]>].pass[<context.location.left>].fail[<context.location.right>]>
        # Check that the other door is actually in fact a door
        - stop if:<[other_door].material.advanced_matches[vanilla_tagged:doors].not>
        # Check that the door next to us has the hinge on the opposite side
        - stop if:<[other_door].material.hinge.equals[<context.location.material.hinge>]>
        # Check that the door next to us is facing the same way
        - stop if:<[other_door].material.direction.equals[<context.location.material.direction>].not>
        # Check that the door next to us is on the same Y level
        - stop if:<[other_door].material.half.equals[<context.location.material.half>].not>
        # Add all of the door blocks to the list
        - define doorblocks:->:<context.location>
        - define doorblocks:->:<[other_door]>
        - if <context.location.material.half> == TOP:
            - define doorblocks:->:<context.location.below>
            - define doorblocks:->:<[other_door].below>
        - else:
            - define doorblocks:->:<context.location.above>
            - define doorblocks:->:<[other_door].above>
        # If any of the door blocks are receiving a redstone signal, switch them all on
        - if <[doorblocks].parse[power].highest> > 0:
            - switch <[doorblocks].first[2]> state:on
            - determine <[doorblocks].parse[power].highest>
        - else:
            - switch <[doorblocks].first[2]> state:off