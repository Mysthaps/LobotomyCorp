local joker = {
    name = "Bloodbath",
    config = {extra = {hand_size = 0}}, rarity = 2, cost = 7,
    pos = {x = 5, y = 2}, 
    blueprint_compat = false, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "teth",
    discover_rounds = {2, 4, 6},
}

joker.calculate = function(self, card, context)
    if context.after and context.cardarea == G.jokers and not context.blueprint then
        if next(context.poker_hands["Flush"]) or next(context.poker_hands["Straight"]) then
            G.E_MANAGER:add_event(Event({func = function()
                card.ability.extra.hand_size = card.ability.extra.hand_size + 1
                if G.hand.config.card_limits.total_slots == 1 then
                    G.GAME.lobc_death_text = "bloodbath"
                    check_for_unlock({type = "lobc_wrist_cutter"})
                end
                G.hand:change_size(-1)
            return true end})) 
            return {
                message = localize{type = 'variable', key = 'lobc_a_hand_size_minus', vars = {1}},
                colour = G.C.RED,
            }
        elseif card.ability.extra.hand_size > 0 then
            G.E_MANAGER:add_event(Event({func = function()
                card.ability.extra.hand_size = card.ability.extra.hand_size - 1
                G.hand:change_size(1)
            return true end})) 
            return {
                message = localize{type = 'variable', key = 'lobc_a_hand_size', vars = {1}},
                colour = G.C.BLUE,
            }
        end
    end
end

joker.add_to_deck = function(self, card, from_debuff)
    if from_debuff then
        G.hand:change_size(-card.ability.extra.hand_size)
    end
end

joker.remove_from_deck = function(self, card, from_debuff)
    if from_debuff then
        G.hand:change_size(card.ability.extra.hand_size)
    end
end

joker.loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.hand_size + 1, card.ability.extra.hand_size}}
end

local four_fingersref = SMODS.four_fingers
function SMODS.four_fingers(hand_type)
    local highest = 0
    for k, v in ipairs(SMODS.find_card('j_lobc_bloodbath') or {}) do
        highest = math.max(highest, v.ability.extra.hand_size + 1)
    end
    if highest > 0 then 
        return math.min(math.max(5 - highest, 1), four_fingersref(hand_type))
    end
    return four_fingersref(hand_type)
end

return joker

-- not the gd level