local blind = {
    name = "The Red Mist",
    pos = {x = 0, y = 19},
    dollars = 1, 
    mult = 40, 
    phases = 4, 
    vars = {}, 
    debuff = {},
    boss = {showdown = true, min = 10, max = 10},
    boss_colour = HEX('D41C25'),
    loc_txt = {}
}

blind.set_blind = function(self, reset, silent)
    G.GAME.current_round.lobc_phases_beaten = 1
    G.GAME.blind.lobc_current_effect = 11
    G.GAME.blind:set_text()
    G.GAME.blind.prepped = nil
    -- this keeps track of the score
    G.GAME.blind.hands_sub = to_big(0)

    local quips = {
        global = 4,
        { phase = 0, amount = 2 },
        { phase = 1, amount = 2 },
        { phase = 2, amount = 3 },
        { phase = 3, amount = 2 },
    }
    local eval_func = function() return G.GAME.blind.config.blind and G.GAME.blind.config.blind.key == "bl_lobc_red_mist" end
    lobc_abno_text("gebura", eval_func, 0.2, quips)
    ease_background_colour_blind()
end

blind.press_play = function(self)
    G.GAME.blind.prepped = true
    ease_hands_played(1)

    -- [2] Destroy 1-3 cards in hand
    if G.GAME.blind.lobc_current_effect == 2 then
        local available_cards = {}
        for _, v in ipairs(G.hand.cards) do
            if not v.highlighted then available_cards[#available_cards+1] = v end
        end
        for i = 1, pseudorandom("gebura_effect_2", 1, 3) do
            if #available_cards <= 0 then break end
            local chosen_card, chosen_card_key = pseudorandom_element(available_cards, pseudoseed("geb_random_card_2"))
            table.remove(available_cards, chosen_card_key)
            G.E_MANAGER:add_event(Event({
                trigger = 'after', 
                delay = 0.3 * G.SETTINGS.GAMESPEED, 
                func = function()
                    G.GAME.blind:wiggle()
                    chosen_card:start_dissolve() 
                    play_sound("lobc_gebura_slash", math.random(90, 110)/100, 0.5)
                return true 
                end 
            }))
        end
        G.GAME.blind.triggered = true
        return true
    end

    -- [3] Lose $1 per played card, destroy it if cannot afford
    if G.GAME.blind.lobc_current_effect == 3 then
        local current_dollars = G.GAME.dollars
        local first = true
        G.E_MANAGER:add_event(Event({
            func = function()
                for _, v in ipairs(G.play.cards) do
                    if current_dollars > 0 then 
                        G.E_MANAGER:add_event(Event({func = function() v:juice_up(); return true end })) 
                        ease_dollars(-1) 
                        current_dollars = current_dollars - 1
                    else
                        v:start_dissolve() 
                        play_sound("lobc_gebura_slash", math.random(90, 110)/100, first and 0.5 or 0)
                        first = nil
                    end
                    delay(0.23)
                end
            return true 
            end 
        })) 
        G.GAME.blind.triggered = true
        return true
    end

    -- [13] Destroy 1-3 played cards
    if G.GAME.blind.lobc_current_effect == 13 then
        local first = true
        G.GAME.blind:wiggle()
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                local available_cards = {}
                for _, v in ipairs(G.play.cards) do
                    available_cards[#available_cards+1] = v
                end
                for i = 1, pseudorandom("gebura_effect_13", 1, 3) do
                    if #available_cards <= 0 then break end
                    local chosen_card, chosen_card_key = pseudorandom_element(available_cards, pseudoseed("geb_random_card_13"))
                    table.remove(available_cards, chosen_card_key)
                    chosen_card:start_dissolve() 
                    play_sound("lobc_gebura_slash", math.random(90, 110)/100, first and 0.5 or 0)
                    first = nil
                end
            return true
            end
        }))
        G.GAME.blind.triggered = true
        return true
    end

    -- [14] Permanently debuff all played Enhanced cards
    if G.GAME.blind.lobc_current_effect == 14 then
        local proc = nil
        G.E_MANAGER:add_event(Event({
            func = function()
                for _, v in ipairs(G.play.cards) do
                    if v.config.center ~= G.P_CENTERS.c_base then 
                        proc = true
                        v:set_debuff(true)
                        v.ability.perma_debuff = true
                    end
                end
            return true
            end
        }))
        G.GAME.blind.triggered = proc
        return proc
    end

    -- [15] Lose $2 per card in hand, destroy it if cannot afford
    if G.GAME.blind.lobc_current_effect == 15 then
        local current_dollars = G.GAME.dollars
        local first = true
        G.E_MANAGER:add_event(Event({
            func = function()
                for _, v in ipairs(G.hand.cards) do
                    if current_dollars > 0 then 
                        G.E_MANAGER:add_event(Event({func = function() v:juice_up(); return true end })) 
                        ease_dollars(-2) 
                        current_dollars = current_dollars - 2
                    else
                        v:start_dissolve() 
                        play_sound("lobc_gebura_slash", math.random(90, 110)/100, first and 0.5 or 0)
                        first = nil
                    end
                    delay(0.23)
                end
            return true 
            end 
        })) 
        G.GAME.blind.triggered = true
        return true
    end
