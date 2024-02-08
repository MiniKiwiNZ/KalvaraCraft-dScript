dbarrel_common_world:
  type: world
  debug: false
  events:
######################
## Set up of barrel in a location
######################
    after player places dbarrel_item_*:
    # Set some defaults, and copy the barrel data to the block
    - flag <context.location> barrel.count:0
    - flag <context.location> barrel.script:<context.item_in_hand.script>
    # Create entities to hold the material, name, and quantity
    - define central <context.location.center.with_facing_direction>
    # The specific positioning prevents oddities in the shading of 3d items
    - spawn item_display[item=air;scale=0.3,0.3,0.001] <[central].forward[0.501].up[0.25]> save:item
    - spawn item_display[item=<context.item_in_hand.script.data_key[data.icon]>;scale=0.14,0.14,0.001] <[central].forward[0.501].up[0.42].right[0.42]> save:icon
    - spawn text_display[display=center;scale=0.5,0.5,0.5] <[central].forward[0.51].down[0.15]> save:name
    - spawn text_display[display=center;scale=0.7,0.7,0.7] <[central].forward[0.51].down[0.4]> save:qty
    - flag <context.location> barrel.entities.item:<entry[item].spawned_entity>
    - flag <context.location> barrel.entities.icon:<entry[icon].spawned_entity>
    - flag <context.location> barrel.entities.name:<entry[name].spawned_entity>
    - flag <context.location> barrel.entities.qty:<entry[qty].spawned_entity>
    # Check whether the barrel has any items in it already and insert that data
    - if <context.item_in_hand.has_flag[barrel]>:
      - flag <context.location> barrel.count:<context.item_in_hand.flag[barrel.count]>
      - flag <context.location> barrel.item:<context.item_in_hand.flag[barrel.item]>
      - define max_stacks <context.item_in_hand.script.data_key[data.stacks]>
      - flag <context.location> barrel.max_count:<context.location.flag[barrel.item].max_stack.mul[<[max_stacks]>]>
      - run barrel_update_tick def:<context.location>
######################
## Build the item to be dropped from a barrel
######################
    on player breaks barrel location_flagged:barrel:
    # If the barrel isn't empty, store its content
    - define response_item:<context.location.flag[barrel.script].name.as[item]>
    - if <context.location.flag[barrel.count]> > 0:
      - adjust def:response_item flag:barrel.count:<context.location.flag[barrel.count]>
      - adjust def:response_item flag:barrel.item:<context.location.flag[barrel.item]>
      - adjust def:response_item lore:<[response_item].lore.include[<empty>|<white><bold>Contents<&co>|<dark_purple><italic><context.location.flag[barrel.item].display.if_null[<context.location.flag[barrel.item].material.name.replace[_].with[ ].to_titlecase>]> x<context.location.flag[barrel.count]>]>
    - determine <[response_item]>
######################
## Clean up of location flags after barrel is broken
######################
    after player breaks barrel location_flagged:barrel:
    # Clean up the flags on the location, as well as the display entities
    - remove <context.location.flag[barrel.entities].values>
    - flag <context.location> barrel:!
######################
## Player right clicking handles inserting items into the barrel
######################
    on player right clicks barrel location_flagged:barrel:
    # Don't do anything if the player is sneaking
    - if <player.is_sneaking>:
      - stop
    - determine passively cancelled
    - ratelimit <player> 1t
    # If there isn't an item currently in the barrel
    - if !<context.location.has_flag[barrel.item]>:
      # And the player has an item in their main hand
      - if <player.item_in_hand.advanced_matches[air]>:
        - stop
      # And the item isn't a barrel with stuff in it
      - if <player.item_in_hand.has_flag[barrel]>:
        - stop
      # Allow storage of the item - update the icon, text, and quantity
      - flag <context.location> barrel.item:<player.item_in_hand.with[quantity=1]>
      - flag <context.location> barrel.count:+:<player.item_in_hand.quantity>
      - define max_stacks <context.location.flag[barrel.script].as[script].data_key[data.stacks]>
      - flag <context.location> barrel.max_count:<player.item_in_hand.max_stack.mul[<[max_stacks]>]>
      - take iteminhand quantity:<player.item_in_hand.quantity>
    - else:
      # If there is an item, the item in hand must match to continue
      - if !<player.item_in_hand.with[quantity=1].advanced_matches[raw_exact:<context.location.flag[barrel.item]>]>:
        - stop
      # Check whether the full stack will fit in the barrel
      - define qty_take <player.item_in_hand.quantity.min[<context.location.flag[barrel.max_count].sub[<context.location.flag[barrel.count]>]>]>
      # Take the items, increase the count
      - flag <context.location> barrel.count:+:<[qty_take]>
      - take iteminhand quantity:<[qty_take]>
    - run barrel_update_tick def:<context.location>
