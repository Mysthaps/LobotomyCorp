local blind = {
    name = "Amber Dusk",
    color = "amber",
    time = "dusk",
    pos = {x = 0, y = 3},
    dollars = 5, 
    mult = 2, 
    vars = {}, 
    debuff = {},
    boss = {min = 1, max = 10},
    loc_txt = {}
}

blind.press_play = function(self)
    local destroyed_cards = {}
    G.E_MANAGER:add_event(Event({
        func = function()
            for _, v in ipairs(G.play.cards) do
                if v.debuff then
                    destroyed_cards[#destroyed_cards+1] = card
                    v:start_dissolve() 
                end
            end
            return true 
        end 
    }))
    delay(0.2)
    for i = 1, #G.jokers.cards do
        G.jokers.cards[i]:calculate_joker({remove_playing_cards = true, removed = destroyed_cards})
    end
    if #destroyed_cards > 0 then G.GAME.blind:wiggle() end
    return #destroyed_cards > 0
end

blind.defeat = function(self)
    for _, v in ipairs(G.playing_cards) do
        v.ability.amber_debuff = nil
    end
end

blind.disable = function(self)
    for _, v in ipairs(G.playing_cards) do
        v.ability.amber_debuff = nil
    end
end

blind.debuff_card = function(self, card, from_blind)
    if card.ability.amber_debuff then
        card:set_debuff(true)
        return true
    end
end

-- Amber Dusk's debuff per card drawn
local draw_from_deck_to_handref = G.FUNCS.draw_from_deck_to_hand
function G.FUNCS.draw_from_deck_to_hand(e)
    draw_from_deck_to_handref(e)
    if G.GAME.blind.config.blind.key == "bl_lobc_dusk_amber" and not G.GAME.blind.disabled then
        local cards_drawn = e or math.min(#G.deck.cards, G.hand.config.card_limit - #G.hand.cards)
        local available_cards = {}
        local proc = false

        for _, v in ipairs(G.hand.cards) do
            if not v.ability.amber_debuff then available_cards[#available_cards+1] = v end
        end
        for _, v in ipairs(G.deck.cards) do
            if not v.ability.amber_debuff then available_cards[#available_cards+1] = v end
        end

        for i = 1, cards_drawn do
            if #available_cards > 0 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function() 
                        local chosen_card, chosen_card_key = pseudorandom_element(available_cards, pseudoseed("dusk_amber"))
                        chosen_card:set_debuff(true)
                        chosen_card.ability.amber_debuff = true
                        table.remove(available_cards, chosen_card_key)
                        proc = true
                        return true
                    end 
                }))
            end
        end

        if proc then G.GAME.blind:wiggle() end
    end
end

return blind