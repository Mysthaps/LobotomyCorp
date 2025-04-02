--- Welcome to Lobcorp spaghetti code

local current_mod = SMODS.current_mod
local mod_path = SMODS.current_mod.path
local config = SMODS.current_mod.config
lobc_seen_what = config.seen_what
local folder = string.match(mod_path, "[Mm]ods.*")
SMODS.load_file("blindexpander.lua")()

--=============== STEAMODDED OBJECTS ===============--

-- To disable any object, comment it out by adding -- at the start of the line.
local joker_list = {
    --- Project Moon Abnos
    "scorched_girl",
    "one_sin",
    "queen_of_hatred",
    "happy_teddy_bear",
    "red_shoes",
    "theresia",
    "old_lady",
    "nameless_fetus",
    "wall_gazer", -- The Lady Facing the Wall
    --"nothing_there",
    "big_bird",
    "all_around_helper",
    "spider_bud",
    "plague_doctor",
    "whitenight",
    "rudolta", -- Rudolta of the Sleigh
    "forsaken_murderer",
    "wellcheers", -- Opened Can of WellCheers
    "child_galaxy", -- Child of the Galaxy
    "punishing_bird",
    "little_red", -- Little Red Riding Hooded Mercenary
    "big_bad_wolf",
    "fragment_universe", -- Fragment of the Universe
    "judgement_bird",
    "apocalypse_bird",
    "price_of_silence",
    "laetitia",
    "fotdb", -- Funeral of the Dead Butterflies
    "mosb", -- The Mountain of Smiling Bodies
    "heart_of_aspiration",
    "giant_tree_sap",
    "fairy_festival",
    "iron_maiden", -- We Can Change Anything
    "express_train", -- Express Train to Hell
    "scarecrow_searching", -- Scarecrow Searching for Wisdom
    "censored",
    "shy_look", -- Today's Shy Look
    "you_must_be_happy",
    "old_faith", -- Old Faith and Promise
    "firebird", -- The Firebird
    "servant_of_wrath",
    "youre_bald",
    --- Fanmade / Mod Crossover Abnos
    --"jolliest_jester",
}
local blind_list = {
    -- Abnormalities
    "whitenight",
    "apocalypse_bird",
    "ab_beak",
    "ab_eyes",
    "ab_arms",
    -- Meltdowns
    "red_mist",
    --"an_arbiter",
    -- Dawn Ordeals
    "dawn_base",
    "dawn_green",
    "dawn_crimson",
    "dawn_amber",
    "dawn_violet",
    -- Noon Ordeals
    "noon_base",
    "noon_green",
    "noon_crimson",
    "noon_indigo",
    "noon_violet",
    -- Dusk Ordeals
    "dusk_base",
    "dusk_green",
    "dusk_crimson",
    "dusk_amber",
    -- Midnight Ordeals
    "midnight_base",
    "midnight_green",
    "midnight_violet",
    "midnight_amber",
    -- ???
    "erlking_heathcliff",
    "what_blind",
}
local sound_list = {
    music_first_warning = "Emergency1",
    music_second_warning = "Emergency2",
    music_third_warning = "Emergency3",
    music_abno_choice = "AbnormalityChoice",
    music_story1 = "Story1",
    music_neutral1 = "Neutral1",
    music_neutral2 = "Neutral2",
    music_neutral3 = "Neutral3",
    music_neutral4 = "Neutral4",
    music_roland1 = "Roland01",
    music_roland2 = "Roland02",
    music_roland3 = "Roland03",

    music_malkuth_1 = "Violation of Black Colors",
    music_malkuth_2 = "Red Dots",
    music_yesod_1 = "Untitled9877645623413123325",
    music_yesod_2 = "Faded",
    music_hod_1 = "Theme - Retro Time ALT",
    music_hod_2 = "Theme - Retro Time ALT Mix 1",
    music_netzach_1 = "Abandoned",
    music_netzach_2 = "Blue Dots",
    music_tiphereth_1 = "Eternal",
    music_tiphereth_2 = "Dark Fantasy Scene",
    music_gebura_1 = "Distorted Night",
    music_gebura_2 = "Insignia Decay",
    music_tpov = "Through Patches of Violet",
    music_compass = "what/compass",

    meltdown_start = "Boss_StartButton",
    overload_alert = "OverloadAlert3",

    mosb_upgrade = "Danggo_Lv2",
    old_lady_downgrade = "OldLady_effect01",
    plague_doctor_bell = "Lucifer_Bell0",
    punishing_bird_hit = "SmallBird_Hit",
    iron_maiden_tick = "Iron_Generate",
    iron_maiden_end = "Iron_End",
    nameless_cry = "nameless_cry",
    silence_destroy = "Clock_NoCreate",
    silence_tick = "Clock_Tick",
    helper_destroy = "Robo_Rise",
    butterfly_attack = "Butterfly_Attack",
    censored = "Censored_Atk",
    big_bird_attract = "Bigbird_Attract",
    big_bird_destroy = "Bigbird_HeadCut",
    train_sell = "Train_Sell",
    train_start = "Train_Start",
    littlered_gun = "RedHood_Gun",
    wolf_bite = "Wolf_Bite",
    wolf_out = "Wolf_EatOut",
    wolf_scratch = "Wolf_Scratch",

    evade = "what/evade",
    coin_fail = "what/coin_fail",
    what_1 = "what/what_1",
    what_2 = "what/what_2",
    what_sfx_1 = "what/what_sfx_1",
    what_sfx_2 = "what/what_sfx_2",
    what_sfx_3 = "what/what_sfx_3",
    what_s1 = "what/what_s1",
    what_s2 = "what/what_s2",
    what_p1 = "what/what_p1",
    what_p2 = "what/what_p2",
    what_p3 = "what/what_p3",
    what_p1s2 = "what/what_p1s2",
    what_p1s3 = "what/what_p1s3",
    what_p2s1 = "what/what_p2s1",
    what_p2s3 = "what/what_p2s3",
    what_p3s1 = "what/what_p3s1",
    what_p3s2 = "what/what_p3s2",
    what_p3s3 = "what/what_p3s3",
    what_death = "what/what_death",

    gebura_slash = "Gebura_Phase2_Atk1",
    dice_roll = "Dice_Roll",
    apoc_birth = "Bossbird_Birth",

    green_start = "Machine_Start",
    green_end = "Machine_End",
    amber_start = "Bug_Start",
    amber_end = "Bug_End",
    crimson_start = "Circus_Start",
    crimson_end = "Circus_End",
    violet_start = "OutterGod_Start",
    violet_end = "OutterGod_End",
    indigo_start = "Scavenger_Start",
    indigo_end = "Scavenger_End",
}
local challenge_list = {
    "ordeals",
    "production",
    "dark_days",
    "malkuth",
    "yesod",
    "hod",
    "netzach",
    "tiphereth",
    "gebura",
}
local consumable_list = {
    "wisdom",
    "tt2",
}

local badge_colors = {
    lobc_gift = HEX("A0243A"),
    lobc_blessed = HEX("380D36"),
    lobc_blessed_wn = HEX("EDA9D3"),
    lobc_apostle = HEX("FF0000"),
    lobc_amplified = HEX("004d00"),
    lobc_pebble = HEX("AAAAAA"),
    lobc_enchanted = HEX("C8831B"),
    lobc_perma_enchanted = HEX("C8831B"),
    lobc_marked = HEX("C3181B"),
    lobc_devoured = HEX("174D7D"),
    lobc_prey_mark = HEX("1506A5"),
    lobc_zayin = HEX("1DF900"),
    lobc_teth = HEX("13A2FF"),
    lobc_he = HEX("FFF900"),
    lobc_waw = HEX("7B2BF3"),
    lobc_aleph = HEX("FF0000"),
    lobc_o_green = HEX("008000"),
    lobc_o_amber = HEX("FFA500"),
    lobc_o_crimson = HEX("DC143C"),
    lobc_o_violet = HEX("800080"),
    lobc_o_indigo = HEX("1E90FF"),
    lobc_o_base = HEX('C4C4C4'),
    EGO_Gift = HEX('DD4930'),
}
-- Badge colors
local get_badge_colourref = get_badge_colour
function get_badge_colour(key)
    return badge_colors[key] or get_badge_colourref(key)
end
-- Localization colors
local loc_colourref = loc_colour
function loc_colour(_c, _default)
    return (_c and badge_colors['lobc_'.._c]) or loc_colourref(_c, _default)
end

