##########################################
## dUtils:Invsee                   v1.0 ##
## Created by MiniMuleNZ                ##
## Made available under the MIT License ##
## Copyright 2022 MiniMuleNZ            ##
##########################################
dUtils_invsee_cmd:
    type: command
    name: invsee
    description: Does something
    usage: /invsee <&lt>player<&gt>
    permission: dutils.invsee
    tab completions:
        1: <proc[dutils_utils_visibleplayers].parse_tag[<[parse_value].name>]>
    script:
    - if <context.args.size> == 0:
        - narrate "<&c>Please specify a player to see"
        - stop
    - define targetPlayer <server.match_offline_player[<context.args.get[1]>].if_null[]>
    - if <[targetPlayer]> == <empty>:
        - narrate "<&c>Specified player not found"
        - stop
    - flag <player> dutils.temp.invseePlayer:<[targetPlayer]>
    - inventory open d:<proc[dUtils_invsee_helper_proc].context[<[targetPlayer]>|<player>]>
    - wait 1s
    - while <player.has_flag[dutils.temp.invseePlayer]>:
        - adjust <player.open_inventory> contents:<proc[dUtils_invsee_contents_proc].context[<[targetPlayer]>|<player>]>
        - wait 1s

##########################################
## dUtils:Enderchest               v1.0 ##
## Created by MiniMuleNZ                ##
## Made available under the MIT License ##
## Copyright 2022 MiniMuleNZ            ##
##########################################
dUtils_ec_cmd:
    debug: false
    type: command
    name: ec
    description: Open your enderchest, or another player's enderchest
    usage: /ec [<&lt>player<&gt>]
    permission: dutils.ec
    tab completions:
        1: <proc[dutils_utils_visibleplayers].parse_tag[<[parse_value].name>]>
    script:
    - if <context.source_type> != player:
        - narrate "<&c>This command must be used by a player"
        - stop
    - if <context.args.size> == 0 || <player.has_permission[dutils.ec.others].not>:
        - inventory open destination:<player.enderchest>
        - stop
    - define targetPlayer <server.match_offline_player[<context.args.get[1]>].if_null[]>
    - if <[targetPlayer]> == <empty>:
        - narrate "<&c>Specified player not found"
        - stop
    - inventory open destination:<[targetPlayer].enderchest>

dUtils_invsee_gui:
    type: inventory
    inventory: chest
    title: Inventory: PlayerName
    size: 54

dUtils_invsee_world:
    type: world
    data:
        # This map contains a source to destination map between the invsee GUI
        #  slots and the player inventory slots. The player hotbar is slot 1-9
        #  but then numbering goes to the top of the inventory so we have to
        #  disconnect them. Additionally, the armor slots map to a different slot
        #  again
        slot_map:
            1: HELMET
            2: CHESTPLATE
            10: LEGGINGS
            11: BOOTS
            19: 10
            20: 11
            21: 12
            22: 13
            23: 14
            24: 15
            25: 16
            26: 17
            27: 18
            28: 19
            29: 20
            30: 21
            31: 22
            32: 23
            33: 24
            34: 25
            35: 26
            36: 27
            37: 28
            38: 29
            39: 30
            40: 31
            41: 32
            42: 33
            43: 34
            44: 35
            45: 36
            46: 1
            47: 2
            48: 3
            49: 4
            50: 5
            51: 6
            52: 7
            53: 8
            54: 9
    events:
        ## Prevent players from taking GUI elements
        on player clicks item_flagged:action in dUtils_invsee_gui:
        - determine passively cancelled
        - stop if:<context.click.equals[LEFT].not>
        - choose <context.item.flag[action]>:
            - case teleport:
                - teleport <player> <player.flag[dutils.temp.invseePlayer].location>
            - case ender:
                - inventory open destination:<player.flag[dutils.temp.invseePlayer].enderchest>
        on player clicks item in dUtils_invsee_gui permission:dutils.invsee.modify:
        # Block the forbidden actions that are not controlled right now
        - determine cancelled if:<list[COLLECT_TO_CURSOR|DROP_ALL_SLOT|HOTBAR_SLOT].contains[<context.action>]>
        # Don't handle this event if the user clicked a GUI button
        - stop if:<context.item.has_flag[action]>
        # Don't handle this event if the user clicked in their own inventory
        - stop if:<context.raw_slot.is_more_than[54]>
        # Wait to break out of this tick
        - wait 1t
        # Update the source slot to the state of this slot
        - inventory set o:<context.inventory.slot[<context.slot>]> slot:<script.data_key[data.slot_map.<context.slot>]> d:<player.flag[dutils.temp.invseePlayer].inventory>



        ### If the player picks up the whole stack, 
        #on player clicks item in dUtils_invsee_gui action:PICKUP_ALL permission:dutils.invsee.modify:
        ## This handler isn't needed for items with an action
        #- stop if:<context.item.has_flag[action]>
        ## Our modification handler isn't required if the player clicked in their own inventory
        ## The top inventory contains slot 1->54 so we only need to watch those
        #- stop if:<context.raw_slot.is_more_than[54]>
        ## Take the stack of items from the source inventory
        #- inventory set o:air slot:<script.data_key[data.slot_map.<context.slot>]> d:<player.flag[dutils.temp.invseePlayer].inventory>
        #on player clicks item in dUtils_invsee_gui action:PLACE_ALL permission:dutils.invsee.modify:
        ## This handler isn't needed for items with an action
        #- stop if:<context.item.has_flag[action]>
        ## Our modification handler isn't required if the player clicked in their own inventory
        ## The top inventory contains slot 1->54 so we only need to watch those
        #- stop if:<context.raw_slot.is_more_than[54]>
        ## Place the stack of items in the source inventory
        #- inventory set o:<context.cursor_item> slot:<script.data_key[data.slot_map.<context.slot>]> d:<player.flag[dutils.temp.invseePlayer].inventory>
        ## Set the slot in the source inventory
        #on player clicks item in dUtils_invsee_gui action:COLLECT_TO_CURSOR|DROP_ALL_SLOT|HOTBAR_SWAP:
        #- determine cancelled



        on player drags in dUtils_invsee_gui:
        # Block the user from dragging to the armor slots
        - define armorslots 1|2|10|11
        - foreach <context.raw_slots> as:slot:
            - determine cancelled if:<[armorslots].contains[<[slot]>]>
        # Wait to break out of this tick
        - wait 1t
        # Update the source inventory
        - foreach <context.raw_slots> as:slot:
            - inventory set o:<context.inventory.slot[<[slot]>]> slot:<script.data_key[data.slot_map.<[slot]>]> d:<player.flag[dutils.temp.invseePlayer].inventory>
        on player clicks in dUtils_invsee_gui:
        - narrate "Slot: <context.slot> | Action: <context.action> | Raw Slot: <context.raw_slot>"
        on player closes dUtils_invsee_gui:
        - flag <player> dutils.temp.invseePlayer:!

