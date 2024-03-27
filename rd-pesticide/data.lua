

local grenade = {
  type = "capsule",
  name = "grenade",
  icon = "__base__/graphics/icons/grenade.png",
  icon_size = 64, icon_mipmaps = 4,
  capsule_action =
  {
    type = "throw",
    attack_parameters =
    {
      type = "projectile",
      activation_type = "throw",
      ammo_category = "grenade",
      cooldown = 30,
      projectile_creation_distance = 0.6,
      range = 15,
      ammo_type =
      {
        category = "grenade",
        target_type = "position",
        action =
        {
          {
            type = "direct",
            action_delivery =
            {
              type = "projectile",
              projectile = "grenade",
              starting_speed = 0.3
            }
          },
          {
            type = "direct",
            action_delivery =
            {
              type = "instant",
              target_effects =
              {
                {
                  type = "play-sound",
                  sound = sounds.throw_projectile
                }
              }
            }
          }
        }
      }
    }
  },
  -- radius_color = { r = 0.25, g = 0.05, b = 0.25, a = 0.25 },
  subgroup = "capsule",
  order = "a[grenade]-a[normal]",
  stack_size = 100
}

