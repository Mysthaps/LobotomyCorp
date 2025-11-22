local joker = {
    name = "The Knight of Despair",
    config = {extra = {charge = 0}}, rarity = 3, cost = 8,
    pos = {x = 5, y = 4}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "waw",
    discover_rounds = {1, 3, 5, 7},
    no_pool_flag = "knight_of_despair_breach",
}

joker.calculate = function(self, card, context)
    
end

joker.loc_vars = function(self, info_queue, card)
    if not card.fake_card and card:check_rounds() >= 3 then info_queue[#info_queue+1] = {key = 'lobc_magical_girl_temp', set = 'Other'} end
    return {vars = {card.ability.extra.dollars, card.ability.extra.decrease}}
end

return joker

-- tiphxodia gaming