# Build a CMI-esque invsee GUI for a target player
# The origin player is provided so that the correct permissions can
#  be tested
dUtils_invsee_helper_proc:
    type: procedure
    definitions: targetPlayer|originPlayer
    script:
    # Get the items for the inventory
    - define items <proc[dUtils_invsee_contents_proc].context[<[targetPlayer]>|<[originPlayer]>]>
    # Create a new instance of the inventory
    - define inv <inventory[dUtils_invsee_gui]>
    # Set the contents of the created inventory
    - adjust def:inv contents:<[items]>
    # Change the name of the created inventory
    - adjust def:inv "title:Inventory: <[targetPlayer].name>"
    # Send the inventory back to the caller
    - determine <[inv]>

dUtils_invsee_contents_proc:
    type: procedure
    definitions: targetPlayer|originPlayer
    script:
    # Define an empty list of items to start with
    - define items <list>
    # Get the equipment that the target player currently has equipped
    - define equipment <[targetPlayer].equipment>
    # The first two slots contain equipment
    - define items:->:<[equipment].get[4].if_null[air]>
    - define items:->:<[equipment].get[3].if_null[air]>
    # Not used yet
    - define items:->:air
    # Get some of the data items from another proc
    - define items:->:<proc[dUtils_invsee_component_proc].context[POTIONS|<[targetPlayer]>|<[originPlayer]>]>
    - define items:->:<proc[dUtils_invsee_component_proc].context[LOCATION|<[targetPlayer]>|<[originPlayer]>]>
    - define items:->:<proc[dUtils_invsee_component_proc].context[ENDERCHEST|<[targetPlayer]>|<[originPlayer]>]>
    # Placeholders for spacing and appearance
    - define items:->:gray_stained_glass_pane[flag=action:none]
    - define items:->:gray_stained_glass_pane[flag=action:none]
    - define items:->:gray_stained_glass_pane[flag=action:none]
    # The first two slots of the second row contain equipment
    - define items:->:<[equipment].get[2].if_null[air]>
    - define items:->:<[equipment].get[1].if_null[air]>
    # Not used yet
    - define items:->:air
    # More data from another proc
    - define items:->:<proc[dUtils_invsee_component_proc].context[PLAYERINFO|<[targetPlayer]>|<[originPlayer]>]>
    - define items:->:<proc[dUtils_invsee_component_proc].context[STATISTICS|<[targetPlayer]>|<[originPlayer]>]>
    # More placeholders for spacing and appearance
    - define items:->:gray_stained_glass_pane[flag=action:none]
    - define items:->:gray_stained_glass_pane[flag=action:none]
    - define items:->:gray_stained_glass_pane[flag=action:none]
    - define items:->:gray_stained_glass_pane[flag=action:none]
    # Slot 10 -> 36 are the main inventory of the player
    - repeat 27 from:10 as:slot:
        - define items:->:<[targetPlayer].inventory.slot[<[slot]>]>
    # Then put the hotbar items in the bottom row of the inventory
    - repeat 9 as:slot:
        - define items:->:<[targetPlayer].inventory.slot[<[slot]>]>
    - determine <[items]>

