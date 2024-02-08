##########################################
## dToys:Magic Snowball            v1.0 ##
## Created by MiniKiwiNZ                ##
## Made available under the MIT License ##
## Copyright 2023 MiniKiwiNZ            ##
##########################################

dtoys_magic_snowball:
  type: item
  material: snowball
  mechanisms:
    custom_model_data: 1
  display name: <aqua>M<white>agical <aqua>S<white>nowball
  lore:
  - <dark_purple><italic>Throw it to someone and they might
  - <dark_purple><italic>throw it back!
  - <empty>
  - <white>Throwing the snowball returns it
  - <white>to you after a short delay
  - <empty>
  - <gold>[Toy]

dtoys_magic_snowball_world:
  type: world
  events:
    ## Handle the snowball hitting another entity or block
    on snowball hits:
    - stop if:<context.projectile.item.advanced_matches[dtoys_magic_snowball].not>
    - determine passively cancelled
    - if <context.hit_block>:
      # Hitting a block means we just drop the snowball on the ground
      - drop <context.projectile.item> <context.location.above>
    - else:
      # Otherwise we're going to return it to the original thrower
      - define return_item <context.projectile.item>
      - remove <context.projectile>
      - define hit_entity <context.hit_entity>
      - define shooter <context.shooter>
      - wait 1.5s
      - shoot snowball[item=<[return_item]>] origin:<[hit_entity].location> destination:<[shooter].location> shooter:<[shooter]> save:shot
