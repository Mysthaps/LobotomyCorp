local blind = {
    name = "Crimson Dawn",
    color = "crimson",
    time = "dawn",
    pos = {x = 0, y = 8},
    dollars = 3, 
    mult = 0.8, 
    vars = {}, 
    debuff = {},
    boss = {min = 1, max = 10},
    loc_txt = {},
}


blind.press_play = function(self)
    if G.GAME.current_round.hands_played % 3 == 2 then
        local available_cards = {}
        for _, v in ipairs(G.jokers.cards) do
            if v ~= card and not v.ability.eternal then available_cards[#available_cards+1] = v end
        end

        if #available_cards > 0 then
            local selected_card = pseudorandom_element(available_cards, pseudoseed("price_of_silence"))
            G.FUNCS.sell_card({config = {ref_table = selected_card}})
            G.GAME.blind.triggered = true
        end
    end
end

return blind