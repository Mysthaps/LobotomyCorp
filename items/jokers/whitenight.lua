local joker = {
    name = "WhiteNight",
    config = {extra = {mult = 20, retriggers = 3}}, rarity = 4, cost = 20,
    pos = {x = 3, y = 8}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = false,
    abno = true,
    risk = "aleph",
    discover_rounds = {0, 1, 3},
    yes_pool_flag = "whitenight_defeated",
    no_pool_flag = "whitenight_confessed",
}

joker.in_pool = function(self, args)
    return false
end

joker.calculate = function(self, card, context)
    if context.cardarea == G.play and context.other_card and context.other_card.ability.plague_doctor_baptism then
        if context.individual then
            return {
                mult = card.ability.extra.mult,
                card = context.blueprint_card or card,
            }
        elseif context.repetition then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retriggers,
                card = context.blueprint_card or card,
            }
        end
    end

    if context.cardarea == G.hand and context.other_card and context.repetition and context.other_card.ability.plague_doctor_baptism and (next(context.card_effects[1]) or #context.card_effects > 1) then
        return {
            message = localize('k_again_ex'),
            repetitions = card.ability.extra.retriggers,
            card = context.blueprint_card or card,
        }
    end

    if context.cardarea == G.jokers and not context.blueprint then
        if context.before and context.full_hand then
            local card_to_mark = nil

            -- Check in played
            for k, v in ipairs(context.full_hand) do
                if v.ability and not v.ability.plague_doctor_baptism then
                    card_to_mark = context.full_hand[k]
                    break
                end
            end

            -- Check in hand
            if not card_to_mark then
                for k, v in ipairs(G.hand.cards) do
                    if v.ability and not v.ability.plague_doctor_baptism then
                        card_to_mark = G.hand.cards[k]
                        break
                    end
                end
            end

            -- Check in deck
            if not card_to_mark then
                for k, v in ipairs(G.deck.cards) do
                    if v.ability and not v.ability.plague_doctor_baptism then
                        card_to_mark = G.deck.cards[k]
                        break
                    end
                end
            end

            if card_to_mark then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = function()
                        card:juice_up()
                        card_to_mark:juice_up()
                        card_to_mark.ability.plague_doctor_baptism = true
                    return true
                    end
                }))
            end
        end
    end
end

joker.add_to_deck = function(self, card, from_debuff)
    G.jokers.config.card_limit = G.jokers.config.card_limit + 1
end

joker.remove_from_deck = function(self, card, from_debuff)
    G.jokers.config.card_limit = G.jokers.config.card_limit - 1
end

joker.loc_vars = function(self, info_queue, card)
    if lobc_get_usage_count("j_lobc_plague_doctor") > 0 then info_queue[#info_queue+1] = {key = 'lobc_bless_order', set = 'Other'} end
    return {vars = {card.ability.extra.mult, card.ability.extra.retriggers}}
end

if JokerDisplay then
    JokerDisplay.Definitions.j_lobc_whitenight = {
        text = {
            { text = "+", colour = G.C.MULT },
            {
                ref_table = "card.joker_display_values",
                ref_value = "mult",
                colour = G.C.MULT
            }
        },

        calc_function = function(card)
            local mult = 0
            local hand = next(G.play.cards) and G.play.cards or G.hand.highlighted
            local _, _, scoring_hand = JokerDisplay.evaluate_hand(hand)

            for i = 1, #scoring_hand do
                if not scoring_hand[i].debuff and scoring_hand[i].ability.plague_doctor_baptism then
                    mult = mult + card.ability.extra.mult
                end
            end

            card.joker_display_values.mult = mult
        end,

        retrigger_function = function(card, scoring_hand, held_in_hand)
            if held_in_hand then return 0 end
            return card.ability.plague_doctor_baptism and 3 or 0
        end,

        style_function = function(card, text, reminder_text, extra)
            if text then 
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

-- just reset if you get plague doctor on day 11 lmao