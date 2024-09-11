local joker = {
    name = "Old Lady",
    config = {extra = {mult = 0, gain = 2, loss = 10}}, rarity = 1, cost = 6,
    pos = {x = 7, y = 0}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = false,
    abno = true,
    risk = "teth",
    discover_rounds = 5,
    loc_txt = {},
}

joker.calculate = function(self, card, context)
    if context.cardarea == G.jokers and not context.blueprint then
        if context.before then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT,
                card = card
            }
        end
    end

    if context.joker_main then
        if card.ability.extra.mult > 0 then
            SMODS.eval_this(card, {
                message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult, 
                colour = G.C.MULT
            })
        else
            SMODS.eval_this(card, {
                message = localize{type = 'variable', key = 'a_mult_minus', vars = {-card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult, 
                colour = G.C.MULT
            })
        end
        return nil, true
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local sign = card.ability.extra.mult >= 0 and "+" or ""
    local vars = { card.ability.extra.mult, card.ability.extra.gain, card.ability.extra.loss, card:check_rounds(2), card:check_rounds(5), sign }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(5) < 5 then
        desc_key = 'dis_'..desc_key..'_2'
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
    end
end

if JokerDisplay then
    JokerDisplay.Definitions.j_lobc_old_lady = {
        text = {
            { ref_table = "card.joker_display_values", ref_value = "sign" },
            { ref_table = "card.ability.extra", ref_value = "mult" }
        },
        text_config = { colour = G.C.MULT },
        calc_function = function(card)
            card.joker_display_values.sign = card.ability.extra.mult >= 0 and "+" or ""
        end,
        style_function = function(card, text, reminder_text, extra)
            if text then 
                text.states.visible = card:check_rounds(2) >= 2
            end
            if reminder_text then
            end
            if extra then
            end
            return false
        end
    }
end

return joker

-- the one that nobody cares