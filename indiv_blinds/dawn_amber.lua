local blind = {
    name = "Amber Dawn",
    color = "amber",
    time = "dawn",
    pos = {x = 0, y = 7},
    dollars = 3, 
    mult = 1, 
    vars = {}, 
    debuff = {},
    boss = {min = 1, max = 10},
    loc_txt = {}
}

blind.press_play = function(self)
    local available_cards = {}

    for _, v in ipairs(G.deck.cards) do
        if not v.ability.amber_debuff then available_cards[#available_cards+1] = v end
    end

    for i = 1, math.min(4, math.ceil(#available_cards)) do
        local chosen_card, chosen_card_key = pseudorandom_element(available_cards, pseudoseed("amber_dawn"))
        chosen_card:set_debuff(true)
        chosen_card.ability.amber_debuff = true
        table.remove(available_cards, chosen_card_key)
    end

    return true
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

return blind