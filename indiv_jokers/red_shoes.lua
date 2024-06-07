local joker = {
    name = "Red Shoes",
    config = {extra = {gain = 10, selected_card = nil}}, rarity = 2, cost = 5,
    pos = {x = 5, y = 0}, 
    blueprint_compat = true, 
    eternal_compat = false,
    perishable_compat = false,
    abno = true,
    discover_rounds = 7,
    loc_txt = {
        name = "Red Shoes",
        text = {
            "Played cards permanently gain",
            "{C:chips}+#1#{} Chips when scored",
            "When {C:attention}Blind{} is selected, forces",
            "{C:attention}3{} cards to always be selected",
            "Destroys scored cards with",
            "{C:chips}50{} or more bonus Chips"
        }
    },
}

joker.process_loc_text = function(self)
    SMODS.Joker.process_loc_text(self)
    SMODS.process_loc_text(G.localization.descriptions["Other"], "und_j_lobc_red_shoes", {
        name = "O-04-08",
        text = {
            "The girl begged in tears.",
            "\"Mister, please cut off my feet...\"",
        }
    })
    SMODS.process_loc_text(G.localization.descriptions["Joker"], "dis_j_lobc_red_shoes_1", {
        name = "O-04-08",
        text = {
            "{C:attention}(#2#/2){} ...",
            "{C:attention}(#3#/3){} ...",
            "{C:attention}(#4#/7){} ..."
        }
    })
    SMODS.process_loc_text(G.localization.descriptions["Joker"], "dis_j_lobc_red_shoes_2", {
        name = "O-04-08",
        text = {
            "Played cards permanently gain",
            "{C:chips}+#1#{} Chips when scored",
            "{C:attention}(#3#/3){} ...",
            "{C:attention}(#4#/7){} ..."
        }
    })
    SMODS.process_loc_text(G.localization.descriptions["Joker"], "dis_j_lobc_red_shoes_3", {
        name = "O-04-08",
        text = {
            "Played cards permanently gain",
            "{C:chips}+#1#{} Chips when scored",
            "When {C:attention}Blind{} is selected, forces",
            "{C:attention}3{} cards to always be selected",
            "{C:attention}(#4#/7){} ..."
        }
    })
end

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
                
                    for i = 1, math.min(3, G.hand.config.highlighted_limit) do
                        if #available_cards > 0 then
                            local chosen_card, chosen_card_key = pseudorandom_element(available_cards, pseudoseed("random_card"))
                            chosen_card.ability.forced_selection = true
                            G.hand:add_to_highlighted(chosen_card)
                            table.remove(available_cards, chosen_card_key)
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

    if context.destroying_card and not context.blueprint and context.destroying_card.ability.perma_bonus >= 50 then
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

    if not card.config.center.discovered then
        full_UI_table.name = localize{type = 'name', key = 'und_'..self.key, set = "Other", name_nodes = {}, vars = specific_vars or {}}
    else
        full_UI_table.name = localize{type = 'name', key = self.key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    end
    localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
end

return joker