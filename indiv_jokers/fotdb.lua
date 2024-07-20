local joker = {
    name = "Funeral of the Dead Butterflies",
    config = {extra = {x_mult = 1, gain = 1}}, rarity = 2, cost = 7,
    pos = {x = 0, y = 4}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "he",
    discover_rounds = 6,
    loc_txt = {},
}

joker.calculate = function(self, card, context)
    if context.end_of_round and not context.repetition and not context.individual and G.GAME.blind.boss then
        local available_cards = {}
        for _, v in ipairs(G.jokers.cards) do
            if v.config.center.eternal_compat and not v.ability.eternal and not v.ability.perishable then 
                available_cards[#available_cards+1] = v 
            end
        end

        if #available_cards > 0 then
            local selected_card = pseudorandom_element(available_cards, pseudoseed("fotdb"))
            selected_card:set_eternal(true)
            selected_card:juice_up()
            play_sound("lobc_butterfly_attack", 1, 0.2)
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

joker.set_ability = function(self, card, initial, delay_sprites)
    card.ability.eternal = true
end

joker.update = function(self, card, dt)
    if G.STAGE == G.STAGES.RUN then
        card.ability.extra.x_mult = 0
        for k, v in pairs(G.jokers.cards) do
            if v.ability.eternal then card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.gain end
        end
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { 
        card.ability.extra.x_mult, card.ability.extra.gain, card:check_rounds(1), card:check_rounds(3), card:check_rounds(6)
    }
    local desc_key = self.key
    if card:check_rounds(1) < 1 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(3) < 3 then
        desc_key = 'dis_'..desc_key..'_2'
    elseif card:check_rounds(6) < 6 then
        desc_key = 'dis_'..desc_key..'_3'
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
    end
end

if SMODS.Mods.JokerDisplay then
    JokerDisplay.Definitions.j_lobc_fotdb = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "x_mult" }
                }
            }
        },
        style_function = function(card, text, reminder_text, extra)
            if text then 
                text.states.visible = card:check_rounds(3) >= 3
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

-- the one that nobody cares