-- Load all jokers
for _, v in ipairs(joker_list) do
    local joker = SMODS.load_file("indiv_jokers/" .. v .. ".lua")()

    --joker.discovered = true
    joker.key = v
    joker.atlas = "LobotomyCorp_Jokers"
    --[[if not joker.yes_pool_flag then
        joker.yes_pool_flag = "allow_abnormalities_in_shop"
    end]]--
    --joker.config.discover_rounds = 0

    if not joker.pos then
        joker.pos = { x = 0, y = 0 }
    end

    local joker_obj = SMODS.Joker(joker)

    for k_, v_ in pairs(joker) do
        if type(v_) == 'function' then
            joker_obj[k_] = joker[k_]
        end
    end

    if not joker.set_sprites then
        joker_obj.set_sprites = function(self, card, front)
            card.children.center.atlas = G.ASSET_ATLAS["lobc_LobotomyCorp_Jokers"]
            local count = lobc_get_usage_count(card.config.center_key)
            if count < card.config.center.discover_rounds and not config.show_art_undiscovered then
                card.children.center.atlas = G.ASSET_ATLAS["lobc_LobotomyCorp_Undiscovered"]
            end
            card.children.center:set_sprite_pos(card.config.center.pos)
        end
    end

    if not joker.in_pool then
        joker_obj.in_pool = function(self, args)
            if not args then return true end
            if args.source == "lobc_rudolta" then return false end
            return true
        end
    end

    if joker.risk then
        joker_obj.set_badges = function(self, card, badges)
            if self.discovered then
                local color = nil
                if joker.risk == "he" or joker.risk == "zayin" then color = G.C.UI.TEXT_DARK end
                badges[#badges + 1] = create_badge(localize("lobc_" .. joker.risk, "labels"), get_badge_colour("lobc_" .. joker.risk), color)
            end
        end
    end
end

-- Load all blinds
for _, v in ipairs(blind_list) do
    local blind = SMODS.load_file("indiv_blinds/" .. v .. ".lua")
    if not blind then goto continue else blind = blind() end

    blind.key = v
    blind.atlas = blind.atlas or "LobotomyCorp_Blind"
    if not blind.pos then blind.pos = {x = 0, y = 0} end
    if blind.atlas == "v" then blind.atlas = nil end
    --blind.discovered = true
    if blind.color then
        blind.boss_colour = badge_colors["lobc_o_" .. blind.color]
    end

    local blind_obj = SMODS.Blind(blind)

    for k_, v_ in pairs(blind) do
        if type(v_) == 'function' then
            blind_obj[k_] = blind[k_]
        end
    end
    ::continue::
end

-- Load all sounds
for k, v in pairs(sound_list) do
    local sound = SMODS.Sound({
        key = k,
        path = v..".ogg",
        pitch = 1,
        volume = 0.6,
        sync = false,
        no_sync = true,
    })
    
    for _, vv in ipairs(SMODS.load_file("sound_conditionals.lua")()) do
        if k == vv.key then
            sound.select_music_track = vv.select_music_track
            sound.sync = vv.sync
            sound.pitch = 0.7
        end
    end
end

-- Load challenges
for _, v in ipairs(challenge_list) do
    local chal = SMODS.load_file("challenges/" .. v .. ".lua")()
    chal.key = v
    local chal_obj = SMODS.Challenge(chal)
end

-- Load consumables
for _, v in ipairs(consumable_list) do
    local cons = SMODS.load_file("indiv_consumable/" .. v .. ".lua")()

    cons.key = v
    cons.atlas = "LobotomyCorp_consumable"
    if not cons.set then cons.set = "EGO_Gift" end
    cons.discovered = true
    cons.alerted = true
    local cons_obj = SMODS.Consumable(cons)

    for k_, v_ in pairs(cons) do
        if type(v_) == 'function' then
            cons_obj[k_] = cons[k_]
        end
    end
end

-- Load achievements
SMODS.load_file("achievements.lua")()

--=============== DRAW STEPS ===============--

SMODS.DrawStep({
    key = "modifiers",
    order = 45, -- Above stickers
    func = function(self)
        for _, v in ipairs(G.lobc_global_modifiers or {}) do
            if self.ability[v] then
                G.lobc_shared_modifiers[v].role.draw_major = self
                G.lobc_shared_modifiers[v]:draw_shader('dissolve', nil, nil, nil, self.children.center)
                G.lobc_shared_modifiers[v]:draw_shader('voucher', nil, self.ARGS.send_to_shader, nil, self.children.center)
            end
        end
    end
})
SMODS.DrawStep({
    key = "mood",
    order = 50, -- Same order as The Soul/floating sprite
    func = function(self)
        if self.children.mood then
            self.children.mood.role.draw_major = self
            self.children.mood:draw_shader('dissolve', 0, nil, nil, self.children.center, nil, nil, nil, 0.1 + 0.03*math.sin(1.8*G.TIMERS.REAL), nil, 0.6)
            self.children.mood:draw_shader('dissolve', nil, nil, nil, self.children.center, nil, nil)
        end
    end
})
SMODS.DrawStep({
    key = "prey",
    order = 51,
    func = function(self)
        if self.sprite_facing ~= "front" then return end
        local h_mod = 0
        if self.children.lobc_prey then
            self.children.lobc_prey:draw_shader('dissolve', 0, nil, nil, self.children.center, 0.1, nil, nil, 0.1 + 0.03*math.sin(1.8*G.TIMERS.REAL) + self.T.h*-0.2-h_mod, nil, 0.6)
            self.children.lobc_prey:draw_shader('dissolve', nil, nil, nil, self.children.center, 0.1, nil, nil, self.T.h*-0.2-h_mod)
            h_mod = h_mod + 0.5
        end
        if self.children.lobc_prey_mark then
            self.children.lobc_prey_mark:draw_shader('dissolve', 0, nil, nil, self.children.center, 0.1, nil, nil, 0.1 + 0.03*math.sin(1.8*G.TIMERS.REAL) + self.T.h*-0.2-h_mod, nil, 0.6)
            self.children.lobc_prey_mark:draw_shader('dissolve', nil, nil, nil, self.children.center, 0.1, nil, nil, self.T.h*-0.2-h_mod)
            h_mod = h_mod + 0.5
        end
    end
})

--=============== HELPER FUNCTIONS ===============--

-- Talisman compat
to_big = to_big or function(num)
    return num
end

-- copied from attention_text
function lobc_screen_text(args)
    if config.disable_all_text then return end
    args = args or {}
    args.text = args.text or 'test'
    args.scale = args.scale or 1
    args.colour = copy_table(args.colour or G.C.WHITE)
    args.hold = (args.hold or 0) + 0.1*(G.SPEEDFACTOR)
    args.pos = args.pos or {x = 0, y = 0}
    args.align = args.align or 'cm'
    args.emboss = args.emboss or nil
    if args.float == nil then args.float = true end

    args.fade = 1
    args.cover_colour = copy_table(G.C.CLEAR)

    args.uibox_config = {
        align = args.align or 'cm',
        offset = args.offset or { x = 0, y = 0}, 
        major = args.cover or args.major or nil,
    }

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0,
        blockable = false,
        blocking = false,
        func = function()
            args.AT = UIBox{
                T = {args.pos.x,args.pos.y,0,0},
                definition = 
                    {n=G.UIT.ROOT, config = {align = args.cover_align or 'cm', minw = (args.cover and args.cover.T.w or 0.001) + (args.cover_padding or 0), minh = (args.cover and args.cover.T.h or 0.001) + (args.cover_padding or 0), padding = 0.03, r = 0.1, emboss = args.emboss, colour = args.cover_colour}, nodes={
                        {n=G.UIT.O, config = { draw_layer = 1, object = DynaText({scale = args.scale, string = args.text, maxw = args.maxw, colours = {args.colour}, float = args.float, shadow = true, silent = not args.noisy, pop_in = args.pop_in or 0, pop_in_rate = args.pop_in_rate or 3, rotate = args.rotate or nil, text_rot = args.text_rot or 0, font = G.LANGUAGES[G.SETTINGS.language].font })}},
                    }}, 
                config = args.uibox_config
            }
            args.AT.states.hover.can = false
            args.AT.states.click.can = false
            args.AT.attention_text = true

            args.text = args.AT.UIRoot.children[1].config.object
            args.text.yesod_immune = true
            --args.text:pulse(0.5)
        return true
        end
    }))

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = args.hold,
        blockable = false,
        blocking = false,
        func = function()
            if not args.start_time then
                args.start_time = G.TIMERS.TOTAL
                args.text:pop_out(args.pop_out or 3)
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 1,
                    blockable = false,
                    blocking = false,
                    timer = "REAL",
                    func = function()
                        if args.AT then args.AT:remove() end
                    return true
                    end
                }))
            end
        return true
        end
    }))
end

-- on-screen text that's present in like every project moon game
function lobc_abno_text(key, eval_func, delay, quips)
    if config.disable_abno_text then return end
    local chosen_quip = nil

    for _, v in pairs(G.lobc_global_meltdowns) do
        if G.GAME.modifiers["lobc_"..v] and key ~= v then return end
    end

    if type(quips) == "number" then chosen_quip = math.random(1, quips or 8)
    else
        --[[
            quips = {
                global = 2,
                { min_ante = 0, max_ante = 3, amount = 2 },
                { min_ante = 4, max_ante = 6, amount = 4 },
                { min_ante = 7, max_ante = G.GAME.win_ante, amount = 4 },
            }
        ]]--
        local all_quips = {}

        if quips["global"] and G.GAME.round_resets.ante <= G.GAME.win_ante then
            for i = 1, quips["global"] do
                all_quips[#all_quips+1] = "0_"..i
            end
        end

        for k, v in ipairs(quips) do
            if (v.phase and G.GAME.current_round.phases_beaten == v.phase) or 
               (v.min_ante and G.GAME.round_resets.ante >= v.min_ante and G.GAME.round_resets.ante <= v.max_ante) then
                for i = 1, v.amount do
                    all_quips[#all_quips+1] = k.."_"..i
                end
            end
        end

        chosen_quip = all_quips[math.random(#all_quips)]
    end
    local rotation = math.random(-50, 50)/100
    local offset = {x = math.random(-100, 100)/100, y = math.random(-150, 150)/100}

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = delay or 0, 
        blocking = false, 
        blockable = false, 
        timer = 'REAL',
        func = function() 
            if eval_func() and key and chosen_quip then 
                lobc_screen_text({scale = 0.6, text = localize("k_lobc_"..key.."_"..chosen_quip), colour = G.C.RED, hold = 5*G.SETTINGS.GAMESPEED, align = 'cm', offset = offset, major = G.play, noisy = false, text_rot = rotation, pop_in_rate = 0.25, pop_out = 0.1*G.SETTINGS.GAMESPEED})
                lobc_abno_text(key, eval_func, math.random(2, 10), quips) 
            end 
        return true 
        end
    }))
end

-- what it says
function lobc_get_usage_count(key)
    return G.PROFILES[G.SETTINGS.profile].joker_usage[key] and G.PROFILES[G.SETTINGS.profile].joker_usage[key].count or 0
end

-- Check rounds until observation unlock
function Card:check_rounds(comp)
    local val = lobc_get_usage_count(self.config.center_key)
    return math.min(val, comp)
end

-- Make Abnos breach
function abno_breach(card, delay)
    G.E_MANAGER:add_event(Event({
        trigger = 'after', 
        delay = (delay or 1)*G.SETTINGS.GAMESPEED,
        func = function()
            play_sound('tarot1')
            card.T.r = -0.2
            card:juice_up(0.3, 0.4)
            card.states.drag.is = true
            card.children.center.pinch.x = true
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_lobc_breached'), colour = G.C.FILTER, instant = true})
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                func = function()
                    G.jokers:remove_card(card)
                    card:remove()
                    card = nil
                return true 
                end
            }))
            return true
        end
    }))
end

-- Restart music
function lobc_restart_music()
    if config.disable_music then return end
    G.ARGS.push = G.ARGS.push or {}
    G.ARGS.push.type = 'restart_music'
    if G.F_SOUND_THREAD then
        G.SOUND_MANAGER.channel:push(G.ARGS.push)
    else
        RESTART_MUSIC(G.ARGS.push)
    end
end

-- Shallow copy (deep copy is in blindexpander)
function shallow_copy(t)
    local t2 = {}
    for k,v in pairs(t) do
        t2[k] = v
    end
    return t2
end

--=============== BLINDS ===============--

-- Overwrite blind spawning for Abnormality Boss Blinds if requirements are met
local get_new_bossref = get_new_boss
function get_new_boss()
    if (string.lower(G.PROFILES[G.SETTINGS.profile].name) == "ishmael" or (os.date("%d%m") == "0104" and not config.seen_what)) and G.GAME.round_resets.ante == 9 then return "bl_lobc_what_blind" end
    if G.GAME.modifiers.lobc_gebura and G.GAME.round_resets.ante >= 9 then return "bl_lobc_red_mist" end
    if G.GAME.modifiers.lobc_all_whitenight or 
    (G.GAME.pool_flags["plague_doctor_breach"] and not G.GAME.pool_flags["whitenight_defeated"]) then return "bl_lobc_whitenight" end
    if G.GAME.modifiers.lobc_placeholder or 
    (G.GAME.pool_flags["apocalypse_bird_event"] and not G.GAME.pool_flags["apocalypse_bird_defeated"]) then return "bl_lobc_apocalypse_bird" end
    if G.GAME.modifiers.lobc_production then
        local ante = G.GAME.round_resets.ante
        if ante <= 2 then return "bl_lobc_dawn_base" end
        if ante <= 4 then return "bl_lobc_noon_base" end
        if ante <= 6 then return "bl_lobc_dusk_base" end
        return "bl_lobc_midnight_base"
    end
    if string.lower(G.PROFILES[G.SETTINGS.profile].name) == "heathcliff" then return "bl_lobc_erlking_heathcliff" end
    local new_boss = get_new_bossref() 
    while G.P_BLINDS[new_boss].mod and G.P_BLINDS[new_boss].mod.id == "LobotomyCorp" do -- does this work?
        new_boss = get_new_bossref()
    end
    return new_boss
end

