
local disable_biters = {
    -- PrototypeBase
    type = "technology",
    name = "rd-biter-biter-disable",

    -- Prototype/Technology
    icon = "__rd-biter-remover__/graphics/biter-disable.png",
    icon_size = 256,
    unit = {
        count = 10000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"military-science-pack", 1},
            {"utility-science-pack", 1},
            {"space-science-pack", 1},
        },
        time = 30
    },
    upgrade = true,
    max_level = "infinite",
    effects = {},
    visible_when_disabled = true,
    prerequisites = {"space-science-pack", "artillery"},
}

local enable_biters = {
    -- PrototypeBase
    type = "technology",
    name = "rd-biter-biter-enable",

    -- Prototype/Technology
    icon = "__rd-biter-remover__/graphics/biter-enable.png",
    icon_size = 256,
    unit = {
        count = 10000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"military-science-pack", 1},
            {"utility-science-pack", 1},
            {"space-science-pack", 1},
        },
        time = 30
    },
    upgrade = true,
    max_level = "infinite",
    effects = {},
    visible_when_disabled = true,
    prerequisites = {"space-science-pack", "artillery"},
}

local disable_pollution = {
    -- PrototypeBase
    type = "technology",
    name = "rd-biter-pollution-disable",

    -- Prototype/Technology
    icon = "__rd-biter-remover__/graphics/pollution-disable.png",
    icon_size = 256,
    unit = {
        count = 10000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"military-science-pack", 1},
            {"utility-science-pack", 1},
            {"space-science-pack", 1},
        },
        time = 30
    },
    upgrade = true,
    max_level = "infinite",
    effects = {},
    visible_when_disabled = true,
    prerequisites = {"space-science-pack", "artillery"},
}

local enable_pollution = {
    -- PrototypeBase
    type = "technology",
    name = "rd-biter-pollution-enable",

    -- Prototype/Technology
    icon = "__rd-biter-remover__/graphics/pollution-enable.png",
    icon_size = 256,
    unit = {
        count = 10000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"military-science-pack", 1},
            {"utility-science-pack", 1},
            {"space-science-pack", 1},
        },
        time = 30
    },
    upgrade = true,
    max_level = "infinite",
    effects = {},
    visible_when_disabled = true,
    prerequisites = {"space-science-pack", "artillery"},
}

local clear_biters = {
    -- PrototypeBase
    type = "technology",
    name = "rd-biter-biter-clear",

    -- Prototype/Technology
    icon = "__rd-biter-remover__/graphics/biter-clear.png",
    icon_size = 256,
    unit = {
        count = 10000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"military-science-pack", 1},
            {"utility-science-pack", 1},
            {"space-science-pack", 1},
        },
        time = 30
    },
    upgrade = true,
    max_level = "infinite",
    effects = {},
    visible_when_disabled = true,
    prerequisites = {"space-science-pack", "artillery"},
}

local clear_pollution = {
    -- PrototypeBase
    type = "technology",
    name = "rd-biter-pollution-clear",

    -- Prototype/Technology
    icon = "__rd-biter-remover__/graphics/pollution-clear.png",
    icon_size = 256,
    unit = {
        count = 10000,
        ingredients = {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"chemical-science-pack", 1},
            {"military-science-pack", 1},
            {"utility-science-pack", 1},
            {"space-science-pack", 1},
        },
        time = 30
    },
    upgrade = true,
    max_level = "infinite",
    effects = {},
    visible_when_disabled = true,
    prerequisites = {"space-science-pack", "artillery"},
}


data:extend({
    disable_biters,
    enable_biters,
    disable_pollution,
    enable_pollution,
})

if not settings.startup["rd-biter-combine-research"].value then
    data:extend({
        clear_biters,
        clear_pollution,
    })
end




