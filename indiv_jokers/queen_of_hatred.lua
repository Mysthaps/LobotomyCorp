local joker = {
    name = "The Queen of Hatred",
    config = {extra = {x_mult = 5, loss = 0.5, hysteria = false}}, rarity = 3, cost = 8,
    pos = {x = 3, y = 0}, 
    blueprint_compat = true, 
    eternal_compat = false,
    perishable_compat = false,
    abno = true,
    risk = "waw",
    discover_rounds = 7,
    no_pool_flag = "queen_of_hatred_breach",
    loc_txt = {},
}

joker.calculate = function(self, card, context)
    if context.joker_main then
        return {
            message = localize{type= 'variable', key='a_xmult', vars={card.ability.extra.x_mult}},
            Xmult_mod = card.ability.extra.x_mult
        }
    end

    if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
        local chips_check = false
        if to_big then
            chips_check = (to_big(G.GAME.chips) >= to_big(G.GAME.blind.chips) * 5)
        else
            chips_check = (G.GAME.chips >= G.GAME.blind.chips * 5)
        end

        if chips_check then
            card.ability.extra.hysteria = true
        end

        if card.ability.extra.hysteria then
            if card.ability.extra.x_mult - card.ability.extra.loss <= 1 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling * 2
                        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                            func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil
                            return true;
                            end
                        })) 
                    return true
                    end
                })) 
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
        end
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { card.ability.extra.x_mult, card:check_rounds(2), card:check_rounds(3), card:check_rounds(7) }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(3) < 3 then
        desc_key = 'dis_'..desc_key..'_2'
    else
        info_queue[#info_queue+1] = {key = 'lobc_hysteria', set = 'Other'}
        if card:check_rounds(7) < 7 then
            desc_key = 'dis_'..desc_key..'_3'
        else
            info_queue[#info_queue+1] = {key = 'lobc_magical_girl', set = 'Other'}
        end
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
    end
end

return joker