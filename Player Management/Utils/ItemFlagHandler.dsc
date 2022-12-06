dUtils_common_item_flags:
    type: world
    events:
        ## Prevent flagged items from being placed with right click
        on player right clicks block with:item_flagged:block_right_click:
        - determine cancelled
        ## Prevent flagged items from being dispensed
        on block dispenses item_flagged:block_dispense:
        - determine cancelled
        ## Prevent flagged item from being placed
        on player places item_flagged:block_place:
        - determine cancelled
        on player prepares item_flagged:no_enchant enchant:
        - determine cancelled
        #on player prepares grindstone craft item_flagged:no_grindstone:
        #- determine cancelled