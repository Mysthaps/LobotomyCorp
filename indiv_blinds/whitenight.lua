local blind = {
    name = "WhiteNight",
    pos = {x = 0, y = 0},
    dollars = 8, 
    mult = 66.6, 
    vars = {}, 
    debuff = {},
    boss = {showdown = true, min = 10, max = 10},
    boss_colour = HEX('D41C25'),
    passives = {
        "psv_lobc_the_time_has_come",
        "psv_lobc_rise_and_serve_me",
        "psv_lobc_suppression"
    }
}

blind.set_blind = function(self, reset, silent)
    if next(SMODS.find_card("j_lobc_one_sin", true)) then
        lobc_screen_text({
            text = localize('k_lobc_whitenight_confession'),
            scale = 0.35, 
            hold = 4*G.SETTINGS.GAMESPEED,
            major = G.play,
            align = 'cm',
            offset = {x = 0, y = -3.5},
            noisy = false
        })
    end

    if G.GAME.modifiers.lobc_all_whitenight then
        if G.GAME.round_resets.blind_ante <= 1 then G.GAME.blind.chips = G.GAME.blind.chips / 6 end
        if G.GAME.round_resets.blind_ante == 2 then G.GAME.blind.chips = G.GAME.blind.chips / 3 end
        if G.GAME.round_resets.blind_ante == 3 then G.GAME.blind.chips = G.GAME.blind.chips / 2 end
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end

    local eval_func = function()
        return G.GAME.blind and G.GAME.blind.config.blind.key == 'bl_lobc_whitenight'
    end
    if not next(SMODS.find_card("j_lobc_one_sin", true)) then lobc_abno_text("whitenight", eval_func, 2, 12) end
end

blind.recalc_debuff = function(self, card, from_blind)
    if card.ability.plague_doctor_baptism then
        return true
    end
end

blind.disable = function(self)
    if not next(SMODS.find_card("j_lobc_one_sin", true)) then
        lobc_screen_text({
            text = localize('k_lobc_whitenight_disable'),
            scale = 0.35, 
            hold = 8*G.SETTINGS.GAMESPEED,
            major = G.play,
            backdrop_colour = G.C.CLEAR,
            align = 'cm',
            offset = {x = 0, y = -3.5},
            noisy = false,
            float = false
        })
        G.GAME.blind:wiggle()
    end
end

blind.defeat = function(self)
    if not G.GAME.modifiers.lobc_all_whitenight then
        G.GAME.pool_flags["whitenight_defeated"] = true
        if not next(SMODS.find_card("j_lobc_one_sin", true)) then
            G.GAME.joker_buffer = G.GAME.joker_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = function() 
                    local card = create_card('Abnormality', G.jokers, nil, 0, nil, nil, "j_lobc_whitenight", 'wn')
                    card:add_to_deck()
                    G.jokers:emplace(card)
                    card:start_materialize()
                    G.GAME.joker_buffer = 0
                    return true
                end
            }))
        else
            G.GAME.pool_flags["whitenight_confessed"] = true
            check_for_unlock({type = "lobc_penitence"})
        end
    end
end

blind.press_play = function(self)
    local proc = false
    local base_chips = get_blind_amount(G.GAME.round_resets.ante)*G.GAME.starting_params.ante_scaling
    local destroyed_cards = {}
    G.E_MANAGER:add_event(Event({
        func = function()
            for _, v in ipairs(G.play.cards) do
                if v.ability and v.ability.plague_doctor_baptism then
                    if G.GAME.blind.chips > base_chips*6.66 then
                        proc = true
                        destroyed_cards[#destroyed_cards+1] = v
                        v:start_dissolve() 
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.2*G.SETTINGS.GAMESPEED,
                            func = function() 
                                G.GAME.blind.chips = G.GAME.blind.chips - base_chips*5
                                G.GAME.blind.chips = math.max(G.GAME.blind.chips, base_chips*6.66)
                                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                                G.GAME.blind:wiggle()
                                return true
                            end 
                        }))
                    end
                end
            end
            delay(0.2)
            SMODS.calculate_context({remove_playing_cards = true, removed = destroyed_cards})
            return true 
        end 
    }))
    return proc
end

return blind