local config = SMODS.current_mod.config
local joker = {
    name = "Nameless Fetus",
    config = {extra = {x_mult = 4, x_mult_penalty = 0.5, chosen_hand = nil, proc = false}}, rarity = 2, cost = 8,
    pos = {x = 8, y = 0}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "he",
    discover_rounds = 8,
    loc_txt = {},
}

joker.calculate = function(self, card, context)
    if context.cardarea == G.jokers and not context.blueprint then
        if context.before then
            if #context.full_hand == 1 and 
               not context.full_hand[1].ability.eternal and G.GAME.current_round.hands_played == 0 then
                card.ability.extra.proc = true
            end
        elseif context.after then
            if card.ability.extra.proc then
                local _poker_hands = {}
                for k, v in pairs(G.GAME.hands) do
                    if v.visible and k ~= G.GAME.nameless_hand_type then _poker_hands[#_poker_hands + 1] = k end
                end
                G.GAME.nameless_hand_type = pseudorandom_element(_poker_hands, pseudoseed('fetus_reset'))

                SMODS.eval_this(card, {
                    message = localize("k_reset")
                })
            end
            card.ability.extra.proc = false
        end
    end

    if context.destroying_card and not context.blueprint and #context.full_hand == 1 and 
       not context.full_hand[1].ability.eternal and G.GAME.current_round.hands_played == 0 then
        return true
    end

    if context.joker_main then
        if context.scoring_name == G.GAME.nameless_hand_type then
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.x_mult}},
                Xmult_mod = card.ability.extra.x_mult
            }
        else
            if not config.disable_unsettling_sfx then play_sound("lobc_nameless_cry", 1, 0.6) end
            return {
                message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.x_mult_penalty}},
                Xmult_mod = card.ability.extra.x_mult_penalty
            }
        end
    end
end

joker.set_ability = function(self, card, initial, delay_sprites)
    if G.GAME and not G.GAME.nameless_hand_type then
        local _poker_hands = {}
        for k, v in pairs(G.GAME.hands) do
            if v.visible and k ~= G.GAME.nameless_hand_type then _poker_hands[#_poker_hands + 1] = k end
        end
        G.GAME.nameless_hand_type = pseudorandom_element(_poker_hands, pseudoseed('fetus'))
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local hand_var = G.GAME and localize(G.GAME.nameless_hand_type, 'poker_hands') or localize("High Card", 'poker_hands')
    local vars = { hand_var, card.ability.extra.x_mult, card.ability.extra.x_mult_penalty, 
        card:check_rounds(2), card:check_rounds(4), card:check_rounds(8) }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(4) < 4 then
        desc_key = 'dis_'..desc_key..'_2'
    elseif card:check_rounds(8) < 8 then
        desc_key = 'dis_'..desc_key..'_3'
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if not self.discovered and card.area ~= G.jokers then
        localize{type = 'descriptions', key = 'und_'..self.key, set = "Other", nodes = desc_nodes, vars = vars}
    elseif specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
    end
end

if JokerDisplay then
    JokerDisplay.Definitions.j_lobc_nameless_fetus = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.joker_display_values", ref_value = "x_mult" }
                }
            }
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "chosen_hand", colour = G.C.IMPORTANT },
            { text = ")" },
        },
        calc_function = function(card)
            local hand = next(G.play.cards) and G.play.cards or G.hand.highlighted
            local text, _, _= JokerDisplay.evaluate_hand(hand)

            card.joker_display_values.chosen_hand = localize(G.GAME.nameless_hand_type, 'poker_hands')
            card.joker_display_values.x_mult = (G.GAME.nameless_hand_type == text or text == "NULL") and card.ability.extra.x_mult or card.ability.extra.x_mult_penalty
        end,
        style_function = function(card, text, reminder_text, extra)
            if text then 
                text.states.visible = card:check_rounds(2) >= 2
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

-- let's go gambling!
-- xxx aw dangit
-- xxx aw dangit
-- xxx aw dangit
-- xxx aw dangit
-- xxx aw da-