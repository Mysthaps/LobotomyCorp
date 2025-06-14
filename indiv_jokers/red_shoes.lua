local joker = {
    name = "Red Shoes",
    config = {extra = {gain = 10, selected_card = nil}}, rarity = 2, cost = 5,
    pos = {x = 5, y = 0}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "he",
    discover_rounds = {2, 3, 6},
}

joker.calculate = function(self, card, context)
    if context.first_hand_drawn and not context.blueprint then
        if #G.hand.highlighted < G.hand.config.highlighted_limit then
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.2*G.SETTINGS.GAMESPEED,
                func = function() 
                    local available_cards = {}

                    for _, v in ipairs(G.hand.cards) do
                        if not v.ability.forced_selection then
                            available_cards[#available_cards+1] = v
                        end
                    end
                
                    for i = 1, math.min(2, G.hand.config.highlighted_limit - #G.hand.highlighted) do
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
                return true
                end
            }))
        end
    end

    if context.individual and context.cardarea == G.play then
        context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0
        context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + card.ability.extra.gain
        return {
            extra = {message = localize('k_upgrade_ex'), colour = G.C.CHIPS},
            colour = G.C.CHIPS,
            card = context.blueprint_card or card,
        }
    end

    if context.destroying_card and not context.blueprint and
       context.destroying_card.ability.perma_bonus >= 100 and not context.destroying_card.ability.eternal then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                play_sound('slice1', 0.96+math.random()*0.08, 0.7)
            return true
            end
        }))
        return {
            remove = true
        }
    end
end

joker.loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.gain}}
end

if JokerDisplay then
    JokerDisplay.Definitions.j_lobc_red_shoes = {
        reminder_text = {
            { text = "(" },
            { text = "100", colour = G.C.CHIPS },
            { text = ")" },
        },
        style_function = function(card, text, reminder_text, extra)
            if text then 
            end
            if reminder_text then
                reminder_text.states.visible = card:check_rounds(7) >= 7
            end
            if extra then
            end
            return false
        end
    }
end

return joker

-- pink shoes aberration
-- roseate desire faust when