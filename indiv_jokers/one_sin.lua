local joker = {
    name = "One Sin and Hundreds of Good Deeds",
    config = {extra = {mult = 3}}, rarity = 1, cost = 5,
    pos = {x = 2, y = 0}, 
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "zayin",
    discover_rounds = {2, 2},
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

joker.discover_override = function(self, level, card)
    if level == 2 and (not G.P_BLINDS["bl_lobc_whitenight"].discovered or card:check_rounds() < 2) then
        return "lobc_obs_one_sin_2"
    end
end

joker.loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.mult}}
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