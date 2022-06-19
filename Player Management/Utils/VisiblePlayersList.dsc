#############################################
## dUtils:Utils:VisiblePlayers        v1.0 ##
## Created by MiniMuleNZ                   ##
## Made available under the MIT License    ##
## Copyright 2022 MiniMuleNZ               ##
##                                         ##
## Get the list of players that the linked ##
##  player can see                         ##
#############################################
dutils_utils_visibleplayers:
    type: procedure
    debug: false
    script:
    - if <player.has_permission[essentials.vanish.see].if_null[true]>:
        - determine <server.online_players>
    - determine <server.online_players.filter_tag[<[filter_value].is_vanished.not>]>