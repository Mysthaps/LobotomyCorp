local joker = {
    name = "All-Around Helper",
    config = {extra = {x_mult = 1, gain = 0.25, counter = 0}}, rarity = 2, cost = 7,
    pos = {x = 7, y = 1}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = false,
    abno = true,
    risk = "he",
    discover_rounds = 6,
    loc_txt = {},
}

joker.calculate = function(self, card, context)
    if context.end_of_round and not context.repetition and not context.individual then
        if G.GAME.current_round.hands_played == 1 then
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.gain
            card.ability.extra.counter = card.ability.extra.counter + 1
            if card.ability.extra.counter >= 4 then
                local available_cards = {}
                for _, v in ipairs(G.jokers.cards) do
                    if v ~= card and not v.ability.eternal then available_cards[#available_cards+1] = v end
                end

                if #available_cards > 0 then
                    local selected_card = pseudorandom_element(available_cards, pseudoseed("all_around_helper"))
                    selected_card:start_dissolve()
                    play_sound('slice1', 0.96+math.random()*0.08, 0.7)
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        func = function()
                            play_sound('lobc_helper_destroy', 1, 0.7)
                        return true
                        end
                    }))
                end
                card.ability.extra.counter = 0
            end
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT,
                card = card
            }
        end
    end

    if context.joker_main and card.ability.extra.x_mult > 1 then
        return {
            message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.x_mult}},
            Xmult_mod = card.ability.extra.x_mult, 
            colour = G.C.MULT
        }
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { 
        card.ability.extra.x_mult, card.ability.extra.gain, 4 - card.ability.extra.counter, 
        card:check_rounds(3), card:check_rounds(6)
    }
    local desc_key = self.key
    if card:check_rounds(3) < 3 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(6) < 6 then
        desc_key = 'dis_'..desc_key..'_2'
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
    end
end

-- JokerDisplay mod support
if SMODS.Mods["JokerDisplay"] then
    local jd_def = JokerDisplay.Definitions
    jd_def["j_lobc_all_around_helper"] = {
        line_1 = {
            {
                border_nodes = {
                    {
                        text = "X"
                    },
                    {
                        ref_table = "card.ability.extra",
                        ref_value = "x_mult"
                    }
                }
            }
        },
        line_2 = {
            {
                text = "(",
                colour = G.C.UI.TEXT_INACTIVE
            },
            {
                ref_table = "card.joker_display_values",
                ref_value = "blinds_remaining",
                colour = G.C.ORANGE
            },
            {
                text = " blinds)",
                colour = G.C.UI.TEXT_INACTIVE
            }
        },

        calc_function = function(card)
            card.joker_display_values.blinds_remaining = 4 - card.ability.extra.counter
        end
    }
end

return joker

-- the one that nobody cares


