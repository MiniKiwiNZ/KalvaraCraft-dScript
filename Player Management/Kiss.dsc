dutils_kiss_cmd:
    type: command
    debug: false
    name: kiss
    description: Kiss the player standing in front of you
    usage: /kiss
    script:
    - if <player.target.advanced_matches[player].if_null[false]>:
        - actionbar "<&color[#FF1493]>You kissed <player.target.name>!"
        - actionbar "<&color[#FF1493]><player.name> kissed you!" targets:<player.target>
        - playeffect effect:heart at:<player.location.up[1.5].points_between[<player.target.location.up[1.5]>]> quantity:3 offset:0.5,0.5,0.5