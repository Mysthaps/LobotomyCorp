local joker = {
    name = "The Heart of Aspiration",
    config = {extra = {x_mult = 1, gain = 1, round_count = 0}}, rarity = 2, cost = 6,
    pos = {x = 9, y = 4}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = false,
    abno = true,
    risk = "teth",
    discover_rounds = 6,
}

joker.calculate = function(self, card, context)
    if context.setting_blind and not context.getting_sliced and not context.blueprint then
        G.GAME.lobc_no_hands_reset = true
    end

    if context.cardarea == G.jokers and context.before and not context.blueprint then
        card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.gain
        return {
            message = localize('k_upgrade_ex'),
            card = card,
            colour = G.C.MULT
        }
    end

    if context.joker_main and card.ability.extra.x_mult > 1 then
        return {
            x_mult = card.ability.extra.x_mult, 
            colour = G.C.MULT,
            card = context.blueprint_card or card,
        }
    end

    if context.end_of_round and not context.repetition and not context.individual then
        if G.GAME.current_round.hands_left <= 4 then 
            card.ability.extra.round_count = card.ability.extra.round_count + 1 
        else
            card.ability.extra.round_count = 0
        end

        if card.ability.extra.round_count >= 6 then
            check_for_unlock({type = "lobc_aspiration"})
        end

        if G.GAME.blind.boss then
            card.ability.extra.x_mult = 1
            if not G.GAME.modifiers.lobc_netzach then
                G.GAME.lobc_no_hands_reset = false
            end
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
end

joker.add_to_deck = function(self, card, from_debuff)
    G.GAME.lobc_no_hands_reset = true
end

joker.remove_from_deck = function(self, card, from_debuff)
    -- potential bug: two hearts of aspiration debuffed won't clear the no hands reset. too lazy to fix
    if not G.GAME.modifiers.lobc_netzach and #SMODS.find_card("j_lobc_heart_of_aspiration", true) == 0 then
        G.GAME.lobc_no_hands_reset = false
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { 
        card.ability.extra.x_mult, card.ability.extra.gain,
        card:check_rounds(2), card:check_rounds(4), card:check_rounds(6)
    }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(4) < 4 then
        desc_key = 'dis_'..desc_key..'_2'
    elseif card:check_rounds(6) < 6 then
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
    JokerDisplay.Definitions.j_lobc_heart_of_aspiration = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "x_mult" }
                }
            }
        },
        style_function = function(card, text, reminder_text, extra)
            if text then 
                text.states.visible = card:check_rounds(4) >= 4
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

-- funny free clashing abno card