-- Overwrite blind select for Ordeals
local reset_blindsref = reset_blinds
function reset_blinds()
    reset_blindsref()
    -- Hide Small and Big Blind (Gebura)
    if (G.GAME.modifiers.lobc_gebura and G.GAME.round_resets.ante > 8) or ((string.lower(G.PROFILES[G.SETTINGS.profile].name) == "ishmael" or (os.date("%d%m") == "0104" and not config.seen_what)) and G.GAME.round_resets.ante == 9) then
        G.GAME.round_resets.blind_states.Small = 'Hide'
        G.GAME.round_resets.blind_states.Big = 'Hide'
        ease_background_colour_blind()
        return
    end
    if config.disable_ordeals and not G.GAME.modifiers.lobc_ordeals then return end
    if G.GAME.modifiers.lobc_production then return end
    if G.GAME.round_resets.blind_states.Small == 'Upcoming' or G.GAME.round_resets.blind_states.Small == 'Hide' then
        if G.GAME.round_resets.ante % 8 == 2 and G.GAME.round_resets.ante > 0 and
           (G.GAME.modifiers.lobc_ordeals or pseudorandom("dawn_ordeal") < 0.125) and 
           not (G.GAME.round_resets.ante >= 8 and G.GAME.modifiers.lobc_tiphereth) then
                G.GAME.round_resets.blind_choices.Small = 'bl_lobc_dawn_base'
        else
            G.GAME.round_resets.blind_choices.Small = 'bl_small'
        end

        if G.GAME.round_resets.ante % 8 == 4 and G.GAME.round_resets.ante > 0 and
           (G.GAME.modifiers.lobc_ordeals or pseudorandom("noon_ordeal") < 0.125) then
            G.GAME.round_resets.blind_choices.Big = 'bl_lobc_noon_base'
        else
            G.GAME.round_resets.blind_choices.Big = 'bl_big'
        end

        -- don't overwrite whitenight
        if G.GAME.round_resets.blind_choices.Boss == "bl_lobc_whitenight" then return end

        if G.GAME.round_resets.ante % 8 == 6 and G.GAME.round_resets.ante > 0 then
            if G.GAME.modifiers.lobc_ordeals or pseudorandom("dusk_ordeal") < 0.125 then
                G.GAME.bosses_used[G.GAME.round_resets.blind_choices.Boss] = G.GAME.bosses_used[G.GAME.round_resets.blind_choices.Boss] - 1
                G.GAME.round_resets.blind_choices.Boss = 'bl_lobc_dusk_base'
            end
        end

        if (G.GAME.round_resets.ante % 8 == 0 and G.GAME.round_resets.ante > 0) or
           (G.GAME.round_resets.ante == 8 and G.GAME.modifiers.lobc_tiphereth) then
            if G.GAME.modifiers.lobc_ordeals or pseudorandom("midnight_ordeal") < 0.125 or G.GAME.modifiers.lobc_tiphereth then
                G.GAME.bosses_used[G.GAME.round_resets.blind_choices.Boss] = G.GAME.bosses_used[G.GAME.round_resets.blind_choices.Boss] - 1
                G.GAME.round_resets.blind_choices.Boss = 'bl_lobc_midnight_base'
            end
        end
    end
end

-- Ordeals
local set_blindref = Blind.set_blind
function Blind.set_blind(self, blind, reset, silent)
    if not reset then
        if blind and blind.color and blind.color == "base" then
            local chosen_blind = pseudorandom_element(blind.blind_list, pseudoseed("dusk_ordeal"))
            return self:set_blind(G.P_BLINDS['bl_lobc_'..chosen_blind], reset, silent)
        end
        if blind and blind.key == "bl_lobc_apocalypse_bird" then
            if not G.GAME.blind.original_blind then
                G.GAME.blind.original_blind = "bl_lobc_apocalypse_bird"
                G.GAME.apoc_music = 1
                play_sound("lobc_dice_roll", 1, 0.8)
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    func = function()
                        lobc_restart_music()
                        display_cutscene({x = 0, y = 0}, "ab")
                    return true 
                    end 
                }))
                return self:set_blind(G.P_BLINDS["bl_lobc_ab_eyes"], reset, silent)
            else
                G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function() 
                    play_sound("lobc_apoc_birth", 1, 0.8)
                return true end }))
                G.E_MANAGER:add_event(Event({trigger = 'before', func = function()
                    display_cutscene({x = 0, y = 1}, "ab")
                return true end }))
            end
        end
    end
    set_blindref(self, blind, reset, silent)
    if not reset and blind and (blind.time == "dusk" or blind.time == "midnight") then
        G.E_MANAGER:add_event(Event({trigger = 'before', func = function()
            lobc_restart_music()
        return true end }))
    end
end

local defeatref = Blind.defeat
function Blind.defeat(self, silent)
    -- Reset music when a LobotomyCorp boss is defeated
    if self.original_blind and self.original_blind == self.config.blind.key then
        self.original_blind = nil
        G.apoc_music = nil
    end
    defeatref(self, silent)
    -- Clear Enchanted from cards
    if not find_passive("psv_lobc_lamp") then
        for _, v in ipairs(G.playing_cards) do
            if v.ability.big_bird_enchanted and not v.ability.permanent_enchanted then
                v.ability.big_bird_enchanted = nil
            end
        end
    end
end

-- WhiteNight confession win round
local alert_debuffref = Blind.alert_debuff
function Blind.alert_debuff(self, first)
    if self.config.blind.color and self.config.blind.color == "base" then return end
    if self.config.blind.phases then return end
    if self.config.blind.key == "bl_lobc_apocalypse_bird" or find_passive("psv_lobc_cracking_eggs") then return end
    if self.config.blind.key == "bl_lobc_whitenight" and next(SMODS.find_card("j_lobc_one_sin", true)) then
        self.block_play = true
        G.E_MANAGER:add_event(Event({
            blocking = false,
            blockable = false,
            func = function() 
                if G.STATE == G.STATES.SELECTING_HAND then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 4*G.SETTINGS.GAMESPEED,
                        blocking = false,
                        blockable = false,
                        func = function() 
                            self.block_play = false
                            self.chips = 0
                            self.chip_text = number_format(self.chips)
                            self.dollars = to_big(0)
                            G.E_MANAGER:add_event(Event({
                                trigger = 'after',
                                delay = 1,
                                blocking = false,
                                blockable = false,
                                func = (function()
                                    self.block_play = nil
                                    if G.buttons then
                                        local _buttons = G.buttons:get_UIE_by_ID('play_button')
                                        _buttons.disable_button = nil
                                    end
                                    -- recheck just in case it fucks up
                                    if G.STATE == G.STATES.SELECTING_HAND then
                                        G.STATE = G.STATES.HAND_PLAYED
                                        G.STATE_COMPLETE = true
                                        end_round()
                                    end
                                    return true
                                end)
                            }))
                            return true
                        end
                    }))
                    return true
                end
            end
        }))
    else
        if self.config.blind.color and not config.disable_all_text then
            self:ordeal_alert()
        else 
            alert_debuffref(self, first) 
        end
    end
end

-- Make Ordeals not end the game on win ante hopefully
local get_typeref = Blind.get_type
function Blind.get_type(self)
    if self.config.blind.color and not self.config.bonus then
        return G.GAME.blind_on_deck
    end
    return get_typeref(self)
end

-- Save some blind variables
local blind_saveref = Blind.save
function Blind.save(self)
    local blindTable = blind_saveref(self)
    blindTable.lobc_score_cap = self.lobc_score_cap
    blindTable.lobc_current_effect = self.lobc_current_effect
    blindTable.lobc_has_sold_joker = self.lobc_has_sold_joker
    blindTable.p_sp = self.p_sp
    blindTable.b_sp = self.b_sp
    blindTable.ego = self.ego
    blindTable.in_panic = self.in_panic
    blindTable.skill_deck = self.skill_deck
    blindTable.shield_value = self.shield_value
    return blindTable
end

local blind_loadref = Blind.load
function Blind.load(self, blindTable)
    self.lobc_score_cap = blindTable.lobc_score_cap
    self.lobc_current_effect = blindTable.lobc_current_effect
    self.lobc_has_sold_joker = blindTable.lobc_has_sold_joker
    self.p_sp = blindTable.p_sp
    self.b_sp = blindTable.b_sp
    self.ego = blindTable.ego
    self.in_panic = blindTable.in_panic
    self.skill_deck = blindTable.skill_deck
    self.shield_value = blindTable.shield_value
    blind_loadref(self, blindTable)
    ease_background_colour_blind()
    local obj = self.config.blind
    if obj.setup_sprites and type(obj.setup_sprites) == 'function' then
        return obj:setup_sprites()
    end
end

-- Load text midgame
local set_textref = Blind.set_text
function Blind.set_text(self)
    if self.config.blind and self.config.blind.lobc_loc_txt and type(self.config.blind.lobc_loc_txt) == 'function' then
        local res = self.config.blind:lobc_loc_txt() or {}
        local loc_vars = res.vars or {}
        local loc_key = res.key or self.config.blind.key
        local upd_name = res.upd_name
        local loc_target = localize{type = 'raw_descriptions', key = loc_key, set = 'Blind', vars = loc_vars or self.config.blind.vars}
        if loc_target then 
            self.loc_name = self.name == '' and self.name or localize{type = 'name_text', key = upd_name and loc_key or self.config.blind.key, set = 'Blind'}
            if self.config.blind.key == "bl_lobc_what_blind" and not upd_name then self.loc_name = localize{type = 'name_text', key = "bl_lobc_what_blind_name", set = 'Blind'} end
            self.loc_debuff_text = ''
            EMPTY(self.loc_debuff_lines)
            for k, v in ipairs(loc_target) do
                self.loc_debuff_text = self.loc_debuff_text..v..(k <= #loc_target and ' ' or '')
                self.loc_debuff_lines[k] = v
            end
        else
            return set_textref(self)
        end
    else
        set_textref(self)
    end
end

-- Score capping, just steal it from Cryptid
Blind.cry_cap_score = Blind.cry_cap_score or function(self, score)
    if not self.disabled then
        local obj = self.config.blind
        if obj.cry_cap_score and type(obj.cry_cap_score) == 'function' then
            return obj:cry_cap_score(score)
        end
    end
    return score
end

-- Blind cutscenes
function display_cutscene(pos, c_type, delay_pause)
    local atlas = nil
    local mod_x, mod_y = 1, 1
    if c_type == "ab" then
        atlas = "lobc_LobotomyCorp_cutscenes"
        mod_x = (1024 / 654)
    elseif c_type == "what" then
        atlas = "lobc_black"
        mod_x = 3
        mod_y = 3
    end

    G.lobc_cutscene_transparency = c_type == "what" and 1 or 0
    G.lobc_cutscene_timer = 0
    G.lobc_update_lock = true
    G.lobc_displaying_cutscene = c_type

    local ui_nodes = {}
    if atlas then
        G.lobc_cutscene = Sprite(0, 0, 14.2 * mod_x, 14.2 * mod_y, G.ASSET_ATLAS[atlas], pos)
        G.lobc_cutscene.states.drag.can = false
        G.lobc_cutscene.draw_self = function(self, overlay)
            if not self.states.visible then return end
            if self.sprite_pos.x ~= self.sprite_pos_copy.x or self.sprite_pos.y ~= self.sprite_pos_copy.y then
                self:set_sprite_pos(self.sprite_pos)
            end
            prep_draw(self, 1)
            love.graphics.scale(1 / (self.scale.x / self.VT.w), 1 / (self.scale.y / self.VT.h))
            love.graphics.setColor({ 1, 1, 1, G.lobc_cutscene_transparency })
            love.graphics.draw(
                self.atlas.image,
                self.sprite,
                0, 0,
                0,
                self.VT.w / (self.T.w),
                self.VT.h / (self.T.h)
            )
            love.graphics.pop()
            add_to_drawhash(self)
            self:draw_boundingrect()
            if self.shader_tab then love.graphics.setShader() end
        end
        ui_nodes = {
            {n = G.UIT.R, config = { align = "cm", colour = G.C.CLEAR }, nodes = {
                { n = G.UIT.O, config = { object = G.lobc_cutscene }},
            }}
        }
    end

    if delay_pause then
        G.OVERLAY_MENU = UIBox{
            definition = {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes=ui_nodes},
            config = {
                align = "cm",
                offset = {x = 0, y = 0},
                major = G.ROOM_ATTACH,
                bond = 'Strong',
                no_esc = true
            }
        }
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = delay_pause, timer = "REAL", func = function() 
            G.lobc_update_lock = nil
            G.SETTINGS.paused = true
            G.CONTROLLER.locks.frame_set = true
            G.CONTROLLER.locks.frame = true
            G.CONTROLLER.cursor_down.target = nil
            G.CONTROLLER:mod_cursor_context_layer(G.NO_MOD_CURSOR_STACK and 0 or 1)
        return true end }))
    else
        G.lobc_update_lock = nil
        G.SETTINGS.paused = true
        if G.OVERLAY_MENU then G.OVERLAY_MENU:remove() end
        G.CONTROLLER.locks.frame_set = true
        G.CONTROLLER.locks.frame = true
        G.CONTROLLER.cursor_down.target = nil
        G.CONTROLLER:mod_cursor_context_layer(G.NO_MOD_CURSOR_STACK and 0 or 1)
        G.OVERLAY_MENU = UIBox{
            definition = {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes=ui_nodes},
            config = {
                align = "cm",
                offset = {x = 0, y = 0},
                major = G.ROOM_ATTACH,
                bond = 'Strong',
                no_esc = true
            }
        }
    end
