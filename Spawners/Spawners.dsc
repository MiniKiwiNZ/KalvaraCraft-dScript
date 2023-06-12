dSpawners_SpawnerConfig:
  debug: false
  type: world
  data:
    Prefix: <gold><bold>dSpawner ► <green>
    NaturalDrops:
      BLAZE:
      - dSpawners_SpawnerShard_1[quantity=2]
      - money:150
      ZOMBIE:
      - dSpawners_SpawnerShard_2[quantity=2]
      - money:200
      CAVE_SPIDER:
      - dSpawners_SpawnerShard_2
      - money:200
      MAGMA_CUBE:
      - dSpawners_SpawnerShard_3[quantity=2]
      - money:500
      SKELETON:
      - dSpawners_SpawnerShard_2[quantity=2]
      - money:200
      SPIDER:
      - dSpawners_SpawnerShard_2[quantity=2]
      - money:200
    DefaultStats:
      spawner_max_nearby_entities: 1
      # Delay Format: delay-to-next-spawn|minimum-delay|maximum-delay
      spawner_delay_data: 400|400|400
      spawner_player_range: 8
      spawner_count: 1
      spawner_range: 12
  events:
    ## When the scripts reload, ask all spawner components to register themselves
    after reload scripts:
      - run dspawners_task_reloadmodules
      - stop
      - flag server dSpawners.SubModules:!
      - customevent id:dspawners_register_spawner_modules
      - announce to_console "<script.parsed_key[data.Prefix]>Registered <server.flag[dSpawners.SubModules.Shards].size.if_null[0]> spawner shards"
      - announce to_console "<script.parsed_key[data.Prefix]>Registered <server.flag[dSpawners.SubModules.Core].size.if_null[0]> spawner cores"
      - announce to_console "<script.parsed_key[data.Prefix]>Registered <server.flag[dSpawners.SubModules.Spawner].size.if_null[0]> spawners"
    after server start:
      - run dspawners_task_reloadmodules
      - stop
      - flag server dSpawners.SubModules:!
      - customevent id:dspawners_register_spawner_modules
      - announce to_console "<script.parsed_key[data.Prefix]>Registered <server.flag[dSpawners.SubModules.Shards].size.if_null[0]> spawner shards"
      - announce to_console "<script.parsed_key[data.Prefix]>Registered <server.flag[dSpawners.SubModules.Core].size.if_null[0]> spawner cores"
      - announce to_console "<script.parsed_key[data.Prefix]>Registered <server.flag[dSpawners.SubModules.Spawner].size.if_null[0]> spawners"
    ## Listen for players placing a spawner
    on player places spawner:
      - if <context.item_in_hand.script.data_key[data.Placeable].if_null[false]>:
        - adjust <context.location> spawner_type:<context.item_in_hand.spawner_type>
        # Collect the base stats of the spawner and apply them
        - adjust <context.location> <script.data_key[data.DefaultStats].include[<context.item_in_hand.script.data_key[data.BaseStats]>]>
        - flag <context.location> spawner
        - flag <context.location> script:<context.item_in_hand.script.name>
        # For any upgrades, perform their OnPlace event
        - if <context.item_in_hand.has_flag[Upgrades]>:
          - foreach <context.item_in_hand.flag[Upgrades].keys> as:upgrade:
            - define level <context.item_in_hand.flag[Upgrades.<[upgrade]>]>
            - flag <context.location> Upgrades.<[upgrade]>:<[level]>
            - run <script[dspawners_upgradeconfig]> path:data.Upgrades.<[upgrade]>.Actions.OnPlace def.location:<context.location> def.level:<[level]> def.player:<player> if:<script[dspawners_upgradeconfig].list_keys[data.Upgrades.<[upgrade]>.Actions].if_null[<list>].contains[OnPlace]>
        # If the player hasn't placed a spawner in a while, remind them to charge it up
        - if <player.has_flag[SpawnerChargeReminder].not>:
          - flag <player> SpawnerChargeReminder expire:1d
          - narrate "<script.parsed_key[data.Prefix]>Don't forget to charge your spawners so they can spawn mobs! <red>Any remaining charge will be lost if you break a spawner."
      - else:
        - determine passively cancelled
        - narrate "<script.parsed_key[data.Prefix]><red>This spawner item is not valid"
    ## Listen for players breaking a spawner
    on player breaks spawner:
      # Check whether this was a natural spawner or not
      - if <context.location.has_flag[spawner]>:
        # Get the base item to drop
        - define dropitem <proc[dSpawners_Spawners_getSpawnerItem].context[<context.location>]>
        - flag <context.location> Upgrades:!
        - flag <context.location> spawner:!
        - flag <context.location> script:!
        - flag <context.location> rechargeduration:!
        - determine passively 0
        - determine <[dropitem]>
      - else:
        - if <script[dSpawners_SpawnerConfig].list_keys[data.NaturalDrops].contains[<context.location.spawner_type.entity_type>]>:
          - define dropsresult <list>
          - foreach <script[dSpawners_SpawnerConfig].data_key[data.NaturalDrops.<context.location.spawner_type.entity_type>]> as:drop:
            - if <[drop].starts_with[money:]>:
              - define moneyAmount <[drop].substring[<[drop].index_of[:].add[1]>]>
              - actionbar "Earned <server.economy.format[<[moneyAmount]>]> for breaking a natural <context.location.spawner_type.entity_type.to_lowercase.replace_text[_].with[ ]> spawner"
              - money give quantity:<[moneyAmount]>
            - else:
              - define dropsresult:->:<[drop].as[item]>
          - determine <[dropsresult]>
    ## Listen for entities spawning from a custom spawner
    on spawner spawns entity:
      - if <context.spawner_location.has_flag[spawner]> && <context.spawner_location.has_flag[rechargeduration].not>:
        # Check if this spawner actually needs recharging and cancel the spawn if it does
        - determine cancelled if:<context.spawner_location.flag[script].as[script].data_key[data].contains[Recharge]>
      - flag <context.entity> from_spawner
      - stop if:<context.spawner_location.has_flag[spawner].not>
      # Remove the entity's awareness
      - adjust <context.entity> is_aware:false
      # Remove the entity's equipment
      - equip <context.entity> head:air chest:air legs:air boots:air hand:air offhand:air
      # If the entity is riding or being ridden, remove the mount or the rider
      - if <context.entity.is_inside_vehicle>:
        - remove <context.entity.vehicle>
      - if <context.entity.passengers.is_empty.not>:
        - remove <context.entity.passengers>
      # For each upgrade, run its OnSpawn action
      - foreach <context.spawner_location.flag[Upgrades].keys.if_null[<list>]> as:upgrade:
        - define level <context.spawner_location.flag[Upgrades.<[upgrade]>]>
        - flag <context.entity> Upgrades.<[upgrade]>:<[level]>
        - run <script[dspawners_upgradeconfig]> path:data.Upgrades.<[upgrade]>.Actions.OnSpawn def.entity:<context.entity> def.level:<[level]> if:<script[dspawners_upgradeconfig].list_keys[data.Upgrades.<[upgrade]>.Actions].if_null[<list>].contains[OnSpawn]>
    ## Transformed entities from spawners are still from spawners
    on entity_flagged:from_spawner transforms:
      - flag <context.new_entities> from_spawner
      - equip <context.new_entities> head:air chest:air legs:air boots:air hand:air offhand:air
      - adjust <context.new_entities> is_aware:false
    ## Make sure spawner entities cannot pick up items
    on entity_flagged:from_spawner picks up item:
      - determine cancelled
    ## Prevent endermen teleporting
    on entity_flagged:from_spawner teleports:
      - determine cancelled
    ## Listen for the death of entities from custom spawners
    on entity_flagged:Upgrades dies:
      - define drops <context.drops>
      - define xp <context.xp>
      # For each upgrade, run its OnDeath action
      - foreach <context.entity.flag[Upgrades].keys> as:upgrade:
        - define level <context.entity.flag[Upgrades.<[upgrade]>]>
        - inject <script[dspawners_upgradeconfig]> path:data.Upgrades.<[upgrade]>.Actions.OnDeath if:<script[dspawners_upgradeconfig].list_keys[data.Upgrades.<[upgrade]>.Actions].if_null[<list>].contains[OnDeath]>
      - determine passively <tern[<[drops].is_empty>].pass[NO_DROPS].fail[<[drops]>]>
      - determine passively <tern[<[xp].equals[0]>].pass[NO_XP].fail[<[xp]>]>
    ## Listen for upgrade clicks
    on player clicks spawner with:item_flagged:UpgradeSpawner:
      - determine passively cancelled
      - stop if:<context.location.has_flag[spawner].not>
      - inventory open d:<proc[dSpawners_Spawners_getUpgradeGui].context[<context.location>|<player>]>
    ## Listen for clicks in the upgrade GUI
    on player clicks item_flagged:Upgrade in dSpawners_SpawnerGUI:
      - ratelimit <player> 5t
      # Get the cost of the upgrade
      - define location <context.inventory.list_contents.get[5].flag[location].as[location]>
      - define currentlevel <[location].flag[Upgrades.<context.item.flag[Upgrade]>].if_null[0]>
      - define itemcost <[location].flag[script].as[script].data_key[data.Upgrades.<context.item.flag[Upgrade]>.Cost.<[currentlevel].add[1]>]>
      # Check if the player has all the items
      - if <proc[dSpawners_Spawners_hasAllItems].context[<list[<player>].include_single[<[itemcost]>]>]>:
        - foreach <[itemcost]> as:item:
          - if <[item].starts_with[money:]>:
            - money take quantity:<[item].substring[<[item].last_index_of[:].add[1]>]>
          - else:
            - define itagitem <[item].as[item]>
            - if <[itagitem].script.exists>:
              - take item:<[itagitem].script.name> quantity:<[itagitem].quantity>
            - else:
              - take raw_exact:<[itagitem]> quantity:<[itagitem].quantity>
        - flag <[location]> Upgrades.<context.item.flag[Upgrade]>:<[location].flag[Upgrades.<context.item.flag[Upgrade]>].if_null[0].add[1]>
        - run dSpawners_Spawners_reapplyUpgrades def:<[location]>|<player>
        - inventory open d:<proc[dSpawners_Spawners_getUpgradeGui].context[<[location]>|<player>]>
      - else:
        - narrate "<script.parsed_key[data.Prefix]><red>Missing resources for upgrade"
    on player left clicks item_flagged:recharge in dSpawners_SpawnerGUI:
      - ratelimit <player> 5t
      # Get the recharge information
      - define location <context.inventory.list_contents.get[5].flag[location].as[location]>
      - define rechargeData <[location].flag[script].as[script].data_key[data.Recharge]>
      # See whether the player has the items to perform the recharge
      - define hasItems <proc[dSpawners_Spawners_hasAllItems].context[<player>|<[rechargeData].get[Cost]>]>
      - define canRecharge <[location].flag_expiration[rechargeduration].from_now.if_null[<duration[0]>].add[<[rechargeData].get[CostDuration]>].is_less_than[<[rechargeData].get[MaxDuration]>]>
      - if <[canRecharge].not>:
        - narrate "<script.parsed_key[data.Prefix]><red>This spawner is already nearly fully charged"
        - stop
      - if <[hasItems].not>:
        - narrate "<script.parsed_key[data.Prefix]><red>You are missing items to recharge this spawner"
        - stop
      # Take the items
      - foreach <[rechargeData].get[Cost]> as:item:
        - if <[item].starts_with[money:]>:
          - money take quantity:<[item].substring[<[item].last_index_of[:].add[1]>]>
        - else:
          - define itagitem <[item].as[item]>
          - if <[itagitem].script.exists>:
            - take item:<[itagitem].script.name> quantity:<[itagitem].quantity>
          - else:
            - take raw_exact:<[itagitem]> quantity:<[itagitem].quantity>
      # Increase the duration
      - flag <[location]> rechargeduration expire:<[location].flag_expiration[rechargeduration].from_now.if_null[<duration[0]>].add[<[rechargeData].get[CostDuration]>]>
      - inventory open d:<proc[dSpawners_Spawners_getUpgradeGui].context[<[location]>|<player>]>
      - narrate "<script.parsed_key[data.Prefix]>Recharged spawner - <gray><[location].flag_expiration[rechargeduration].from_now.formatted><white> remaining"
    ## Stop the player eating things that can't be eaten
    on player consumes item_flagged:PreventEat priority:-1:
      - determine cancelled
    ## Stop the player placing things that can't be placed
    on player places item_flagged:PreventPlace priority:-1:
      - determine cancelled
    ## Prevent dispensers placing things that can't be placed
    on dispenser dispenses item_flagged:PreventPlace priority:-1:
      - determine cancelled
    ## Prevent players using items that shouldn't be usable
    on player right clicks block with:item_flagged:PreventUse priority:-1:
      - determine cancelled
    ## Prevent players using items on entities that shouldn't be usable
    on player right clicks entity with:item_flagged:PreventEntityUse priority:-1:
      - determine cancelled
    ## Prevent players from using spawn eggs on spawners
    on player right clicks spawner with:*_spawn_egg:
      - narrate "<dark_red>Spawners can not be changed using spawn eggs"
      - determine cancelled
