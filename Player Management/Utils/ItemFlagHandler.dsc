dUtils_common_item_flags:
    type: world
    events:
        ## Prevent flagged items from being placed with right click
        on player right clicks block with:item_flagged:block_right_click:
        - determine cancelled
        ## Prevent flagged items from being dispensed
        on block dispenses item_flagged:block_dispense:
        - determine cancelled
