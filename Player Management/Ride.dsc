dutils_ride_cmd:
    type: command
    name: ride
    description: Ride the targeted entity
    usage: /ride
    permission: dutils.ride
    script:
    - if <player.target.exists> && <player.target.is_living>:
        # If the target already has a passenger, find the first entity in the chain without a passenger
        - define currentTarget <player.target>
        - while <[currentTarget].has_passenger>:
            - define currentTarget <[currentTarget].passenger>
        - mount <player>|<[currentTarget]>
        - if <player.target.is_player>:
            - actionbar "<green><player.name> is riding you! Do /shake to shake them off!" targets:<player.target>
        - actionbar "<green>You are riding <player.target.name>!"
    - else:
        - actionbar "<red>You must be looking at a rideable entity"

dutils_shake_cmd:
    type: command
    name: shake
    description: Shake your rider off
    usage: /shake
    permission: dscript.shake
    script:
    - if <player.has_passenger>:
        - mount cancel <player>|<player.passenger>