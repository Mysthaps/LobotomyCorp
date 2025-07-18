local joker = {
    name = "Laetitia",
    config = {extra = {first = false, not_hearts = true, all_hearts = true}}, rarity = 3, cost = 8,
    pos = {x = 9, y = 3}, 
    blueprint_compat = true, 
    eternal_compat = false,
    perishable_compat = false,
    abno = true,
    risk = "he",
    discover_rounds = {2, 4, 8},
}

joker.calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card and 
       context.other_card:is_suit("Hearts") and card.ability.extra.all_hearts and 
       not context.other_card.ability.laetitia_gift then
        local to_copy = context.other_card
        G.E_MANAGER:add_event(Event({
            func = function()
                -- Cryptid's effect
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                local _card = copy_card(to_copy, nil, nil, G.playing_card)
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
        return nil, true
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
        return {
            remove = true
        }
    end
end

joker.remove_from_deck = function(self, card, from_debuff)
    if not from_debuff then
        for _, v in ipairs(G.playing_cards) do
            if v.ability.laetitia_gift then
                SMODS.debuff_card(v, true, 'laetitia_perma_debuff')
                v.ability.perma_debuff = true
            end
        end
    end
end

if JokerDisplay then
    JokerDisplay.Definitions.j_lobc_laetitia = {
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = lighten(G.C.SUITS["Hearts"], 0.35) },
            { text = ")" }
        },
        calc_function = function(card)
            card.joker_display_values.localized_text = localize("Hearts", 'suits_plural')
        end,
        style_function = function(card, text, reminder_text, extra)
            if text then 
            end
            if reminder_text then
                reminder_text.states.visible = card:check_rounds(2) >= 2
            end
            if extra then
            end
            return false
        end
    }
end

return joker

-- "Shoutouts to the time I called laetitia lolita" - not me