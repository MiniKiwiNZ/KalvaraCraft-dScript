dUtils_friends_command:
  type: command
  name: friend
  usage: /friend <&lt>action<&gt> [<&lt>arguments<&gt>]
  description: Manage player friends
  data:
    syntax:
    - <white>[<gold><bold>Friends<white>] ⇒ <bold>Command Help
    - <green>▎ <red>Syntax: <italic>/friend <&lt>action<&gt> <&lt>player<&gt>
    - <green>▎ <bold>Actions<&co>
    - <green>▎  <white>- add: <italic>Add a player as a friend
    - <green>▎  <white>- remove: <italic>Unfriend a player
    - <green>▎  <white>- block: <italic>Block or unblock a player's friend requests
    - <green>▎  <white>- upgrade: <italic>Unlock new friendship perks
    - <green>▎  <white>- gift: <italic>Send the item in your hand to a friend
    syntax_restricted:
      dUtils.friends.admin:
      - <green>▎ <bold>Admin Commands<&co>
      dUtils.friends.admin.block:
      - <green>▎  <white>/friend adminblock <&lt>player-1<&gt> <&lt>player-2<&gt>
      - <green>▎    <white><italic>Force the specified players to block each other
    player_argument:
    - <white>[<gold><bold>Friends<white>] ⇒ <red><&dq>%command%<&dq> requires second argument to be a valid player name
    injects:
      syntax:
      - narrate <script.parsed_key[data.syntax].separated_by[<n>]>
      #- foreach <script.parsed_key[data.syntax_restricted]>:
      #  - if <player.has_permission[<[key]>]>:
      #    - narrate <[value].separated_by[<n>]>
  aliases:
  - friends
  tab complete:
  # Define an initial reult list
  - define result <list>
  # Determine which argument we are checking for
  - choose "<tern[<context.raw_args.ends_with[ ]>].pass[<context.args.size.add[1]>].fail[<context.args.size.max[1]>]>":
    - case 1:
      # The first argument is the action which must be one of the following: add|remove|block|upgrade|send
      - define result <list[add|remove|block|upgrade|gift].filter[contains[<context.args.get[1].if_null[]>]]>
    - case 2:
      - if <context.args.get[1].is_in[add]>:
        # In these cases, complete with the names of online players that aren't friends
        - define result <proc[dutils_utils_visibleplayers].filter_tag[<player.flag[dFriends.friends].get[<[filter_value].uuid>].is_truthy.not>]>
      - else if <context.args.get[1].is_in[remove|upgrade|send]>:
        # In these cases, complete with the names of friends regardless of online state
        - define result <player.flag[dFriends.friends].keys.parse_tag[<[parse_value].as[player].name>].alphanumeric>
  # Filter out any strings that don't match the current input
  - determine <[result].filter_tag[<[filter_value].contains[<context.args.last>]>]>
  script:
  # If there are two or more arguments, attempt to turn the second one into a player
  - if <context.args.size> >= 2:
    - define target <server.match_player[<context.args.get[2]>]||server.match_offline_player[<context.args.get[2]>]||empty>
  # If there are less than two arguments, show the help
  - if <context.args.size> < 2 || !<[target]>:
    - inject path:data.injects.syntax
    - stop
  # If the second argument is not a valid player, and the command requires a player, return an error
  - if <context.args.get[1].is_in[add|remove|block|upgrade|gift]> && <[target]> == <empty>:
    - narrate <script.parsed_key[data.player_argument].separated_by[<n>].replace[%command%].with[<context.args.get[1]>]>
    - stop
  # Enter subcommand specific handling
  - choose <context.args.get[1]>:
    - case add:
      # Trigger the add friend task
      - run dUtils_friends_task_add <player>|<[target]>
    - case remove:
      # Trigger the remove friend task
      - run dUtils_friends_task_remove <player>|<[target]>
    - case block:
      # Trigger the block task
      - run dUtils_friends_task_block <player>|<[target]>
    - case gift:
      # Trigger the gift task
      - run dUtils_friends_task_gift <player>|<[target]>

