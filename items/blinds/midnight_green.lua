local blind = {
    name = "Green Midnight",
    lobc_color = "green",
    lobc_time = "midnight",
    pos = {x = 0, y = 16},
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
    local hand_level = G.GAME.hands[handname].level
    local to_remove = hand_level/2
    if type(hand_level) == "table" then to_remove:ceil() else to_remove = math.ceil(to_remove) end
    if not check then
        level_up_hand(G.GAME.blind.children.animatedSprite, handname, nil, -to_remove)
        G.GAME.blind:wiggle()
    end
end

return blind