dUtils_invsee_component_proc:
    type: procedure
    definitions: component|targetPlayer|originPlayer
    script:
    - choose <[component]>:
        - case PLAYERINFO:
            - determine gray_stained_glass_pane[flag=action:none] if:<[originPlayer].has_permission[dutils.invsee.general].not>
            - define responseItem "<item[book[display=<&8>General Information]]>"
            - define lore <list>
            - define "lore:->:<&2>Health: <&6><[targetPlayer].health>/<[targetPlayer].health_max>"
            - define "lore:->:<&2>Hunger: <&6><tern[<[targetPlayer].is_online>].pass[<[targetPlayer].food_level>].fail[<&8>Player offline]>"
            - define "lore:->:<&2>Saturation: <&6><[targetPlayer].saturation>"
            - define "lore:->:<&2>Level: <&6><tern[<[targetPlayer].is_online>].pass[<[targetPlayer].xp_level>].fail[<&8>Player offline]>"
            - define "lore:->:<&2>GameMode: <&6><[targetPlayer].gamemode.to_sentence_case>"
            - define "lore:->:<&2>Flying: <tern[<[targetPlayer].is_flying>].pass[<&a>Enabled].fail[<&c>Disabled]>"
            - adjust def:responseItem lore:<[lore]>
            - adjust def:responseItem flag:action:none
            - determine <[responseItem]>
        - case STATISTICS:
            - determine gray_stained_glass_pane[flag=action:none] if:<[originPlayer].has_permission[dutils.invsee.statistics].not>
            - define responseItem <item[book[display=<&8>Statistics]]>
            - define lore <list>
            - define "lore:->:<&e>**************** UUID ****************"
            - define lore:->:<&6><[targetPlayer].uuid>
            - define "lore:->:<&2>First Joined: <&6><[targetPlayer].first_played_time.format>"
            - if <script[dUtils_playtime_world].exists>:
                - define "lore:->:<&2>Playtime: <&6><[targetPlayer].flag[dUtils.totalPlayTime].if_null[<duration[0s]>].formatted>"
            - else:
                - define "lore:->:<&2>Playtime: <&7>Not available"
                - define "lore:->:<&7><&o>Requires playtime module installed"
            - adjust def:responseItem lore:<[lore]>
            - adjust def:responseItem flag:action:none
            - determine <[responseItem]>
        - case LOCATION:
            - determine gray_stained_glass_pane[flag=action:none] if:<[originPlayer].has_permission[dutils.invsee.location].not>
            - define responseItem "<item[map[display=<&8>Player Location]]>"
            - define lore <list>
            - define "lore:->:<&2>World: <&6><[targetPlayer].location.world.name>"
            - define "lore:->:<&2>X: <&6><[targetPlayer].location.x.round_to[2]>"
            - define "lore:->:<&2>Y: <&6><[targetPlayer].location.y.round_to[2]>"
            - define "lore:->:<&2>Z: <&6><[targetPlayer].location.z.round_to[2]>"
            - define "lore:->:<&2>Pitch: <&6><[targetPlayer].location.pitch.round_to[6]>"
            - define "lore:->:<&2>Yaw: <&6><[targetPlayer].location.yaw.round_to[6]>"
            - if <[originPlayer].has_permission[dutils.invsee.teleport]>:
                - adjust def:responseItem flag:action:teleport
                - define lore:->:<empty>
                - define "lore:->:<&7>[Left click to teleport]"
            - else:
                - adjust def:responseItem flag:action:none
            - adjust def:responseItem lore:<[lore]>
            - determine <[responseItem]>
        - case POTIONS:
            - determine gray_stained_glass_pane[flag=action:none] if:<[originPlayer].has_permission[dutils.invsee.potions].not>
            - define responseItem "<item[potion[color=#FFC0CB;display=<&8>Potion Effects;hides=ALL]]>"
            - define lore <list>
            - if <[targetPlayer].effects_data.length> > 0:
                - foreach <[targetPlayer].effects_data>:
                    - define "lore:->:<&9>- <&6><[value].get[type]> <&9>(<&6><[value].get[amplifier].add[1]><&9>) - <&6><[value].get[duration].formatted>"
            - else:
                - define "lore:->:<&5>No Effects"
            - adjust def:responseItem flag:action:none
            - adjust def:responseItem lore:<[lore]>
            - determine <[responseItem]>
        - case ENDERCHEST:
            - determine gray_stained_glass_pane[flag=action:none] if:<[originPlayer].has_permission[dutils.invsee.ender].not>
            - define responseItem "ender_chest[flag=action:ender;display=<&f><[targetPlayer].name>'s Enderchest;lore=|<&7>[Left click to open]]"
            - determine <[responseItem]>