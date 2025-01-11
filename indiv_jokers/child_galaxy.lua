local joker = {
    name = "Child of the Galaxy",
    config = {extra = {per = 0, gain = 2, loss = 2}}, rarity = 2, cost = 8,
    pos = {x = 9, y = 2}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = false,
    abno = true,
    risk = "he",
    discover_rounds = 7,
    loc_txt = {},
}

joker.calculate = function(self, card, context)
    if context.before and context.cardarea == G.jokers and not context.blueprint then
        for _, v in ipairs(context.scoring_hand) do
            if v.ability.child_galaxy_pebble then
                card.ability.extra.per = card.ability.extra.per + card.ability.extra.gain
            else
                if card.ability.extra.per >= -10 then
                    card.ability.extra.per = card.ability.extra.per - card.ability.extra.loss
                end
            end
        end
        if card.ability.extra.per >= 40 then
            check_for_unlock({type = "lobc_our_galaxy"})
        end
    end

    if context.joker_main then
        local chips = G.GAME.hands[context.scoring_name].chips * (card.ability.extra.per / 10)
        local mult = G.GAME.hands[context.scoring_name].mult * (card.ability.extra.per / 10)
        
        return {
            chips = chips,
            mult = mult,
            card = context.blueprint_card or card,
        }
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { 
        card.ability.extra.per/10, card.ability.extra.gain/10, card.ability.extra.loss/10, 
        card:check_rounds(2), card:check_rounds(4), card:check_rounds(7)
    }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(4) < 4 then
        desc_key = 'dis_'..desc_key..'_2'
    else
        info_queue[#info_queue+1] = {key = 'lobc_pebble', set = 'Other'}
        if card:check_rounds(7) < 7 then
            desc_key = 'dis_'..desc_key..'_3'
        end
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
    JokerDisplay.Definitions.j_lobc_child_galaxy = {
        text = {
            { ref_table = "card.joker_display_values", ref_value = "sign", colour = G.C.CHIPS },
            { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS },
            { text = " " },
            { ref_table = "card.joker_display_values", ref_value = "sign", colour = G.C.MULT },
            { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT }
        },
        calc_function = function(card)
            local hand = next(G.play.cards) and G.play.cards or G.hand.highlighted
            local text, _, _ = JokerDisplay.evaluate_hand(hand)

            local chips = text and G.GAME.hands[text] and G.GAME.hands[text].chips * card.ability.extra.per or 0
            local mult = text and G.GAME.hands[text] and G.GAME.hands[text].mult * card.ability.extra.per or 0

            card.joker_display_values.sign = card.ability.extra.per >= 0 and "+" or ""
            card.joker_display_values.chips = number_format(chips)
            card.joker_display_values.mult = number_format(mult)
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

-- you wouldn't hurt a child, would you?
-- after all, it just wants to be your friend