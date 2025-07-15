local blind = {
    name = "Hatred",
    pos = {x = 0, y = 20},
    dollars = 8, 
    mult = 2, 
    vars = {}, 
    debuff = {
        akyrs_cannot_be_disabled = true,
        akyrs_blind_difficulty = "expert",
    },
    boss = {showdown = true, min = 10, max = 10},
    boss_colour = HEX('CB34B4'),
    passives = {
        "psv_lobc_hatred",
        "psv_lobc_adverse",
        "psv_lobc_arcana",
    },
    lobc_bg = {new_colour = darken(HEX("CB34B4"), 0.1), special_colour = darken(HEX("CB34B4"), 0.3), contrast = 0.7}
}

blind.set_blind = function(self)
    local eval_func = function()
        return G.GAME.blind and G.GAME.blind.config.blind.key == 'bl_lobc_mg_hatred'
    end
    lobc_abno_text("long_arms", eval_func, 2, 6)
end

blind.drawn_to_hand = function(self)

end

return blind