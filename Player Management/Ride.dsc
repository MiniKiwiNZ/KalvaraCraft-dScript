##########################################
## dUtils:Ride                     v1.0 ##
## Created by MiniKiwiNZ                ##
## Made available under the MIT License ##
## Copyright 2023 MiniKiwiNZ            ##
##########################################
dutils_ride_cmd:
    type: command
    name: ride
    description: Ride the targeted entity
    usage: /ride
    permission: dutils.ride
    script:
    # This command can only be run by a player
    - if <context.source_type> != PLAYER:
        - narrate "<red>This command cannot be run from the console"
        - stop
    # Check that the executing player is looking at a living target
    - if <player.target.exists> && <player.target.is_living>:
        # If the target already has a passenger, find the first entity in the chain without a passenger
        - define currentTarget <player.target>
        - while <[currentTarget].has_passenger>:
            - define currentTarget <[currentTarget].passenger>
        # Mount the player to the target
        - mount <player>|<[currentTarget]>
        # If the entity mounted was a player, let the target player know
        - if <[currentTarget].is_player>:
            - actionbar "<green><player.name> is riding you! Do /shake to shake them off!" targets:<[currentTarget]>
        # Let the executing player know what they're riding
        - actionbar "<green>You are riding <[currentTarget].name>!"
    - else:
        # Player is not looking at a rideable mob
        - actionbar "<red>You must be looking at a rideable entity"

##########################################
## dUtils:Shake                    v1.0 ##
## Created by MiniKiwiNZ                ##
## Made available under the MIT License ##
## Copyright 2023 MiniKiwiNZ            ##
##########################################
dutils_shake_cmd:
    type: command
    name: shake
    description: Shake your rider off
    usage: /shake
    permission: dutils.shake
    script:
    # This command can only be run by a player
    - if <context.source_type> != PLAYER:
        - narrate "<red>This command cannot be run from the console"
        - stop
    # Unmount the riding entity if there is one
    - if <player.has_passenger>:
        - mount cancel <player>|<player.passenger>