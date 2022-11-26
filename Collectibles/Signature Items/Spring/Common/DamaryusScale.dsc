dCollectibles_scale_Damaryus:
  type: item
  material: blaze_spawn_egg
  display name: <white><bold>Scale of Damaryus
  lore:
  - <white><bold>Common
  - <empty>
  - <dark_purple><italic><&dq>You can see your hand through
  - <dark_purple><italic>the scale and it glows with a
  - <dark_purple><italic>warm light. The energy inside
  - <dark_purple><italic>it swirls endlessly and yet
  - <dark_purple><italic>it's ice cold.<&dq>
  - <empty>
  - <white>Right-click to light up a small
  - <white>area for 10 minutes. Can be used
  - <white>with no cooldown, but placing a
  - <white>light removes the previous one.
  - <empty>
  - <gold>[Collectible - Spring]
  mechanisms:
    hides:
    - ENCHANTS
    custom_model_data: 1
  flags:
    block_dispense: true
  enchantments:
  - unbreaking:1

dCollectibles_scale_Damaryus_world:
  type: world
  events:
    on player right clicks block with:dCollectibles_scale_Damaryus:
    - determine passively cancelled
    - stop if:<context.location.material.exists.not>
    #- if <context.relative.material.advanced_matches[air]>:
    #  - modifyblock