local joker = {
    name = "The Queen of Hatred",
    config = {extra = {x_mult = 5, loss = 0.5, hysteria = false}}, rarity = 3, cost = 8,
    pos = {x = 3, y = 0}, 
    blueprint_compat = true, 
    eternal_compat = false,
    perishable_compat = false,
    abno = true,
    discover_rounds = 7,
    loc_txt = {
        name = "The Queen of Hatred",
        text = {
            "{X:red,C:white} X#1# {} Mult",
            "If score is at least {X:red,C:white} X5 {} of {C:attention}Blind{},",
            "this Abnormality enters {C:attention}Hysteria{}",
            "At {X:red,C:white} X1 {} Mult, destroys itself",
            "and permanent {X:red,C:white} X2 {} Blind Size"
        }
    },
}

joker.process_loc_text = function(self)
    SMODS.Joker.process_loc_text(self)
    SMODS.process_loc_text(G.localization.descriptions["Other"], "und_j_lobc_queen_of_hatred", {
        name = "O-01-04",
        text = {
            "In the name of",
            "Love and Justice~",
            "Here comes Magical Girl!"
        }
    })
    SMODS.process_loc_text(G.localization.descriptions["Joker"], "dis_j_lobc_queen_of_hatred_1", {
        name = "O-01-04",
        text = {
            "{C:attention}(#2#/2){} ...",
            "{C:attention}(#3#/3){} ...",
            "{C:attention}(#4#/7){} ...",
        }
    })
    SMODS.process_loc_text(G.localization.descriptions["Joker"], "dis_j_lobc_queen_of_hatred_2", {
        name = "O-01-04",
        text = {
            "{X:red,C:white} X#1# {} Mult",
            "{C:attention}(#3#/3){} ...",
            "{C:attention}(#4#/7){} ...",
        }
    })
    SMODS.process_loc_text(G.localization.descriptions["Joker"], "dis_j_lobc_queen_of_hatred_3", {
        name = "O-01-04",
        text = {
            "{X:red,C:white} X#1# {} Mult",
            "If score is at least {X:red,C:white} X5 {} of {C:attention}Blind{},",
            "this Abnormality enters {C:attention}Hysteria{}",
            "{C:attention}(#4#/7){} ...",
        }
    })
end

joker.calculate = function(self, card, context)
    if context.joker_main then
        return {
            message = localize{type= 'variable', key='a_xmult', vars={card.ability.extra.x_mult}},
            Xmult_mod = card.ability.extra.x_mult
        }
    end

    if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
        if G.GAME.chips >= G.GAME.blind.chips * 5 then
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
                                return true; end})) 
                        return true
                    end
                })) 
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
        end
    end
    

    if not card.config.center.discovered then
        full_UI_table.name = localize{type = 'name', key = 'und_'..self.key, set = "Other", name_nodes = {}, vars = specific_vars or {}}
    else
        full_UI_table.name = localize{type = 'name', key = self.key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    end
    localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
end

return joker