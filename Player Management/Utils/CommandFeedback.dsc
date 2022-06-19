#############################################
## dUtils:Utils:CommandFeedback       v1.0 ##
## Created by MiniMuleNZ                   ##
## Made available under the MIT License    ##
## Copyright 2022 MiniMuleNZ               ##
##                                         ##
## Send the specified text to the command  ##
##  sender which is either <player> or the ##
##  the console                            ##
#############################################
dutils_utils_commandfeedback:
    type: task
    definitions: message
    debug: false
    script:
    - if <context.source_type> == PLAYER:
        - narrate <[message]>
    - if <context.source_type> == SERVER:
        - announce to_console <[message]>