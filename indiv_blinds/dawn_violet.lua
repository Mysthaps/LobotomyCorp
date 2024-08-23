local blind = {
    name = "Violet Dawn",
    color = "violet",
    time = "dawn",
    pos = {x = 0, y = 9},
    dollars = 3, 
    mult = 1, 
    vars = {}, 
    debuff = {},
    loc_txt = {}
}

blind.set_blind = function(self, reset, silent)
    G.GAME.blind.prepped = nil
    -- this keeps track of the score
    G.GAME.blind.hands_sub = to_big(0)
end

blind.press_play = function(self)
    G.GAME.blind.prepped = true
end

blind.drawn_to_hand = function(self)
    if G.GAME.blind.prepped then
        local chips_this_round = to_big(G.GAME.chips) - to_big(G.GAME.blind.hands_sub)
        if chips_this_round <= to_big(G.GAME.blind.chips) * 0.2 then
            G.GAME.blind:wiggle()
            ease_hands_played(-1)

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