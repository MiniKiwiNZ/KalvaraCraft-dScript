# Sheep can be used to obtain wool, but without awareness they won't be infinite wool
AR_SpawnerCore_Sheep:
  type: item
  material: white_wool
  display name: <&e>Sheep Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  flags:
    PreventPlace: true
  lore:
  - <&f>Mob Type: <&6>Sheep
  - <&f>Shard Tier: <&6>1
  - <empty>
  - Used to craft a Sheep spawner
  - <&f>[<&a>Uncommon<&f>]
AR_SpawnerCore_Sheep2:
  type: item
  material: white_wool
  display name: <&e>Sheep Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  flags:
    PreventPlace: true
  lore:
  - <&f>Mob Type: <&6>Sheep
  - <&f>Shard Tier: <&6>2
  - <empty>
  - Used to craft a Sheep spawner
  - <&f>[<&9>Rare<&f>]
  recipes:
    1:
      type: shapeless
      input: AR_SpawnerCore_Sheep
AR_SpawnerCore_Sheep_Register:
  type: world
  debug: false
  events:
    on custom event id:ar_register_spawner_modules:
      - run AR_Spawners_registerCore def:SHEEP|AR_SpawnerCore_Sheep2
    on player kills sheep:
      - stop if:<context.entity.has_flag[from_spawner]>
      - if <util.random.int[1].to[512]> <= <proc[AR_Spawners_BoostThreshold].context[1|Cores|<player>]>:
        - flag server SpawnerDrops.Cores.Sheep:++
        - drop AR_SpawnerCore_Sheep2 <context.entity.location>
    on sheep spawns because BREEDING:
      - flag <context.entity> from_spawner