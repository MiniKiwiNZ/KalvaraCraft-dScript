dCollectibles_config:
  type: data
  dateFormat: MM/DD
  seasons:
    Winter:
      starts: <&pc>current_year<&pc>/12/01
      ends: <&pc>next_year<&pc>/03/01
      #categories:
      #- name: 
      #  lore:
      #  - 
      #  material: 
      #  items:
      #  - 
    Spring:
      starts: <&pc>current_year<&pc>/03/01
      ends: <&pc>current_year<&pc>/06/01
      #categories:
      #- name: 
      #  lore:
      #  - 
      #  material: 
      #  items:
      #  - 
    Summer:
      starts: <&pc>current_year<&pc>/06/01
      ends: <&pc>current_year<&pc>/09/01
      #categories:
      #- name: 
      #  lore:
      #  - 
      #  material: 
      #  items:
      #  - 
    Fall:
      starts: <&pc>current_year<&pc>/09/01
      ends: <&pc>current_year<&pc>/12/01
      #categories:
      #- name: 
      #  lore:
      #  - 
      #  material: 
      #  items:
      #  - 

dCollectibles_proc_getActiveSeason:
  type: procedure
  debug: false
  definitions: date
  script:
  - if !<[date].exists>:
    - define date <util.time_now.start_of_day>
  - else:
    - define date <time[<[date]>]>
  - define current_year <[date].year>
  - define result <empty>
  - foreach <script[dCollectibles_config].parsed_key[seasons]> as:season:
    - define start <time[<[season].get[starts].replace[<&pc>current_year<&pc>].with[<[current_year]>].replace[<&pc>next_year<&pc>].with[<[current_year].add[1]>]>]>
    - define end <time[<[season].get[ends].replace[<&pc>current_year<&pc>].with[<[current_year]>].replace[<&pc>next_year<&pc>].with[<[current_year].add[1]>]>]>
    # If the target date is before the end date and not before the start date...0
    - if <[date].is_before[<[end]>]> && !<[date].is_before[<[start]>]>:
      - define result <[season]>
      - define result.name <[key]>
      - define result.starts <[start]>
      - define result.ends <[end]>
    # Otherwise try with the previous year
    - else:
      - define start <time[<[season].get[starts].replace[<&pc>current_year<&pc>].with[<[current_year].sub[1]>].replace[<&pc>next_year<&pc>].with[<[current_year]>]>]>
      - define end <time[<[season].get[ends].replace[<&pc>current_year<&pc>].with[<[current_year].sub[1]>].replace[<&pc>next_year<&pc>].with[<[current_year]>]>]>
      - if <[date].is_before[<[end]>]> && !<[date].is_before[<[start]>]>:
        - define result <[season]>
        - define result.name <[key]>
        - define result.starts <[start]>
        - define result.ends <[end]>
  - determine <[result]>

dCollectibles_proc_seasonsTest:
  type: task
  debug: false
  script:
  - repeat 12:
    - narrate "2022/<[value]>/01 is in the <proc[dCollectibles_proc_getActiveSeason].context[2022/<[value]>/01]> season"

dCollectibles_task_seasonReassessment:
  type: task
  debug: false
  script:
  # Get the current season that should be active
  - define currentSeason <proc[dCollectibles_proc_getActiveSeason]>
  # If there is no season to continue into, but an existing season to finish, notify the players
  - if <[currentSeason]> == <empty>:
    - announce "The <server.flag[dCollectibles]> collectibles season has ended!" if:<server.has_flag[dCollectibles]>
    - flag server dCollectible:!
    - stop
  # If there is a new season, announce it
  - if <[currentSeason].get[name]> != <server.flag[dCollectibles.season].if_null[]>:
    - flag server dCollectibles.season:<[currentSeason].get[name]>
    - flag server dCollectibles.startTime:<util.current_time_millis>
    - announce "The <server.flag[dCollectibles.season]> collectibles season has begun and will last for <[currentSeason].get[ends].from_now.formatted_words>!"
    - flag <server.online_players> dCollectibles:<server.flag[dCollectibles]>

dCollectibles_world:
  type: world
  debug: false
  events:
    after player joins:
    - if <player.has_flag[dCollectibles]>:
      # If the collectibles season has ended since the player last joined, let them know
      - if !<server.has_flag[dCollectibles]>:
        - define seasonName <player.flag[dCollectibles.season]>
        - flag <player> dCollectibles:!
        - wait 5s
        - narrate "The <[seasonName]> collectibles season has ended!"
        - stop
      # If the collectibles season has changed since the player last joined, let them know
      - if <server.flag[dCollectibles.startTime]> != <server.flag[dCollectibles.startTime]>:
        - flag <player> dCollectibles:<server.flag[dCollectibles]>
        - define seasonName <server.flag[dCollectibles.season]>
        - define season <proc[dCollectibles_proc_getActiveSeason]>
        - wait 5s
        - narrate "The <[seasonName]> collectibles season has begun and will last for <[season].get[ends].from_now.formatted_words>!"
        - stop
      # Every 12 hours, let the player know when the collectibles season will end
      - ratelimit <player> 12h
      - define seasonName <server.flag[dCollectibles.season]>
      - define season <proc[dCollectibles_proc_getActiveSeason]>
      - wait 5s
      - narrate "The <[seasonName]> collectibles season will continue for <[season].get[ends].from_now.formatted_words>!"
    # If the player doesn't have a collectibles season, but the server does, start the new season
    - else if <server.has_flag[dCollectibles]>:
        - flag <player> dCollectibles:<server.flag[dCollectibles]>
        - define seasonName <server.flag[dCollectibles.season]>
        - define season <proc[dCollectibles_proc_getActiveSeason]>
        - wait 5s
        - narrate "The <[seasonName]> collectibles season has begun and will last for <[season].get[ends].from_now.formatted_words>!"
        - stop
    after server start:
    - run dCollectibles_task_seasonReassessment
    after script reload:
    - run dCollectibles_task_seasonReassessment
    after system time 00:00:
    - run dCollectibles_task_seasonReassessment
    - debug LOG "Running daily collectibles reset" name:dCollectibles