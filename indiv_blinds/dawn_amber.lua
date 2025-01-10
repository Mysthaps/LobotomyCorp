local blind = {
    name = "Amber Dawn",
    color = "amber",
    time = "dawn",
    pos = {x = 0, y = 7},
    dollars = 3, 
    mult = 1, 
    vars = {}, 
    debuff = {},
    loc_txt = {}
}

blind.press_play = function(self)
    local available_cards = {}

    for _, v in ipairs(G.deck.cards) do
        if not v.ability.amber_debuff then available_cards[#available_cards+1] = v end
    end

    for i = 1, math.min(4, math.ceil(#available_cards)) do
        local chosen_card, chosen_card_key = pseudorandom_element(available_cards, pseudoseed("amber_dawn"))
        SMODS.debuff_card(chosen_card, true, 'amber_debuff')
        table.remove(available_cards, chosen_card_key)
    end

    return true
end

blind.defeat = function(self)
    for _, v in ipairs(G.playing_cards) do
        SMODS.debuff_card(v, false, 'amber_debuff')
    end
end

blind.disable = function(self)
    for _, v in ipairs(G.playing_cards) do
        SMODS.debuff_card(v, false, 'amber_debuff')
    end
end

return blind