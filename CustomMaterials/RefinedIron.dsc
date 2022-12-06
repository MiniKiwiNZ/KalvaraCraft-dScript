CM_refined_iron:
    type: item
    material: iron_ingot
    display name: <white>Refined Iron
    lore:
        - <white><bold>Refined Iron
        - <empty>
        - <gold>[Crafting Material]
    recipes:
        1:
            type: stonecutting
            input: material:iron_block

CM_refined_iron_block:
    type: item
    material: iron_block
    display name: <white>Refined Block of Iron
    lore:
        - <white><bold>Refined Iron
        - <empty>
        - <gold>[Crafting Material]
    flags:
        block_place: true
    recipes:
        1:
            type: shaped
            input:
            - CM_refined_iron|CM_refined_iron|CM_refined_iron
            - CM_refined_iron|CM_refined_iron|CM_refined_iron
            - CM_refined_iron|CM_refined_iron|CM_refined_iron