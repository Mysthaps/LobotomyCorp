local blind = {
    name = "WhiteNight",
    slug = "whitenight", 
    dollars = 8, 
    mult = 66.6, 
    vars = {}, 
    debuff = {},
    boss = {showdown = true, min = 10, max = 10},
    boss_colour = HEX('D41C25'),
    loc_txt = {
        name = "WhiteNight",
        text = {
            "Scored Apostles reduce",
            "blind size by 5X Base"
        }
    }
}

blind.set_blind = function(self, blind)
    for _, v in ipairs(G.playing_cards) do
        if v.ability and v.ability.plague_doctor_baptism then
            v.debuff = true
        end
    end
end

blind.disable = function(self, blind)
    for _, v in ipairs(G.playing_cards) do
        if v.ability and v.ability.plague_doctor_baptism then
            G.E_MANAGER:add_event(Event({
                func = function() 
                    v:start_dissolve() 
                    return true
                end 
            }))
        end
    end
    attention_text({
        text = localize('k_lobc_whitenight_disable'),
        scale = 0.35, 
        hold = 8*G.SETTINGS.GAMESPEED,
        major = G.play,
        backdrop_colour = G.C.CLEAR,
        align = 'cm',
        offset = {x = 0, y = -3.5},
        silent = true
    })
    blind:wiggle()
end

blind.defeat = function(self, blind)
    G.GAME.pool_flags["whitenight_defeated"] = true
    for _, v in ipairs(G.playing_cards) do
        if v.ability and v.ability.plague_doctor_baptism then
            G.E_MANAGER:add_event(Event({
                func = function() 
                    v:start_dissolve() 
                    return true
                end 
            }))
        end
    end
end

blind.press_play = function(self, blind)
    G.E_MANAGER:add_event(Event({
        trigger = 'after', 
        delay = 0.2*G.SETTINGS.GAMESPEED, 
        func = function()
            for _, v in ipairs(G.play.cards) do
                if v.ability and v.ability.plague_doctor_baptism then
                    G.E_MANAGER:add_event(Event({
                        func = function() 
                            v:start_dissolve() 
                            return true
                        end 
                    }))
                    blind.chips = blind.chips - get_blind_amount(G.GAME.round_resets.ante)*G.GAME.starting_params.ante_scaling*5
                    blind.chip_text = number_format(blind.chips)
                    delay(0.2*G.SETTINGS.GAMESPEED)
                end
            end
            return true 
        end 
    }))
    return true
end

return blind