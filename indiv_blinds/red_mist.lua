local config = SMODS.current_mod.config
local blind = {
    name = "The Red Mist",
    pos = {x = 0, y = 19},
    dollars = 0, 
    mult = 4, 
    phases = 4, 
    vars = {}, 
    debuff = {},
    boss = {showdown = true, min = 10, max = 10},
    boss_colour = HEX('C71F1F'),
    passives = {
        "psv_lobc_fixed_encounter",
        "psv_lobc_final_battle",
        "psv_lobc_kali",
        "psv_lobc_the_strongest",
        "psv_lobc_the_red_mist",
        "psv_lobc_ego_manifestation",
    },
    phase_refresh = true,
    no_collection = true,
}

local function destroy_cards(cardarea, min, max)
    local first = true
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            local available_cards = {}
            local destroyed_cards = {}
            for _, v in ipairs(cardarea.cards) do
                if not v.highlighted then available_cards[#available_cards+1] = v end
            end
            for i = 1, pseudorandom("gebura_effect_"..G.GAME.blind.lobc_current_effect, min, max) do
                if #available_cards <= 0 then break end
                local chosen_card, chosen_card_key = pseudorandom_element(available_cards, pseudoseed("geb_random_card_"..G.GAME.blind.lobc_current_effect))
                table.remove(available_cards, chosen_card_key)
                destroyed_cards[#destroyed_cards+1] = chosen_card
                chosen_card:start_dissolve() 
                if first then play_sound("lobc_gebura_slash", math.random(90, 110)/100, 0.5) end
                first = nil
            end
            delay(0.2)
            SMODS.calculate_context({remove_playing_cards = true, removed = destroyed_cards})
        return true
        end
    }))
end