dSpawners_SpawnerGUI:
  type: inventory
  gui: true
  inventory: chest
  size: 36
  title: Upgrade Spawner
  slots:
  - [gray_stained_glass_pane] [gray_stained_glass_pane] [gray_stained_glass_pane] [gray_stained_glass_pane] [air] [gray_stained_glass_pane] [gray_stained_glass_pane] [gray_stained_glass_pane] [gray_stained_glass_pane]
  - [gray_stained_glass_pane] [gray_stained_glass_pane] [gray_stained_glass_pane] [gray_stained_glass_pane] [gray_stained_glass_pane] [gray_stained_glass_pane] [gray_stained_glass_pane] [gray_stained_glass_pane] [gray_stained_glass_pane]
  - [gray_stained_glass_pane] [air] [air] [air] [air] [air] [air] [air] [gray_stained_glass_pane]
  - [gray_stained_glass_pane] [gray_stained_glass_pane] [gray_stained_glass_pane] [gray_stained_glass_pane] [gray_stained_glass_pane] [gray_stained_glass_pane] [gray_stained_glass_pane] [gray_stained_glass_pane] [gray_stained_glass_pane]
dSpawners_Spawners_getSpawnerItem:
  type: procedure
  debug: false
  definitions: location
  script:
    - if <[location].has_flag[spawner]>:
      # Get the base item to drop
      - define dropitem <[location].flag[script].as[item]>
      # If there are upgrades, add the correct flags, and also add lore
      - if <[location].has_flag[Upgrades]>:
        - adjust def:dropitem lore:<[dropitem].lore.include_single[]>
        - foreach <[location].flag[Upgrades].keys.alphanumeric> as:upgrade:
          - define level <[location].flag[Upgrades.<[upgrade]>]>
          - adjust def:dropitem lore:<[dropitem].lore.include_single[<script[dSpawners_SpawnerConfig].parsed_key[data.Upgrades.<[upgrade]>.Name]><white>:<&sp><gold><[level]>]>
          - adjust def:dropitem flag:Upgrades.<[upgrade]>:<[level]>
      - determine <[dropitem]>
    - else:
      - determine null
