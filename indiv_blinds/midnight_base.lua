local blind = {
    name = "Midnight Ordeal",
    color = "base",
    time = "midnight",
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
    loc_txt = {},
    no_collection = true,
}

return blind