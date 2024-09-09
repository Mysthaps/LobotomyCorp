local cons = {
    name = "TT2 Protocol",
    config = {},
    cost = 10,
    pos = {x = 1, y = 0},
    loc_txt = {},
    no_doe = true,
}

cons.add_to_deck = function(self, card, from_debuff)
    if G.GAME.modifiers.lobc_gebura then
        G.E_MANAGER:add_event(Event({
            func = function()
                card.ability.eternal = true
                card:set_edition({negative = true})
                return true
            end
        }))
    end
end

-- Available if Ante % 8 isn't 7 or 0
cons.can_use = function(self, card)
    return G.STATE == G.STATES.BLIND_SELECT and ((G.GAME.round_resets.ante - 1) % 8 < 6) and not (G.GAME.modifiers.lobc_gebura and G.GAME.round_resets.ante > 8)
end

cons.use = function(self, card, area, copier)
    local temp = G.GAME.round_resets.ante % 8
    ease_ante(7 - temp)

    local first = true
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            local available_cards = {}
            for _, v in ipairs(G.playing_cards) do
                if not v.highlighted then available_cards[#available_cards+1] = v end
            end
            for i = 1, (G.GAME.modifiers.lobc_gebura and 8 or 4) * (7 - temp) do
                if #available_cards <= 0 then break end
                local chosen_card, chosen_card_key = pseudorandom_element(available_cards, pseudoseed("tt2_proto"))
                table.remove(available_cards, chosen_card_key)
                chosen_card:start_dissolve() 
                play_sound("lobc_gebura_slash", math.random(90, 110)/100, first and 0.5 or 0)
                first = nil
            end
        return true
        end
    }))
    delay(0.5)
end

cons.loc_vars = function(self, info_queue, card)
    return {vars = {G.GAME.modifiers.lobc_gebura and 8 or 4}}
end

cons.update = function(self, card, dt)
    if ((G.GAME.round_resets.ante - 1) % 8 >= 6) or (G.GAME.modifiers.lobc_gebura and G.GAME.round_resets.ante > 8) then
        card.ability.tt2_debuff = true
        card:set_debuff(true)
    else
        card.ability.tt2_debuff = nil
        card:set_debuff(false)
    end
end

return cons