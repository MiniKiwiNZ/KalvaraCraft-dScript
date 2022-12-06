CM_refined_diamond:
    type: item
    material: diamond
    display name: <white>Refined Diamond
    lore:
        - <white><bold>Refined Diamond
        - <empty>
        - <gold>[Crafting Material]
    recipes:
        1:
            type: stonecutting
            input: material:diamond_block

CM_refined_diamond_block:
    type: item
    material: diamond_block
    display name: <white>Refined Block of Diamond
    lore:
        - <white><bold>Refined Diamond
        - <empty>
        - <gold>[Crafting Material]
    flags:
        block_place: true
    recipes:
        1:
            type: shaped
            input:
            - CM_refined_diamond|CM_refined_diamond|CM_refined_diamond
            - CM_refined_diamond|CM_refined_diamond|CM_refined_diamond
            - CM_refined_diamond|CM_refined_diamond|CM_refined_diamond