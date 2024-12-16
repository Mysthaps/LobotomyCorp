local suits = {
    {"Spades", "Hearts"},
    {"Clubs", "Diamonds"},
    {"Hearts", "Spades"},
    {"Diamonds", "Clubs"}
}

local blind = {
    name = "Apocalypse Bird",
    pos = {x = 0, y = 3},
    atlas = "LobotomyCorp_ApocBird",
    dollars = 8, 
    mult = 4, 
    vars = {}, 
    debuff = {},
    boss = {showdown = true, min = 10, max = 10},
    boss_colour = HEX('C8831B'),
    loc_txt = {},
    passives = {
        "psv_lobc_fixed_encounter",
        "psv_lobc_monster_of_the_forest",
        "psv_lobc_eternal_peace",
        "psv_lobc_lamp",
        "psv_lobc_misdeeds",
        "psv_lobc_judgement",
        --"psv_lobc_suppression", --doesn't have one yet
    }
}

blind.loc_vars = function(self)
    if not G.GAME.blind or not G.GAME.blind.hands_sub then return end
    local suit = suits[G.GAME.blind.hands_sub]
    return {vars = {localize(suit[1], 'suits_plural'), localize(suit[2], 'suits_plural')}}
end

blind.set_blind = function(self, blind, reset, silent)
    ease_hands_played(math.max(0, G.GAME.round_resets.hands + G.GAME.round_bonus.next_hands) - G.GAME.current_round.hands_left)
    G.GAME.blind.prepped = nil
    G.GAME.blind.hands_sub = 1
    G.GAME.blind:set_text()
    if not G.GAME.lobc_long_arms then G.GAME.lobc_long_arms = {} end
    if not G.GAME.lobc_small_beak then G.GAME.lobc_small_beak = {} end
    local eval_func = function()
        return G.GAME.blind and G.GAME.blind.config.blind.key == 'bl_lobc_apocalypse_bird'
    end
    lobc_abno_text("apocalypse_bird", eval_func, 2, 12)
end

blind.press_play = function(self)
    G.GAME.blind.prepped = true
    if find_passive("psv_lobc_judgement") then
        local destroyed_cards = {}
        local count = 0
        for _, v in ipairs(G.play.cards) do
            if v.debuff then count = count + 1 end
        end
        if count >= 3 then
            G.E_MANAGER:add_event(Event({
                func = function()
                    for _, v in ipairs(G.play.cards) do
                        if v.debuff then
                            destroyed_cards[#destroyed_cards+1] = card
                            v:start_dissolve() 
                        end
                    end
                    for _, v in ipairs(G.hand.cards) do
                        if v.debuff then
                            destroyed_cards[#destroyed_cards+1] = card
                            v:start_dissolve() 
                        end
                    end
                    return true 
                end 
            }))

            delay(0.2)
            for i = 1, #G.jokers.cards do
                G.jokers.cards[i]:calculate_joker({remove_playing_cards = true, removed = destroyed_cards})
            end
            if #destroyed_cards > 0 then G.GAME.blind:wiggle() end
            return #destroyed_cards > 0
        end
    end
end

blind.drawn_to_hand = function(self)
    for _, v in ipairs(G.playing_cards) do
        SMODS.recalc_debuff(v)
    end
    if G.GAME.blind.prepped then
        for k, v in ipairs(G.GAME.blind.passives) do
            if v == "psv_lobc_lamp" then
                if G.GAME.chips >= G.GAME.blind.chips*(1/4) then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        func = function()
                            display_cutscene({x = 1, y = 1})
                        return true 
                        end 
                    }))
                    ease_hands_played(1)
                    G.GAME.blind.hands_sub = 2
                    G.GAME.blind:set_text()
                    table.remove(G.GAME.blind.passives, k)
                end
            elseif v == "psv_lobc_misdeeds" then
                if G.GAME.chips >= G.GAME.blind.chips*(2/4) then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        func = function()
                            display_cutscene({x = 2, y = 1})
                        return true 
                        end 
                    }))
                    ease_hands_played(1)
                    G.GAME.blind.hands_sub = 3
                    G.GAME.blind:set_text()
                    table.remove(G.GAME.blind.passives, k)
                    G.GAME.lobc_small_beak = nil
                end
            elseif v == "psv_lobc_judgement" then
                if G.GAME.chips >= G.GAME.blind.chips*(3/4) then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        func = function()
                            display_cutscene({x = 4, y = 0})
                        return true 
                        end 
                    }))
                    ease_hands_played(1)
                    G.GAME.blind.hands_sub = 4
                    G.GAME.blind:set_text()
                    table.remove(G.GAME.blind.passives, k)
                    G.GAME.lobc_long_arms = nil
                end
            end
        end
    end
end

blind.recalc_debuff = function(self, card, from_blind)
    if find_passive("psv_lobc_judgement") and G.GAME.lobc_long_arms[card:get_id()] and G.GAME.lobc_long_arms[card:get_id()] >= 5 then
        return true
    end
end

blind.defeat = function(self)
    G.GAME.apoc_music = nil
    G.GAME.pool_flags["apocalypse_bird_defeated"] = true
end

blind.debuff_hand = function(self, cards, hand, handname, check)
    if find_passive("psv_lobc_lamp") then
        local count = 0
        for _, v in ipairs(cards) do
            if v.ability.big_bird_enchanted then count = count + 1 end
        end
        if count >= 2 then return true end
    end
    if G.GAME.lobc_small_beak and G.GAME.lobc_small_beak[handname] then return true end
    if find_passive("psv_lobc_judgement") and not check then
        for _, v in ipairs(cards) do
            local id = v:get_id()
            G.GAME.lobc_long_arms[id] = G.GAME.lobc_long_arms[id] or 0
            G.GAME.lobc_long_arms[id] = G.GAME.lobc_long_arms[id] + 1
        end
    end
end

blind.cry_cap_score = function(self, score)
    local final_mult = 0.5
    local proc = false
    for _, v in ipairs(G.play.cards) do
        if v:is_suit(suits[G.GAME.blind.hands_sub][1], true) then final_mult = final_mult + 0.1 end
        if v:is_suit(suits[G.GAME.blind.hands_sub][2], true) then 
            final_mult = final_mult - 0.2 
            proc = true
        end
    end
    score = score * final_mult
    if proc then G.GAME.blind:juice_up() end
    if find_passive("psv_lobc_lamp") then
        return math.floor(math.min(G.GAME.blind.chips*(1/4) - G.GAME.chips, score)+0.5)
    elseif find_passive("psv_lobc_misdeeds") then
        return math.floor(math.min(G.GAME.blind.chips*(2/4) - G.GAME.chips, score)+0.5)
    elseif find_passive("psv_lobc_judgement") then
        return math.floor(math.min(G.GAME.blind.chips*(3/4) - G.GAME.chips, score)+0.5)
    else return score
    end
end

return blind