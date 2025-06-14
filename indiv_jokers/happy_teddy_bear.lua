local joker = {
    name = "Happy Teddy Bear",
    config = {extra = {upgrade = 1, last_hand_played = nil, upgrades = {}}}, rarity = 2, cost = 6,
    pos = {x = 4, y = 0}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "he",
    discover_rounds = {2, 6},
}

joker.calculate = function(self, card, context)
    if context.cardarea == G.jokers then
        local hand = context.scoring_name
        if context.before then
            if hand == card.ability.extra.last_hand_played then
                if not context.blueprint then
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_lobc_downgrade')})
                    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(hand, 'poker_hands'),chips = G.GAME.hands[hand].chips, mult = G.GAME.hands[hand].mult, level=G.GAME.hands[hand].level})
                    level_up_hand(card, hand, nil, -G.GAME.hands[hand].level)
                    card.ability.extra.upgrades[hand] = 0
                end
            else
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
                update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(hand, 'poker_hands'),chips = G.GAME.hands[hand].chips, mult = G.GAME.hands[hand].mult, level=G.GAME.hands[hand].level})
                level_up_hand(context.blueprint_card or card, hand, nil, 1)
                if not context.blueprint then 
                    card.ability.extra.upgrades[hand] = card.ability.extra.upgrades[hand] or 0
                    card.ability.extra.upgrades[hand] = card.ability.extra.upgrades[hand] + 1
                    if card.ability.extra.upgrades[hand] >= 10 then
                        check_for_unlock({type = "lobc_bear_paws"})
                    end
                end
            end
        elseif context.after and not context.blueprint then
            card.ability.extra.last_hand_played = hand
        end
    end
end

joker.loc_vars = function(self, info_queue, card)
    local hand_var = card.ability.extra.last_hand_played and localize(card.ability.extra.last_hand_played, 'poker_hands') or localize('k_none')
    return {vars = {hand_var}}
end

if JokerDisplay then
    JokerDisplay.Definitions.j_lobc_happy_teddy_bear = {
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "hand_text", colour = G.C.IMPORTANT },
            { text = ")" },
        },
        calc_function = function(card)
            card.joker_display_values.hand_text = card.ability.extra.last_hand_played and localize(card.ability.extra.last_hand_played, 'poker_hands') or localize('k_none')
        end,
        style_function = function(card, text, reminder_text, extra)
            if text then 
            end
            if reminder_text then
                reminder_text.states.visible = card:check_rounds(6) >= 6
            end
            if extra then
            end
            return false
        end
    }
end

return joker

-- happy teddy bear fervent emotions go