CM_refined_gold:
    type: item
    material: gold_ingot
    display name: <white>Refined Gold
    lore:
        - <white><bold>Refined Gold
        - <empty>
        - <gold>[Crafting Material]
    recipes:
        1:
            type: stonecutting
            input: material:gold_block

CM_refined_gold_block:
    type: item
    material: gold_block
    display name: <white>Refined Block of Gold
    lore:
        - <white><bold>Refined Gold
        - <empty>
        - <gold>[Crafting Material]
    flags:
        block_place: true
    recipes:
        1:
            type: shaped
            input:
            - CM_refined_gold|CM_refined_gold|CM_refined_gold
            - CM_refined_gold|CM_refined_gold|CM_refined_gold
            - CM_refined_gold|CM_refined_gold|CM_refined_gold