dSpawners_Spawners_getUpgradeItems:
  type: procedure
  debug: false
  definitions: location|player
  script:
    - define upgradeIds <[location].flag[script].as[script].data_key[data.Upgrades].keys>
    - define result <list>
    - foreach <[upgradeIds]> as:id:
      - define result:->:<proc[dSpawners_Spawners_getUpgradeItemSingle].context[<[location]>|<[player]>|<[id]>]>
    - determine <[result]>
dSpawners_Spawners_getUpgradeItemSingle:
  type: procedure
  debug: false
  definitions: location|player|id
  script:
  - define item <script[dspawners_upgradeconfig].data_key[data.Upgrades.<[id]>.Material].as[item]>
  - adjust def:item display_name:<script[dspawners_upgradeconfig].parsed_key[data.Upgrades.<[id]>.Name]>
  - adjust def:item lore:<script[dspawners_upgradeconfig].parsed_key[data.Upgrades.<[id]>.Description]>
  - define maxlevel <[location].flag[script].as[script].data_key[data.Upgrades.<[id]>.MaxLevel]>
  - define currentlevel <[location].flag[Upgrades.<[id]>].if_null[0]>
  - adjust def:item lore:<[item].lore.include_single[<empty>]>
  - adjust def:item lore:<[item].lore.include_single[<gray>Level<&sp><aqua><[currentlevel]><gray>/<aqua><[maxlevel]>]>
  - if <[currentlevel].is_less_than[<[maxlevel]>]>:
    - adjust def:item lore:<[item].lore.include_single[<empty>]>
    - adjust def:item lore:<[item].lore.include_single[<white>Upgrade<&sp>Cost:]>
    - foreach <[location].flag[script].as[script].data_key[data.Upgrades.<[id]>.Cost.<[currentlevel].add[1]>]> as:cost:
      - if <[cost].starts_with[money:]>:
        - define moneyamount <[cost].substring[<[cost].last_index_of[:].add[1]>]>
        - define has <[player].money.is_more_than_or_equal_to[<[moneyamount]>]>
        - adjust def:item lore:<[item].lore.include_single[<tern[<[has]>].pass[<dark_green><bold>✓].fail[<dark_red><bold>✗]><&sp><gray><server.economy.format[<[moneyamount]>]>]>
      - else:
        - define costitem <[cost].as[item]>
        - if <[costitem].script.exists>:
          - define has <[player].inventory.contains_item[<[costitem].script.name>].quantity[<[costitem].quantity>]>
        - else:
          - define has <[player].inventory.contains_item[raw_exact:<[costitem]>].quantity[<[costitem].quantity>]>
        - adjust def:item lore:<[item].lore.include_single[<tern[<[has]>].pass[<dark_green><bold>✓].fail[<dark_red><bold>✗]><&sp><gray><[costitem].display.strip_color.if_null[<[costitem].material.name.replace[_].with[<&sp>].to_titlecase>]> <white>x<[costitem].quantity>]>
      - define cantupgrade false if:<[has].not>
    - adjust def:item lore:<[item].lore.include_single[<empty>]>
    - adjust def:item flag:Upgrade:<[id]>
    - if <[cantupgrade].exists>:
      - adjust def:item lore:<[item].lore.include_single[<dark_red>Missing resources]>
      - adjust def:item flag:BlockUpgrade:true
    - else:
      - adjust def:item enchantments:luck_of_the_sea=2
      - adjust def:item hides:ENCHANTS
      - adjust def:item lore:<[item].lore.include_single[<gold>--- Click to upgrade ---]>
  - determine <[item]>
