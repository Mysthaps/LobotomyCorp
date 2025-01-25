local blind = {
    name = "Crimson Noon",
    color = "crimson",
    time = "noon",
    summon = "bl_lobc_dawn_crimson",
    pos = {x = 0, y = 12},
    dollars = 4, 
    mult = 1.5, 
    vars = {}, 
    debuff = {},
    passives = {
        "psv_lobc_harmony"
    }
}

blind.defeat = function(self)
    if G.GAME.facing_blind then ease_hands_played(1) end
end

return blind