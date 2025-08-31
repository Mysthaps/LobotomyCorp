local joker = {
    name = "All-Around Helper",
    config = {extra = {x_mult = 1, gain = 0.4, counter = 0}}, rarity = 2, cost = 7,
    pos = {x = 7, y = 1}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = false,
    abno = true,
    risk = "he",
    discover_rounds = {3, 6},
}

joker.calculate = function(self, card, context)
    if context.end_of_round and context.main_eval then
        if G.GAME.current_round.hands_played == 1 then
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.gain
            if card.ability.extra.x_mult >= 5 then
                check_for_unlock({type = "lobc_grinder_mk4"})
            end
            card.ability.extra.counter = card.ability.extra.counter + 1
            if card.ability.extra.counter >= 4 then
                local available_cards = {}
                for _, v in ipairs(G.jokers.cards) do
                    if v ~= card and not SMODS.is_eternal(v, card) then available_cards[#available_cards+1] = v end
                end

                if #available_cards > 0 then
                    local selected_card = pseudorandom_element(available_cards, pseudoseed("all_around_helper"))
                    selected_card:start_dissolve()
                    play_sound('slice1', 0.96+math.random()*0.08, 0.7)
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        func = function()
                            play_sound('lobc_helper_destroy', 1, 0.7)
                        return true
                        end
                    }))
                end
                card.ability.extra.counter = 0
            end
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT,
                card = card
            }
        end
    end

    if context.joker_main and card.ability.extra.x_mult > 1 then
        return {
            x_mult = card.ability.extra.x_mult, 
            colour = G.C.MULT
        }
    end
end

joker.loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.x_mult, card.ability.extra.gain, 4 - card.ability.extra.counter}}
end

-- JokerDisplay compat
-- Modified from OppositeWolf770's implementation
if JokerDisplay then
    JokerDisplay.Definitions.j_lobc_all_around_helper = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "x_mult" }
                }
            }
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "remaining_text", colour = G.C.IMPORTANT },
            { text = ")" }
        },
        calc_function = function(card)
            card.joker_display_values.remaining_text = localize{type = 'variable', key = 'loyalty_inactive', vars = {4 - card.ability.extra.counter}}
        end,
        style_function = function(card, text, reminder_text, extra)
            if text then 
                text.states.visible = card:check_rounds(3) >= 3
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

-- reddit the abnormality