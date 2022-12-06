CM_refined_netherite:
    type: item
    material: netherite_ingot
    display name: <white>Refined Netherite
    lore:
        - <white><bold>Refined Netherite
        - <empty>
        - <gold>[Crafting Material]
    recipes:
        1:
            type: stonecutting
            input: material:netherite_block

CM_refined_netherite_block:
    type: item
    material: netherite_block
    display name: <white>Refined Block of Netherite
    lore:
        - <white><bold>Refined Netherite
        - <empty>
        - <gold>[Crafting Material]
    flags:
        block_place: true
    recipes:
        1:
            type: shaped
            input:
            - CM_refined_netherite|CM_refined_netherite|CM_refined_netherite
            - CM_refined_netherite|CM_refined_netherite|CM_refined_netherite
            - CM_refined_netherite|CM_refined_netherite|CM_refined_netherite