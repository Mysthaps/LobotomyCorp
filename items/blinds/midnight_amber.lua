local blind = {
    name = "Amber Midnight",
    lobc_color = "amber",
    lobc_time = "midnight",
    pos = {x = 0, y = 17},
    dollars = 5, 
    mult = 2, 
    vars = {}, 
    debuff = {},
    boss = {min = 1, max = 10},
    loc_txt = {}
}

blind.set_blind = function(self, reset, silent)
    local available_cards = {}

    for _, v in ipairs(G.playing_cards) do
        available_cards[#available_cards+1] = v
    end

    for i = 1, math.ceil(#available_cards/2) do
        local chosen_card, chosen_card_key = pseudorandom_element(available_cards, pseudoseed("random_card"))
        SMODS.debuff_card(chosen_card, true, 'amber_debuff')
        table.remove(available_cards, chosen_card_key)
    end
end

blind.press_play = function(self)
    G.E_MANAGER:add_event(Event({
        func = function()
            local destroyed_cards = {}
            for _, v in ipairs(G.play.cards) do
                if v.debuff then
                    destroyed_cards[#destroyed_cards+1] = v
                    v:start_dissolve() 
                end
            end
            SMODS.calculate_context({remove_playing_cards = true, removed = destroyed_cards})
            return true 
        end 
    }))
end

blind.defeat = function(self)
    for _, v in ipairs(G.playing_cards) do
        SMODS.debuff_card(v, false, 'amber_debuff')
    end
    check_for_unlock({type = "lobc_midnight"})
end

blind.disable = function(self)
    for _, v in ipairs(G.playing_cards) do
        SMODS.debuff_card(v, false, 'amber_debuff')
    end
end

return blind