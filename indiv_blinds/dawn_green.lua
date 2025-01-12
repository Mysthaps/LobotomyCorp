local blind = {
    name = "Green Dawn",
    color = "green",
    time = "dawn",
    pos = {x = 0, y = 6},
    dollars = 3, 
    mult = 1, 
    vars = {}, 
    debuff = {},
    boss_bcolour = HEX("008000"),
}

blind.debuff_hand = function(self, cards, hand, handname, check)
    if G.GAME.hands[handname].level > 0 and G.GAME.current_round.hands_played == 0 then
        G.GAME.blind.triggered = true
        if not check then
            level_up_hand(G.GAME.blind.children.animatedSprite, handname, nil, -1)
            G.GAME.blind:wiggle()
        end
    end
end

return blind