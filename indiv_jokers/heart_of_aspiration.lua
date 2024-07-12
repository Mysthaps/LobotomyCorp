local joker = {
    name = "The Heart of Aspiration",
    config = {extra = {reset = 2, x_mult = 2, gain = 1}}, rarity = 2, cost = 6,
    pos = {x = 9, y = 4}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = false,
    abno = true,
    risk = "teth",
    discover_rounds = 6,
    loc_txt = {},
}

joker.calculate = function(self, card, context)
    if context.setting_blind and not context.getting_sliced and not context.blueprint then
        G.GAME.lobc_no_hands_reset = true
    end

    if context.cardarea == G.jokers and context.before and not context.blueprint then
        card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.gain
        return {
            message = localize('k_upgrade_ex'),
            card = card,
            colour = G.C.MULT
        }
    end

    if context.joker_main and card.ability.extra.x_mult > 1 then
        return {
            message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.x_mult}},
            Xmult_mod = card.ability.extra.x_mult, 
            colour = G.C.MULT
        }
    end

    if context.end_of_round and not context.repetition and not context.individual and G.GAME.blind.boss then
        card.ability.extra.x_mult = card.ability.extra.reset
        if not G.GAME.modifiers.lobc_netzach then
            G.GAME.lobc_no_hands_reset = false
        end
        SMODS.eval_this(card, {
            message = localize('k_reset')
        })
    end
end

joker.add_to_deck = function(self, card, from_debuff)
    G.GAME.lobc_no_hands_reset = true
end

joker.remove_from_deck = function(self, card, from_debuff)
    if not G.GAME.modifiers.lobc_netzach and #SMODS.find_card("j_lobc_heart_of_aspiration") == 1 then
        G.GAME.lobc_no_hands_reset = false
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { 
        card.ability.extra.x_mult, card.ability.extra.gain,
        card:check_rounds(2), card:check_rounds(4), card:check_rounds(6)
    }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(4) < 4 then
        desc_key = 'dis_'..desc_key..'_2'
    elseif card:check_rounds(6) < 6 then
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

-- funny free clashing abno card