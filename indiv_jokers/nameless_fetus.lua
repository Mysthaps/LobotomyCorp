local joker = {
    name = "Nameless Fetus",
    config = {extra = {x_mult = 4, x_mult_penalty = 0.1, chosen_hand = nil}}, rarity = 2, cost = 8,
    pos = {x = 8, y = 0}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "he",
    discover_rounds = 8,
    loc_txt = {},
}

joker.calculate = function(self, card, context)
    if context.destroying_card and not context.blueprint and #context.full_hand == 1 and 
    not context.full_hand[1].ability.eternal and G.GAME.current_round.hands_played == 0 then
        local _poker_hands = {}
        for k, v in pairs(G.GAME.hands) do
            if v.visible and k ~= card.ability.extra.chosen_hand then _poker_hands[#_poker_hands + 1] = k end
        end
        card.ability.extra.chosen_hand = pseudorandom_element(_poker_hands, pseudoseed('fetus_reset'))
        SMODS.eval_this(card, {
            message = localize("k_reset")
        })
        return true
    end

    if context.joker_main then
        if context.scoring_name == card.ability.extra.chosen_hand then
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.x_mult}},
                Xmult_mod = card.ability.extra.x_mult
            }
        else
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.x_mult_penalty}},
                Xmult_mod = card.ability.extra.x_mult_penalty
            }
        end
    end
end

joker.set_ability = function(self, card, initial, delay_sprites)
    local _poker_hands = {}
    for k, v in pairs(G.GAME.hands) do
        if v.visible and k ~= card.ability.extra.chosen_hand then _poker_hands[#_poker_hands + 1] = k end
    end
    card.ability.extra.chosen_hand = pseudorandom_element(_poker_hands, pseudoseed('fetus'))
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local hand_var = localize(card.ability.extra.chosen_hand, 'poker_hands')
    local vars = { hand_var, card.ability.extra.x_mult, card.ability.extra.x_mult_penalty, 
        card:check_rounds(2), card:check_rounds(4), card:check_rounds(8) }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(4) < 4 then
        desc_key = 'dis_'..desc_key..'_2'
    elseif card:check_rounds(8) < 8 then
        desc_key = 'dis_'..desc_key..'_3'
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
    end
end

return joker