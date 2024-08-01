local joker = {
    name = "CENSORED",
    config = {extra = {
        mult = 10,
        x_mult = 1.5,
        chips = 30,
    }}, rarity = 3, cost = 9,
    pos = {x = 1, y = 6}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "aleph",
    discover_rounds = 8,
    loc_txt = {},
}

joker.calculate = function(self, card, context)
    if context.individual and context.cardarea == G.hand then
        if context.other_card.debuff then
            return {
                message = localize('k_debuffed'),
                colour = G.C.RED,
                card = card,
            }
        else
            return {
                h_chips = card.ability.extra.chips,
                card = card
            }
        end
    end

    if context.joker_main then
        for _, v in ipairs(G.jokers.cards) do
            if v.debuff then
                SMODS.eval_this(v, {
                    message = localize('k_debuffed'),
                    colour = G.C.RED,
                })
            else
                SMODS.eval_this(v, {
                    message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
                    mult_mod = card.ability.extra.mult, 
                    colour = G.C.MULT
                })
            end
        end
        for _, v in ipairs(G.consumeables.cards) do
            if v.debuff then
                SMODS.eval_this(v, {
                    message = localize('k_debuffed'),
                    colour = G.C.RED,
                })
            else
                SMODS.eval_this(v, {
                    message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.x_mult}},
                    Xmult_mod = card.ability.extra.x_mult, 
                    colour = G.C.MULT
                })
            end
        end
    end

    if context.after and context.cardarea == G.jokers and not context.blueprint then
        local available_cards = {}
        for _, v in ipairs(G.jokers.cards) do
            if v ~= card and not v.ability.lobc_censored then available_cards[#available_cards+1] = v end
        end
        for _, v in ipairs(G.consumeables.cards) do
            if v ~= card and not v.ability.lobc_censored then available_cards[#available_cards+1] = v end
        end
        for _, v in ipairs(G.playing_cards) do
            if v ~= card and not v.ability.lobc_censored then available_cards[#available_cards+1] = v end
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after', 
            func = function()
                if #available_cards > 0 then
                    local selected_card = pseudorandom_element(available_cards, pseudoseed("censored_select"))
        
                    selected_card.ability.lobc_censored = true
                    selected_card:set_sprites(selected_card.config.center)
                    selected_card:juice_up()
        
                    play_sound("lobc_censored", 1, 0.1)
                end
            return true 
            end 
        }))
    end
end

joker.add_to_deck = function(self, card, from_debuff)
    G.E_MANAGER:add_event(Event({
        trigger = 'after', 
        func = function()
            if JokerDisplay and not from_debuff then
                for k, v in pairs(G.jokers.cards) do
                    v.children.joker_display = nil
                    v:update_joker_display(false, true, "j_lobc_censored")
                end
            end
        return true 
        end 
    }))
    
end

joker.remove_from_deck = function(self, card, from_debuff)
    if JokerDisplay and not from_debuff then
        for k, v in pairs(G.jokers.cards) do
            v.children.joker_display = nil
            v:update_joker_display(false, true, "j_lobc_censored")
        end
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { 
        card.ability.extra.mult, card.ability.extra.x_mult, card.ability.extra.chips, 
        card:check_rounds(2), card:check_rounds(5), card:check_rounds(8),
    }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(5) < 5 then
        desc_key = 'dis_'..desc_key..'_2'
    elseif card:check_rounds(8) < 8 then
        desc_key = 'dis_'..desc_key..'_3'
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
    end
end

if JokerDisplay then
    --[[JokerDisplay.Definitions.j_lobc_censored = {
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
            { ref_table = "card.joker_display_values", ref_value = "remaining_text", colour = G.C.IMPORTANT },
            { text = ")" }
        },
        calc_function = function(card)
            card.joker_display_values.remaining_text = localize{type = 'variable', key = 'loyalty_inactive', vars = {4 - card.ability.extra.counter}}
        end,
        style_function = function(card, text, reminder_text, extra)
            if text then 
                text.states.visible = card:check_rounds(3) >= 3
            end
            if reminder_text then
                reminder_text.states.visible = card:check_rounds(6) >= 6
            end
            if extra then
            end
            return false
        end
    }]]--

    JokerDisplay.Definitions.lobc_other_censored = {
        text = {
            { text = "CENSORED", colour = G.C.RED },
        },
    }
end

return joker

-- Hello?
-- I love you.