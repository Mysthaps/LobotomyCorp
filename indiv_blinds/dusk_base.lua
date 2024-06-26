local blind = {
    name = "Dusk Ordeal",
    color = "base",
    time = "dusk",
    discovered = true,
    pos = {x = 0, y = 1},
    dollars = 5, 
    mult = 2, 
    vars = {}, 
    debuff = {},
    boss = {min = 1, max = 10},
    boss_colour = HEX('C4C4C4'),
    loc_txt = {}
}

blind.set_blind = function(self, reset, silent)
    local dusk_blinds = {
        "dusk_green"
    }

    local chosen_blind = pseudorandom_element(dusk_blinds, pseudoseed("dusk_ordeal"))
    G.GAME.blind:set_blind(G.P_BLINDS['bl_lobc_'..chosen_blind])
end

return blind