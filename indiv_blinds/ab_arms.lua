local blind = {
    name = "Long Arms",
    pos = {x = 0, y = 2},
    atlas = "LobotomyCorp_ApocBird",
    dollars = 8, 
    mult = 1, 
    vars = {}, 
    debuff = {},
    boss = {showdown = true, min = 10, max = 10},
    boss_colour = HEX('C8831B'),
    loc_txt = {},
    passives = {
        "psv_lobc_fixed_encounter",
        "psv_lobc_cracking_eggs",
        "psv_lobc_lamp",
        "psv_lobc_misdeeds",
        "psv_lobc_judgement"
    },
    summon = "bl_lobc_apocalypse_bird",
    phase_refresh = true,
    no_collection = true
}

blind.set_blind = function(self)
    ease_hands_played(1)
    G.GAME.lobc_long_arms = {}
    if not G.GAME.lobc_small_beak then G.GAME.lobc_small_beak = {} end
    local eval_func = function()
        return G.GAME.blind and G.GAME.blind.config.blind.key == 'bl_lobc_ab_arms'
    end
    lobc_abno_text("long_arms", eval_func, 2, 6)
end

blind.drawn_to_hand = function(self)
    for _, v in ipairs(G.playing_cards) do
        SMODS.recalc_debuff(v)
    end
end

blind.press_play = function(self)
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

blind.defeat = function(self)
    G.GAME.apoc_music = 3
    play_sound("lobc_dice_roll", 1, 0.8)
    G.ARGS.push = G.ARGS.push or {}
    G.ARGS.push.type = 'restart_music'
    if G.F_SOUND_THREAD then
        G.SOUND_MANAGER.channel:push(G.ARGS.push)
    else
        RESTART_MUSIC(G.ARGS.push)
    end
    G.E_MANAGER:add_event(Event({
        trigger = 'before',
        func = function()
            display_cutscene({x = 3, y = 0})
        return true 
        end 
    }))
end

blind.recalc_debuff = function(self, card, from_blind)
    if G.GAME.lobc_long_arms and G.GAME.lobc_long_arms[card:get_id()] and G.GAME.lobc_long_arms[card:get_id()] >= 5 then
        return true
    end
end

blind.debuff_hand = function(self, cards, hand, handname, check)
    local count = 0
    local temp_ranks = {}
    for _, v in ipairs(cards) do
        if v.ability.big_bird_enchanted then count = count + 1 end
    end
    if count >= 2 then return true end
    if G.GAME.lobc_small_beak[handname] then return true end
    if not check then 
        for _, v in ipairs(cards) do
            local id = v:get_id()
            G.GAME.lobc_long_arms[id] = G.GAME.lobc_long_arms[id] or 0
            G.GAME.lobc_long_arms[id] = G.GAME.lobc_long_arms[id] + 1
            if not temp_ranks[id] then
                temp_ranks[id] = true
                G.GAME.lobc_long_arms[id] = G.GAME.lobc_long_arms[id] + 1
            end
        end
    end
end

return blind