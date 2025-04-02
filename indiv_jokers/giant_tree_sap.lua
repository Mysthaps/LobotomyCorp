local joker = {
    name = "Giant Tree Sap",
    config = {extra = {
        gain = 1, money = 6, chance = 0, inc = 15, cap = 60
    }}, rarity = 2, cost = 6,
    pos = {x = 2, y = 5}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "he",
    discover_rounds = 7,
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

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { 
        card.ability.extra.gain, card.ability.extra.money, 
        card.ability.extra.chance, card.ability.extra.inc, card.ability.extra.cap,
        card:check_rounds(3), card:check_rounds(5), card:check_rounds(7)
    }
    local desc_key = self.key
    if card:check_rounds(3) < 3 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(5) < 5 then
        desc_key = 'dis_'..desc_key..'_2'
    elseif card:check_rounds(7) < 7 then
        desc_key = 'dis_'..desc_key..'_3'
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if not self.discovered and card.area ~= G.jokers then
        localize{type = 'descriptions', key = 'und_'..self.key, set = "Other", nodes = desc_nodes, vars = vars}
    elseif specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
    end
end

return joker

-- yummy tree yummy