end

-- Blind passive UI size
function current_mod.passive_ui_size()
    return G.GAME.blind.config.blind.key == "bl_lobc_erlking_heathcliff" and 7.5 or 6
end

--=============== SKILLS ===============--

G.P_CENTER_POOLS["SkillLobc"] = {}
SMODS.SkillLobc = SMODS.Center:extend({
    pos = { x = 0, y = 0 },
    class_prefix = 'sk',
    set = 'SkillLobc',
    atlas = 'lobc_what_skills',
    config = {},
    required_params = {
        'key',
    },
    no_collection = true,
    loc_vars = function(self, info_queue)
        return {}
    end,
    set_sprites = function(self, card)
        card.T.w = card.T.w / 1.775
        card.T.h = card.T.h / 2.375
    end,
    set_card_type_badge = function(self, card, badges)
        badges = {}
    end,
    no_mod_badges = true
})

local skill_list = {
    "what_s1",
    "what_s2",
    "what_p1s1",
    "what_p1s2",
    "what_p1s3",
    "what_p2s1",
    "what_p2s2",
    "what_p2s3",
    "what_p3s1",
    "what_p3s2",
    "what_p3s3",
}
-- Load all skills
for k, v in pairs(skill_list) do
    local skill = SMODS.load_file("indiv_skills/" .. v .. ".lua")()
    skill.key = v
    local skill_obj = SMODS.SkillLobc(skill)
end

-- Add skills to blind description
local HUD_blind_debuffref = G.FUNCS.HUD_blind_debuff
function G.FUNCS.HUD_blind_debuff(e)
    HUD_blind_debuffref(e)
    if G.GAME.blind.skill_deck then
        if not G.skill_deck then
            G.skill_deck = CardArea(0, 0, 4.2, 1.2, {card_limit = 5, type = 'title_2'})
            local deck = {n = G.UIT.R, config = {align = "cm", maxh = 1.2, maxw = 4.2}, nodes = {}}
            for _, v in ipairs(G.GAME.blind.skill_deck) do
                local _card = SMODS.create_card({
                    set = "SkillLobc",
                    key = "sk_lobc_"..v,
                    area = G.skill_deck
                })
                G.skill_deck:emplace(_card)
                _card.states.click.can = false
                _card.states.drag.can = false
                G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.2, func = function() 
                    _card:juice_up()
                return true end }))
            end
            for _, v in ipairs(G.skill_deck.cards) do
                v.states.click.can = false
                v.states.drag.can = false
            end
            table.insert(deck.nodes, {n=G.UIT.O, config = {object = G.skill_deck}})
            e.UIBox:set_parent_child(deck, e)
            e.UIBox:recalculate()
        end
    end
end

-- Skill UI config
local card_align_h_popupref = Card.align_h_popup
function Card.align_h_popup(self)
    local t = card_align_h_popupref(self)
    if self.ability.set == "SkillLobc" then
        t.offset.x = 0
        t.offset.y = 0
        t.type = "cr"
    end
    return t
end

--=============== JOKERS ===============--

-- E.G.O Gift sell costs / Fairy Festival
local set_costref = Card.set_cost
function Card.set_cost(self)
    set_costref(self)
    if self.ability.set == "EGO_Gift" then self.sell_cost = 0 end
    if self.ability.lobc_fairy_festival and self.cost > 0 then self.cost = 0 end
end