dSpawners_Spawners_hasAllItems:
  type: procedure
  debug: false
  definitions: player|items
  script:
  - foreach <[items]> as:item:
    - if <[item].starts_with[money:]>:
      - define moneyamount <[item].substring[<[item].last_index_of[:].add[1]>]>
      - determine false if:<[player].money.is_less_than[<[moneyamount]>]>
    - else:
      - define costitem <[item].as[item]>
      - if <[costitem].script.exists>:
        - determine false if:<[player].inventory.contains_item[<[costitem].script.name>].quantity[<[costitem].quantity>].not>
      - else:
        - determine false if:<[player].inventory.contains_item[raw_exact:<[costitem]>].quantity[<[costitem].quantity>].not>
  - determine true
dSpawners_Spawners_getUpgradeGui:
  type: procedure
  debug: false
  definitions: location|player
  script:
    - define spawnerItem <proc[dSpawners_Spawners_getSpawnerItem].context[<[location]>].with_flag[location:<[location]>]>
    # If this spawner type needs recharging, add the information about recharging to the lore
    - if <[location].flag[script].as[script].data_key[data].contains[Recharge]>:
      - adjust def:spawnerItem flag:recharge
      - define rechargeData <[location].flag[script].as[script].data_key[data.Recharge]>
      - define addedLore <list[<&sp>|<dark_gray>--------------------]>
      - define addedLore:->:<gold><bold>Recharge
      - define "addedLore:->:<white>Charge: <gray><tern[<[location].has_flag[rechargeduration]>].pass[<[location].flag_expiration[rechargeduration].from_now.formatted>].fail[0s]> / <[rechargeData].get[MaxDuration].as[duration].formatted>"
      - define canRecharge <[location].flag_expiration[rechargeduration].from_now.if_null[<duration[0]>].add[<[rechargeData].get[CostDuration]>].is_less_than[<[rechargeData].get[MaxDuration]>]>
      - define "addedLore:->:<white>Cost: <gray>(per <[rechargeData].get[CostDuration].as[duration].formatted>)" if:<[canRecharge]>
      - foreach <[rechargeData].get[Cost]> as:cost if:<[canRecharge]>:
        - if <[cost].starts_with[money:]>:
          - define moneyamount <[cost].substring[<[cost].last_index_of[:].add[1]>]>
          - define has <[player].money.is_more_than_or_equal_to[<[moneyamount]>]>
          - define "addedLore:->:<tern[<[has]>].pass[<dark_green><bold>✓].fail[<dark_red><bold>✗]> <gray><server.economy.format[<[moneyamount]>]>"
        - else:
          - define costitem <[cost].as[item]>
          - if <[costitem].script.exists>:
            - define has <[player].inventory.contains_item[<[costitem].script.name>].quantity[<[costitem].quantity>]>
          - else:
            - define has <[player].inventory.contains_item[raw_exact:<[costitem]>].quantity[<[costitem].quantity>]>
          - define "addedLore:->:<tern[<[has]>].pass[<dark_green><bold>✓].fail[<dark_red><bold>✗]> <gray><[costitem].display.strip_color.if_null[<[costitem].material.name.replace[_].with[ ].to_titlecase>]> <white>x<[costitem].quantity>"
      - define addedLore:->:<&8>--------------------
      - define "addedLore:->:<red>Breaking a spawner will destroy"
      - define "addedLore:->:<red> any remaining charge it has"
      - if <[canRecharge]>:
        # Add action lore if the player has all the items
        - adjust def:spawnerItem flag:recharge:true
        - if <proc[dSpawners_Spawners_hasAllItems].context[<[player]>|<[rechargeData].get[Cost]>]>:
          - define "addedLore:->:<gold>--- Click to add charge ---"
        - else:
          - define "addedLore:->:<dark_red>Missing resources"
      - else:
        - define "addedLore:->:<dark_red>Spawner is near max charge"
      - adjust def:spawnerItem lore:<[spawnerItem].lore.include[<[addedLore]>]>
    - define upgradeIcons <proc[dSpawners_Spawners_getUpgradeItems].context[<[location]>|<[player]>]>
    - determine <inventory[dSpawners_SpawnerGUI].include[<list[<[spawnerItem]>].include[<[upgradeIcons]>]>]>
