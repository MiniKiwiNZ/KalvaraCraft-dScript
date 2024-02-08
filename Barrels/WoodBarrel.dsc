dbarrel_item_wood:
  type: item
  material: barrel
  debug: false
  display name: Wooden Barrel
  data:
    stacks: 32
    icon: oak_planks
  lore:
  - <dark_purple><italic>Compact storage solution for bulk items
  - <dark_purple><italic>Can hold 32 stacks of one item
  - <empty>
  - <gold>[Storage]
  recipes:
    1:
      type: shaped
      input:
      - *_planks|*_wood/*_hyphae|*_planks
      - *_wood/*_hyphae|barrel|*_wood/*_hyphae
      - *_planks|*_wood/*_hyphae|*_planks