-- Front sprites thing (Today's Shy Look / You Must Be Happy / Express Train to Hell / Opened Can of WellCheers)
local alignref = Card.align
function Card.align(self)  
    if self.children.mood then 
        self.children.mood.T.y = self.T.y
        self.children.mood.T.x = self.T.x
        self.children.mood.T.r = self.T.r
    end

    if self.children.lobc_prey then 
        self.children.lobc_prey.T.y = self.T.y
        self.children.lobc_prey.T.x = self.T.x
        self.children.lobc_prey.T.r = self.T.r
    end

    if self.children.lobc_prey_mark then 
        self.children.lobc_prey_mark.T.y = self.T.y
        self.children.lobc_prey_mark.T.x = self.T.x
        self.children.lobc_prey_mark.T.r = self.T.r
    end

    alignref(self)
end

local sprite_drawref = Sprite.draw
function Sprite.draw(self, overlay)
    if self.atlas == G.ASSET_ATLAS["lobc_LobotomyCorp_moodboard"] then return end
    if self.atlas == G.ASSET_ATLAS["lobc_LobotomyCorp_yes_no"] then return end
    if self.atlas == G.ASSET_ATLAS["lobc_LobotomyCorp_lights"] then return end
    if self.atlas == G.ASSET_ATLAS["lobc_LobotomyCorp_wellcheers"] then return end
    if self.atlas == G.ASSET_ATLAS["lobc_LobotomyCorp_modifiers"] and self.sprite_pos.x == 4 and self.sprite_pos.y == 0 then return end
    if self.atlas == G.ASSET_ATLAS["lobc_LobotomyCorp_modifiers"] and self.sprite_pos.x == 5 and self.sprite_pos.y == 0 then return end
    sprite_drawref(self, overlay)
end

-- Global start of hand effect
local drawn_to_handref = Blind.drawn_to_hand
function Blind.drawn_to_hand(self)
    drawn_to_handref(self)
    if not G.GAME.lobc_prepped then return end

    -- Gebura's effect
    if G.GAME.modifiers.lobc_gebura then
        local available_cards = {}
        local destroyed_cards = {}
        local first = true
        for _, v in ipairs(G.hand.cards) do
            if not v.highlighted then available_cards[#available_cards+1] = v end
        end
        if #available_cards > 0 then
            for i = 1, (G.GAME.blind and G.GAME.blind.config.blind.key == "bl_lobc_red_mist" and G.GAME.current_round.phases_beaten >= 2) and 2 or 1 do
                local chosen_card, chosen_card_key = pseudorandom_element(available_cards, pseudoseed("lobc_gebura_destroy"))
                table.remove(available_cards, chosen_card_key)
                destroyed_cards[#destroyed_cards+1] = chosen_card
                chosen_card:start_dissolve() 
                if first then play_sound("lobc_gebura_slash", math.random(90, 110)/100, 0.5) end
                first = nil
            end
            delay(0.2)
            SMODS.calculate_context({remove_playing_cards = true, removed = destroyed_cards})
        end
    end

    -- Child of the Galaxy add new pebbles
    local children_of_the_galaxy = SMODS.find_card('j_lobc_child_galaxy')
    if next(children_of_the_galaxy) then
        for _, v in ipairs(G.playing_cards) do
            v.ability.child_galaxy_pebble = nil
        end
        local available_cards = {}
        for _, v in ipairs(G.hand.cards) do
            if not v.ability.child_galaxy_pebble then
                available_cards[#available_cards + 1] = v
            end
        end
        for i = 1, 5 * #children_of_the_galaxy do
            if #available_cards > 0 then
                local chosen_card, chosen_card_key = pseudorandom_element(available_cards, pseudoseed("random_card"))
                chosen_card.ability.child_galaxy_pebble = true
                chosen_card:juice_up()
                table.remove(available_cards, chosen_card_key)
            end
        end
    end

    G.GAME.lobc_prepped = nil
    save_run()
end

local play_cards_from_highlightedref = G.FUNCS.play_cards_from_highlighted
function G.FUNCS.play_cards_from_highlighted(e)
    play_cards_from_highlightedref(e)
    G.GAME.lobc_prepped = true
end

-- Card popup UI effects
local card_h_popupref = G.UIDEF.card_h_popup
function lobc_card_h_popup(card)
    local t = card_h_popupref(card)
    -- Yesod remove UI
    if G.GAME and G.GAME.modifiers.lobc_yesod and G.GAME.round_resets.ante > 3 then
        return {n=G.UIT.ROOT, config = {align = 'cm', colour = G.C.CLEAR}, nodes={}}
    end
    -- CENSORED
    if (next(SMODS.find_card("j_lobc_censored", true)) and (not card.config or not card.config.center or card.config.center.key ~= "j_lobc_censored"))
       or (card.ability and card.ability.lobc_censored) then
        local name_nodes = localize{type = 'name', key = "j_lobc_censored", set = "Joker", name_nodes = {}, vars = {}}
        name_nodes[1].nodes[1].config.object.colours = {G.C.RED}
        return {n=G.UIT.ROOT, config = {align = 'cm', colour = G.C.CLEAR}, nodes={
            {n=G.UIT.C, config={align = "cm", object = Moveable(), ref_table = nil}, nodes = {
                {n=G.UIT.R, config={padding = 0.05, r = 0.12, colour = G.C.BLACK, emboss = 0.07}, nodes={
                    {n=G.UIT.R, config={align = "cm", padding = 0.07, r = 0.1, colour = G.C.RED}, nodes={
                        {n=G.UIT.R, config={align = "cm", padding = 0.05, r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes = name_nodes},
                    }}
                }}
            }},
        }}
    end
    -- Apocalypse Bird/Long Arms
    if G.GAME.lobc_long_arms and card.playing_card and G.GAME.lobc_long_arms[card:get_id()] then
        table.insert(
            t.nodes[1].nodes[1].nodes[1].nodes[2].nodes[1].nodes,
            {n=G.UIT.R, config={align = "cm"}, nodes={
                {n=G.UIT.T, config={
                    text = localize("k_lobc_rank_sin"),
                    scale = 0.32*G.LANG.font.DESCSCALE*(G.F_MOBILE_UI and 1.5 or 1),
                    colour = G.C.UI.TEXT_DARK,
                }},
                {n=G.UIT.T, config={
                    text = G.GAME.lobc_long_arms[card:get_id()], 
                    scale = 0.32*G.LANG.font.DESCSCALE*(G.F_MOBILE_UI and 1.5 or 1),
                    colour = G.C.RED,
                }}
            }}
        )

    end
    return t
end

-- Remove the topleft message when CENSORED/Yesod is active
local generate_UIBox_ability_tableref = Card.generate_UIBox_ability_table
function Card.generate_UIBox_ability_table(self, ...)
    if (next(SMODS.find_card("j_lobc_censored", true)) and self.config.center.key ~= "j_lobc_censored") 
    or (G.GAME and G.GAME.modifiers.lobc_yesod and G.GAME.round_resets.ante > 3) 
    or (self.ability and self.ability.lobc_censored) then return end

    -- Add "Sin" info_queue
    local full_UI_table = generate_UIBox_ability_tableref(self, ...)
    if self.playing_card then
        local id = self:get_id()
        if G.GAME.lobc_long_arms and G.GAME.lobc_long_arms[id] then
            generate_card_ui({key = 'lobc_sin', set = 'Other'}, full_UI_table)
        end
    end
    return full_UI_table
end

-- JokerDisplay text replacements
if JokerDisplay then
    JokerDisplay.Global_Definitions.Replace["lobc_censored"] = {
        priority = 1,
        replace_text = "lobc_other_censored",
        replace_reminder = {},
        replace_extra = {},
        replace_modifiers = {},
        replace_debuff_text = { { text = "CENSORED", colour = G.C.UI.TEXT_INACTIVE } },
        stop_calc = true,
        is_replaced_func = function (card, custom_parent)
            return next(SMODS.find_card("j_lobc_censored")) and card.config.center.key ~= "j_lobc_censored"
        end
    }
    JokerDisplay.Global_Definitions.Replace["lobc_yesod"] = {
        priority = 10,
        replace_text = {},
        replace_reminder = {},
        replace_extra = {},
        replace_modifiers = {},
        replace_debuff_text = {},
        replace_debuff_reminder = {},
        replace_debuff_extra = {},
        stop_calc = true,
        is_replaced_func = function (card, custom_parent)
            return G.GAME and G.GAME.modifiers.lobc_yesod and G.GAME.round_resets.ante > 3
        end
    }
end

--=============== ACTIVES ===============--

-- Implements the following functions:
-- center.lobc_can_use_active(center, card): If true, the USE button will become active
-- center.lobc_active(center, card): The USE button is only present when the center has this function. Called when the USE button is pressed

local use_and_sell_buttonsref = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
    local t = use_and_sell_buttonsref(card)
    if t and t.nodes[1] and t.nodes[1].nodes[2] and card.config.center.lobc_active and type(card.config.center.lobc_active) == "function" then
        table.insert(t.nodes[1].nodes[2].nodes, 
            {n=G.UIT.C, config={align = "cr"}, nodes={
                {n=G.UIT.C, config={ref_table = card, align = "cr", maxw = 1.25, padding = 0.1, r=0.08, minw = 1.25, minh = 1, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'lobc_active_ability', func = 'lobc_can_use_active'}, nodes={
                    {n=G.UIT.B, config = {w=0.1,h=0.6}},
                    {n=G.UIT.T, config={text = localize('b_use'),colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}}
                }}
            }}
        )
    end
    return t
end

G.FUNCS.lobc_can_use_active = function(e)
    local card = e.config.ref_table
    local can_use = 
    not (not skip_check and ((G.play and #G.play.cards > 0) or
    (G.CONTROLLER.locked) or
    (G.GAME.STOP_USE and G.GAME.STOP_USE > 0))) and
    G.STATE ~= G.STATES.HAND_PLAYED and G.STATE ~= G.STATES.DRAW_TO_HAND and G.STATE ~= G.STATES.PLAY_TAROT and
    card.area == G.jokers and not card.debuff and
    (not card.config.center.lobc_can_use_active or card.config.center:lobc_can_use_active(card))
    if can_use then 
        e.config.colour = G.C.RED
        e.config.button = 'lobc_active_ability'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.lobc_active_ability = function(e, mute, nosave)
    local card = e.config.ref_table

    G.E_MANAGER:add_event(Event({func = function()
        e.disable_button = nil
        e.config.button = 'lobc_active_ability'
    return true end }))

    if card.children.use_button then card.children.use_button:remove(); card.children.use_button = nil end
    if card.children.sell_button then card.children.sell_button:remove(); card.children.sell_button = nil end

    card.config.center:lobc_active(card)
    card.area:remove_from_highlighted(card)
end

--=============== CHALLENGES ===============--

-- Apply Modifiers to run
local start_runref = Game.start_run
function Game.start_run(self, args)
    -- Reapply blank font to continued games (Yesod)
    if args.savetext then
        local g_game = args.savetext.GAME
        if g_game.modifiers.lobc_yesod and g_game.round_resets.ante > 6 then
            G.LANG.font = G.FONTS["blank"]
        end
    end

    start_runref(self, args)

    if not args.savetext then
        if G.GAME.modifiers.lobc_fast_ante_1 then G.GAME.modifiers.scaling = 2 end
        if G.GAME.modifiers.lobc_fast_ante_2 then G.GAME.modifiers.scaling = 3 end
        if G.GAME.modifiers.lobc_netzach then G.GAME.lobc_no_hands_reset = true end
        if G.GAME.modifiers.lobc_hod then G.GAME.lobc_hod_modifier = 0.85 end
        if G.GAME.modifiers.lobc_gebura or (string.lower(G.PROFILES[G.SETTINGS.profile].name) == "ishmael" or (os.date("%d%m") == "0104" and not config.seen_what)) then G.GAME.win_ante = 9 end
        if G.GAME.modifiers.lobc_end_ante then G.GAME.win_ante = G.GAME.modifiers.lobc_end_ante end
    end

    -- First time text
    if not config.first_time then
        config.first_time = true
        SMODS.save_mod_config(current_mod)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            lobc_screen_text({
                text = localize('k_lobc_first_time_1'),
                scale = 0.35, 
                hold = 10*G.SETTINGS.GAMESPEED,
                major = G.play,
                align = 'cm',
                offset = {x = 0.3, y = -3.5},
                noisy = false,
                float = false,
            })
            lobc_screen_text({
                text = localize('k_lobc_first_time_2'),
                scale = 0.35, 
                hold = 10*G.SETTINGS.GAMESPEED,
                major = G.play,
                align = 'cm',
                offset = {x = 0.3, y = -3.1},
                noisy = false,
                float = false,
            })
            return true 
            end 
        }))
    end

    -- Abno text
    local quips = {
        malkuth = {
            global = 2,
            { min_ante = 0, max_ante = 3, amount = 2 },
            { min_ante = 4, max_ante = 6, amount = 4 },
            { min_ante = 7, max_ante = G.GAME.win_ante, amount = 4 },
        },
        yesod = {
            global = 2,
            { min_ante = 0, max_ante = 3, amount = 2 },
            { min_ante = 4, max_ante = 6, amount = 4 },
            { min_ante = 7, max_ante = G.GAME.win_ante, amount = 3 },
        },
        hod = {
            global = 2,
            { min_ante = 0, max_ante = 3, amount = 2 },
            { min_ante = 4, max_ante = 6, amount = 4 },
            { min_ante = 7, max_ante = G.GAME.win_ante, amount = 4 },
        },
        netzach = {
            global = 3,
            { min_ante = 0, max_ante = 3, amount = 2 },
            { min_ante = 4, max_ante = 6, amount = 3 },
            { min_ante = 7, max_ante = G.GAME.win_ante, amount = 4 },
        },
        tiphereth = {
            global = 2,
            { min_ante = 0, max_ante = 3, amount = 3 },
            { min_ante = 4, max_ante = 6, amount = 3 },
            { min_ante = 7, max_ante = G.GAME.win_ante, amount = 3 },
        },
        gebura = {},
    }

    local eval_func = function() return G.GAME.round_resets.ante <= G.GAME.win_ante end
    for k, v in pairs(quips) do
        if G.GAME.modifiers["lobc_"..k] then
            if v.global then lobc_abno_text(k, eval_func, 0.2, v) end
            ease_background_colour_blind()
            if not args.save_text and not config.disable_unsettling_sfx then play_sound("lobc_meltdown_start", 1, 0.5) end
            break
        end
    end

    -- Reapply blank text to DynaTexts on Continue
    if G.GAME.modifiers.lobc_yesod and G.GAME.round_resets.ante > 6 then
        for _, v in pairs(G.I.MOVEABLE) do
            if getmetatable(v) == DynaText and not v.yesod_immune then
                v.font = G.FONTS["blank"]
                v:update_text(true)
            end
        end
        G.HUD:recalculate()
    end
end

-- Permanent background color
local colors = {
    malkuth = HEX("D8D556"),
    yesod = HEX("81339C"),
    hod = HEX("DA7F2F"),
    netzach = HEX("69A448"),
    tiphereth = HEX("FFC50B"),
    gebura = HEX("C71F1F"),
}
local ease_background_colour_blindref = ease_background_colour_blind
function ease_background_colour_blind(state, blind_override)
    if G.GAME.blind then
        if G.GAME.blind.config.blind.key == "bl_lobc_whitenight" then
            ease_background_colour({new_colour = darken(HEX("FFFFFF"), 0.2), special_colour = darken(HEX("FFFFFF"), 0.4), contrast = 0.7})
            return
        elseif G.GAME.blind.original_blind == "bl_lobc_apocalypse_bird" then
            ease_background_colour({new_colour = darken(HEX("C8831B"), 0.1), special_colour = darken(HEX("C8831B"), 0.3), contrast = 1})
            return
        elseif G.GAME.blind.config.blind.key == "bl_lobc_what_blind" then
            ease_background_colour({new_colour = darken(HEX("FCDBCB"), 0.1), special_colour = darken(HEX("FCDBCB"), 0.3), contrast = 0.5})
            return
        end
    end

    if config.disable_meltdown_color then return ease_background_colour_blindref(state, blind_override) end
    for k, v in pairs(colors) do
        if G.GAME.modifiers["lobc_"..k] then
            ease_colour(G.C.DYN_UI.MAIN, v)
            ease_background_colour({new_colour = darken(v, 0.1), special_colour = darken(v, 0.3), contrast = 1})
            return
        end
    end

    ease_background_colour_blindref(state, blind_override)
end

local get_blind_main_colourref = get_blind_main_colour
function get_blind_main_colour(blind)
    if config.disable_meltdown_color then return get_blind_main_colourref(blind) end

    for k, v in pairs(colors) do
        if G.GAME.modifiers["lobc_"..k] then return v end
    end

    return get_blind_main_colourref(blind)
end

-- Effects upon changing Ante
local ease_anteref = ease_ante
function ease_ante(mod)
    ease_anteref(mod)
    G.E_MANAGER:add_event(Event({
        trigger = "immediate",
        func = function()
            -- You Must Be Happy ante effect
            if G.GAME.you_must_be_happy and G.GAME.you_must_be_happy ~= 1 then
                G.GAME.lobc_hod_modifier = G.GAME.lobc_hod_modifier / G.GAME.you_must_be_happy
                G.GAME.you_must_be_happy = 1
            end

            -- Card shuffle (Malkuth)
            if G.GAME.modifiers.lobc_malkuth and G.GAME.round_resets.ante > 6 then
                G.jokers:unhighlight_all()
                if #G.jokers.cards > 1 then 
                    G.E_MANAGER:add_event(Event({ func = function() 
                        G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('malk_shuffle'); play_sound('cardSlide1', 0.85);return true end })) 
                        delay(0.1)
                        G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('malk_shuffle'); play_sound('cardSlide1', 1.15);return true end })) 
                        delay(0.1)
                        G.E_MANAGER:add_event(Event({ func = function() G.jokers:shuffle('malk_shuffle'); play_sound('cardSlide1', 1);return true end })) 
                    return true end })) 
                end
            end

            -- JokerDisplay text hiding (Yesod)
            if G.GAME.modifiers.lobc_yesod and G.GAME.round_resets.ante > 3 and JokerDisplay then
                JokerDisplay.update_all_joker_display(false, true, "lobc_yesod")
            end

            -- Full text hiding (Yesod)
            if G.GAME.modifiers.lobc_yesod and G.GAME.round_resets.ante > 6 then
                for _, v in pairs(G.I.MOVEABLE) do
                    if getmetatable(v) == DynaText and not v.yesod_immune then
                        v.font = G.FONTS["blank"]
                        v:update_text(true)
                    end
                end
                G.HUD:recalculate()
            end

            -- Increase the decrease value (Hod)
            if G.GAME.modifiers.lobc_hod then
                if G.GAME.round_resets.ante >= 4 and G.GAME.round_resets.ante <= 6 then
                    G.GAME.lobc_hod_modifier = 0.75
                elseif G.GAME.round_resets.ante > 6 then
                    G.GAME.lobc_hod_modifier = 0.65
                end
            end

            for _, v in pairs({"malkuth", "yesod", "hod", "netzach", "tiphereth"}) do
                if G.GAME.modifiers["lobc_"..v] and (G.GAME.round_resets.ante == 4 or G.GAME.round_resets.ante == 7) then
                    if not config.disable_unsettling_sfx then play_sound("lobc_overload_alert", 1, 0.5) end
                    break
                end
            end
            return true
        end
    }))
