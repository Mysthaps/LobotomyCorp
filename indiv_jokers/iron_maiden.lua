local joker = {
    name = "We Can Change Anything",
    config = {extra = {
        blind_gain = 5, hands_loss = 0.02, 
        loss_increase = 0.02, interval = 10, 
        elapsed = 0, seconds = 0
    }}, rarity = 1, cost = 5,
    pos = {x = 7, y = 5}, 
    blueprint_compat = false, 
    eternal_compat = true,
    perishable_compat = false,
    abno = true,
    risk = "zayin",
    discover_rounds = 5,
}

joker.update = function(self, card, dt)
    if card.area == G.jokers and G.STAGE == G.STAGES.RUN and G.STATE == G.STATES.SELECTING_HAND and not card.debuff and not (G.GAME.blind and find_passive("psv_lobc_fixed_encounter")) then
        card.ability.extra.elapsed = card.ability.extra.elapsed + (dt / G.SETTINGS.GAMESPEED)
        if card.ability.extra.elapsed >= 1 then
            card.ability.extra.elapsed = card.ability.extra.elapsed - 1
            card.ability.extra.seconds = card.ability.extra.seconds + 1

            G.GAME.chips = G.GAME.chips + card.ability.extra.blind_gain
            G.GAME.chips_text = number_format(G.GAME.chips)
            G.hand_text_area.game_chips.config.scale = math.min(0.8, scale_number(G.GAME.chips, 1.1))
            G.GAME.current_round.hands_left = G.GAME.current_round.hands_left - card.ability.extra.hands_loss
            local chips_check = false
            if to_big then
                chips_check = (to_big(G.GAME.chips) >= to_big(G.GAME.blind.chips))
            else
                chips_check = (G.GAME.chips >= G.GAME.blind.chips)
            end

            if chips_check or G.GAME.current_round.hands_left <= 0 then
                play_sound("lobc_iron_maiden_end", 1, 0.4)
                G.STATE = G.STATES.NEW_ROUND
                G.STATE_COMPLETE = false
                if G.GAME.current_round.hands_left <= 0 then 
                    G.GAME.current_round.hands_left = 0
                    G.GAME.lobc_death_text = localize("k_lobc_iron_maiden") 
                end
            else
                play_sound("lobc_iron_maiden_tick", 1, 0.4)
            end

            if card.ability.extra.seconds >= card.ability.extra.interval then
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
                card.ability.extra.blind_gain = card.ability.extra.blind_gain * 2
                card.ability.extra.hands_loss = card.ability.extra.hands_loss + card.ability.extra.loss_increase
                card.ability.extra.hands_loss = math.floor(card.ability.extra.hands_loss*100)/100
                card.ability.extra.seconds = card.ability.extra.seconds - card.ability.extra.interval
                -- Update JokerDisplay text
                if card.joker_display_values then
                    card.joker_display_values.blind_gain = number_format(card.ability.extra.blind_gain)
                    card.joker_display_values.hands_loss = card:check_rounds(3) >= 3 and "-"..card.ability.extra.hands_loss or "???"
                end
            end
        end
    end
end

joker.set_ability = function(self, card, initial, delay_sprites)
    card.ability.extra.blind_gain = card.ability.extra.blind_gain * 2^(G.GAME.round_resets.ante-1)
    card.ability.extra.hands_loss = card.ability.extra.hands_loss + card.ability.extra.loss_increase*(G.GAME.round_resets.ante-1)
end

joker.calculate = function(self, card, context)
    if context.setting_blind and not card.getting_sliced then
        card.ability.extra.elapsed = 0
        card.ability.extra.seconds = 0
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { 
        number_format(card.ability.extra.blind_gain), card.ability.extra.hands_loss, card.ability.extra.interval, card.ability.extra.loss_increase,
        card:check_rounds(2), card:check_rounds(3), card:check_rounds(5) }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(3) < 3 then
        desc_key = 'dis_'..desc_key..'_2'
    elseif card:check_rounds(5) < 5 then
        desc_key = 'dis_'..desc_key..'_3'
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if not self.discovered and card.area ~= G.jokers then
        localize{type = 'descriptions', key = 'und_'..self.key, set = "Other", nodes = desc_nodes, vars = vars}
    elseif specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
        local check = (G.STAGE == G.STAGES.RUN and G.STATE == G.STATES.SELECTING_HAND) and not (G.GAME.blind and find_passive("psv_lobc_fixed_encounter"))
        desc_nodes[#desc_nodes+1] = {
            {n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
                {n=G.UIT.C, config={ref_table = self, align = "m", colour = check and G.C.GREEN or G.C.RED, r = 0.05, padding = 0.06}, nodes={
                    {n=G.UIT.T, config={text = ' '..localize(check and 'k_lobc_active' or 'k_lobc_inactive')..' ',colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.9}},
                }}
            }}
        }
    end
end

if JokerDisplay then
    JokerDisplay.Definitions.j_lobc_iron_maiden = {
        text = {
            { ref_table = "card.joker_display_values", ref_value = "blind_gain", colour = G.C.IMPORTANT },
            { text = ", " },
            { ref_table = "card.joker_display_values", ref_value = "hands_loss", colour = G.C.BLUE }
        },
        calc_function = function(card)
            card.joker_display_values.blind_gain = number_format(card.ability.extra.blind_gain)
            card.joker_display_values.hands_loss = card:check_rounds(3) >= 3 and "-"..card.ability.extra.hands_loss or "???"
        end,
        style_function = function(card, text, reminder_text, extra)
            if text then 
                text.states.visible = card:check_rounds(2) >= 2
                if text.children[3] then text.children[3].config.colour = card:check_rounds(3) >= 3 and G.C.BLUE or G.C.UI.TEXT_INACTIVE end
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

-- iron maiden
-- my lady has spoken
-- ga1ahad you will shall never collapse
-- so i charged up my lasers

-- ta lilalu lila
-- that makes your bones stronger than steel
-- tu lilata lila
-- that backs your thoughts up to the cloud