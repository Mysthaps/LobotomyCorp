local joker = {
    name = "Fragment of the Universe",
    config = {extra = {planet = 2, spectral = 8}}, rarity = 1, cost = 5,
    pos = {x = 3, y = 3}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = false,
    abno = true,
    risk = "teth",
    discover_rounds = {2, 5},
}

joker.calculate = function(self, card, context)
    if context.after and context.cardarea == G.jokers then
        local suits = {}
        local suits_count = 0
        for _, v in ipairs(context.scoring_hand) do
            if SMODS.has_any_suit(v) then suits_count = suits_count + 1
            elseif not SMODS.has_no_suit(v) and not suits[v.base.suit] then
                suits[v.base.suit] = true
                suits_count = suits_count + 1
            end
        end
        if suits_count >= 3 then
            if pseudorandom("fragment_planet_roll") < (G.GAME.probabilities.normal / card.ability.extra.planet) then
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({func = function()
                        G.E_MANAGER:add_event(Event({func = function()
                            local _card = SMODS.add_card({set = "Planet", area = G.consumeables, key_append = "fragment_planet"})
                            _card.ability.perishable = true
                            _card.ability.perish_tally = G.GAME.perishable_rounds
                            G.GAME.consumeable_buffer = 0
                        return true end }))
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})
                    return true end }))
                end
            end
            if pseudorandom("fragment_spectral_roll") < (G.GAME.probabilities.normal / card.ability.extra.spectral) then
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({func = function()
                        G.E_MANAGER:add_event(Event({func = function()
                            local _card = SMODS.add_card({set = "Spectral", area = G.consumeables, key_append = "fragment_spectral"})
                            _card.ability.eternal = true
                            G.GAME.consumeable_buffer = 0
                        return true end }))
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})
                    return true end }))
                end
            end
        end
    end
end

joker.loc_vars = function(self, info_queue, card)
    return {vars = {G.GAME.probabilities.normal, card.ability.extra.planet, card.ability.extra.spectral}}
end

return joker

-- children's scribbles c: yay yippee