#####################################################
## Process a friend request being sent to a player ##
##                                                 ##
## Params:                                         ##
##  - from: The player sending the request         ##
##  - to: The player receiving the request         ##
#####################################################
dUtils_friends_task_add:
  type: task
  definitions: from|to
  data:
    already_friends:
    - <white>[<gold><bold>Friends<white>] ⇒ <red>You are already friends with %player%!
    pending_request:
    - <white>[<gold><bold>Friends<white>] ⇒ <red>You have already sent a friend request to %player%! Please wait until they accept it, or the invitation expires
    recipient_blocked:
    - <white>[<gold><bold>Friends<white>] ⇒ <red>You cannot send %player% a friend request because you have blocked them!
    now_friends:
    - <white>[<gold><bold>Friends<white>] ⇒ <green>You are now friends with %player%!
    request_accepted:
    - <white>[<gold><bold>Friends<white>] ⇒ <green>%player% accepted your friend request!
    request_sent:
    - <white>[<gold><bold>Friends<white>] ⇒ You have sent %player% a friend request. We'll let you know when they accept it!
  script:
  # Ensure the players are not already friends
  - if <[from].has_flag[dFriends.requests.<[to].uuid>]>:
    - narrate <script.parsed_key[data.already_friends].separated_by[<n>].replace[%player].with[<[to].name>]>
    - stop
  # Ensure the sender has not blocked the recipient
  - if <[from].has_flag[dFriends.blocked.<[to].uuid>]>:
    - narrate <script.parsed_key[data.recipient_blocked].separated_by[<n>].replace[%player%].with[<[to].name>]>
    - stop
  # Ensure the recipient doesn't already have a pending friend request from the sender
  - if <[to].has_flag[dFriends.requests.<[from].uuid>]>:
    - narrate <script.parsed_key[data.pending_request].separated_by[<n>].replace[%player%].with[<[to].name>]>
    - stop
  # If the sender already has a friend request from the recipient, accept it
  - if <[from].has_flag[dFriends.requests.<[to].uuid>]>:
    - define startTime:<util.time_now>
    - flag <[from]> dFriends.friends.<[to].uuid>:<[startTime]>
    - flag <[to]> dFriends.friends.<[from].uuid>:<[startTime]>
    - flag <[from]> dFriends.requests.<[to].uuid>:!
    # Let the current sender know they are now friends
    - narrate <script.parsed_key[data.now_friends].separated_by[<n>].replace[%player%].with[<[to].name>]>
    # If the other player is online, let them know, otherwise queue the notification for when they come online
    - if <[to].is_online>:
      - narrate <script.parsed_key[data.request_accepted].separated_by[<n>].replace[%player%].with[<[from].name>]> targets:<[to]>
    - else:
      - flag <[to]> dFriends.notifications:->:<script.parsed_key[data.request_accepted].separated_by[<n>].replace[%player%].with[<[from].name>]>
    - stop
  # Otherwise, add a friend request to the specified player
  - flag <[to]> dFriends.requests.<[from].uuid> expire:7d
  - narrate <script.parsed_key[data.request_sent].separated_by[<n>].replace[%player%].with[<[to].name>]>

#####################################################
## Process a player being unfriended by another    ##
##                                                 ##
## Params:                                         ##
##  - executor: The player sending the request     ##
##  - target: The player being unfriended          ##
##  - suppress: Whether to suppress the messages   ##
##      that would normally be sent by this task   ##
##      (optional, defaults to false)              ##
#####################################################
dUtils_friends_task_remove:
  type: task
  definitions: executor|target|suppress
  data:
    not_friends:
    - <white>[<gold><bold>Friends<white>] ⇒ <red>%player% is not your friend so you can't unfriend them.
    unfriended:
    - <white>[<gold><bold>Friends<white>] ⇒ You are no longer friends with %player%
  script:
  # Ensure that the players are currently friends
  - if !<[executor].has_flag[dFriends.friends.<[target].uuid>]>:
    - narrate <script.parsed_key[data.not_friends].separated_by[<n>].replace[%player%].with[<[target].name>]> if:<[suppress].if_null[false].not>
    - stop
  # Remove the player as a friend
  - flag <[executor]> dFriends.friends.<[target].uuid>:!
  - flag <[target]> dFriends.friends.<[executor].uuid>:!
  - narrate <script.parsed_key[data.unfriended].separated_by[<n>].replace[%player%].with[<[target].name>]> if:<[suppress].if_null[false].not>