end

--=============== MECHANICAL ===============--

local init_game_objectref = Game.init_game_object
function Game.init_game_object(self)
    local G = init_game_objectref(self)
    
    -- Make Lobcorp blinds unable to spawn normally
    for _, v in ipairs(blind_list) do
        G.bosses_used["bl_lobc_"..v] = 1e300
    end

    -- Yesod font
    self.FONTS["blank"] = {
        file = folder.."assets/fonts/AdobeBlank.ttf", 
        render_scale = self.TILESIZE*10, 
        TEXT_HEIGHT_SCALE = 0.83, 
        TEXT_OFFSET = {x=10,y=-20}, 
        FONTSCALE = 0.1, 
        squish = 1, 
        DESCSCALE = 1,
        FONT = love.graphics.newFont(folder.."assets/fonts/AdobeBlank.ttf", self.TILESIZE*10)
    }

    return G
end

-- Global vars, end of round effect
function current_mod.reset_game_globals(start_run)
    if start_run then
        -- Nameless Fetus
        G.GAME.nameless_hand_type = nil
        -- Production last pack Ante
        G.GAME.production_last_pack = 1
        -- Effect multi
        G.GAME.lobc_hod_modifier = 1
        -- Rank's Sin
        G.GAME.lobc_long_arms = {}
    else
        for k, _ in pairs(G.GAME.lobc_long_arms) do
            if G.GAME.lobc_long_arms[k] >= 10 then G.GAME.lobc_long_arms[k] = G.GAME.lobc_long_arms[k] / 2 end
            G.GAME.lobc_long_arms[k] = G.GAME.lobc_long_arms[k] - 1
            if G.GAME.lobc_long_arms[k] <= 0 then G.GAME.lobc_long_arms[k] = nil end
        end
    end
end

-- i am NOT implementing a none hand myself. yell at me if this fucks up anything
local get_poker_hand_inforef = G.FUNCS.get_poker_hand_info
function G.FUNCS.get_poker_hand_info(_cards)
    if G.STATE == G.STATES.HAND_PLAYED and #_cards == 0 then
        local poker_hands = evaluate_poker_hand(_cards)
        local scoring_hand = {}
        local text = "High Card"
        local disp_text = text
        local loc_disp_text = localize(text, 'poker_hands')
        return text, loc_disp_text, poker_hands, scoring_hand, disp_text
    end
    return get_poker_hand_inforef(_cards)
end

-- Make infoboxes show under the card in Collection view middle row
local align_h_popupref = Card.align_h_popup
function Card.align_h_popup(self)
    local ret = align_h_popupref(self)
    local focused_ui = self.children.focused_ui and true or false
    if (self.config.center.abno and self.T.y < G.CARD_H*1.2) then
        ret.offset.y = focused_ui and 0.12 or 0.1
        ret.type = "bm"
    end
    return ret
end

-- Debuffing effects
local should_debuff_ability = {
    "scorched_girl_debuff",
    "theresia_debuff",
    "tt2_debuff",
}
function SMODS.current_mod.set_debuff(card, should_debuff)
    if card.ability then
        for _, v in ipairs(should_debuff_ability) do
            if card.ability[v] then 
                --card:set_debuff(true)
                return true
            end
        end
    end
end

-- Make cards keep ability when transformed
local set_abilityref = Card.set_ability
function Card.set_ability(self, center, initial, delay_sprites)
    local lobc_abilities = {}

    if self.ability and self.playing_card then
        for _, v in ipairs(G.lobc_global_modifiers) do
            if self.ability[v] then
                lobc_abilities[v] = true
            end
        end
    end

    set_abilityref(self, center, initial, delay_sprites)

    if self.ability and self.playing_card then
        for k, v in pairs(lobc_abilities) do
            if v then
                self.ability[k] = true
            end
        end
    end
    
    if self.ability and self.playing_card and self.ability.set == "Enhanced" then
        self:lobc_check_amplified()
    end
end

-- Blind:alert_debuff for ordeals
function Blind:ordeal_alert()
    if G.GAME.current_round.hands_played > 0 then return end
    for _, v in ipairs(SMODS.find_card("bl_lobc_iron_maiden", true)) do
        if v.ability.extra.elapsed ~= 0 or v.ability.extra.seconds ~= 0 then return true end
    end
    self.block_play = true
    G.E_MANAGER:add_event(Event({
        blockable = false,
        blocking = false,
        func = (function()
            if self.disabled then self.block_play = nil; return true end
            if G.STATE == G.STATES.SELECTING_HAND then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = G.SETTINGS.GAMESPEED * 0.05,
                    blockable = false,
                    func = (function()
                        play_sound('lobc_'..self.config.blind.color..'_start', 1, 0.3)
                        local hold_time = G.SETTINGS.GAMESPEED * 5
                        local loc_key = 'k_lobc_'..self.config.blind.time..'_'..self.config.blind.color
                        lobc_screen_text({scale = 0.3, text = localize(loc_key), hold = hold_time, align = 'cm', offset = { x = 0, y = -3.5 }, major = G.play, noisy = false, float = false})
                        lobc_screen_text({scale = 1, text = localize(loc_key..'_name'), hold = hold_time, align = 'cm', offset = { x = 0, y = -2.5 }, major = G.play, noisy = false, float = false})
                        lobc_screen_text({scale = 0.35, text = localize(loc_key..'_start_1'), hold = hold_time, align = 'cm', offset = { x = 0, y = -1 }, major = G.play, noisy = false, float = false})
                        lobc_screen_text({scale = 0.35, text = localize(loc_key..'_start_2'), hold = hold_time, align = 'cm', offset = { x = 0, y = -0.6 }, major = G.play, noisy = false, float = false})
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = hold_time,
                            blocking = false,
                            blockable = false,
                            func = (function()
                                self.block_play = nil
                                if G.buttons then
                                    local _buttons = G.buttons:get_UIE_by_ID('play_button')
                                    _buttons.disable_button = nil
                                end
                                return true
                            end)
                        }))
                        return true
                    end)
                }))
                return true
            end
        end)
    }))
end

-- Announce Ordeal during end_round
local draw_from_hand_to_discardref = G.FUNCS.draw_from_hand_to_discard
function G.FUNCS.draw_from_hand_to_discard(e)
    if G.GAME.blind.config.blind.color then
        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = not config.disable_all_text and G.SETTINGS.GAMESPEED * 4 or 0,
            blockable = false,
            func = (function()
                if config.disable_all_text then return true end
                local hold_time = G.SETTINGS.GAMESPEED * 5
                local blind = G.GAME.blind
                local loc_key = 'k_lobc_'..blind.config.blind.time..'_'..blind.config.blind.color
                play_sound('lobc_'..blind.config.blind.color..'_end', 1, 0.3)
                lobc_screen_text({scale = 0.3, text = localize(loc_key), hold = hold_time, align = 'cm', offset = { x = 0, y = -3.5 }, major = G.play, noisy = false, float = false})
                lobc_screen_text({scale = 1, text = localize(loc_key..'_name'), hold = hold_time, align = 'cm', offset = { x = 0, y = -2.5 }, major = G.play, noisy = false, float = false})
                lobc_screen_text({scale = 0.35, text = localize(loc_key..'_end_1'), hold = hold_time, align = 'cm', offset = { x = 0, y = -1 }, major = G.play, noisy = false, float = false})
                lobc_screen_text({scale = 0.35, text = localize(loc_key..'_end_2'), hold = hold_time, align = 'cm', offset = { x = 0, y = -0.6 }, major = G.play, noisy = false, float = false})
                return true
            end)
        }))
    end
    draw_from_hand_to_discardref(e)
end

local new_roundref = new_round
function new_round()
    new_roundref()
    -- Reset death text if any
    G.GAME.lobc_death_text = nil

    -- Kill on new round if hands is 0
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            if G.GAME.current_round.hands_left <= 0 and G.GAME.lobc_no_hands_reset then
                G.STATE = G.STATES.NEW_ROUND
                G.STATE_COMPLETE = false
            end
        return true
        end
    }))

    G.GAME.lobc_prepped = true
end

local play_soundref = play_sound
local played_enchanted = false
function play_sound(sound_code, per, vol)
    if sound_code and sound_code:find('lobc') then
        -- No SFX toggle
        if config.no_sfx then return end
        if sound_code == "lobc_big_bird_attract" then
            if played_enchanted then return end
            played_enchanted = true
            G.E_MANAGER:add_event(Event({trigger = 'after', blocking = false, func = function()
                played_enchanted = false
            return true end }))
        end
        return play_soundref(sound_code, per, vol * 0.8)
    end
    return play_soundref(sound_code, per, vol)
end

