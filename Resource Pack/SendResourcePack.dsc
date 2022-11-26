dResPack_world:
  type: world
  events:
    on bungee player joins network flagged:dResPack:
      - wait 1t
      - if <player.is_online> && <player.flag[dResPack]>:
        - ~webget https://github.com/JGMinimule/KalvaraCraft-ResourcePack/releases/download/latest/hash.txt save:hash
        - resourcepack url:https://github.com/JGMinimule/KalvaraCraft-ResourcePack/releases/download/latest/KalvaraMC.zip hash:<entry[hash].result>
    on player joins:
      - if <player.has_flag[dResPack].not>:
        #- ratelimit <player> 12h
        - wait 5s
        - narrate "<gold><bold>Want a better experience?<white><n>We use a resource pack to enhance our chat experience - it's completely optional and you can change your settings anytime using /resourcepack"
        - narrate "<green><&click[/resourcepack true]><&hover[Woo! Let's party with the resource pack!]>[Yes please!]<&end_hover><&end_click> <red><&click[/resourcepack false]><&hover[It's okay - we understand! We'll be here if you change your mind!]>[No thank you!]<&end_hover><&end_click>"
      - else if <player.flag[dResPack]>:
        - ~webget https://github.com/JGMinimule/KalvaraCraft-ResourcePack/releases/download/latest/hash.txt save:hash
        - resourcepack url:https://github.com/JGMinimule/KalvaraCraft-ResourcePack/releases/download/latest/KalvaraMC.zip hash:<entry[hash].result>
    on resource pack status:
      - if <context.status> == SUCCESSFULLY_LOADED:
        - flag <player> dResPack:active
    on player quits:
      - if <player.flag[dResPack].if_null[]> == active:
        - flag <player> dResPack:true

dResPack_command:
  type: command
  name: resourcepack
  description: Change your resource pack settings for the server
  usage: /resourcepack true|false
  tab completions:
    1: true|false
  script:
    - choose <context.args.first.to_lowercase.if_null[]>:
      - case true active:
        - narrate "<green>Resource pack will now be sent automatically when you join"
        - if <player.flag[dResPack].if_null[]> != active:
          - flag <player> dResPack:true
        - ratelimit <player> 1m
        - ~webget https://github.com/JGMinimule/KalvaraCraft-ResourcePack/releases/download/latest/hash.txt save:hash
        - resourcepack url:https://github.com/JGMinimule/KalvaraCraft-ResourcePack/releases/download/latest/KalvaraMC.zip hash:<entry[hash].result>
      - case false:
        - flag <player> dResPack:false
        - narrate "<red>Resource pack will no longer be sent when you join"
      - default:
        - if <player.has_flag[dResPack].not>:
          - narrate "You haven't told us yet whether you want to use the resource pack or not"
        - else if:<player.flag[dResPack]>:
          - narrate "You are set to receive our resource pack automatically!"
        - else:
          - narrate "You have chosen not to receive our resource pack"

