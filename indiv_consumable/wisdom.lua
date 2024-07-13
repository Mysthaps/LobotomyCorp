local cons = {
    name = "Wisdom",
    config = {},
    cost = 0,
    pos = {x = 0, y = 0},
    loc_txt = {},
    discovered = true,
}

-- Available if hand is active
cons.can_use = function(self, card)
    return G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED
end

cons.use = function(self, card, area, copier)
    G.E_MANAGER:add_event(Event({
        func = function()
            local _card = create_playing_card({
                front = pseudorandom_element(G.P_CARDS, pseudoseed('wisdom')), 
                center = G.P_CENTERS.c_base}, G.hand, nil, nil, {G.C.SECONDARY_SET.Enhanced})
            G.GAME.blind:debuff_card(_card)
            G.hand:sort()
            return true
        end
    })) 
    playing_card_joker_effects({true})
end

return cons