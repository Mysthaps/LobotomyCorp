local joker = {
    name = "Today's Shy Look",
    config = {extra = {
        chips = 5, mult = 1, face = 3
    }}, rarity = 1, cost = 4,
    pos = {x = 7, y = 4}, 
    blueprint_compat = true, 
    eternal_compat = false,
    perishable_compat = false,
    abno = true,
    risk = "teth",
    discover_rounds = 9,
    loc_txt = {},
}

joker.calculate = function(self, card, context)
    if context.joker_main then
        if card.ability.extra.chips > 0 then
            SMODS.eval_this(card, {
                message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}},
                chip_mod = card.ability.extra.chips, 
                colour = G.C.CHIPS
            })
        end
        if card.ability.extra.mult > 0 then
            SMODS.eval_this(card, {
                message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult, 
                colour = G.C.MULT
            })
        end
        --return {}
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { card.ability.extra.chips, card.ability.extra.mult, 
                card.ability.extra.chips_gain, card.ability.extra.mult_gain,
                card:check_rounds(3), card:check_rounds(6), card:check_rounds(9),
                card.ability.extra.gain_scale
            }
    local desc_key = self.key
    if card:check_rounds(3) < 3 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(6) < 6 then
        desc_key = 'dis_'..desc_key..'_2'
    elseif card:check_rounds(9) < 9 then
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