end

blind.debuff_hand = function(self, cards, hand, handname, check)
    -- [4], [16] Must play 5 cards
    if G.GAME.blind.lobc_current_effect == 4 or G.GAME.blind.lobc_current_effect == 16 then
        if #cards < 5 then
            G.GAME.blind.triggered = true
            return true
        end
    end

    -- [5] Must play High Card
    if G.GAME.blind.lobc_current_effect == 5 then
        if handname ~= "High Card" then
            G.GAME.blind.triggered = true
            return true
        end
    end

    -- [12] No hands until all consumables used
    if G.GAME.blind.lobc_current_effect == 12 then
        if #G.consumeables.cards > 0 then
            G.GAME.blind.triggered = true
            return true
        end
    end

    -- [18] Hand must contain three different suits
    if G.GAME.blind.lobc_current_effect == 18 then
        local suits = {}
        local count = 0
        for _, v in ipairs(cards) do
            if v.config.center.no_suit then 
            elseif v.config.center.any_suit then count = count + 1
            elseif not suits[v.base.suit] then
                suits[v.base.suit] = true
                count = count + 1
            end
        end
        G.GAME.blind.triggered = (count < 3)
        return (count < 3)
    end
end

blind.recalc_debuff = function(self, card, from_blind)
    -- [6] All Enhanced cards are debuffed, taken from The Stone
    if G.GAME.blind.lobc_current_effect == 6 then
        if card.area ~= G.jokers and card.config.center ~= G.P_CENTERS.c_base then
            return true
        end
    end

    -- [7] All face cards are debuffed
    if G.GAME.blind.lobc_current_effect == 7 then
        if card.area ~= G.jokers and card:is_face(true) then
            return true
        end
    end

    -- Universal debuff effect
    if card.ability.lobc_gebura_debuff then
        return true
    end
end

blind.modify_hand = function(self, cards, poker_hands, text, mult, hand_chips)
    -- [8] Base Chips and Mult are halved
    if G.GAME.blind.lobc_current_effect == 8 then
        G.GAME.blind.triggered = true
        return math.max(math.floor(mult*0.5 + 0.5), 1), math.max(math.floor(hand_chips*0.5 + 0.5), 0), true
    end

    -- [19] Halves Base Mult, sets Base Chips to Base Mult
    if G.GAME.blind.lobc_current_effect == 19 then
        G.GAME.blind.triggered = true
        return math.max(math.floor(mult*0.5 + 0.5), 1), math.max(math.floor(mult*0.5 + 0.5), 1), true
    end

    return mult, hand_chips, false
end

blind.drawn_to_hand = function(self)
    if G.GAME.blind.prepped then
        local chips_this_round = to_big(G.GAME.chips) - to_big(G.GAME.blind.hands_sub)
        -- Only change effect if the hand scored
        if chips_this_round > to_big(0) then
            local phase_effects = {
                {min = 2, max = 8},
                {min = 2, max = 9},
                {min = 2, max = 8},
                {min = 2, max = 8},
            }
            local phase = G.GAME.current_round.lobc_phases_beaten
            local effect_selected = nil

            local function additional_check(eff)
                if eff == 12 and #G.consumeables.cards == 0 then return true end
            end

            while not effect_selected or effect_selected == G.GAME.blind.lobc_current_effect or additional_check(effect_selected) do
                local min = phase_effects[phase+1].min
                local max = phase_effects[phase+1].max
                effect_selected = phase * 10 + pseudorandom("red_mist_phase_"..phase, min, max)
            end
            G.GAME.blind.lobc_current_effect = effect_selected
            G.GAME.blind:set_text()
            SMODS.juice_up_blind()
        end
        G.GAME.blind.hands_sub = G.GAME.blind.hands_sub + chips_this_round

        -- Reset debuffs
        for _, v in ipairs(G.jokers.cards) do
            v.ability.lobc_gebura_debuff = nil
        end

        for _, v in ipairs(G.playing_cards) do
            v.ability.lobc_gebura_debuff = nil
        end

        -- [17] Debuff 1-3 random Jokers
        if G.GAME.blind.lobc_current_effect == 17 then
            local available_cards = {}
            for _, v in ipairs(G.jokers.cards) do
                if not v.ability.perma_debuff and not v.ability.lobc_gebura_debuff then available_cards[#available_cards+1] = v end
            end
            for i = 1, pseudorandom("gebura_effect_17", 1, 3) do
                if #available_cards <= 0 then break end
                local chosen_card, chosen_card_key = pseudorandom_element(available_cards, pseudoseed("geb_random_card_17"))
                table.remove(available_cards, chosen_card_key)
                chosen_card.ability.lobc_gebura_debuff = true
                chosen_card:juice_up()
            end
            G.GAME.blind:wiggle()
        end

        for _, v in ipairs(G.jokers.cards) do
            SMODS.recalc_debuff(v)
        end

        for _, v in ipairs(G.playing_cards) do
            SMODS.recalc_debuff(v)
        end
    end
end

-- [1] Caps score, using Cryptid's The Tax function
blind.cry_cap_score = function(self, score)
    return math.floor(math.min(0.15*G.GAME.blind.chips,score)+0.5)
end

return blind