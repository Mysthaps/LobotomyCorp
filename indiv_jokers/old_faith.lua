local joker = {
    name = "Old Faith and Promise",
    config = {extra = 4}, rarity = 1, cost = 6,
    pos = {x = 9, y = 6}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "zayin",
    discover_rounds = {2, 4},
}

joker.calculate = function(self, card, context)
    if context.setting_blind and not card.getting_sliced then
        local available_cards = {}
        for _, v in ipairs(G.jokers.cards) do
            if v ~= card and not v.edition then available_cards[#available_cards+1] = v end
        end
        for _, v in ipairs(G.consumeables.cards) do
            if v ~= card and not v.edition then available_cards[#available_cards+1] = v end
        end
        for _, v in ipairs(G.playing_cards) do
            if v ~= card and not v.edition then available_cards[#available_cards+1] = v end
        end

        if #available_cards > 0 then
            local selected_card = pseudorandom_element(available_cards, pseudoseed("old_faith_select"))

            if pseudorandom('old_faith_debuff') < G.GAME.probabilities.normal/card.ability.extra then
                SMODS.debuff_card(selected_card, true, 'old_faith_perma_debuff')
                selected_card.ability.perma_debuff = true
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                    play_sound('tarot2', 0.76, 0.4);return true end}))
                play_sound('tarot2', 1, 0.4)
            else
                local edition = poll_edition('old_faith_edition', nil, nil, true)
                selected_card:set_edition(edition, true)
            end
            card:juice_up()
        end
        return nil, true
    end
end

joker.loc_vars = function(self, info_queue, card)
    return {vars = {G.GAME.probabilities.normal, card.ability.extra}}
end

if JokerDisplay then
    JokerDisplay.Definitions.j_lobc_old_faith = {
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = " in "},
                { ref_table = "card.ability", ref_value = "extra" },
                { text = ")"},
            }
        },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
        calc_function = function(card)
            card.joker_display_values.odds = G.GAME and G.GAME.probabilities.normal or 1
        end,
        style_function = function(card, text, reminder_text, extra)
            if text then 
            end
            if reminder_text then
            end
            if extra then
                extra.states.visible = card:check_rounds(4) >= 4
            end
            return false
        end
    }
end

return joker

-- the one that nobody cares