CM_refined_copper:
    type: item
    material: copper_ingot
    display name: <white>Refined Copper
    lore:
        - <white><bold>Refined Copper
        - <empty>
        - <gold>[Crafting Material]
    recipes:
        1:
            type: stonecutting
            input: material:exposed_copper/weathered_copper/oxidized_copper/*cut_copper/waxed_*_copper/*copper_block

CM_refined_copper_block:
    type: item
    material: copper_block
    display name: <white>Refined Block of Copper
    lore:
        - <white><bold>Refined Copper
        - <empty>
        - <gold>[Crafting Material]
    flags:
        block_place: true
    recipes:
        1:
            type: shaped
            input:
            - CM_refined_copper|CM_refined_copper|CM_refined_copper
            - CM_refined_copper|CM_refined_copper|CM_refined_copper
            - CM_refined_copper|CM_refined_copper|CM_refined_copper