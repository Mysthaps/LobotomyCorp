local joker = {
    name = "Void Dream",
    config = {extra = {dollars = 3, chance = 2}}, rarity = 1, cost = 6,
    pos = {x = 1, y = 7}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "teth",
    discover_rounds = {2, 4},
}

joker.calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card then
        if context.other_card.debuff then
            return {
                message = localize('k_debuffed'),
                colour = G.C.RED,
                card = context.blueprint_card or card,
            }
        else
            if SMODS.pseudorandom_probability(card, "void_dream", 1, card.ability.extra.chance) then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
                if not Handy.animation_skip.should_skip_messages() then
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            G.GAME.dollar_buffer = 0
                            return true
                        end)
                    }))
                else
                    G.GAME.dollar_buffer = 0
                end
                return {
                    dollars = card.ability.extra.dollars
                }
            end
        end
    end

    if G.STATE == G.STATES.HAND_PLAYED and context.modify_scoring_hand and not context.blueprint then 
        for _, _card in ipairs(context.scoring_hand) do
            -- Activate effect on scoring cards only
            if _card == context.other_card or SMODS.always_scores(context.other_card) or next(find_joker('Splash')) then 
                if not context.other_card.ability.void_dream_activated or not context.other_card.ability.void_dream_activated[card.sort_id] then
                    context.other_card.ability.void_dream_activated = context.other_card.ability.void_dream_activated or {}
                    context.other_card.ability.void_dream_activated[card.sort_id] = true
                    if pseudorandom("void_dream_unscore") < 0.25 then
                        card:juice_up()
                        SMODS.calculate_effect({
                            message = localize("k_lobc_asleep"),
                            colour = G.C.PURPLE,
                        }, context.other_card)
                        delay(0.2)
                        return {
                            remove_from_hand = true,
                        }
                    end
                end
            end
        end
    end

    if context.after and not context.blueprint then
        for _, v in ipairs(G.playing_cards) do
            v.ability.void_dream_activated = nil
        end
    end
end

joker.loc_vars = function(self, info_queue, card)
    local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.chance)
    return {vars = {numerator, denominator, card.ability.extra.dollars}}
end

return joker

-- What's the color of the electric sheep you see?