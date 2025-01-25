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
    ease_discard(1)
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

blind.defeat = function(self)
    G.GAME.apoc_music = 3
    play_sound("lobc_dice_roll", 1, 0.8)
    lobc_restart_music()
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

local lamped = false
local beaked = false
blind.debuff_hand = function(self, cards, hand, handname, check)
    local count = 0
    local temp_ranks = {}
    for _, v in ipairs(cards) do
        if v.ability.big_bird_enchanted then count = count + 1 end
    end
    if count >= 2 then lamped = true; return true 
    else lamped = false end
    if G.GAME.lobc_small_beak and G.GAME.lobc_small_beak[handname] then beaked = handname; return true
    else beaked = false end
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

blind.get_loc_debuff_text = function(self)
    if lamped then return localize("k_lobc_lamp") end
    if beaked then return localize("k_lobc_misdeeds").." ("..localize(beaked, 'poker_hands')..')' end
end

return blind