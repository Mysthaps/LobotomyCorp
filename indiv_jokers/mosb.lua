local config = SMODS.current_mod.config
local joker = {
    name = "The Mountain of Smiling Bodies",
    config = {extra = {
        chips = 0, mult = 0, 
        chips_gain = 2, mult_gain = 1, 
        gain_scale = 1, destroyed = 0,
    }}, rarity = 3, cost = 9,
    pos = {x = 7, y = 4}, 
    blueprint_compat = true, 
    eternal_compat = false,
    perishable_compat = false,
    abno = true,
    risk = "aleph",
    discover_rounds = {3, 6, 9},
}

joker.calculate = function(self, card, context)
    if context.destroying_card and not context.blueprint and not context.destroying_card.ability.eternal then
        return {
            remove = true
        }
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
                        if not config.disable_unsettling_sfx then play_sound('lobc_mosb_upgrade', 1, 0.3) end
                        return true
                    end
                }))
                if card.ability.extra.mult_gain >= 15 then
                    check_for_unlock({type = "lobc_smile"})
                end
            end

            return nil, true
        end
    end

    if context.joker_main then
        return {
            chips = card.ability.extra.chips,
            mult = card.ability.extra.mult,
            card = context.blueprint_card or card,
        }
    end
end

joker.loc_vars = function(self, info_queue, card)
    return {vars = {
        card.ability.extra.chips, card.ability.extra.mult, 
        card.ability.extra.chips_gain, card.ability.extra.mult_gain,
        "unused", "unused", "unused",
        card.ability.extra.gain_scale
    }}
end

if JokerDisplay then
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