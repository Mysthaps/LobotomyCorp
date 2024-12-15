local blind = {
    name = "Dusk Ordeal",
    color = "base",
    time = "dusk",
    discovered = true,
    pos = {x = 0, y = 1},
    dollars = 5, 
    mult = 2, 
    vars = {}, 
    debuff = {},
    blind_list = {
        "dusk_green",
        "dusk_crimson",
        "dusk_amber"
    },
    boss = {min = 1, max = 10},
    loc_txt = {}
}

return blind