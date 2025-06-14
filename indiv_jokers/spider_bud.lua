local joker = {
    name = "Spider Bud",
    config = {extra = {cards = 0, card_gain = 1, first = true, counter = 0}}, rarity = 2, cost = 6,
    pos = {x = 9, y = 1}, 
    blueprint_compat = false, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "teth",
    discover_rounds = {2, 5},
}

joker.calculate = function(self, card, context)
    if context.discard and not context.blueprint and context.other_card and context.other_card == context.full_hand[1] then
        if card.ability.extra.first then
            card.ability.extra.first = false
            card.ability.extra.cards = card.ability.extra.cards + card.ability.extra.card_gain
            G.hand:change_size(card.ability.extra.card_gain)
            if card.ability.extra.cards >= 5 then
                check_for_unlock({type = "lobc_red_eyes"})
            end
            card.ability.extra.counter = card.ability.extra.counter + 1
            if card.ability.extra.counter >= 20 then
                check_for_unlock({type = "lobc_red_eyes_open"})
            end
            return {remove = true}
        end
    end

    if context.end_of_round and not context.blueprint and context.main_eval then
        if G.GAME.blind.boss then 
            G.hand:change_size(-card.ability.extra.cards)
            card.ability.extra.cards = 0 
            return {
                message = localize('k_reset')
            }
        end
        card.ability.extra.first = true
    end
end

joker.add_to_deck = function(self, card, from_blind)
    G.hand:change_size(card.ability.extra.cards)
end

joker.remove_from_deck = function(self, card, from_blind)
    G.hand:change_size(-card.ability.extra.cards)
end

joker.loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.cards, card.ability.extra.card_gain}}
end

return joker

-- why does lobotomy e.g.o::red eyes & penitence ryoshu's kit have NO BIND in it