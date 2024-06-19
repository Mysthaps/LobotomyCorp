local joker = {
    name = "The Servant of Wrath",
    config = {extra = {counter = 0, x_mult = 2.5}}, rarity = 3, cost = 8,
    pos = {x = 4, y = 8}, 
    blueprint_compat = true, 
    eternal_compat = false,
    perishable_compat = false,
    abno = true,
    risk = "waw",
    discover_rounds = 7,
    no_pool_flag = "servant_of_wrath_breach",
    loc_txt = {},
}

joker.calculate = function(self, card, context)
    if context.first_hand_drawn and not context.blueprint then
        G.hand:sort('desc')
        G.E_MANAGER:add_event(Event({
            func = function() 
                local text, loc_disp_text, poker_hands, scoring_hand, disp_text = G.FUNCS.get_poker_hand_info(G.hand.cards)
                for _, v in ipairs(scoring_hand) do
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.2,
                        func = function() 
                            G.hand:add_to_highlighted(v)
                        return true 
                        end 
                    })) 
                end

                G.E_MANAGER:add_event(Event({
                    func = function() 
                        G.FUNCS.play_cards_from_highlighted({})
                    return true 
                    end 
                })) 

                if #scoring_hand < 4 then 
                    card.ability.extra.counter = card.ability.extra.counter + 1
                    SMODS.eval_this(card, {
                        message = (card.ability.extra.counter..'/3'),
                        colour = G.C.FILTER
                    })
                end
            return true 
            end 
        }))
    end

    if context.individual and context.cardarea == G.play and G.GAME.current_round.hands_played == 0 then
        return {
            x_mult = card.ability.extra.x_mult,
            card = card
        }
    end

    if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
        if card.ability.extra.counter >= 3 then
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card.T.r = -0.2
                    card:juice_up(0.3, 0.4)
                    card.states.drag.is = true
                    card.children.center.pinch.x = true
                    G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling * 2
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.3,
                        blockable = false,
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
            G.GAME.pool_flags["servant_of_wrath_breach"] = true
            return {
                message = localize('k_lobc_breached'),
                colour = G.C.FILTER
            }
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
    elseif card:check_rounds(7) < 7 then
        desc_key = 'dis_'..desc_key..'_3'
    else
        info_queue[#info_queue+1] = {key = 'lobc_magical_girl', set = 'Other'}
    end
    
    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
    end
end

return joker