dSpawners_Spawners_reapplyUpgrades:
  type: task
  debug: false
  definitions: location|player
  script:
  # Collect the base stats of the spawner and apply them
  - define default <script[dSpawners_SpawnerConfig].data_key[data.DefaultStats]>
  - define defaultType <[location].flag[script].as[script].data_key[data.BaseStats]>
  - adjust <[location]> <[default].include[<[defaultType]>]>
  # For any upgrades, perform their OnPlace event
  - if <[location].has_flag[Upgrades]>:
    - foreach <[location].flag[Upgrades].keys> as:upgrade:
      - define level <[location].flag[Upgrades.<[upgrade]>]>
      - if <script[dspawners_upgradeconfig].list_keys[data.Upgrades.<[upgrade]>.Actions].if_null[<list>].contains[OnPlace]>:
        - run <script[dspawners_upgradeconfig]> path:data.Upgrades.<[upgrade]>.Actions.OnPlace def.location:<[location]> def.level:<[level]> def.player:<[player]>
dSpawners_Spawners_registerShard:
  type: task
  debug: false
  definitions: tier|scriptname
  script:
  # Check whether this shard type is already registered and emit a warning if it is
  - if <server.has_flag[dSpawners.SubModules.Shards.<[tier]>]>:
    - announce to_console "<script[dSpawners_SpawnerConfig].parsed_key[data.Prefix]><yellow>Spawner shard with tier <[tier]> (<server.flag[dSpawners.SubModules.Shards.<[tier]>]>) is being overwritten by item <[scriptname]>"
  #- else:
    #- announce to_console "<script[dSpawners_SpawnerConfig].parsed_key[data.Prefix]>Registered spawner shard tier <[tier]> with item <[scriptname]>"
  - flag server dSpawners.SubModules.Shards.<[tier]>:<[scriptname]>
