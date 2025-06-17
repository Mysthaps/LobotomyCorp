local metallic = {
    "m_gold",
    "m_steel",
    "m_bunc_copper",
    "m_grim_iron",
    "m_grim_lead",
    "m_grim_platinum",
    "m_grim_radium",
    "m_grim_silver",
    "m_kino_sci_fi",
    "m_mills_cinna", "m_mills_cinnabar",
    "m_mills_cob", "m_mills_cobalt",
    "m_mills_elec", "m_mills_electrum",
    "m_mills_ir", "m_mills_iron",
    "m_mills_titanium",
    "m_mf_brass",
    "m_ortalab_rusty",
    "m_jen_potassium",
    "m_reverse_copper",
    "m_reverse_iridium",
    "m_crv_coatedcopper",
    "m_toga_bronze",
    "m_toga_copper",
    "m_toga_electrum",
    "m_toga_iron",
    "m_toga_osmium",
    "m_toga_silver",
    "m_toga_tin",
}
local joker = {
    name = "Dreaming Electric Sheep",
    config = {extra = {can_trig = false}}, rarity = 2, cost = 7,
    pos = {x = 8, y = 8}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "he",
    discover_rounds = {2, 4, 7},
    or_dependencies = {
        "Bunco",
        "Grim",
        "Kino",
        "MillsCookbook",
        "MoreFluff",
        "Ortalab",
        "jen",
        "reverse_tarot",
        "RevosVault",
        "TOGAPack",
    }
}

joker.calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and card.ability.extra.can_trig then
        for _, v in ipairs(metallic) do
            if context.other_card.config.center.key == v then
                G.E_MANAGER:add_event(Event({trigger = 'before', func = function() 
                    play_sound("lobc_electric_sheep", 1, 0.7)
                return true end }))
                SMODS.calculate_effect({
                    message = localize("k_conduct"),
                    colour = G.C.PURPLE,
                }, context.blueprint_card or card)

                local fake_context = {cardarea = G.hand, end_of_round = true}
                local fake_context_main = {cardarea = G.hand, full_hand = G.play.cards, scoring_hand = context.scoring_hand, scoring_name = context.scoring_name, poker_hands = context.poker_hands}
                for i, _card in ipairs(G.hand.cards) do
                    for _, vv in ipairs(metallic) do if _card.config.center.key == vv then
                        SMODS.score_card(_card, fake_context_main) -- main scoring
                        -- end of round effects from SMODS.calculate_end_of_round_effects
                        local reps = {1}
                        local j = 1
                        while j <= #reps do
                            percent = (i-0.999)/(#fake_context.cardarea.cards-0.998) + (j-1)*0.1
                            if reps[j] ~= 1 then
                                local _, eff = next(reps[j])
                                SMODS.calculate_effect(eff, eff.card)
                                percent = percent + 0.08
                            end

                            fake_context.playing_card_end_of_round = true
                            --calculate the hand effects
                            local effects = {eval_card(_card, fake_context)}
                            SMODS.calculate_quantum_enhancements(_card, effects, fake_context)

                            fake_context.playing_card_end_of_round = nil
                            fake_context.individual = true
                            fake_context.other_card = _card
                            -- context.end_of_round individual calculations

                            SMODS.calculate_card_areas('jokers', fake_context, effects, { main_scoring = true })
                            SMODS.calculate_card_areas('individual', fake_context, effects, { main_scoring = true })

                            local flags = SMODS.trigger_effects(effects, _card)

                            fake_context.individual = nil
                            fake_context.repetition = true
                            fake_context.card_effects = effects
                            if reps[j] == 1 then
                                SMODS.calculate_repetitions(_card, fake_context, reps)
                            end

                            fake_context.repetition = nil
                            fake_context.card_effects = nil
                            fake_context.other_card = nil
                            j = j + (flags.calculated and 1 or #reps)
                        end
                    end end
                end
            end
        end
    end
    if context.end_of_round and not context.blueprint then
        card.ability.extra.can_trig = false
        for _, v in ipairs(G.playing_cards) do
            SMODS.debuff_card(v, false, "electric_sheep_debuff")
        end
    end
end

joker.remove_from_deck = function(self, card, from_debuff)
    for _, v in ipairs(G.playing_cards) do
        SMODS.debuff_card(v, false, 'electric_sheep_debuff')
    end
end

joker.update = function(self, card, dt)
    if G.STAGE == G.STAGES.RUN and (G.GAME and G.GAME.blind and G.GAME.blind.in_blind) and (card.area == G.jokers or card.area == G.consumeables) and not card.debuff and G.hand then
        local count = 0
        for _, _card in ipairs(G.hand.cards) do
            for _, vv in ipairs(metallic) do if _card.config.center.key == vv then
                count = count + 1
            end end
        end
        card.ability.extra.can_trig = (count > 0 and count <= 5)
        for _, _card in ipairs(G.hand.cards) do
            local is_metallic = false
            for _, vv in ipairs(metallic) do if _card.config.center.key == vv then
                is_metallic = true
            end end
            if not is_metallic then SMODS.debuff_card(_card, (count > 0 and count <= 5), "electric_sheep_debuff") end
        end
    end
end

joker.loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = {key = 'lobc_metallic', set = 'Other'}
    return {}
end

return joker

-- WHAT'S THE COLOR OF THE ELECTRIC SHEEP YOU SEE?