######################
## Player left clicking withdraws items as long as they're clicking the front
######################
    on player left clicks barrel location_flagged:barrel:
    - if <context.relative> != <context.location.add[<context.location.block_facing>]>:
      - stop
    - determine passively cancelled
    - ratelimit <player> 1t
    # We can't withdraw if the barrel is empty
    - if !<context.location.has_flag[barrel.item]>:
      - stop
    # Determine the quantity to withdraw based on the player sneaking or not
    - define qty_give <tern[<player.is_sneaking>].pass[<context.location.flag[barrel.item].max_stack.min[<context.location.flag[barrel.count]>]>].fail[1]>
    # Give the player the items and decrement the count
    - give <context.location.flag[barrel.item]> quantity:<[qty_give]>
    - flag <context.location> barrel.count:-:<[qty_give]>
    - run barrel_update_tick def:<context.location>
    - ratelimit <player> 1s
    - playsound <player> sound:entity_item_pickup pitch:<util.random.decimal[1.0].to[2.0]> sound_category:players
######################
## For upgradeable barrels, the inventory GUI is not used
######################
    on player opens inventory:
    - determine cancelled if:<context.inventory.location.has_flag[barrel].if_null[false]>
######################
## Do things when hoppers or droppers interact with the barrel
######################
    on item moves from inventory to inventory:
    - if <context.destination.location.has_flag[barrel].if_null[false]>:
      # Verify that the barrel is empty, or that the item matches
      - if !<context.destination.location.has_flag[barrel.item]>:
        # Allow storage of the item and run updates
        - flag <context.destination.location> barrel.item:<context.item.with[quantity=1]>
        - define max_stacks <context.destination.location.flag[barrel.script].as[script].data_key[data.stacks]>
        - flag <context.destination.location> barrel.max_count:<context.item.max_stack.mul[<[max_stacks]>]>
      - else if <context.item.with[quantity=1].advanced_matches[raw_exact:<context.destination.location.flag[barrel.item]>]>:
        # Check how much will fit in the barrel
        - define qty_take <context.item.quantity.min[<context.destination.location.flag[barrel.max_count].sub[<context.destination.location.flag[barrel.count]>]>]>
        - if <[qty_take]> == 0:
          - determine cancelled
        - determine passively <context.item.with[quantity=<[qty_take]>]>
      - else:
        # Prevent the transfer from occurring
        - determine cancelled
    after item moves from inventory to inventory:
    - if <context.destination.location.has_flag[barrel].if_null[false]>:
      - flag <context.destination.location> barrel.count:+:<context.item.quantity>
      - run barrel_update_tick def:<context.destination.location>
    - else if <context.origin.location.has_flag[barrel].if_null[false]>:
      - flag <context.origin.location> barrel.count:-:<context.item.quantity>
      - run barrel_update_tick def:<context.origin.location>

barrel_get_quantity_string:
  type: procedure
  definitions: material|qty
  debug: false
  script:
  # If less than a full stack, or item doesn't stack, just use the raw count
  - if <[qty]> < <[material].max_stack_size> ||  <[material].max_stack_size> == 1:
    - determine <white><[qty]>
  - else:
    # Determine how many full stacks there are
    - define stacks <[qty].div[<[material].max_stack_size>].round_down>
    # Determine the remainder
    - define remainder <[qty].sub[<[stacks].mul[<[material].max_stack_size>]>]>
    # Return the appropriate "Xs(+Y)" response
    - if <[remainder]> == 0:
      - determine <white><[stacks]><gray>s
    - else:
      - determine <white><[stacks]><gray>s+<white><[remainder]>

barrel_update_tick:
  type: task
  definitions: location
  debug: false
  script:
  # If the barrel is empty...
  - if <[location].flag[barrel.count]> == 0:
    # Remove the stored item and the stored details about the item
    - flag <[location]> barrel.item:!
    - flag <[location]> barrel.max_count:!
    # Clear the display entities
    - adjust <[location].flag[barrel.entities.item]> item:air
    - adjust <[location].flag[barrel.entities.name]> text:<empty>
    - adjust <[location].flag[barrel.entities.qty]> text:<empty>
    # Ensure the internal inventory is empty
    - adjust <[location].inventory> contents:air
  - else:
    # Update the display entities
    - adjust <[location].flag[barrel.entities.item]> item:<[location].flag[barrel.item]>
    - adjust <[location].flag[barrel.entities.name]> text:<[location].flag[barrel.item].display.if_null[<[location].flag[barrel.item].material.name.replace[_].with[ ].to_titlecase>]>
    - adjust <[location].flag[barrel.entities.qty]> text:<proc[barrel_get_quantity_string].context[<[location].flag[barrel.item].material>|<[location].flag[barrel.count]>]>
    # Ensure the internal inventory contains a single instance of the item
    - adjust <[location].inventory> contents:<[location].flag[barrel.item]>