##########################################
## dToys:Lego Brick                v1.0 ##
## Created by MiniKiwiNZ                ##
## Made available under the MIT License ##
## Copyright 2023 MiniKiwiNZ            ##
##########################################
dtoys_lego_brick:
  type: item
  material: brick
  mechanisms:
    custom_model_data: 1
  display name: <white>Lego Brick
  lore:
  - <dark_purple><italic>There are few things more painful than
  - <dark_purple><italic>standing on a piece of Lego
  - <empty>
  - <white>Sneak to pick this item up
  - <empty>
  - <gold>[Toy]

dtoys_lego_brick_world:
  type: world
  events:
    ## Handle a player picking up the brick
    on player picks up dtoys_lego_brick:
    # If the player isn't sneaking, they can't pick it up
    - if <player.is_sneaking.not>:
      - determine passively cancelled
      - ratelimit <player> 1.5s
      - narrate "<italic>You stood on a Lego brick! Ow!"
      - animate <player> animation:hurt
      - playsound <player> sound:ENTITY_PLAYER_HURT