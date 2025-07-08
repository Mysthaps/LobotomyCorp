local blind = {
    name = "In the Name of Love and Hate",
    pos = {x = 0, y = 1},
    atkas = "v",
    dollars = 8, 
    mult = 2, 
    vars = {}, 
    debuff = {},
    boss = {min = 1, max = 10, showdown = true},
    boss_colour = HEX('CB34B4'),
    passives = {
        "psv_lobc_hatred",
        "psv_lobc_adverse",
        "psv_lobc_arcana",
    }
}

return blind