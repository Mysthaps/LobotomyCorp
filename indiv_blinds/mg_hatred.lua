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
        "psv_lobc_magical_girl"
    },
    lobc_bg = {new_colour = darken(HEX("CB34B4"), 0.1), special_colour = darken(HEX("CB34B4"), 0.3), contrast = 0.7}
}

blind.set_blind = function(self)
    local eval_func = function()
        return G.GAME.blind and G.GAME.blind.config.blind.key == 'bl_lobc_mg_hatred'
    end
    lobc_abno_text("hatred", eval_func, 2, 6)
    G.GAME.blind.hysteria = 0
    G.GAME.blind.hands_sub = -2 -- Hands passed
    G.GAME.blind.transformed = false
    G.GAME.blind.alt_skill = false
    G.GAME.blind:set_text()
end

blind.drawn_to_hand = function(self)
    G.GAME.blind.hands_sub = math.abs(G.GAME.blind.hands_sub + 1) % 3
    -- [Arcana Slave] Switch to alt skill every 3 hands
    if G.GAME.blind.hands_sub == 0 then
        G.GAME.blind.alt_skill = true
    end
    G.GAME.blind:set_text()
end

blind.cry_cap_score = function(self, score)
    -- [Adverse Change] Up to 50% Blind Size
    if to_big(G.GAME.chips) + score >= to_big(G.GAME.blind.chips) / 2 then
        G.GAME.blind.alt_skill = true
        return to_big(G.GAME.blind.chips) / 2 - to_big(G.GAME.chips)
    end
    return score
end

blind.lobc_loc_txt = function(self)

    return {
        key = G.GAME.blind.alt_skill and "bl_lobc_mg_hatred_alt" or "bl_lobc_mg_hatred_effect", 
        vars = {
            G.GAME.blind.hysteria,
            G.GAME.blind.hysteria and (G.GAME.blind.alt_skill and G.GAME.blind.hysteria * 10 or G.GAME.blind.hysteria + 1)
        }
    }
end

return blind