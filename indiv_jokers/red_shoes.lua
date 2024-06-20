local joker = {
    name = "Red Shoes",
    config = {extra = {gain = 10, selected_card = nil}}, rarity = 2, cost = 5,
    pos = {x = 5, y = 0}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "he",
    discover_rounds = 7,
    loc_txt = {},
}

joker.calculate = function(self, card, context)
    if context.first_hand_drawn and not context.blueprint then
        if #G.hand.highlighted < G.hand.config.highlighted_limit then
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.2*G.SETTINGS.GAMESPEED,
                func = function() 
                    local available_cards = {}

                    for _, v in ipairs(G.hand.cards) do
                        if not v.ability.forced_selection then
                            available_cards[#available_cards+1] = v
                        end
                    end
                
                    for i = 1, math.min(2, G.hand.config.highlighted_limit - #G.hand.highlighted) do
                        if #available_cards > 0 then
                            local chosen_card, chosen_card_key = pseudorandom_element(available_cards, pseudoseed("random_card"))
                            G.E_MANAGER:add_event(Event({
                                func = function() 
                                    chosen_card.ability.forced_selection = true
                                    G.hand:add_to_highlighted(chosen_card)
                                return true 
                                end 
                            })) 
                            table.remove(available_cards, chosen_card_key)
                            delay(0.2)
                        end
                    end
                return true
                end
            }))
        end
    end

    if context.individual and context.cardarea == G.play then
        context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0
        context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + card.ability.extra.gain
        return {
            extra = {message = localize('k_upgrade_ex'), colour = G.C.CHIPS},
            colour = G.C.CHIPS,
            card = card
        }
    end

    if context.destroying_card and not context.blueprint and
       context.destroying_card.ability.perma_bonus >= 100 and not context.destroying_card.ability.eternal then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                play_sound('slice1', 0.96+math.random()*0.08, 0.7)
            return true
            end
        }))
        return true
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { card.ability.extra.gain, card:check_rounds(2), card:check_rounds(3), card:check_rounds(7) }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(3) < 3 then
        desc_key = 'dis_'..desc_key..'_2'
    elseif card:check_rounds(7) < 7 then
        desc_key = 'dis_'..desc_key..'_3'
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
    end
end

return joker