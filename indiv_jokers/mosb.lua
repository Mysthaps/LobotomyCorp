local joker = {
    name = "The Mountain of Smiling Bodies",
    config = {extra = {chips = 0, mult = 0, chips_gain = 5, mult_gain = 2, destroyed = 0}}, rarity = 3, cost = 8,
    pos = {x = 7, y = 4}, 
    blueprint_compat = true, 
    eternal_compat = false,
    perishable_compat = false,
    abno = true,
    discover_rounds = 9,
    loc_txt = {
        name = "The Mountain of Smiling Bodies",
        text = {
            "Destroys all {C:attention}scored{} cards",
            "This Abnormality gains {C:chips}+#3#{} Chips and",
            "{C:mult}+#4#{} Mult when it destroys a card",
            "Increase {C:chips}Chips{} and {C:mult}Mult{} gain by {C:attention}1{}",
            "if {C:attention}5{} cards are destroyed at once",
            "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips and {C:mult}+#2#{C:inactive} Mult)"
        }
    },
}

joker.process_loc_text = function(self)
    SMODS.Joker.process_loc_text(self)
    SMODS.process_loc_text(G.localization.descriptions["Other"], "und_j_lobc_mosb", {
        name = "T-01-75",
        text = {
            "The smiling faces are",
            "unfamiliar yet sorrowful.",
        }
    })
    SMODS.process_loc_text(G.localization.descriptions["Joker"], "dis_j_lobc_mosb_1", {
        name = "T-01-75",
        text = {
            "{C:attention}(#5#/3){} ...",
            "{C:attention}(#6#/6){} ...",
            "{C:attention}(#7#/9){} ...",
        }
    })
    SMODS.process_loc_text(G.localization.descriptions["Joker"], "dis_j_lobc_mosb_2", {
        name = "T-01-75",
        text = {
            "Destroys all {C:attention}scored{} cards",
            "{C:attention}(#6#/6){} ...",
            "{C:attention}(#7#/9){} ...",
        }
    })
    SMODS.process_loc_text(G.localization.descriptions["Joker"], "dis_j_lobc_mosb_3", {
        name = "T-01-75",
        text = {
            "Destroys all {C:attention}scored{} cards",
            "This Abnormality gains {C:chips}+#3#{} Chips and",
            "{C:mult}+#4#{} Mult when it destroys a card",
            "{C:attention}(#7#/9){} ...",
            "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips and {C:mult}+#2#{C:inactive} Mult)"
        }
    })
end

joker.calculate = function(self, card, context)
    if context.destroying_card and not context.blueprint then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                card.ability.extra.destroyed = card.ability.extra.destroyed + 1

                if card.ability.extra.destroyed == 1 then
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
                end

                if card.ability.extra.destroyed == 5 then
                    card.ability.extra.chips_gain = card.ability.extra.chips_gain + 1
                    card.ability.extra.mult_gain = card.ability.extra.mult_gain + 1
                end
            return true
            end
        }))
        return true
    end

    if context.cardarea == G.jokers and not context.blueprint then
        if context.before then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                func = function()
                    card.ability.extra.destroyed = 0
                return true
                end
            }))
        end
    end

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
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { card.ability.extra.chips, card.ability.extra.mult, 
                card.ability.extra.chips_gain, card.ability.extra.mult_gain,
                card:check_rounds(3), card:check_rounds(6), card:check_rounds(9) }
    local desc_key = self.key
    if card:check_rounds(3) < 3 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(6) < 6 then
        desc_key = 'dis_'..desc_key..'_2'
    elseif card:check_rounds(9) < 9 then
        desc_key = 'dis_'..desc_key..'_3'
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
end

return joker