dSpawners_Spawners_registerSpawner:
  type: task
  debug: false
  definitions: entitytype|scriptname
  script:
  # Check whether this entity type is already registered and emit a warning if it is
  - if <server.has_flag[dSpawners.SubModules.Spawner.<[entitytype]>]>:
    - announce to_console "<script[dSpawners_SpawnerConfig].parsed_key[data.Prefix]><yellow>Spawner for entity <[entitytype]> (<server.flag[dSpawners.SubModules.Spawner.<[entitytype]>]>) is being overwritten by item <[scriptname]>"
  #- else:
    #- announce to_console "<script[dSpawners_SpawnerConfig].parsed_key[data.Prefix]>Registered spawner for entity <[entitytype]> with item <[scriptname]>"
  - flag server dSpawners.SubModules.Spawner.<[entitytype]>:<[scriptname]>
dSpawners_Spawners_registerCore:
  type: task
  debug: false
  definitions: entitytype|scriptname
  script:
  # Check whether this entity's spawner core is already registered and emit a warning if it is
  - if <server.has_flag[dSpawners.SubModules.Core.<[entitytype]>]>:
    - announce to_console "<script[dSpawners_SpawnerConfig].parsed_key[data.Prefix]><yellow>Spawner core for entity <[entitytype].to_uppercase> (<server.flag[dSpawners.SubModules.Core.<[entitytype].to_uppercase>]>) is being overwritten by item <[scriptname]>"
  #- else:
    #- announce to_console "<script[dSpawners_SpawnerConfig].parsed_key[data.Prefix]>Registered spawner core for entity <[entitytype].to_uppercase> with item <[scriptname]>"
  - flag server dSpawners.SubModules.Core.<[entitytype].to_uppercase>:<[scriptname]>