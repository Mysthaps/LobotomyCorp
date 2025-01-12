local blind = {
    name = "Green Noon",
    color = "green",
    time = "noon",
    pos = {x = 0, y = 11},
    dollars = 4, 
    mult = 1.5, 
    vars = {}, 
    debuff = {},
    boss_bcolour = HEX("008000"),
}

blind.debuff_hand = function(self, cards, hand, handname, check)
	local highest_level = 0
	for _, v in ipairs(G.handlist) do
		if to_big(G.GAME.hands[v].level) > to_big(highest_level) then
			highest_level = G.GAME.hands[v].level
		end
	end

    if G.GAME.hands[handname].level == highest_level then
        G.GAME.blind.triggered = true
        if not check then
            level_up_hand(G.GAME.blind.children.animatedSprite, handname, nil, -1)
            G.GAME.blind:wiggle()
        end
    end
end

return blind