#####################################################
## Process a player being blocked or unblocked     ##
##                                                 ##
## Params:                                         ##
##  - executor: The player sending the request     ##
##  - target: The player being targetted           ##
#####################################################
dUtils_friends_task_block:
  type: task
  definitions: executor|target|staff
  data:
    player_blocked:
    - <white>[<gold><bold>Friends<white>] ⇒ You have blocked %player%
    player_unblocked:
    - <white>[<gold><bold>Friends<white>] ⇒ %player% is no longer blocked
    #cannot_unblock:
    #- <white>[<gold><bold>Friends<white>] ⇒ <red>You cannot unblock %player%: %reason%
  script:
  # Check whether the target player is currently blocked
  - if <[executor].has_flag[dFriends.blocked.<[target].uuid>]>:
    # Check if the block is staff enforced, and if so, deny it
    #- if <[executor].flag[dFriends.adminblocked.<[target].uuid>]>:
    #  - narrate <script.parsed_key[data.cannot_unblock].separated_by[<n>]>
    #  - stop
    # Otherwise remove the block
    - flag <[executor]> dFriends.blocked.<[target].uuid>:!
    - narrate <script.parsed_key[data.player_unblocked].separated_by[<n>].replace[%player%].with[<[target].name>]>
    - stop
  # Check if the blocking player has an outstanding friend request to the player they're blocking and remove it
  - if <[target].has_flag[dFriends.requests.<[executor].uuid>]>:
    - flag <[target]> dFriends.requests.<[executor].uuid>:!
  # Otherwise block the player
  - flag <[executor]> dFriends.blocked.<[target].uuid>:false
  - flag <[executor]> dFriends.friends.<[target].uuid>:!
  - flag <[target]> dFriends.friends.<[executor].uuid>:!
  - narrate <script.parsed_key[data.player_blocked].separated_by[<n>].replace[%player%].with[<[target].name>]>

#####################################################
## Process a player gifting an item to a friend    ##
##                                                 ##
## Params:                                         ##
##  - executor: The player sending the item        ##
##  - target: The player receiving the item        ##
#####################################################
dUtils_friends_task_gift:
  type: procedure
  definitions: executor|target
  data:
    not_friends:
    - <white>[<gold><bold>Friends<white>] ⇒ <red>%player% is not your friend so you can't send them gifts.
    already_gifted:
    - <white>[<gold><bold>Friends<white>] ⇒ <red>%player% already has a gift waiting from you.
    empty_hand:
    - <white>[<gold><bold>Friends<white>] ⇒ <red>You must be holding an item to send.
    not_sendable:
    - <white>[<gold><bold>Friends<white>] ⇒ <red>This item can not be sent through the friend system.
    sent:
    - <white>[<gold><bold>Friends<white>] ⇒ Sent %item% to %player%.
  script:
  # If the players aren't friends, they can't send gifts
  - if !<[executor].has_flag[dFriends.friends.<[target].uuid>]>:
    - narrate <script.parsed_key[data.not_friends].separated_by[<n>].replace[%player%].with[<[target].name>]>
    - stop
  # If there is already a gift waiting, cancel out
  - if <[target].has_flag[dFriends.gifts.<[executor].uuid>]>:
    - narrate <script.parsed_key[data.already_gifted].separated_by[<n>].replace[%player%].with[<[target].name>]>
    - stop
  # If the player has an empty hand, cancel out
  - if !<[target].item_in_hand>:
    - narrate <script.parsed_key[data.empty_hand].separated_by[<n>]>
    - stop
  # Otherwise, send the item
  - define sentitem <[executor].item_in_hand>
  - flag <[target]> dFriends.gifts.<[executor].uuid>:<[sentitem]>
  - take iteminhand
  - define itemtext "<&hover[<[sentitem]>]><[sentitem].display||[sentitem].material.translated_name><&end_hover> x<[sentitem].quantity>"
  - narrate <script.parsed_key[data.sent].separated_by[<n>].replace[%player%].with[<[target].name>].replace[%item%].with[<[itemtext]>]>

dUtils_friends_task_requests:
  type: procedure
  definitions: player|page
  data:
    no_requests:
    - <white>[<gold><bold>Friends<white>] ⇒ <red>You have no friend requests outstanding.
    header:
    - <white>[<gold><bold>Friends<white>] ⇒ Friend requests
  script:
  # If the player has no friend requests, tell them
  - if !<[player].has_flag[dFriends.requests]> || !<[player].flag[dFriends.requests].size>:
    - narrate <script.parsed_key[data.no_requests].separated_by[<n>]>
    - stop
  # Otherwise, figure out how many pages there are in total
  - define pages <[player].flag[dFriends.requests].size.div[10].round_up>