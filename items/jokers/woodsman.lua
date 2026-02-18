local joker = {
    name = "Warm-hearted Woodsman",
    config = {extra = {charge = 0, achievement = 0, active = false, destroyed = false}}, rarity = 2, cost = 5,
    pos = {x = 4, y = 1}, 
    blueprint_compat = false, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "he",
    discover_rounds = {1, 3, 6},
}

joker.calc_dollar_bonus = function(self, card)
    if card.ability.extra.charge > 0 then
        local money = card.ability.extra.charge * (#G.jokers.cards - (card.ability.extra.destroyed and 1 or 0))
        card.ability.extra.destroyed = false
        card.ability.extra.charge = card.ability.extra.charge - 1
        return money
    elseif card.ability.extra.active then
        local cost = 0
        for k, v in ipairs(G.jokers.cards) do
            if v ~= card and not SMODS.is_eternal(v, card) then
                cost = math.max(cost, v.sell_cost)
            end
        end
        local available_cards = {}
        for k, v in ipairs(G.jokers.cards) do
            if v.sell_cost == cost then
                available_cards[#available_cards+1] = v
            end
        end
        if #available_cards > 0 then
            local to_destroy = pseudorandom_element(available_cards, "woodsman_destroy")
            SMODS.destroy_cards(to_destroy, nil, true)
            play_sound("lobc_woodsman", 1, 0.7)
            card.ability.extra.charge = card.ability.extra.charge + 3
            card.ability.extra.destroyed = true
            SMODS.calculate_effect({
                message = localize{type = 'variable', key = 'lobc_a_warm_heart', vars = {3}},
                colour = HEX("EF2439")
            }, card)
        end
        if card.ability.extra.charge > 0 then return self:calc_dollar_bonus(card) end
    end
end

joker.calculate = function(self, card, context)
    if context.remove_playing_cards and context.removed then
        local charge = 0
        for _, v in ipairs(context.removed) do
            if v:is_suit("Clubs") then
                charge = charge + 1
            end
        end
        local gain = math.min(3 - card.ability.extra.charge, charge)
        if gain > 0 then
            card.ability.extra.active = true
            card.ability.extra.charge = card.ability.extra.charge + gain
            card.ability.extra.achievement = card.ability.extra.achievement + gain
            if card.ability.extra.achievement >= 15 then check_for_unlock({type = "lobc_logging"}) end
            return {
                message = localize{type = 'variable', key = 'lobc_a_warm_heart', vars = {gain}},
                colour = HEX("EF2439")
            }
        end
    end
end

joker.loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.charge}}
end

return joker

-- loggers