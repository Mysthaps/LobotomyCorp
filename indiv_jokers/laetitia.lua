local joker = {
    name = "Laetitia",
    config = {extra = {first = false, not_hearts = true, all_hearts = true}}, rarity = 3, cost = 7,
    pos = {x = 9, y = 3}, 
    blueprint_compat = true, 
    eternal_compat = false,
    perishable_compat = false,
    abno = true,
    risk = "he",
    discover_rounds = 8,
    loc_txt = {},
}

joker.calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and 
       context.other_card:is_suit("Hearts") and card.ability.extra.all_hearts and 
       not context.other_card.ability.laetitia_gift then
        G.E_MANAGER:add_event(Event({
            func = function()
                -- Cryptid's effect
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                local _card = copy_card(context.other_card, nil, nil, G.playing_card)
                _card.ability.laetitia_gift = true
                _card:add_to_deck()
                G.deck.config.card_limit = G.deck.config.card_limit + 1
                table.insert(G.playing_cards, _card)
                G.hand:emplace(_card)
                _card:start_materialize(nil, card.ability.extra.first)

                card.ability.extra.first = true
                card:juice_up()
                
                playing_card_joker_effects({_card})
                return true
            end
        })) 
        return {}
    end

    if context.cardarea == G.jokers and not context.blueprint then
        if context.before then
            for _, v in ipairs(context.scoring_hand) do
                if v:is_suit("Hearts") then
                    card.ability.extra.not_hearts = false
                else
                    card.ability.extra.all_hearts = false
                end
            end
        elseif context.after then
            card.ability.extra.not_hearts = true
            card.ability.extra.all_hearts = true
            card.ability.extra.first = false
        end
    end

    if context.destroying_card and not context.blueprint and 
       card.ability.extra.not_hearts and not context.destroying_card.ability.eternal then
        return true
    end
end

joker.remove_from_deck = function(self, card, from_debuff)
    for _, v in ipairs(G.playing_cards) do
        if v.ability.laetitia_gift then
            v.debuff = true
            v.ability.perma_debuff = true
        end
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { card:check_rounds(2), card:check_rounds(4), card:check_rounds(8) }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(4) < 4 then
        desc_key = 'dis_'..desc_key..'_2'
    elseif card:check_rounds(8) < 8 then
        desc_key = 'dis_'..desc_key..'_3'
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
    end
end

return joker

-- "Shoutouts to the time I called laetitia lolita" - not me