-- Update every frame
local game_updateref = Game.update
function Game.update(self, dt)
    -- Apply blank font (Yesod)
    if not G.SETTINGS.paused and G.GAME and G.GAME.modifiers.lobc_yesod and G.GAME.round_resets.ante > 6 and G.STATE ~= G.STATES.GAME_OVER then
        G.LANG.font = G.FONTS["blank"]
    else
        G.LANG.font = G.LANGUAGES[G.SETTINGS.language].font
    end

    -- Handle cutscenes
    if G.lobc_displaying_cutscene then
        -- Apocalypse Bird
        if G.lobc_displaying_cutscene == "ab" then
            if G.lobc_cutscene_timer < 0.5 then G.lobc_cutscene_transparency = G.lobc_cutscene_timer * 2 end
            if G.lobc_cutscene_timer >= 0.5 and G.lobc_cutscene_timer < 5 then G.lobc_cutscene_transparency = 1 end
            if G.lobc_cutscene_timer >= 5 and G.lobc_cutscene_timer <= 6 then G.lobc_cutscene_transparency = 6 - G.lobc_cutscene_timer end
            if G.lobc_cutscene_timer >= 6 then 
                G.lobc_cutscene_transparency = 0
                G.lobc_displaying_cutscene = false
                G.SETTINGS.paused = false
                if G.OVERLAY_MENU then G.OVERLAY_MENU:remove() end
            end
        -- what
        elseif G.lobc_displaying_cutscene == "what" then
            if G.lobc_cutscene_timer < 2 then
                if G.lobc_what_txt ~= "bl_lobc_what_blind_name" then 
                    G.ROOM_ORIG.y = 0
                    G.ROOM_ORIG.x = (G.original_orig_x - 1) / 3 + 1
                    G.CANV_SCALE = 3.75
                    G.lobc_what_txt = "bl_lobc_what_blind_name"
                    G.GAME.blind:set_text()
                end
                G.lobc_cutscene_transparency = 1 - G.lobc_cutscene_timer / 2
            end
            if G.lobc_cutscene_timer >= 2 and G.lobc_cutscene_timer < 7.5 then 
                if G.lobc_what_txt ~= "bl_lobc_what_blind_cutscene_1" then 
                    G.lobc_cutscene_transparency = 0
                    G.lobc_what_txt = "bl_lobc_what_blind_cutscene_1"
                    play_sound("lobc_what_1", 1, 0.6)
                    play_sound("lobc_what_sfx_1", 1, 0.6)
                    G.GAME.blind:set_text()
                end
            end
            if G.lobc_cutscene_timer >= 7.5 and G.lobc_cutscene_timer < 10.5 then 
                if G.lobc_what_txt ~= "bl_lobc_what_blind_cutscene_2" then 
                    G.lobc_what_txt = "bl_lobc_what_blind_cutscene_2"
                    play_sound("lobc_what_2", 1, 0.6)
                    G.GAME.blind:set_text()
                    G.E_MANAGER:add_event(Event({trigger = 'ease', ease = 'inexpo', blocking = false, blockable = false, ref_table = G.ROOM_ORIG, ref_value = 'x', ease_to = G.original_orig_x, delay = 2.5, timer = "REAL", func = (function(t) return t end)}))
                    G.E_MANAGER:add_event(Event({trigger = 'ease', ease = 'inexpo', blocking = false, blockable = false, ref_table = G.ROOM_ORIG, ref_value = 'y', ease_to = G.original_orig_y, delay = 2.5, timer = "REAL", func = (function(t) return t end)}))
                    G.E_MANAGER:add_event(Event({trigger = 'ease', ease = 'inexpo', blocking = false, blockable = false, ref_table = G, ref_value = 'CANV_SCALE', ease_to = 1, delay = 2.5, timer = "REAL", func = (function(t) return t end)}))
                end
            end
            if G.lobc_cutscene_timer >= 10.5 then
            --if G.lobc_cutscene_timer >= 0.4 then -- remove this
                G.ROOM_ORIG.x = G.original_orig_x
                G.ROOM_ORIG.y = G.original_orig_y
                G.CANV_SCALE = 1
                G.lobc_cutscene_transparency = 0
                G.lobc_displaying_cutscene = false
                G.SETTINGS.paused = false
                if G.OVERLAY_MENU then G.OVERLAY_MENU:remove() end
                G.lobc_what_txt = nil
            end
        -- what (Phase 2)
        elseif G.lobc_displaying_cutscene == "what_2" then
            if G.lobc_cutscene_timer < 3.5 then
                if G.lobc_what_txt ~= "bl_lobc_what_blind_name" then 
                    G.ROOM_ORIG.x = (G.original_orig_x - 1) / 3 + 1
                    G.ROOM_ORIG.y = 0
                    G.CANV_SCALE = 3.75
                    play_sound("lobc_what_sfx_2", 1, 0.6)
                    G.lobc_what_txt = "bl_lobc_what_blind_name"
                    G.GAME.blind:set_text()
                end
            end
            if G.lobc_cutscene_timer >= 3.5 and G.lobc_cutscene_timer < 6.5 then 
                if G.lobc_what_txt ~= "bl_lobc_what_blind_name_copy" then 
                    G.lobc_what_txt = "bl_lobc_what_blind_name_copy"
                    G.GAME.blind:set_text()
                    G.E_MANAGER:add_event(Event({trigger = 'ease', ease = 'inexpo', blocking = false, blockable = false, ref_table = G.ROOM_ORIG, ref_value = 'x', ease_to = G.original_orig_x, delay = 2.5, timer = "REAL", func = (function(t) return t end)}))
                    G.E_MANAGER:add_event(Event({trigger = 'ease', ease = 'inexpo', blocking = false, blockable = false, ref_table = G.ROOM_ORIG, ref_value = 'y', ease_to = G.original_orig_y, delay = 2.5, timer = "REAL", func = (function(t) return t end)}))
                    G.E_MANAGER:add_event(Event({trigger = 'ease', ease = 'inexpo', blocking = false, blockable = false, ref_table = G, ref_value = 'CANV_SCALE', ease_to = 1, delay = 2.5, timer = "REAL", func = (function(t) return t end)}))
                end
            end
            if G.lobc_cutscene_timer >= 6.5 then
                G.ROOM_ORIG.x = G.original_orig_x
                G.ROOM_ORIG.y = G.original_orig_y
                G.CANV_SCALE = 1
                G.lobc_displaying_cutscene = false
                G.SETTINGS.paused = false
                if G.OVERLAY_MENU then G.OVERLAY_MENU:remove() end
                G.lobc_what_txt = nil
            end
        -- what (Phase 3)
        elseif G.lobc_displaying_cutscene == "what_3" then
            if G.lobc_cutscene_timer < 6 then
                if G.lobc_what_txt ~= "bl_lobc_what_blind_name" then 
                    G.ROOM_ORIG.x = (G.original_orig_x - 1) / 3 + 1
                    G.ROOM_ORIG.y = 0
                    G.CANV_SCALE = 3.75
                    play_sound("lobc_what_sfx_3", 1, 0.6)
                    G.lobc_what_txt = "bl_lobc_what_blind_name"
                    G.GAME.blind:set_text()
                end
            end
            if G.lobc_cutscene_timer >= 6 and G.lobc_cutscene_timer < 9.5 then 
                if G.lobc_what_txt ~= "bl_lobc_what_blind_name_copy" then 
                    G.lobc_what_txt = "bl_lobc_what_blind_name_copy"
                    G.GAME.blind:set_text()
                    G.E_MANAGER:add_event(Event({trigger = 'ease', ease = 'inexpo', blocking = false, blockable = false, ref_table = G.ROOM_ORIG, ref_value = 'x', ease_to = G.original_orig_x, delay = 2.5, timer = "REAL", func = (function(t) return t end)}))
                    G.E_MANAGER:add_event(Event({trigger = 'ease', ease = 'inexpo', blocking = false, blockable = false, ref_table = G.ROOM_ORIG, ref_value = 'y', ease_to = G.original_orig_y, delay = 2.5, timer = "REAL", func = (function(t) return t end)}))
                    G.E_MANAGER:add_event(Event({trigger = 'ease', ease = 'inexpo', blocking = false, blockable = false, ref_table = G, ref_value = 'CANV_SCALE', ease_to = 1, delay = 2.5, timer = "REAL", func = (function(t) return t end)}))
                end
            end
            if G.lobc_cutscene_timer >= 9.5 then
                G.ROOM_ORIG.x = G.original_orig_x
                G.ROOM_ORIG.y = G.original_orig_y
                G.CANV_SCALE = 1
                G.lobc_displaying_cutscene = false
                G.SETTINGS.paused = false
                if G.OVERLAY_MENU then G.OVERLAY_MENU:remove() end
                G.lobc_what_txt = nil
            end
        end
        if not G.lobc_update_lock then G.lobc_cutscene_timer = G.lobc_cutscene_timer + dt end
    end

    -- i hate chicot
    if find_passive("psv_lobc_fixed_encounter") then G.GAME.blind.disabled = nil end
    game_updateref(self, dt)
end

-- Reduce return values for card evals
local eval_cardref = eval_card
function eval_card(card, context)
    local eval, post_trig = eval_cardref(card, context)
    if type(eval) ~= "table" then return eval, post_trig end
    if eval and G.GAME.lobc_hod_modifier and G.GAME.lobc_hod_modifier ~= 1 then
        for _, v in pairs(eval) do
            if type(v) ~= "table" then goto continue end
            if v.chips then v.chips = v.chips * G.GAME.lobc_hod_modifier end
            if v.h_chips then v.h_chips = v.h_chips * G.GAME.lobc_hod_modifier end
            if v.chip_mod then v.chip_mod = v.chip_mod * G.GAME.lobc_hod_modifier end
            if v.mult then v.mult = v.mult * G.GAME.lobc_hod_modifier end
            if v.h_mult then v.h_mult = v.h_mult * G.GAME.lobc_hod_modifier end
            if v.mult_mod then v.mult_mod = v.mult_mod * G.GAME.lobc_hod_modifier end
            if v.x_mult then 
                if v.x_mult < 1 then v.x_mult = v.x_mult * G.GAME.lobc_hod_modifier
                else v.x_mult = 1 + (v.x_mult - 1) * G.GAME.lobc_hod_modifier end
            end
            if v.X_mult then 
                if v.X_mult < 1 then v.X_mult = v.X_mult * G.GAME.lobc_hod_modifier
                else v.X_mult = 1 + (v.X_mult - 1) * G.GAME.lobc_hod_modifier end
            end
            if v.xmult then 
                if v.xmult < 1 then v.xmult = v.xmult * G.GAME.lobc_hod_modifier
                else v.xmult = 1 + (v.xmult - 1) * G.GAME.lobc_hod_modifier end
            end
            if v.x_mult_mod then 
                if v.x_mult_mod < 1 then v.x_mult_mod = v.x_mult_mod * G.GAME.lobc_hod_modifier
                else v.x_mult_mod = 1 + (v.x_mult_mod - 1) * G.GAME.lobc_hod_modifier end
            end
            if v.Xmult_mod then 
                if v.Xmult_mod < 1 then v.Xmult_mod = v.Xmult_mod * G.GAME.lobc_hod_modifier
                else v.Xmult_mod = 1 + (v.Xmult_mod - 1) * G.GAME.lobc_hod_modifier end
            end
            if v.h_x_mult then 
                if v.h_x_mult < 1 then v.h_x_mult = v.h_x_mult * G.GAME.lobc_hod_modifier
                else v.h_x_mult = 1 + (v.h_x_mult - 1) * G.GAME.lobc_hod_modifier end
            end
            ::continue::
        end
    end
    return eval, post_trig
end

-- First time against a Boss Blind with passives
function first_time_passive()
    if not config.first_time_passive then
        config.first_time_passive = true
        SMODS.save_mod_config(current_mod)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            lobc_screen_text({
                text = localize('k_lobc_first_time_passive_1'),
                scale = 0.35, 
                hold = 10*G.SETTINGS.GAMESPEED,
                major = G.play,
                align = 'cm',
                offset = {x = 0.3, y = -3.5},
                noisy = false,
                float = false,
            })
            lobc_screen_text({
                text = localize('k_lobc_first_time_passive_2'),
                scale = 0.35, 
                hold = 10*G.SETTINGS.GAMESPEED,
                major = G.play,
                align = 'cm',
                offset = {x = 0.3, y = -3.1},
                noisy = false,
                float = false,
            })
            return true 
            end 
        }))
    end
end

--=============== OBSERVATION ===============--

-- Card updates
local card_updateref = Card.update
function Card.update(self, dt)
    -- Check if enough rounds have passed, should be saving
    if self.config.center.abno then
        local count = lobc_get_usage_count(self.config.center_key)
        if config.discover_all and count < self.config.center.discover_rounds then
            G.PROFILES[G.SETTINGS.profile].joker_usage[self.config.center.key] = {count = self.config.center.discover_rounds or 0}
            self.config.center.discovered = true
            self:set_sprites(self.config.center)
        end
        self.config.center.discovered = (count >= self.config.center.discover_rounds)
    end

    card_updateref(self, dt)
end

-- Update round count for abnos
local set_joker_usageref = set_joker_usage
function set_joker_usage()
    set_joker_usageref()
    for k, v in pairs(G.jokers.cards) do
        if v.config.center_key and v.ability.set == 'Joker' and v.config.center.abno then
            if lobc_get_usage_count(v.config.center_key) >= v.config.center.discover_rounds then
                if not v.config.center.discovered then
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4*G.SETTINGS.GAMESPEED, func = function()
                        play_sound('card1')
                        v:flip()
                    return true end }))
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4*G.SETTINGS.GAMESPEED, func = function()
                        discover_card(v.config.center)
                        v:set_sprites(v.config.center, nil)
                        play_sound('card1')
                        v:flip()
                    return true end }))
                end
                check_for_unlock({type = "lobc_observe_abno", card = v})
            end
        end
    end
end

