CM_refined_lapis:
    type: item
    material: lapis_lazuli
    display name: <white>Refined Lapis
    lore:
        - <white><bold>Refined Lapis
        - <empty>
        - <gold>[Crafting Material]
    recipes:
        1:
            type: stonecutting
            input: material:lapis_block

CM_refined_lapis_block:
    type: item
    material: lapis_block
    display name: <white>Refined Block of Lapis
    lore:
        - <white><bold>Refined Lapis
        - <empty>
        - <gold>[Crafting Material]
    flags:
        block_place: true
    recipes:
        1:
            type: shaped
            input:
            - CM_refined_lapis|CM_refined_lapis|CM_refined_lapis
            - CM_refined_lapis|CM_refined_lapis|CM_refined_lapis
            - CM_refined_lapis|CM_refined_lapis|CM_refined_lapis