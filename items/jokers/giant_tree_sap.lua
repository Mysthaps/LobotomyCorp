local joker = {
    name = "Giant Tree Sap",
    config = {extra = {
        gain = 1, money = 6, chance = 0, inc = 15, cap = 60
    }}, rarity = 2, cost = 6,
    pos = {x = 2, y = 5}, 
    blueprint_compat = false, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "he",
    discover_rounds = {3, 5, 7},
    discover_override = {"lobc_obs_active_1", nil, nil}
}

joker.lobc_active = function(self, card)
    if card.ability.extra.chance <= 0 or pseudorandom("giant_tree_sap") > card.ability.extra.chance/100 then
        ease_hands_played(card.ability.extra.gain)
        ease_dollars(card.ability.extra.money)
        card.ability.extra.chance = math.min(card.ability.extra.chance + card.ability.extra.inc, card.ability.extra.cap)
    else
        ease_hands_played(-G.GAME.current_round.hands_left + 1)
        ease_dollars(-G.GAME.dollars)
        card:start_dissolve()
    end
end

joker.lobc_can_use_active = function(self, card)
    return G.STATE == G.STATES.SELECTING_HAND
end

joker.loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = {key = 'lobc_active_ability', set = 'Other'}
    return {vars = {
        card.ability.extra.gain, card.ability.extra.money, 
        card.ability.extra.chance, card.ability.extra.inc, card.ability.extra.cap
    }}
end

return joker

-- yummy tree yummy