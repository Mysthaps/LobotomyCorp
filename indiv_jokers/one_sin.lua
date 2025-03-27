local joker = {
    name = "One Sin and Hundreds of Good Deeds",
    config = {extra = {mult = 3}}, rarity = 1, cost = 5,
    pos = {x = 2, y = 0}, 
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "zayin",
    discover_rounds = 2,
    no_pool_flag = "plague_doctor_breach",
}

joker.calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
        return {
            mult = card.ability.extra.mult,
            card = context.blueprint_card or card,
        }
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { card.ability.extra.mult, card:check_rounds(2), card:check_rounds(666) }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif not G.P_BLINDS["bl_lobc_whitenight"].discovered then
        desc_key = 'dis_'..desc_key..'_2'
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if not self.discovered and card.area ~= G.jokers then
        localize{type = 'descriptions', key = 'und_'..self.key, set = "Other", nodes = desc_nodes, vars = vars}
    elseif not self.discovered and card.area ~= G.jokers then
        localize{type = 'descriptions', key = 'und_'..self.key, set = "Other", nodes = desc_nodes, vars = vars}
    elseif specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
    end
end

-- Modified from OppositeWolf770's implementation
if JokerDisplay then
    JokerDisplay.Definitions.j_lobc_one_sin = {
        text = {
            { text = "+", colour = G.C.MULT },
            {
                ref_table = "card.joker_display_values",
                ref_value = "mult",
                colour = G.C.MULT
            }
        },

        calc_function = function(card)
            local mult = 0
            local hand = next(G.play.cards) and G.play.cards or G.hand.highlighted
            local _, _, scoring_hand = JokerDisplay.evaluate_hand(hand)

            for i = 1, #scoring_hand do
                if not scoring_hand[i].debuff then
                    mult = mult + card.ability.extra.mult
                end
            end

            card.joker_display_values.mult = mult
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

-- you know you fucked up when you let one sin breach