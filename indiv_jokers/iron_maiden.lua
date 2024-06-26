-- iron maiden
-- my lady has spoken
-- ga1ahad you will shall never collapse
-- so i charged up my lasers

-- ta lilalu lila
-- that makes your bones stronger than steel
-- tu lilata lila
-- that backs your thoughts up to the cloud

local joker = {
    name = "We Can Change Anything",
    config = {extra = {
        blind_gain = 5, hands_loss = 0.02, 
        loss_increase = 0.02, interval = 10, 
        elapsed = 0, seconds = 0
    }}, rarity = 2, cost = 6,
    pos = {x = 7, y = 5}, 
    blueprint_compat = false, 
    eternal_compat = true,
    perishable_compat = false,
    abno = true,
    risk = "zayin",
    discover_rounds = 6,
    loc_txt = {},
}

joker.update = function(self, card, dt)
    if card.area == G.jokers and G.STAGE == G.STAGES.RUN and G.STATE == G.STATES.SELECTING_HAND and not card.debuff then
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
                G.GAME.current_round.hands_left = 0
                play_sound("lobc_iron_maiden_end", 1, 0.4)
                G.STATE = G.STATES.HAND_PLAYED
                G.STATE_COMPLETE = true
                if G.GAME.current_round.hands_left <= 0 then G.GAME.lobc_death_text = localize("k_lobc_iron_maiden") end
                end_round()
            else
                play_sound("lobc_iron_maiden_tick", 1, 0.4)
            end

            if card.ability.extra.seconds >= card.ability.extra.interval then
                card.ability.extra.blind_gain = card.ability.extra.blind_gain * 2
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex')})
                card.ability.extra.hands_loss = card.ability.extra.hands_loss + card.ability.extra.loss_increase
                card.ability.extra.seconds = card.ability.extra.seconds - card.ability.extra.interval
            end
        end
    end
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
        card:check_rounds(2), card:check_rounds(4), card:check_rounds(6) }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(4) < 4 then
        desc_key = 'dis_'..desc_key..'_2'
    elseif card:check_rounds(6) < 6 then
        desc_key = 'dis_'..desc_key..'_3'
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
        local check = (G.STAGE == G.STAGES.RUN and G.STATE == G.STATES.SELECTING_HAND)
        desc_nodes[#desc_nodes+1] = {
            {n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
                {n=G.UIT.C, config={ref_table = self, align = "m", colour = check and G.C.GREEN or G.C.RED, r = 0.05, padding = 0.06}, nodes={
                    {n=G.UIT.T, config={text = ' '..localize(check and 'k_lobc_active' or 'k_lobc_inactive')..' ',colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.9}},
                }}
            }}
        }
    end
end

return joker