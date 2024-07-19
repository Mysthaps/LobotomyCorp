local joker = {
    name = "Happy Teddy Bear",
    config = {extra = {upgrade = 1, last_hand_played = nil}}, rarity = 2, cost = 6,
    pos = {x = 4, y = 0}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "he",
    discover_rounds = 6,
    loc_txt = {},
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
                end
            else
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
                update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(hand, 'poker_hands'),chips = G.GAME.hands[hand].chips, mult = G.GAME.hands[hand].mult, level=G.GAME.hands[hand].level})
                level_up_hand(context.blueprint_card or card, hand, nil, card.ability.extra.upgrade)
            end
        elseif context.after and not context.blueprint then
            card.ability.extra.last_hand_played = hand
        end
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local hand_var = card.ability.extra.last_hand_played and localize(card.ability.extra.last_hand_played, 'poker_hands') or localize('k_none')
    local vars = { card.ability.extra.upgrade, hand_var, card:check_rounds(2), card:check_rounds(6) }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(6) < 6 then
        desc_key = 'dis_'..desc_key..'_2'
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
    end
end

if SMODS.Mods.JokerDisplay then
    JokerDisplay.Definitions.j_lobc_happy_teddy_bear = {
        text = {
            { ref_table = "card.joker_display_values", ref_value = "hand_text", colour = G.C.ORANGE },
        },
        calc_function = function(card)
            card.joker_display_values.hand_text = card.ability.extra.last_hand_played and localize(card.ability.extra.last_hand_played, 'poker_hands') or localize('k_none')
        end,
        style_function = function(card, text, reminder_text, extra)
            if text then 
                text.states.visible = card:check_rounds(6) >= 6
            end
            if reminder_text then
            end
            if extra then
            end
            return false
        end
    }
end

return joker

-- happy teddy bear fervent emotions go