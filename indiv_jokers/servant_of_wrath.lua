local joker = {
    name = "The Servant of Wrath",
    config = {extra = {counter = 0, x_mult = 2.5, round_count = 0}}, rarity = 3, cost = 8,
    pos = {x = 4, y = 8}, 
    blueprint_compat = true, 
    eternal_compat = false,
    perishable_compat = false,
    abno = true,
    risk = "waw",
    discover_rounds = 7,
    no_pool_flag = "servant_of_wrath_breach",
    loc_txt = {},
}

joker.calculate = function(self, card, context)
    if context.first_hand_drawn and not context.blueprint and not G.GAME.servant_triggered then
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

    if context.individual and context.cardarea == G.play and G.GAME.current_round.hands_played == 0 then
        return {
            x_mult = card.ability.extra.x_mult,
            card = card
        }
    end

    if context.joker_main and not context.blueprint and G.GAME.current_round.hands_played == 0 then
        if context.scoring_name == "High Card" then
            card.ability.extra.counter = card.ability.extra.counter + 1
            if card.ability.extra.counter < 3 then
                SMODS.eval_this(card, {
                    message = (card.ability.extra.counter..'/3'),
                    colour = G.C.FILTER
                })
            end
        end
        
        G.GAME.servant_triggered = false

        if card.ability.extra.counter >= 3 then
            G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling * 1.5
            abno_breach(v, 1)
            G.GAME.pool_flags["servant_of_wrath_breach"] = true
        end
    end

    if context.end_of_round and not context.repetition and not context.individual then
        if G.GAME.current_round.hands_played == 1 then
            card.ability.extra.round_count = card.ability.extra.round_count + 1 
        else
            card.ability.extra.round_count = 0
        end

        if card.ability.extra.round_count >= 6 then
            check_for_unlock({type = "lobc_blind_rage"})
        end
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { card.ability.extra.x_mult, card:check_rounds(2), card:check_rounds(3), card:check_rounds(7) }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(3) < 3 then
        desc_key = 'dis_'..desc_key..'_2'
    elseif card:check_rounds(7) < 7 then
        desc_key = 'dis_'..desc_key..'_3'
    else
        info_queue[#info_queue+1] = {key = 'lobc_magical_girl', set = 'Other'}
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