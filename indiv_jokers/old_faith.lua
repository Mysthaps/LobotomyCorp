local joker = {
    name = "Old Faith and Promise",
    config = {extra = 4}, rarity = 1, cost = 4,
    pos = {x = 9, y = 6}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "zayin",
    discover_rounds = 4,
    loc_txt = {},
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
                selected_card.debuff = true
                selected_card.ability.perma_debuff = true
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                    play_sound('tarot2', 0.76, 0.4);return true end}))
                play_sound('tarot2', 1, 0.4)
            else
                local edition = poll_edition('old_faith_edition', nil, true, true)
                selected_card:set_edition(edition, true)
            end
            card:juice_up()
        end
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { G.GAME.probabilities.normal, card.ability.extra, card:check_rounds(2), card:check_rounds(4)}
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(4) < 4 then
        desc_key = 'dis_'..desc_key..'_2'
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
    end
end

return joker

-- the one that nobody cares