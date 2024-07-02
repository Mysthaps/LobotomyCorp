local blind = {
    name = "Crimson Dawn",
    color = "crimson",
    time = "dawn",
    pos = {x = 0, y = 8},
    dollars = 3, 
    mult = 0.8, 
    vars = {}, 
    debuff = {},
    boss = {min = 1, max = 10},
    loc_txt = {},
}

blind.set_blind = function(self)
    if G.GAME.current_round.hands_played > 0 and G.GAME.current_round.hands_played % 3 == 2 then
        G.GAME.blind.hands_sub = 1
        --G.GAME.blind:wiggle()
    else
        G.GAME.blind.hands_sub = 0
    end
end

blind.debuff_card = function(self, card, from_blind)
    if G.GAME.blind.hands_sub == 1 and card.area ~= G.jokers then
        card:set_debuff(true)
        return true
    end
end

blind.drawn_to_hand = function(self)
    if G.GAME.current_round.hands_played > 0 and G.GAME.current_round.hands_played % 3 == 2 then
        G.GAME.blind.hands_sub = 1
        G.GAME.blind:wiggle()
    end
end

return blind