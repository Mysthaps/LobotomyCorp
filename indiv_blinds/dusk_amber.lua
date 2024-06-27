local blind = {
    name = "Amber Dusk",
    color = "amber",
    time = "dusk",
    pos = {x = 0, y = 3},
    dollars = 5, 
    mult = 2, 
    vars = {}, 
    debuff = {},
    boss = {min = 1, max = 10},
    boss_colour = HEX('FFA500'),
    loc_txt = {}
}

blind.press_play = function(self)
    local proc = false
    G.E_MANAGER:add_event(Event({
        func = function()
            for _, v in ipairs(G.play.cards) do
                if v.debuff then
                    proc = true
                    v:start_dissolve() 
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.2*G.SETTINGS.GAMESPEED,
                        func = function() 
                            G.GAME.blind:wiggle()
                            return true
                        end 
                    }))
                end
            end
            return true 
        end 
    }))
    return proc
end

blind.defeat = function(self)
    for _, v in ipairs(G.playing_cards) do
        v.ability.dusk_amber_debuff = nil
    end
end

blind.disable = function(self)
    for _, v in ipairs(G.playing_cards) do
        v.ability.dusk_amber_debuff = nil
    end
end

return blind