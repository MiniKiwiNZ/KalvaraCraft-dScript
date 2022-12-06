CM_refined_redstone:
    type: item
    material: redstone
    display name: <white>Refined Redstone
    lore:
        - <white><bold>Refined Redstone
        - <empty>
        - <gold>[Crafting Material]
    recipes:
        1:
            type: stonecutting
            input: material:redstone_block

CM_refined_redstone_block:
    type: item
    material: redstone_block
    display name: <white>Refined Block of Redstone
    lore:
        - <white><bold>Refined Redstone
        - <empty>
        - <gold>[Crafting Material]
    flags:
        block_place: true
    recipes:
        1:
            type: shaped
            input:
            - CM_refined_redstone|CM_refined_redstone|CM_refined_redstone
            - CM_refined_redstone|CM_refined_redstone|CM_refined_redstone
            - CM_refined_redstone|CM_refined_redstone|CM_refined_redstone