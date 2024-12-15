local blind = {
    name = "Small Beak",
    pos = {x = 0, y = 0},
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
    },
    summon = "bl_lobc_ab_arms",
    phase_refresh = true,
    no_collection = true
}

blind.set_blind = function(self, reset, silent)
    ease_hands_played(1)
    G.GAME.lobc_small_beak = {}
    local eval_func = function()
        return G.GAME.blind and G.GAME.blind.config.blind.key == 'bl_lobc_ab_beak'
    end
    lobc_abno_text("small_beak", eval_func, 2, 6)
end

blind.defeat = function(self)
    play_sound("lobc_dice_roll", 1, 0.8)
    G.E_MANAGER:add_event(Event({
        trigger = 'before',
        func = function()
            display_cutscene({x = 2, y = 0})
        return true 
        end 
    }))
end

blind.debuff_hand = function(self, cards, hand, handname, check)
    local count = 0
    for _, v in ipairs(cards) do
        if v.ability.big_bird_enchanted then count = count + 1 end
    end
    if count >= 2 then return true end
    if G.GAME.lobc_small_beak[handname] then return true end
    if not check then G.GAME.lobc_small_beak[handname] = true end
end

return blind