local joker = {
    name = "We Can Change Anything",
    config = {extra = {
        chips = 0, hands_loss = 0.01, 
        chips_gain = 2, chips_gain_increase = 1, loss_increase = 0.005,
        interval = 1.5, elapsed = 0, times = 0,
        active = false, 
    }}, rarity = 1, cost = 5,
    pos = {x = 7, y = 5}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "zayin",
    discover_rounds = 5,
}

joker.update = function(self, card, dt)
    if card.area == G.jokers and card.ability.extra.active and 
        G.STAGE == G.STAGES.RUN and G.STATE == G.STATES.SELECTING_HAND and not card.debuff then
        card.ability.extra.elapsed = card.ability.extra.elapsed + (dt / G.SETTINGS.GAMESPEED)
        if card.ability.extra.elapsed >= card.ability.extra.interval then
            card.ability.extra.elapsed = card.ability.extra.elapsed - card.ability.extra.interval

            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain
            G.GAME.current_round.hands_left = G.GAME.current_round.hands_left - card.ability.extra.hands_loss
            card.ability.extra.times = card.ability.extra.times + 1

            if G.GAME.current_round.hands_left <= 0 then
                play_sound("lobc_iron_maiden_end", 1, 0.4)
                G.STATE = G.STATES.NEW_ROUND
                G.STATE_COMPLETE = false
                G.GAME.current_round.hands_left = 0
                G.GAME.lobc_death_text = "iron_maiden"
            else
                play_sound("lobc_iron_maiden_tick", 1, 0.4)
            end

            if card.ability.extra.times >= 5 then
                --card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
                --card.ability.extra.chips_gain = card.ability.extra.chips_gain + card.ability.extra.chips_gain_increase
                card.ability.extra.hands_loss = card.ability.extra.hands_loss + card.ability.extra.loss_increase
                card.ability.extra.hands_loss = math.floor(card.ability.extra.hands_loss*1000)/1000
                -- Update JokerDisplay text
                if card.joker_display_values then
                    card.joker_display_values.chips = card.ability.extra.chips
                end
                card.ability.extra.times = 0
                card.ability.extra.interval = card.ability.extra.interval / 2
            end
        end
    end
end

joker.lobc_can_use_active = function(self, card)
    return G.GAME.blind and G.GAME.blind.in_blind and not card.ability.extra.active
end

joker.lobc_active = function(self, card)
    card.ability.extra.active = true
    card.ability.extra.elapsed = card.ability.extra.interval
    G.GAME.lobc_maiden_active = true
    card:juice_up()
end

joker.calculate = function(self, card, context)
    if context.joker_main and card.ability.extra.active and card.ability.extra.chips > 0 then
        local temp = card.ability.extra.chips
        card.ability.extra.chips = 0
        card.ability.extra.hands_loss = 0.01
        card.ability.extra.interval = 1.5
        card.ability.extra.elapsed = 0
        card.ability.extra.active = false
        card.ability.extra.times = 0
        G.GAME.lobc_maiden_active = false
        G.E_MANAGER:add_event(Event({trigger = 'after', func = function()
            if G.GAME.current_round.hands_left < 1 then
                G.GAME.lobc_death_text = "iron_maiden"
            end
        return true end }))
        play_sound("lobc_iron_maiden_end", 1, 0.4)
        return {
            chips = temp
        }
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { 
        card.ability.extra.interval, card.ability.extra.hands_loss, card.ability.extra.chips_gain,
        card.ability.extra.loss_increase, card.ability.extra.chips_gain_increase, card.ability.extra.chips,
        card:check_rounds(1), card:check_rounds(3), card:check_rounds(5) }
    local desc_key = self.key
    if card:check_rounds(1) < 1 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(3) < 3 then
        desc_key = 'dis_'..desc_key..'_2'
    elseif card:check_rounds(5) < 5 then
        desc_key = 'dis_'..desc_key..'_3'
    end
    info_queue[#info_queue+1] = {key = 'lobc_active_ability', set = 'Other'}

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if not self.discovered and card.area ~= G.jokers then
        localize{type = 'descriptions', key = 'und_'..self.key, set = "Other", nodes = desc_nodes, vars = vars}
    elseif specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
        desc_nodes[#desc_nodes+1] = {
            {n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
                {n=G.UIT.C, config={ref_table = self, align = "m", colour = card.ability.extra.active and G.C.GREEN or G.C.RED, r = 0.05, padding = 0.06}, nodes={
                    {n=G.UIT.T, config={text = ' '..localize(card.ability.extra.active and 'k_lobc_active' or 'k_lobc_inactive')..' ',colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.9}},
                }}
            }}
        }
    end
end

if JokerDisplay then
    JokerDisplay.Definitions.j_lobc_iron_maiden = {
        text = {
            { text = "+", colour = G.C.CHIPS },
            { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS }
        },
        calc_function = function(card)
            card.joker_display_values.chips = card.ability.extra.chips
        end,
        style_function = function(card, text, reminder_text, extra)
            if text then 
                text.states.visible = card:check_rounds(2) >= 2
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