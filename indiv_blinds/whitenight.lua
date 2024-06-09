local blind = {
    name = "WhiteNight",
    slug = "whitenight", 
    dollars = 8, 
    mult = 60, 
    vars = {}, 
    debuff = {},
    boss = {showdown = false, min = 1, max = 10},
    boss_colour = HEX('000000'),
    loc_txt = {
        name = "WhiteNight",
        text = {
            "Scored Apostles reduce",
            "blind size by 5X Base"
        }
    }
}

return blind