local joker = {
    name = "The Mountain of Smiling Bodies",
    config = {extra = {
        chips = 0, mult = 0, 
        chips_gain = 3, mult_gain = 1, 
        gain_scale = 1, destroyed = 0,
    }}, rarity = 3, cost = 8,
    pos = {x = 7, y = 4}, 
    blueprint_compat = true, 
    eternal_compat = false,
    perishable_compat = false,
    abno = true,
    risk = "aleph",
    discover_rounds = 9,
    loc_txt = {},
}

joker.calculate = function(self, card, context)
    if context.destroying_card and not context.blueprint and not context.destroying_card.ability.eternal then
        return true
    end

    if context.cardarea == G.jokers and not context.blueprint then
        if context.before then
            card.ability.extra.destroyed = 0
            for _, v in ipairs(context.scoring_hand) do
                if not v.ability.eternal then 
                    card.ability.extra.destroyed = card.ability.extra.destroyed + 1
                    card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                end
            end

            if card.ability.extra.destroyed == 5 then
                card.ability.extra.chips_gain = card.ability.extra.chips_gain + card.ability.extra.gain_scale
                card.ability.extra.mult_gain = card.ability.extra.mult_gain + card.ability.extra.gain_scale
                card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_upgrade_ex') })
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('lobc_mosb_upgrade', 1, 0.3)
                        return true
                    end
                }))
            end
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

if SMODS.Mods.JokerDisplay then
    JokerDisplay.Definitions.j_lobc_mosb = {
        text = {
            { text = "+", colour = G.C.CHIPS },
            { ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS },
            { text = " +", colour = G.C.MULT },
            { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT }
        },
        reminder_text = {
            { text = "+", colour = G.C.CHIPS },
            { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS },
            { text = " +", colour = G.C.MULT },
            { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT }
        },
        calc_function = function(card)
            local chips, mult = 0, 0
            local hand = next(G.play.cards) and G.play.cards or G.hand.highlighted
            local _, _, scoring_hand = JokerDisplay.evaluate_hand(hand)

            for i = 1, #scoring_hand do
                chips = chips + card.ability.extra.chips_gain
                mult = mult + card.ability.extra.mult_gain
            end
            
            card.joker_display_values.mult = mult
            card.joker_display_values.chips = chips
        end,
        style_function = function(card, text, reminder_text, extra)
            if text then 
                text.states.visible = card:check_rounds(6) >= 6
            end
            if reminder_text then
                reminder_text.states.visible = card:check_rounds(6) >= 6
            end
            if extra then
            end
            return false
        end
    }
end

return joker

-- lebron james, scream if you love project moon