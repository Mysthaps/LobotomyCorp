local blind = {
    name = "Small Beak",
    pos = {x = 0, y = 0},
    atlas = "LobotomyCorp_ApocBird",
    dollars = 8, 
    mult = 1, 
    vars = {}, 
    debuff = {
        akyrs_cannot_be_disabled = true,
        akyrs_blind_difficulty = "expert",
    },
    boss = {showdown = true, min = 10, max = 10},
    boss_colour = HEX('C8831B'),
    passives = {
        "psv_lobc_fixed_encounter",
        "psv_lobc_cracking_eggs",
        "psv_lobc_lamp",
        "psv_lobc_misdeeds",
    },
    summon = "bl_lobc_ab_arms",
    phase_refresh = true,
    no_collection = true,
    lobc_bg = {new_colour = darken(HEX("C8831B"), 0.1), special_colour = darken(HEX("C8831B"), 0.3), contrast = 1}
}

blind.lobc_loc_txt = function(self)
    return { key = "bl_lobc_ab_beak_effect" }
end

blind.set_blind = function(self, reset, silent)
    ease_hands_played(1)
    ease_discard(1)
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
            display_cutscene({x = 2, y = 0}, "ab")
        return true 
        end 
    }))
end

local lamped = false
G.beaked = false
blind.debuff_hand = function(self, cards, hand, handname, check)
    local count = 0
    for _, v in ipairs(cards) do
        if v.ability.big_bird_enchanted then count = count + 1 end
    end
    if count >= 2 then lamped = true; return true 
    else lamped = false end
    if G.GAME.lobc_small_beak and G.GAME.lobc_small_beak[handname] then G.beaked = handname; return true
    else G.beaked = false end
    if not check then G.GAME.lobc_small_beak[handname] = true end
end

blind.get_loc_debuff_text = function(self)
    if lamped then return localize("k_lobc_lamp") end
    if G.beaked then return localize("k_lobc_misdeeds").." ("..localize(G.beaked, 'poker_hands')..')' end
end

return blind