--=============== BOOSTER PACK ===============--

-- Get Abnormality pool
-- Implementation somewhat borrowed from Sylvie's Sillyness and based on get_current_pool()
local function get_abno_pool(_type, _rarity, legendary, key_append)
    --create the pool
    G.ARGS.TEMP_POOL = EMPTY(G.ARGS.TEMP_POOL)
    local _pool, _starting_pool, _pool_key, _pool_size = G.ARGS.TEMP_POOL, {}, 'Abnormality'..(_rarity or ''), 0
    
    -- Increased chance to get birds when you get a bird
    local bird = false
    local birds = {}
    for _, birb in ipairs({"j_lobc_punishing_bird", "j_lobc_big_bird", "j_lobc_judgement_bird"}) do
        local birbs = SMODS.find_card(birb)
        if next(birbs) then
            bird = true
            birds[birb] = #birbs
        end
    end
    local roll = pseudorandom("birb_chance")
    if not _rarity and bird and roll < 0.1 and not G.GAME.pool_flags.apocalypse_bird_event then
        for _, birb in ipairs({"j_lobc_punishing_bird", "j_lobc_big_bird", "j_lobc_judgement_bird"}) do
            if not birds[birb] then
                _starting_pool[#_starting_pool+1] = G.P_CENTERS[birb]
            end
            bird = false
        end
    end

    if #_starting_pool == 0 then
        for _, v in ipairs(joker_list) do
            if (_rarity and G.P_CENTERS["j_lobc_"..v].risk == _rarity) or not _rarity then 
                _starting_pool[#_starting_pool+1] = G.P_CENTERS["j_lobc_"..v]
            end
        end
    end

    --cull the pool
    for k, v in ipairs(_starting_pool) do
        local add = true
        
        if G.GAME.used_jokers[v.key] then
            add = false
        end

        if v.yes_pool_flag and v.yes_pool_flag ~= "allow_abnormalities_in_shop" 
           and not G.GAME.pool_flags[v.no_pool_flag] then 
            add = false
        end
        if v.no_pool_flag and G.GAME.pool_flags[v.no_pool_flag] then add = false end

        if add and not G.GAME.banned_keys[v.key] then
           _pool[#_pool+1] = v.key
           _pool_size = _pool_size + 1
        end
    end

    --if pool is empty
    if _pool_size == 0 then
        _pool = EMPTY(G.ARGS.TEMP_POOL)
        _pool[#_pool + 1] = "j_lobc_youre_bald"
    end

    return _pool, _pool_key..G.GAME.round_resets.ante
end

local get_current_poolref = get_current_pool
function get_current_pool(_type, _rarity, _legendary, _append)
    if _type == "Abnormality" then return get_abno_pool(_type, _rarity, _legendary, _append) end
    if _append == "lobc_rudolta" then _rarity = ({"Common", "Uncommon", "Rare", "Legendary"})[_rarity] or _rarity end
    return get_current_poolref(_type, _rarity, _legendary, _append)
end

-- Make Extraction Pack
SMODS.Booster({
    key = 'extraction_normal',
    weight = 1.75,
    kind = "Abnormality",
    cost = 5,
    atlas = "LobotomyCorp_Booster",
    config = {extra = 3, choose = 1},
    create_card = function(self, card)
        return { set = 'Abnormality', area = G.pack_cards, skip_materialize = true, soulable = true, key_append = 'abn' }
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.PLANET_PACK)
    end,
    loc_vars = function(self, info_queue, card)
		return { vars = {card.config.center.config.choose, card.ability.extra} }
	end,
    group_key = "k_lobc_extraction_pack",
})

--=============== CONFIG UI ===============--

local function create_config_node(config_name)
    return
    {n = G.UIT.R, config = {align = "cl", padding = 0}, nodes = {
        {n = G.UIT.C, config = { align = "cl", padding = 0.05 }, nodes = {
            create_toggle{ col = true, label = "", scale = 0.85, w = 0, shadow = true, ref_table = config, ref_value = config_name },
        }},
        {n = G.UIT.C, config = { align = "c", padding = 0 }, nodes = {
            { n = G.UIT.T, config = { text = localize('lobc_'..config_name), scale = 0.35, colour = G.C.UI.TEXT_LIGHT }},
        }},
    }}
end

SMODS.current_mod.config_tab = function()
    return {n = G.UIT.ROOT, config = {r = 0.1, align = "c", padding = 0.1, colour = G.C.BLACK, minh = 6}, nodes = {
        {n = G.UIT.C, config = {align = "t", padding = 0.1}, nodes = {
            create_config_node("no_music"),
            create_config_node("disable_unsettling_sfx"),
            create_config_node("no_sfx"),
            create_config_node("disable_meltdown_color"),
            create_config_node("disable_abno_text"),
        }},

        {n = G.UIT.C, config = {align = "t", padding = 0.1}, nodes = {
            create_config_node("show_art_undiscovered"),
            create_config_node("disable_ordeals"),
            create_config_node("discover_all"),
            create_config_node("unlock_challenges"),
            create_config_node("lobcorp_music"),
        }},
    }}
end

SMODS.current_mod.credits_tab = function()
    return {n = G.UIT.ROOT, config = {r = 0.1, align = "cm", padding = 0.1, colour = G.C.BLACK, minw = 10, minh = 6}, nodes = {
        {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {
            {n = G.UIT.T, config = { text = localize('lobc_credits_1'), scale = 0.35, colour = G.C.UI.TEXT_LIGHT}},
        }},

        {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {
            {n = G.UIT.T, config = { text = localize('lobc_credits_2'), scale = 0.35, colour = G.C.UI.TEXT_LIGHT}},
        }},
        {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {
            {n = G.UIT.T, config = { text = localize('lobc_credits_by'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT}},
            {n = G.UIT.T, config = { text = localize('lobc_credits_pm'), scale = 0.5, colour = G.C.DARK_EDITION}},
        }},

        {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {
            {n = G.UIT.T, config = { text = localize('lobc_credits_full_list'), scale = 0.35, colour = G.C.UI.TEXT_LIGHT}},
        }},

        {n = G.UIT.R, config = {align = "cm", padding = 0, minh = 0.2}, nodes = {}},

        {n = G.UIT.R, config = {align = "cl", padding = 0.05}, nodes = {
            {n = G.UIT.T, config = { text = localize('lobc_credits_4'), scale = 0.3, colour = G.C.UI.TEXT_LIGHT}},
            {n = G.UIT.T, config = { text = localize('lobc_credits_twi'), scale = 0.3, colour = G.C.DARK_EDITION}},
        }},
        {n = G.UIT.R, config = {align = "cl", padding = 0.05}, nodes = {
            {n = G.UIT.T, config = { text = localize('lobc_credits_5'), scale = 0.3, colour = G.C.UI.TEXT_LIGHT}},
            {n = G.UIT.T, config = { text = localize('lobc_credits_opp'), scale = 0.3, colour = G.C.DARK_EDITION}},
        }},
        {n = G.UIT.R, config = {align = "cl", padding = 0.05}, nodes = {
            {n = G.UIT.T, config = { text = localize('lobc_credits_8'), scale = 0.3, colour = G.C.UI.TEXT_LIGHT}},
            {n = G.UIT.T, config = { text = localize('lobc_credits_sam'), scale = 0.3, colour = G.C.DARK_EDITION}},
        }},
        {n = G.UIT.R, config = {align = "cl", padding = 0.05}, nodes = {
            {n = G.UIT.T, config = { text = localize('lobc_credits_6'), scale = 0.3, colour = G.C.UI.TEXT_LIGHT}},
            {n = G.UIT.T, config = { text = localize('lobc_credits_lym'), scale = 0.3, colour = G.C.DARK_EDITION}},
        }},
        {n = G.UIT.R, config = {align = "cl", padding = 0.05}, nodes = {
            {n = G.UIT.T, config = { text = localize('lobc_credits_7'), scale = 0.3, colour = G.C.UI.TEXT_LIGHT}},
            {n = G.UIT.T, config = { text = localize('lobc_credits_sil'), scale = 0.3, colour = G.C.DARK_EDITION}},
        }},
    }}
end

--=============== STEAMODDED OBJECTS 2 ===============--

-- Atlases
SMODS.Atlas({ 
    key = "LobotomyCorp_Jokers", 
    atlas_table = "ASSET_ATLAS", 
    path = "LobotomyCorp_spritesheet.png", 
    px = 71, 
    py = 95 
})
SMODS.Atlas({ 
    key = "LobotomyCorp_Undiscovered", 
    atlas_table = "ASSET_ATLAS", 
    path = "LobotomyCorp_undiscovered.png", 
    px = 71, 
    py = 95 
})
SMODS.Atlas({ 
    key = "LobotomyCorp_Booster", 
    atlas_table = "ASSET_ATLAS", 
    path = "LobotomyCorp_booster.png", 
    px = 71, 
    py = 95 
})
SMODS.Atlas({ 
    key = "LobotomyCorp_Blind", 
    atlas_table = "ANIMATION_ATLAS", 
    path = "LobotomyCorp_blind.png", 
    px = 34, 
    py = 34,
    frames = 21,
})
SMODS.Atlas({
    key = "modicon",
    path = "LobotomyCorp_icon.png",
    px = 34,
    py = 34
})
SMODS.Atlas({
    key = "LobotomyCorp_moodboard",
    path = "LobotomyCorp_moodboard.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "LobotomyCorp_yes_no",
    path = "LobotomyCorp_yes_no.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "LobotomyCorp_lights",
    path = "LobotomyCorp_lights.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "LobotomyCorp_wellcheers",
    path = "LobotomyCorp_wellcheers.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "LobotomyCorp_jokersbald",
    path = "LobotomyCorp_jokersbald.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "LobotomyCorp_modifiers",
    path = "LobotomyCorp_modifiers.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "LobotomyCorp_consumable",
    path = "LobotomyCorp_consumable.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "LobotomyCorp_cutscenes",
    path = "LobotomyCorp_cutscenes.png",
    px = 1024,
    py = 654
})
SMODS.Atlas({
    key = "Erlking_Heathcliff", 
    atlas_table = "ANIMATION_ATLAS", 
    path = "Erlking_Heathcliff.png", 
    px = 1435, 
    py = 1042,
    frames = 1,
})
SMODS.Atlas({ 
    key = "LobotomyCorp_ApocBird", 
    atlas_table = "ANIMATION_ATLAS", 
    path = "LobotomyCorp_ApocBird.png", 
    px = 34, 
    py = 34,
    frames = 21,
})
SMODS.Atlas({
    key = "what", 
    atlas_table = "ANIMATION_ATLAS", 
    path = "what_asset.png", 
    px = 512, 
    py = 512,
    frames = 1,
})
SMODS.Atlas({
    key = "what_huh", 
    atlas_table = "ANIMATION_ATLAS", 
    path = "what_huh.png", 
    px = 34, 
    py = 34,
    frames = 21,
})
SMODS.Atlas({
    key = "black",
    path = "black.png",
    px = 2000,
    py = 2000
})
SMODS.Atlas({
    key = "what_skills",
    path = "Skills.png",
    px = 196,
    py = 196
})

-- ConsumableType (guh)
SMODS.ConsumableType({
    key = 'EGO_Gift', 
    primary_colour = HEX('424e54'),
    secondary_colour = HEX("dd4930"),
    loc_txt = {},
    shop_rate = (SMODS.Mods.Cryptid or {}).can_load and 0.1 or 0,
    default = 'c_lobc_tt2',
    no_doe = true,
})

-- Shaders
SMODS.Shader({
    key = "pixelation",
    path = "pixelation.fs"
})

-- Clear all Cathys
sendInfoMessage("Loaded LobotomyCorp~")