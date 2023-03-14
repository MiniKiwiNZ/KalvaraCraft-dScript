dDoubleDoors_world:
    type: world
    events:
        on player right clicks vanilla_tagged:wooden_doors bukkit_priority:monitor:
        - choose <context.location.material.direction>:
            - case EAST WEST:
                - choose <context.location.material.hinge>:
                    - case RIGHT:
                        # Check that the door next to us has the hinge on the opposite side
                        - stop if:<context.location.forward.material.hinge.equals[RIGHT]>
                        # Check that the door next to us is facing the same way
                        - stop if:<context.location.forward.material.direction.equals[<context.location.material.direction>].not>
                        # Check that the door next to us is on the same Y level
                        - stop if:<context.location.forward.material.half.equals[<context.location.material.half>].not>
                        # Check that the door next to us has the same switched state
                        - stop if:<context.location.forward.material.switched.equals[<context.location.material.switched>].not>
                        # Switch the door next to us
                        - switch <context.location.forward>
                    - case LEFT:
                        - stop if:<context.location.backward.material.hinge.equals[LEFT]>
                        - stop if:<context.location.backward.material.direction.equals[<context.location.material.direction>].not>
                        - stop if:<context.location.backward.material.half.equals[<context.location.material.half>].not>
                        - stop if:<context.location.backward.material.switched.equals[<context.location.material.switched>].not>
                        - switch <context.location.backward>
            - case NORTH SOUTH:
                - choose <context.location.material.hinge>:
                    - case LEFT:
                        - stop if:<context.location.right.material.hinge.equals[LEFT]>
                        - stop if:<context.location.right.material.direction.equals[<context.location.material.direction>].not>
                        - stop if:<context.location.right.material.half.equals[<context.location.material.half>].not>
                        - stop if:<context.location.right.material.switched.equals[<context.location.material.switched>].not>
                        - switch <context.location.right>
                    - case RIGHT:
                        - stop if:<context.location.left.material.hinge.equals[RIGHT]>
                        - stop if:<context.location.left.material.direction.equals[<context.location.material.direction>].not>
                        - stop if:<context.location.left.material.half.equals[<context.location.material.half>].not>
                        - stop if:<context.location.left.material.switched.equals[<context.location.material.switched>].not>
                        - switch <context.location.left>
        on redstone recalculated:
        - if <context.location.material.advanced_matches[vanilla_tagged:doors].not>:
            - stop
        - define doorblocks <list>
        - choose <context.location.material.direction>:
            - case EAST WEST:
                - choose <context.location.material.hinge>:
                    - case RIGHT:
                        # Check that the door next to us has the hinge on the opposite side
                        - stop if:<context.location.forward.material.hinge.equals[RIGHT]>
                        # Check that the door next to us is facing the same way
                        - stop if:<context.location.forward.material.direction.equals[<context.location.material.direction>].not>
                        # Check that the door next to us is on the same Y level
                        - stop if:<context.location.forward.material.half.equals[<context.location.material.half>].not>
                        # Add all of the door blocks to the list
                        - define doorblocks:->:<context.location>
                        - define doorblocks:->:<context.location.forward>
                        - if <context.location.material.half> == TOP:
                            - define doorblocks:->:<context.location.below>
                            - define doorblocks:->:<context.location.forward.below>
                        - else:
                            - define doorblocks:->:<context.location.above>
                            - define doorblocks:->:<context.location.forward.above>
                    - case LEFT:
                        - stop if:<context.location.backward.material.hinge.equals[LEFT]>
                        - stop if:<context.location.backward.material.direction.equals[<context.location.material.direction>].not>
                        - stop if:<context.location.backward.material.half.equals[<context.location.material.half>].not>
                        - define doorblocks:->:<context.location>
                        - define doorblocks:->:<context.location.backward>
                        - if <context.location.material.half> == TOP:
                            - define doorblocks:->:<context.location.below>
                            - define doorblocks:->:<context.location.backward.below>
                        - else:
                            - define doorblocks:->:<context.location.above>
                            - define doorblocks:->:<context.location.backward.above>
            - case NORTH SOUTH:
                - choose <context.location.material.hinge>:
                    - case LEFT:
                        - stop if:<context.location.right.material.hinge.equals[LEFT]>
                        - stop if:<context.location.right.material.direction.equals[<context.location.material.direction>].not>
                        - stop if:<context.location.right.material.half.equals[<context.location.material.half>].not>
                        - define doorblocks:->:<context.location>
                        - define doorblocks:->:<context.location.right>
                        - if <context.location.material.half> == TOP:
                            - define doorblocks:->:<context.location.below>
                            - define doorblocks:->:<context.location.right.below>
                        - else:
                            - define doorblocks:->:<context.location.above>
                            - define doorblocks:->:<context.location.right.above>
                    - case RIGHT:
                        - stop if:<context.location.left.material.hinge.equals[RIGHT]>
                        - stop if:<context.location.left.material.direction.equals[<context.location.material.direction>].not>
                        - stop if:<context.location.left.material.half.equals[<context.location.material.half>].not>
                        - define doorblocks:->:<context.location>
                        - define doorblocks:->:<context.location.left>
                        - if <context.location.material.half> == TOP:
                            - define doorblocks:->:<context.location.below>
                            - define doorblocks:->:<context.location.left.below>
                        - else:
                            - define doorblocks:->:<context.location.above>
                            - define doorblocks:->:<context.location.left.above>
        - if <[doorblocks].parse[power].highest> > 0:
            - switch <[doorblocks].first[2]> state:on
            - determine <[doorblocks].parse[power].highest>
        - else:
            - switch <[doorblocks].first[2]> state:off