local function get_available_jokers()
    local jokers = {}
    for _, v in ipairs(G.jokers.cards) do
        if not v.ability.eternal and not v.ability.hysteria then
            jokers[#jokers+1] = v
        end
    end
    return jokers
end

blind.set_blind = function(self, reset, silent)
    G.GAME.current_round.phases_beaten = 0
    G.GAME.blind.lobc_current_effect = pseudorandom("red_mist_phase_1", 2, 8)
    G.GAME.blind.lobc_score_cap = 0.15
    G.GAME.blind:set_text()
    G.GAME.blind.prepped = nil
    G.GAME.gebura_remove_hod_modifier = 1
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
    if not config.disable_unsettling_sfx then play_sound("lobc_meltdown_start", 1, 0.5) end

    for _, v in ipairs(G.consumeables.cards) do
        if v.config.center.key == "c_lobc_tt2" then
            v:start_dissolve()
        end
    end
    G.E_MANAGER:add_event(Event({trigger = 'before', func = function() 
        lobc_restart_music()
    return true end }))
end

blind.press_play = function(self)
    G.GAME.blind.prepped = true
    ease_hands_played(1)

    -- [2] Destroy 1-3 cards in hand
    if G.GAME.blind.lobc_current_effect == 2 then
        destroy_cards(G.hand, 1, 3)
        G.GAME.blind.triggered = true
        return true
    end
    -- [3], [27] Lose $1/$3 per played card, destroy it if cannot afford
    if G.GAME.blind.lobc_current_effect == 3 or G.GAME.blind.lobc_current_effect == 27 then
        local loss = (G.GAME.blind.lobc_current_effect == 3) and to_big(1) or to_big(3)
        local current_dollars = G.GAME.dollars
        local first = true
        local destroyed_cards = {}
        G.E_MANAGER:add_event(Event({
            func = function()
                for _, v in ipairs(G.play.cards) do
                    if current_dollars - loss >= to_big(0) then 
                        G.E_MANAGER:add_event(Event({func = function() v:juice_up(); return true end })) 
                        ease_dollars(-loss) 
                        current_dollars = current_dollars - loss
                    else
                        destroyed_cards[#destroyed_cards+1] = v
                        v:start_dissolve() 
                        if first then play_sound("lobc_gebura_slash", math.random(90, 110)/100, 0.5) end
                        first = nil
                    end
                    delay(0.23)
                end
                delay(0.2)
                SMODS.calculate_context({remove_playing_cards = true, removed = destroyed_cards})
            return true 
            end 
        }))
        G.GAME.blind.triggered = true
        return true
    end
    -- [13] Destroy 1-3 played cards
    if G.GAME.blind.lobc_current_effect == 13 then
        destroy_cards(G.play, 1, 3)
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
                        SMODS.debuff_card(v, true, 'gebura_perma_debuff')
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
        local destroyed_cards = {}
        G.E_MANAGER:add_event(Event({
            func = function()
                for _, v in ipairs(G.hand.cards) do
                    if current_dollars - 2 >= 0 then 
                        G.E_MANAGER:add_event(Event({func = function() v:juice_up(); return true end })) 
                        ease_dollars(-2) 
                        current_dollars = current_dollars - 2
                    else
                        destroyed_cards[#destroyed_cards+1] = v
                        v:start_dissolve() 
                        if first then play_sound("lobc_gebura_slash", math.random(90, 110)/100, 0.5) end
                        first = nil
                    end
                    delay(0.23)
                end
                delay(0.2)
                SMODS.calculate_context({remove_playing_cards = true, removed = destroyed_cards})
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
    -- [17] No hands until all consumables used
    if G.GAME.blind.lobc_current_effect == 17 then
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
    -- [23] Must play exactly 1 card
    if G.GAME.blind.lobc_current_effect == 23 then
        if #cards ~= 1 then
            G.GAME.blind.triggered = true
            return true
        end
    end
    -- [24] Hand must contain four different ranks
    if G.GAME.blind.lobc_current_effect == 24 then
        local ranks = {}
        local count = 0
        for _, v in ipairs(cards) do
            if v.config.center.no_rank then 
            elseif v.config.center.any_rank then count = count + 1
            elseif not ranks[v.base.id] then
                ranks[v.base.id] = true
                count = count + 1
            end
        end
        G.GAME.blind.triggered = (count < 4)
        return (count < 4)
    end
    -- [26] Halves level of played poker hand (rounded down)
    if G.GAME.blind.lobc_current_effect == 26 then
        G.GAME.blind.triggered = true
        local hand_level = G.GAME.hands[handname].level
        local to_remove = hand_level/2
        if type(hand_level) == "table" then to_remove:ceil() else to_remove = math.ceil(to_remove) end
        if not check then
            level_up_hand(G.GAME.blind.children.animatedSprite, handname, nil, -to_remove)
            G.GAME.blind:wiggle()
        end
    end
    -- [34] No hands until a Joker sold
    if G.GAME.blind.lobc_current_effect == 34 then
        if not G.GAME.blind.lobc_has_sold_joker then
            G.GAME.blind.triggered = true
            return true
        end
    end
    -- [35] No [most played poker hand] allowed
    if G.GAME.blind.lobc_current_effect == 35 then
        if handname == G.GAME.current_round.most_played_poker_hand then
            G.GAME.blind.triggered = true
            return true
        end
    end
    -- [37] Sets level of played poker hand to 0
    if G.GAME.blind.lobc_current_effect == 37 then
        G.GAME.blind.triggered = true
        local hand_level = G.GAME.hands[handname].level
        if not check then
            level_up_hand(G.GAME.blind.children.animatedSprite, handname, nil, -hand_level)
            G.GAME.blind:wiggle()
        end
    end
end

blind.recalc_debuff = function(self, card, from_blind)
    -- [6] All Enhanced cards are debuffed
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
                {min = 2, max = 7},
                {min = 2, max = 7},
            }
            local phase = G.GAME.current_round.phases_beaten
            if phase >= 2 then G.GAME.blind.lobc_score_cap = 0.2 end
            local effect_selected = nil

            local function additional_check(eff)
                if eff == 17 then return (#G.consumeables.cards == 0) end
                if eff == 22 then return (#G.jokers.cards == 0) end
                if eff == 34 then return (#G.jokers.cards <= 5 or #get_available_jokers() == 0) end
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
            SMODS.debuff_card(v, false, 'gebura_debuff')
        end
        for _, v in ipairs(G.playing_cards) do
            SMODS.debuff_card(v, false, 'gebura_debuff')
        end
        G.GAME.lobc_hod_modifier = (G.GAME.lobc_hod_modifier and G.GAME.lobc_hod_modifier or 1) / G.GAME.gebura_remove_hod_modifier
        G.GAME.gebura_remove_hod_modifier = 1
        G.GAME.blind.lobc_has_sold_joker = false

        -- [12] Debuff 1-3 random Jokers
        if G.GAME.blind.lobc_current_effect == 12 then
            local available_cards = {}
            for _, v in ipairs(G.jokers.cards) do
                if not v.ability.perma_debuff and not v.ability.lobc_gebura_debuff then available_cards[#available_cards+1] = v end
            end
            for i = 1, pseudorandom("gebura_effect_12", 1, 3) do
                if #available_cards <= 0 then break end
                local chosen_card, chosen_card_key = pseudorandom_element(available_cards, pseudoseed("geb_random_card_12"))
                table.remove(available_cards, chosen_card_key)
                SMODS.debuff_card(chosen_card, true, 'gebura_debuff')
                chosen_card:juice_up()
            end
            G.GAME.blind:wiggle()
        end
        -- [22], [32] Debuff all [highest owned rarity] Jokers
        if G.GAME.blind.lobc_current_effect == 22 or G.GAME.blind.lobc_current_effect == 32 then
            local highest = 1
            for _, v in ipairs(G.jokers.cards) do
                if type(v.config.center.rarity) ~= "number" then return end
                if v.config.center.rarity > highest then highest = v.config.center.rarity end
            end
            for _, v in ipairs(G.jokers.cards) do
                if v.config.center.rarity == highest then 
                    SMODS.debuff_card(v, true, 'gebura_debuff')
                    v:juice_up()
                end
            end
            G.GAME.blind:wiggle()
        end
        -- [25], [36] All cards give 25%/50% less chips, Mult and XMult
        if G.GAME.blind.lobc_current_effect == 25 then
            G.GAME.lobc_hod_modifier = (G.GAME.lobc_hod_modifier and G.GAME.lobc_hod_modifier or 1) * 0.75
            G.GAME.gebura_remove_hod_modifier = 0.75
        elseif G.GAME.blind.lobc_current_effect == 36 then
            G.GAME.lobc_hod_modifier = (G.GAME.lobc_hod_modifier and G.GAME.lobc_hod_modifier or 1) * 0.5
            G.GAME.gebura_remove_hod_modifier = 0.5
        end
        -- [33] Debuff all [most owned rarity] Jokers
        if G.GAME.blind.lobc_current_effect == 33 then
            local rarities = {0, 0, 0, 0}
            local highest = 0
            for _, v in ipairs(G.jokers.cards) do
                if type(v.config.center.rarity) ~= "number" then return end
                rarities[v.config.center.rarity] = rarities[v.config.center.rarity] or 0
                rarities[v.config.center.rarity] = rarities[v.config.center.rarity] + 1
                if highest < rarities[v.config.center.rarity] then
                    highest = rarities[v.config.center.rarity]
                end
            end
            for k, v in ipairs(rarities) do
                if v == highest and v > 0 then 
                    for _, vv in ipairs(G.jokers.cards) do
                        if vv.config.center.rarity == k then
                            SMODS.debuff_card(vv, true, 'gebura_debuff')
                            vv:juice_up()
                        end
                    end
                    break
                end
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

blind.lobc_loc_txt = function(self)
    local key = G.GAME.blind.lobc_current_effect and "bl_lobc_red_mist_effect_"..G.GAME.blind.lobc_current_effect
    -- [22], [32] Debuff all [highest owned rarity] Jokers
    if G.GAME.blind.lobc_current_effect == 22 or G.GAME.blind.lobc_current_effect == 32 then
        local highest = 1
        for _, v in ipairs(G.jokers.cards) do
            if type(v.config.center.rarity) ~= "number" then
            elseif v.config.center.rarity > highest then highest = v.config.center.rarity end
        end
        return { key = key, vars = {({localize('k_common'), localize('k_uncommon'), localize('k_rare'), localize('k_legendary')})[highest]} }
    end
    -- [33] Debuff all [most owned rarity] Jokers
    if G.GAME.blind.lobc_current_effect == 33 then
        local rarities = {}
        local highest = 0
        for _, v in ipairs(G.jokers.cards) do
            if type(v.config.center.rarity) ~= "number" then return end
            rarities[v.config.center.rarity] = rarities[v.config.center.rarity] or 0
            rarities[v.config.center.rarity] = rarities[v.config.center.rarity] + 1
            if highest < rarities[v.config.center.rarity] then
                highest = rarities[v.config.center.rarity]
            end
        end
        for k, v in ipairs(rarities) do
            if v == highest and v > 0 then 
                return { vars = {({localize('k_common'), localize('k_uncommon'), localize('k_rare'), localize('k_legendary')})[k]} }
            end
        end
        return { key = key, vars = {localize('k_common')} }
    end
    -- [35] No [most played poker hand] allowed
    if G.GAME.blind.lobc_current_effect == 35 then
        return { key = key, vars = { localize(G.GAME.current_round.most_played_poker_hand, 'poker_hands') }}
    end
    return { key = key }
end

-- [1] Caps score, using Cryptid's The Tax function
blind.cry_cap_score = function(self, score)
    return math.floor(math.min(G.GAME.blind.lobc_score_cap*G.GAME.blind.chips,score)+0.5)
end

blind.phase_change = function(self)
    ease_discard(math.max(0, G.GAME.round_resets.discards + G.GAME.round_bonus.discards) - G.GAME.current_round.discards_left)
    if not config.disable_unsettling_sfx then play_sound("lobc_overload_alert", 1, 0.5) end
    G.E_MANAGER:add_event(Event({trigger = 'before', func = function() 
        if G.GAME.current_round.phases_beaten ~= 2 then lobc_restart_music() end
    return true end }))
    G.GAME.blind.hands_sub = -1
    G.GAME.blind.prepped = true
end

-- [34] Selling card
local sell_cardref = Card.sell_card
function Card.sell_card(self)
    if self.ability.set == 'Joker' and G.GAME.blind then
        if G.GAME.blind.config.blind.key == "bl_lobc_red_mist" then
            G.GAME.blind.lobc_has_sold_joker = true
        end
    end
    sell_cardref(self)
end

return blind