dbarrel_item_netherite:
  type: item
  material: barrel
  debug: false
  display name: <white>Netherite Barrel
  data:
    stacks: 1024
    icon: netherite_block
  lore:
  - <dark_purple><italic>Compact storage solution for bulk items
  - <dark_purple><italic>Can hold 1024 stacks of one item
  - <empty>
  - <gold>[Storage]
  recipes:
    # This recipe handles empty barrels being used for crafting
    1:
      type: shaped
      input:
      - netherite_ingot|netherite_block|netherite_ingot
      - netherite_block|dbarrel_item_diamond|netherite_block
      - netherite_ingot|netherite_block|netherite_ingot
    # This recipe is used to handle crafting where the barrel has things in it
    #  in conjunction with the world script below
    2:
      type: shaped
      input:
      - netherite_ingot|netherite_block|netherite_ingot
      - netherite_block|material:barrel|netherite_block
      - netherite_ingot|netherite_block|netherite_ingot

dbarrel_world_netherite:
  type: world
  debug: false
  events:
    on dbarrel_item_netherite recipe formed:
    # Check that it's the correct type of barrel for the upgrade
    - if !<context.recipe.get[5].advanced_matches[dbarrel_item_diamond]>:
      - determine cancelled
    # Check whether the barrel used has items in it
    - if <context.recipe.get[5].has_flag[barrel]>:
      # Begin preparing the response item
      - define response <context.item>
      - adjust def:response flag:barrel:<context.recipe.get[5].flag[barrel]>
      - adjust def:response lore:<[response].lore.include[<empty>|<white><bold>Contents<&co>|<dark_purple><italic><context.recipe.get[5].flag[barrel.item].display.if_null[<context.recipe.get[5].flag[barrel.item].material.name.replace[_].with[ ].to_titlecase>]> x<context.recipe.get[5].flag[barrel.count]>]>
      - determine <[response]>