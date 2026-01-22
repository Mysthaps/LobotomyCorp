local blind = {
    name = "Midnight Ordeal",
    lobc_color = "base",
    lobc_time = "midnight",
    discovered = true,
    pos = {x = 0, y = 15},
    dollars = 5, 
    mult = 2, 
    vars = {}, 
    debuff = {},
    blind_list = {
        "midnight_green",
        "midnight_violet",
        "midnight_amber"
    },
    boss = {min = 1, max = 10},
    no_collection = true,
}

return blind