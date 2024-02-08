##########################################
## dToys:Candy Apple               v1.0 ##
## Created by MiniKiwiNZ                ##
## Made available under the MIT License ##
## Copyright 2023 MiniKiwiNZ            ##
##########################################
dtoys_candy_apple:
  type: item
  material: golden_apple
  mechanisms:
    custom_model_data: 1
  display name: <red>C<white>andy <red>A<white>pple
  lore:
  - <dark_purple><italic><&dq>Because the best things in life are sweet<&dq>
  - <dark_purple>An apple surrounded by a thick layer
  - <dark_purple>of caramel. Mind the sugar crash!
  - <empty>
  - <gold>[Toy]

dtoys_candy_apple_world:
  type: world
  events:
    ## Handle a player consuming the candy apple
    on player consumes dtoys_candy_apple:
    - cast speed amplifier:2 duration:2m hide_particles
    - cast jump amplifier:2 duration:2m hide_particles
    - wait 2m
    - cast slow amplifier:2 duration:1m hide_particles
    - narrate "<italic>Oh man... all that sugar might have been a bad idea..."