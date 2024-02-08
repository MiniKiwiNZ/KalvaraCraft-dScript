##########################################
## dToys:Snow White Apple          v1.0 ##
## Created by MiniKiwiNZ                ##
## Made available under the MIT License ##
## Copyright 2023 MiniKiwiNZ            ##
##########################################
dtoys_snow_white_apple:
  type: item
  material: apple
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  display name: <aqua><bold>S<white>now <aqua><bold>W<white>hite's <aqua><bold>E<white>nchanted <aqua><bold>A<white>pple
  lore:
  - <dark_purple><italic><&dq>Go on, have a bite...<&dq>
  - <dark_purple>An unnaturally red apple. You can glimpse
  - <dark_purple>green underneath the red surface...
  - <empty>
  - <gold>[Toy]
  enchantments:
  - binding_curse:1

dtoys_snow_white_apple_world:
  type: world
  events:
    on player consumes dtoys_snow_white_apple:
    - narrate "<&o>You feel very sleepy..."
    - cast slow amplifier:2 duration:10s hide_particles
    - wait 10s
    - narrate "<&o>The apple's positive magic shines through in the end!"
    - cast speed amplifier:2 duration:1m hide_particles
    - cast jump amplifier:2 duration:1m hide_particles
    - cast regeneration amplifier:2 duration:15s hide_particles