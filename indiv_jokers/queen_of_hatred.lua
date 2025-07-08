local joker = {
    name = "The Queen of Hatred",
    config = {extra = {x_mult = 3, loss = 0.25, hysteria = false, round_count = 0}}, rarity = 3, cost = 7,
    pos = {x = 3, y = 0}, 
    blueprint_compat = true, 
    eternal_compat = false,
    perishable_compat = false,
    abno = true,
    risk = "waw",
    discover_rounds = {2, 3, 7},
    no_pool_flag = "queen_of_hatred_breach",
}

joker.calculate = function(self, card, context)
    if context.joker_main then
        return {
            x_mult = card.ability.extra.x_mult,
            card = context.blueprint_card or card,
        }
    end

    if context.end_of_round and not context.blueprint and context.main_eval then
        card.ability.extra.round_count = card.ability.extra.round_count + 1

        local chips_check = false
        if to_big then
            chips_check = (to_big(G.GAME.chips) >= to_big(G.GAME.blind.chips) * 3)
        else
            chips_check = (G.GAME.chips >= G.GAME.blind.chips * 3)
        end

        if chips_check then
            card.ability.extra.hysteria = true
        end

        if card.ability.extra.hysteria then
            if card.ability.extra.x_mult - card.ability.extra.loss <= 1 then
                abno_breach(card, 1)
                G.GAME.pool_flags["queen_of_hatred_breach"] = true
                return {
                    message = localize('k_lobc_breached'),
                    colour = G.C.FILTER
                }
            else
                card.ability.extra.x_mult = card.ability.extra.x_mult - card.ability.extra.loss
                return {
                    message = localize{type = 'variable', key = 'a_xmult_minus', vars = {card.ability.extra.loss}},
                    colour = G.C.RED
                }
            end
        else
            if card.ability.extra.round_count >= 9 then
                check_for_unlock({type = "lobc_love_and_hate"})
            end
        end
    end

    if context.selling_self and not context.blueprint then
        abno_breach(card, 1)
        G.GAME.pool_flags["queen_of_hatred_breach"] = true
    end
end

joker.loc_vars = function(self, info_queue, card)
    if card:check_rounds() >= 3 then info_queue[#info_queue+1] = {key = 'lobc_hysteria', set = 'Other'} end
    if card:check_rounds() >= 2 then info_queue[#info_queue+1] = {key = 'lobc_magical_girl_temp', set = 'Other'} end
    return {vars = {card.ability.extra.x_mult}}
end

if JokerDisplay then
    JokerDisplay.Definitions.j_lobc_queen_of_hatred = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "x_mult" }
                }
            }
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "hysteria", colour = G.C.IMPORTANT },
            { text = ")" }
        },
        calc_function = function(card)
            card.joker_display_values.hysteria = localize{type = 'name_text', set = 'Other', key = 'lobc_hysteria', nodes = {}}
        end,
        style_function = function(card, text, reminder_text, extra)
            if text then 
                text.states.visible = card:check_rounds(2) >= 2
            end
            if reminder_text then
                reminder_text.states.visible = (card:check_rounds(3) >= 3 and card.ability.extra.hysteria)
            end
            if extra then
            end
            return false
        end
    }
end

return joker

-- THE WORST WAW ABNO IN THE FUCKING GAME
-- but shes cute tho