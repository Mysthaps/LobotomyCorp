local blind = {
    name = "Violet Noon",
    color = "violet",
    time = "noon",
    pos = {x = 0, y = 13},
    dollars = 4, 
    mult = 1.5, 
    vars = {}, 
    debuff = {},
    loc_txt = {}
}

blind.set_blind = function(self, reset, silent)
    G.GAME.blind.prepped = nil
    -- this keeps track of the score
    G.GAME.blind.hands_sub = 0
    -- increase blind size
    local chips = get_blind_amount(G.GAME.round_resets.ante) * G.GAME.starting_params.ante_scaling * G.consumeables.config.card_limit * 0.2
    if type(chips) == 'table' then chips:ceil() else chips = math.ceil(chips) end
    G.GAME.blind.chips = G.GAME.blind.chips + chips
    G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips)
    G.HUD_blind:recalculate()
    G.hand_text_area.blind_chips:juice_up()
end

blind.press_play = function(self)
    G.GAME.blind.prepped = true
end

blind.drawn_to_hand = function(self)
    if G.GAME.blind.prepped then
        local chips_this_round = to_big(G.GAME.chips) - to_big(G.GAME.blind.hands_sub)
        if chips_this_round <= to_big(G.GAME.blind.chips) * 0.2 then
            G.GAME.blind:wiggle()
            ease_hands_played(-2)

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                func = function()
                    if G.GAME.current_round.hands_left <= 0 then 
                        G.STATE = G.STATES.NEW_ROUND
                        G.STATE_COMPLETE = false
                    end
                return true
                end
            }))
        end
        G.GAME.blind.hands_sub = G.GAME.blind.hands_sub + chips_this_round
    end
end

return blind