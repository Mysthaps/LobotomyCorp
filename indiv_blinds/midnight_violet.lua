local blind = {
    name = "Violet Midnight",
    color = "violet",
    time = "midnight",
    pos = {x = 0, y = 18},
    dollars = 5, 
    mult = 3, 
    vars = {}, 
    debuff = {},
    boss = {min = 1, max = 10},
    loc_txt = {}
}

blind.set_blind = function(self, reset, silent)
    G.GAME.blind.prepped = nil
    -- this keeps track of the score
    G.GAME.blind.hands_sub = 0
end

blind.press_play = function(self)
    G.GAME.blind.prepped = true
end

blind.drawn_to_hand = function(self)
    if G.GAME.blind.prepped then
        local chips_this_round = to_big(G.GAME.chips) - to_big(G.GAME.blind.hands_sub)
        if chips_this_round <= to_big(G.GAME.blind.chips) * 0.4 then
            G.GAME.blind:wiggle()
            G.STATE = G.STATES.GAME_OVER
            if not G.GAME.won and not G.GAME.seeded and not G.GAME.challenge then 
                G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt = 0
            end
            G:save_settings()
            G.FILE_HANDLER.force = true
            G.STATE_COMPLETE = false
        end
        G.GAME.blind.hands_sub = G.GAME.blind.hands_sub + chips_this_round
    end
end

return blind