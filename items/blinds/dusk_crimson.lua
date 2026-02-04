local blind = {
    name = "Crimson Dusk",
    lobc_color = "crimson",
    lobc_time = "dusk",
    summon = "bl_lobc_noon_crimson",
    pos = {x = 0, y = 4},
    dollars = 5, 
    mult = 2, 
    vars = {}, 
    debuff = {},
    boss = {min = 1, max = 10},
    passives = {
        "psv_lobc_harmony"
    }
}

blind.defeat = function(self)
    if G.GAME.facing_blind then ease_hands_played(1) end
end

return blind