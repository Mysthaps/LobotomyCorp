local joker = {
    name = "The Servant of Wrath",
    config = {extra = {counter = 0, x_mult = 2, round_count = 0}}, rarity = 3, cost = 8,
    pos = {x = 4, y = 8}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "waw",
    discover_rounds = {2, 5, 7},
    no_pool_flag = "servant_of_wrath_breach",
}

joker.calculate = function(self, card, context)
    if (context.first_hand_drawn or context.lobc_proc_wrath) and not context.blueprint and not G.GAME.servant_triggered then
        if context.lobc_proc_wrath and to_big(G.GAME.chips) < to_big(G.GAME.blind.chips) then
            G.GAME.lobc_maiden_active = nil
        end
        G.GAME.servant_triggered = true
        G.E_MANAGER:add_event(Event({
            func = function() 
                local available_cards = {}

                for _, v in ipairs(G.hand.cards) do
                    if not v.ability.forced_selection then
                        available_cards[#available_cards + 1] = v
                    end
                end

                for i = 1, math.min(5, G.hand.config.highlighted_limit - #G.hand.highlighted, #G.hand.cards - #G.hand.highlighted) do
                    if #available_cards > 0 then
                        local chosen_card, chosen_card_key = pseudorandom_element(available_cards, pseudoseed("random_card"))
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                chosen_card.ability.forced_selection = true
                                G.hand:add_to_highlighted(chosen_card)
                            return true
                            end
                        }))
                        table.remove(available_cards, chosen_card_key)
                        delay(0.2)
                    end
                end

                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function() 
                        G.FUNCS.play_cards_from_highlighted({})
                    return true 
                    end 
                })) 
            return true 
            end 
        }))
    end

    if context.individual and context.cardarea == G.play and (card.ability.extra.from_blind or G.GAME.current_round.hands_played == 0) then
        if G.GAME.blind.config.blind.key == "bl_lobc_mg_wrath" and G.GAME.blind.discards_sub == G.GAME.blind.hands_sub then return end
        return {
            x_mult = card.ability.extra.from_blind and 0.6 or card.ability.extra.x_mult,
            card = context.blueprint_card or card,
        }
    end

    if context.joker_main and not context.blueprint and G.GAME.current_round.hands_played == 0 and not card.ability.extra.from_blind then
        if context.scoring_name == "High Card" then
            card.ability.extra.counter = card.ability.extra.counter + 1
            if card.ability.extra.counter < 3 then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = (card.ability.extra.counter..'/3'), colour = G.C.FILTER})
            end
        end
        
        G.GAME.servant_triggered = false

        if card.ability.extra.counter >= 3 then
            abno_breach(card, 1)
            G.GAME.pool_flags["servant_of_wrath_breach"] = true
            lobc_reroll_boss(card)
        end
    end

    if context.end_of_round and context.main_eval and not card.ability.extra.from_blind then
        if G.GAME.current_round.hands_played == 1 then
            card.ability.extra.round_count = card.ability.extra.round_count + 1 
        else
            card.ability.extra.round_count = 0
        end

        if card.ability.extra.round_count >= 6 then
            check_for_unlock({type = "lobc_blind_rage"})
        end
    end

    if context.selling_self and not context.blueprint and not card.ability.extra.from_blind then
        abno_breach(card, 1)
        G.GAME.pool_flags["servant_of_wrath_breach"] = true
        lobc_reroll_boss(card)
    end
end

joker.loc_vars = function(self, info_queue, card)
    if card:check_rounds() >= 2 and G.GAME.blind.config.blind.key ~= "bl_lobc_mg_wrath" then info_queue[#info_queue+1] = {key = 'lobc_magical_girl_temp', set = 'Other'} end
    return {vars = {card.ability.extra.x_mult, 0.6}, key = (G.GAME.blind.config.blind.key == "bl_lobc_mg_wrath" and "j_lobc_servant_of_wrath_alt" or nil)}
end

if JokerDisplay then
    JokerDisplay.Definitions.j_lobc_servant_of_wrath = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.joker_display_values", ref_value = "x_mult" }
                }
            }
        },
        extra = {
            {
                { text = "(", colour = G.C.UI.TEXT_INACTIVE },
                { ref_table = "card.ability.extra", ref_value = "counter", colour = G.C.IMPORTANT },
                { text = "/3)", colour = G.C.UI.TEXT_INACTIVE }
            }
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "high_card", colour = G.C.IMPORTANT },
            { text = ")" }
        },
        extra_config = { scale = 0.3 },
        calc_function = function(card)
            local count = 0
            local hand = next(G.play.cards) and G.play.cards or G.hand.highlighted
            local _, _, scoring_hand = JokerDisplay.evaluate_hand(hand)

            for k, v in pairs(scoring_hand) do
                count = count + JokerDisplay.calculate_card_triggers(v, not (text == 'Unknown') and scoring_hand or nil)
            end

            card.joker_display_values.x_mult = G.GAME.current_round.hands_played == 0 and tonumber(string.format("%.2f", card.ability.extra.x_mult ^ count)) or 1
            card.joker_display_values.high_card = localize("High Card", 'poker_hands')
        end,

        style_function = function(card, text, reminder_text, extra)
            if text then 
                text.states.visible = card:check_rounds(3) >= 3
            end
            if reminder_text then
                reminder_text.states.visible = card:check_rounds(7) >= 7
            end
            if extra then
                extra.states.visible = card:check_rounds(7) >= 7
            end
            return false
        end
    }
end

return joker

-- tiphxodia gaming