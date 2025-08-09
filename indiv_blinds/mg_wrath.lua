local blind = {
    name = "Wrath",
    pos = {x = 0, y = 21},
    dollars = 8, 
    mult = 4, 
    vars = {}, 
    debuff = {
        akyrs_cannot_be_disabled = true,
        akyrs_blind_difficulty = "expert",
    },
    boss = {showdown = true, min = 10, max = 10},
    boss_colour = HEX('413536'),
    passives = {
        "psv_lobc_fixed_encounter",
        "psv_lobc_realm",
        "psv_lobc_blind_rage",
        "psv_lobc_today_play",
        "psv_lobc_exploited",
        "psv_lobc_magical_girl"
    },
    lobc_bg = {new_colour = lighten(HEX("413536"), 0.1), special_colour = lighten(HEX("413536"), 0.3), contrast = 0.9}
}

blind.set_blind = function(self)
    local eval_func = function()
        return G.GAME.blind and G.GAME.blind.config.blind.key == 'bl_lobc_mg_wrath'
    end
    lobc_abno_text("wrath", eval_func, 2, 4)
    lobc_abno_text("wrath_alt", eval_func, 2, 4)
    G.GAME.blind.hands_sub = 0
    G.GAME.blind:set_text()
end

blind.lobc_loc_txt = function(self)
    if not G.GAME.blind.hands_sub then return end
    return {
        key = G.GAME.blind.hands_sub > 1 and "bl_lobc_mg_wrath_alt" or "bl_lobc_mg_wrath_effect",
    }
end

return blind