local blind = {
    name = "Green Dusk",
    color = "green",
    time = "dusk",
    pos = {x = 0, y = 2},
    dollars = 5, 
    mult = 2, 
    vars = {}, 
    debuff = {},
    boss = {min = 1, max = 10},
    passives = {
        "psv_lobc_irresponsible",
    },
}

blind.debuff_hand = function(self, cards, hand, handname, check)
    G.GAME.blind.triggered = true
    if not check then
        level_up_hand(G.GAME.blind.children.animatedSprite, handname, nil, -2)
        G.GAME.blind:wiggle()
    end
end

return blind