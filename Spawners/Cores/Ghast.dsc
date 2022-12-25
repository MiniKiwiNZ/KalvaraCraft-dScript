# Ghasts drop ghast tears used for ender crystals and regen potions
dSpawners_SpawnerCore_Ghast:
  debug: false
  type: item
  material: ghast_tear
  display name: <&e>Ghast Essence
  mechanisms:
    custom_model_data: 1
    hides:
    - ENCHANTS
  enchantments:
  - unbreaking:10
  lore:
  - <&f>Mob Type: <&6>Ghast
  - <&f>Shard Tier: <&6>4
  - <empty>
  - Used to craft a Ghast spawner
  - <&f>[<&6><&l>Legendary<&f>]
dSpawners_SpawnerCore_Ghast_Register:
  type: world
  debug: false
  events:
    on custom event id:dspawners_register_spawner_modules:
      - run dSpawners_Spawners_registerCore def:GHAST|dSpawners_SpawnerCore_Ghast
    on GHAST dies cause:projectile:
      - stop if:<context.entity.has_flag[from_spawner]>
      - stop if:<context.entity.has_flag[fireballed].not>
      - if <util.random.int[1].to[192]> <= <proc[dSpawners_Spawners_BoostThreshold].context[1|Cores|<context.entity.flag[fireballed]>]>:
        - determine <context.drops.include_single[dSpawners_SpawnerCore_Ghast]>
    on FIREBALL hits GHAST:
      - stop if:<context.shooter.is_player.not>
      - flag <context.hit_entity> fireballed:<context.shooter>