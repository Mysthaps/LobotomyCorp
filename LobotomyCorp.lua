--- Welcome to Lobcorp spaghetti code

local current_mod = SMODS.current_mod
local mod_path = SMODS.current_mod.path
local config = SMODS.current_mod.config
local folder = string.match(mod_path, "[Mm]ods.*")
-- Since Cryptid completely overrides create_card, make sure it is only patched later, and only when needed
create_card_late_patched = false

--=============== STEAMODDED OBJECTS ===============--

-- To disable any object, comment it out by adding -- at the start of the line.
local joker_list = {
    --- Common
    "one_sin",
    "theresia",
    "old_lady",
    "wall_gazer", -- The Lady Facing the Wall
    "plague_doctor",
    "punishing_bird",
    "shy_look", -- Today's Shy Look
    "fairy_festival",
    "iron_maiden", -- We Can Change Anything
    "you_must_be_happy",
    "old_faith", -- Old Faith and Promise
    "youre_bald",

    --- Uncommon
    "scorched_girl",
    "happy_teddy_bear",
    "red_shoes",
    "nameless_fetus",
    "all_around_helper",
    "child_galaxy", -- Child of the Galaxy
    "big_bird",
    "fotdb", -- Funeral of the Dead Butterflies
    "heart_of_aspiration",
    "scarecrow_searching",

    --- Rare
    "queen_of_hatred",
    --"nothing_there",
    "judgement_bird",
    "price_of_silence",
    "laetitia",
    "mosb", -- The Mountain of Smiling Bodies
    "censored",
    "servant_of_wrath",

    --- Legendary
    "whitenight",

    --- Crossovers
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

    "erlking_heathcliff"
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
    lobc_zayin = HEX("1DF900"),
    lobc_teth = HEX("13A2FF"),
    lobc_he = HEX("FFF900"),
    lobc_waw = HEX("7B2BF3"),
    lobc_aleph = HEX("FF0000"),
    lobc_green = HEX("008000"),
    lobc_amber = HEX("FFA500"),
    lobc_crimson = HEX("DC143C"),
    lobc_violet = HEX("800080"),
    lobc_indigo = HEX("1E90FF"),
    lobc_base = HEX('C4C4C4'),
    EGO_Gift = HEX('DD4930'),
}
-- Badge colors
local get_badge_colourref = get_badge_colour
function get_badge_colour(key)
    return badge_colors[key] or get_badge_colourref(key)
end

-- Load all jokers
for _, v in ipairs(joker_list) do
    local joker = SMODS.load_file("indiv_jokers/" .. v .. ".lua")()

    --joker.discovered = true
    if joker.dependency and not (SMODS.Mods[joker.dependency] or {}).can_load then goto continue end
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

    if joker.risk then
        joker_obj.set_badges = function(self, card, badges)
            if self.discovered then
                local color = nil
                if joker.risk == "he" or joker.risk == "zayin" then color = G.C.UI.TEXT_DARK end
                badges[#badges + 1] = create_badge(localize("lobc_" .. joker.risk, "labels"), get_badge_colour("lobc_" .. joker.risk), color)
            end
        end
    end
    ::continue::
end

-- Load all blinds
for _, v in ipairs(blind_list) do
    local blind = SMODS.load_file("indiv_blinds/" .. v .. ".lua")()

    blind.key = v
    blind.atlas = blind.atlas or "LobotomyCorp_Blind"
    if not blind.pos then 
        blind.pos = {x = 0, y = 0} 
        blind.atlas = nil
    end
    --blind.discovered = true
    if blind.color then
        blind.boss_colour = badge_colors["lobc_" .. blind.color]
    end

    local blind_obj = SMODS.Blind(blind)

    for k_, v_ in pairs(blind) do
        if type(v_) == 'function' then
            blind_obj[k_] = blind[k_]
        end
    end
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
                    end
                }))
            end
        end
    }))
end

-- copied from cryptid's cry_deep_copy
function lobc_deep_copy(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[lobc_deep_copy(k, s)] = lobc_deep_copy(v, s) end
    return res
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
            if (v.phase and G.GAME.current_round.lobc_phases_beaten == v.phase) or 
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
            if eval_func() then 
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

-- Find a specific passive key
function find_passive(key)
    if G.GAME.blind and G.GAME.blind.passives then
        for _, v in ipairs(G.GAME.blind.passives) do
            if v == key then return true end
        end
    end
    return false
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

--=============== BLINDS ===============--

-- Overwrite blind spawning for Abnormality Boss Blinds if requirements are met
local get_new_bossref = get_new_boss
function get_new_boss()
    if G.GAME.modifiers.lobc_gebura and G.GAME.round_resets.ante >= 9 then return "bl_lobc_red_mist" end
    if G.GAME.modifiers.lobc_production then
        local ante = G.GAME.round_resets.ante
        if ante <= 2 then return "bl_lobc_dawn_base" end
        if ante <= 4 then return "bl_lobc_noon_base" end
        if ante <= 6 then return "bl_lobc_dusk_base" end
        return "bl_lobc_midnight_base"
    end
    if G.GAME.modifiers.lobc_all_whitenight or 
    (G.GAME.pool_flags["plague_doctor_breach"] and not G.GAME.pool_flags["whitenight_defeated"]) then return "bl_lobc_whitenight" end
    if G.GAME.modifiers.lobc_placeholder or 
    (G.GAME.pool_flags["apocalypse_bird_event"] and not G.GAME.pool_flags["apocalypse_bird_defeated"]) then return "bl_lobc_apocalypse_bird" end
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
    if G.GAME.modifiers.lobc_gebura and G.GAME.round_resets.ante > 8 then
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
           (G.GAME.round_resets.ante >= 8 and G.GAME.modifiers.lobc_tiphereth) then
            if G.GAME.modifiers.lobc_ordeals or pseudorandom("midnight_ordeal") < 0.125 or G.GAME.modifiers.lobc_tiphereth then
                G.GAME.bosses_used[G.GAME.round_resets.blind_choices.Boss] = G.GAME.bosses_used[G.GAME.round_resets.blind_choices.Boss] - 1
                G.GAME.round_resets.blind_choices.Boss = 'bl_lobc_midnight_base'
            end
        end
    end
end

-- Ordeals / Passives
local set_blindref = Blind.set_blind
function Blind.set_blind(self, blind, reset, silent)
    if not reset then
        if blind and blind.color and blind.color == "base" then
            local chosen_blind = pseudorandom_element(blind.blind_list, pseudoseed("dusk_ordeal"))
            return self:set_blind(G.P_BLINDS['bl_lobc_'..chosen_blind], reset, silent)
        end
        if blind and blind.key == "bl_lobc_apocalypse_bird" then
            if not G.GAME.blind.lobc_original_blind then
                G.GAME.blind.lobc_original_blind = "bl_lobc_apocalypse_bird"
                G.GAME.apoc_music = 1
                play_sound("lobc_dice_roll", 1, 0.8)
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    func = function()
                        display_cutscene({x = 0, y = 0})
                    return true 
                    end 
                }))
                return self:set_blind(G.P_BLINDS["bl_lobc_ab_eyes"], reset, silent)
            else
                G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function() 
                    play_sound("lobc_apoc_birth", 1, 0.8)
                return true end }))
                G.E_MANAGER:add_event(Event({trigger = 'before', func = function()
                    display_cutscene({x = 0, y = 1})
                return true end }))
            end
        end
        self.passives = blind and lobc_deep_copy(blind.passives)
        if self.passives then
            self.children.alert = UIBox{
                definition = create_UIBox_card_alert(), 
                config = {
                    align = "tri",
                    offset = {
                        x = 0.1, y = 0
                    },
                    parent = self
                }
            }
        else
            self.children.alert = nil
        end
    end
    return set_blindref(self, blind, reset, silent)
end

-- Phase bosses
local update_new_roundref = Game.update_new_round
function Game.update_new_round(self, dt)
    if self.buttons then self.buttons:remove(); self.buttons = nil end
    if self.shop then self.shop:remove(); self.shop = nil end

    if not G.STATE_COMPLETE and not G.GAME.blind.disabled and (G.GAME.blind.config.blind.summon or G.GAME.blind.config.blind.phases or G.GAME.blind.lobc_original_blind) then
        if G.GAME.blind.lobc_original_blind and not G.GAME.blind.config.blind.summon then -- Triggers if blind is not the original blind
            -- Reset to the original blind's values
            if G.GAME.blind.lobc_original_blind ~= G.GAME.blind.config.blind.key then
                G.GAME.blind:set_blind(G.P_BLINDS[G.GAME.blind.lobc_original_blind])
                G.GAME.blind.chips = get_blind_amount(G.GAME.round_resets.ante)*G.P_BLINDS[G.GAME.blind.lobc_original_blind].mult*G.GAME.starting_params.ante_scaling
                G.GAME.blind.children.alert = nil
            end
            -- Apocalypse Bird death cutscene
            if G.GAME.blind.lobc_original_blind == "bl_lobc_apocalypse_bird" and G.GAME.chips >= G.GAME.blind.chips then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    func = function()
                        display_cutscene({x = 3, y = 1})
                    return true 
                    end 
                }))
            end
        else
            if G.GAME.current_round.hands_left <= 0 and G.GAME.chips < G.GAME.blind.chips then 
                G.GAME.blind.lobc_original_blind = nil
                G.STATE_COMPLETE = true
                end_round()
                return
            else
                G.GAME.current_round.lobc_phases_beaten = G.GAME.current_round.lobc_phases_beaten + 1
            end
            
            if G.GAME.blind.config.blind.phases and G.GAME.current_round.lobc_phases_beaten >= G.GAME.blind.config.blind.phases then
                return update_new_roundref(self, dt)
            end
            
            G.STATE = G.STATES.DRAW_TO_HAND
            G.E_MANAGER:add_event(Event({
                trigger = 'ease',
                blocking = false,
                ref_table = G.GAME,
                ref_value = 'chips',
                ease_to = 0,
                delay = 0.5 * G.SETTINGS.GAMESPEED,
                func = (function(t) return math.floor(t) end)
            }))

            if G.GAME.blind.config.blind.phase_refresh then 
                -- Refresh deck
                G.FUNCS.draw_from_discard_to_deck()
                G.FUNCS.draw_from_hand_to_deck()
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 1,
                    blockable = false,
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            func = function()
                                G.deck:shuffle(G.GAME.blind.config.blind.key..'_refresh')
                                G.deck:hard_set_T()
                            return true
                            end
                        }))
                    return true
                    end
                }))
                
                ease_discard(math.max(0, G.GAME.round_resets.discards + G.GAME.round_bonus.discards) - G.GAME.current_round.discards_left)

                if G.GAME.blind.config.blind.key == "bl_lobc_red_mist" then 
                    G.GAME.blind.lobc_current_effect = G.GAME.current_round.lobc_phases_beaten * 10 + 5 
                    if not config.disable_unsettling_sfx then play_sound("lobc_overload_alert", 1, 0.5) end
                end
                G.GAME.blind.prepped = nil
                G.GAME.blind.hands_sub = 0
                G.GAME.blind:set_text()
                SMODS.juice_up_blind()
            end

            if G.GAME.blind.config.blind.summon then
                local obj = G.GAME.blind.config.blind
                G.P_BLINDS[obj.key].discovered = true
                if obj.defeat and type(obj.defeat) == 'function' then
                    obj:defeat()
                end
                G.GAME.blind.lobc_original_blind = G.GAME.blind.lobc_original_blind or G.GAME.blind.config.blind.key
                G.GAME.blind:set_blind(G.P_BLINDS[G.GAME.blind.config.blind.summon])
                G.GAME.blind.dollars = G.P_BLINDS[G.GAME.blind.lobc_original_blind].dollars
                G.GAME.blind.boss = G.P_BLINDS[G.GAME.blind.lobc_original_blind].boss
                G.GAME.current_round.dollars_to_be_earned = G.GAME.blind.dollars > 0 and (string.rep(localize('$'), G.GAME.blind.dollars)..'') or ('')
            end
        end
    end

    if G.STATE ~= G.STATES.DRAW_TO_HAND then
        update_new_roundref(self, dt)
    end
end

local defeatref = Blind.defeat
function Blind.defeat(self, silent)
    -- Reset music when a LobotomyCorp boss is defeated
    if self.lobc_original_blind and self.lobc_original_blind == self.config.blind.key then
        self.lobc_original_blind = nil
        G.apoc_music = nil
    end
    defeatref(self, silent)
    -- Clear Enchanted from cards
    if not find_passive("psv_lobc_lamp") then
        for _, v in ipairs(G.playing_cards) do
            if v.ability.big_bird_enchanted then
                v.ability.big_bird_enchanted = nil
            end
            if v.ability.big_bird_enchanted then
                v.children.lobc_big_bird_particles = nil
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
                            self.dollars = 0
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
    blindTable.lobc_original_blind = self.lobc_original_blind
    blindTable.lobc_current_effect = self.lobc_current_effect
    blindTable.lobc_has_sold_joker = self.lobc_has_sold_joker
    return blindTable
end

local blind_loadref = Blind.load
function Blind.load(self, blindTable)
    self.lobc_original_blind = blindTable.lobc_original_blind
    self.lobc_current_effect = blindTable.lobc_current_effect
    self.lobc_has_sold_joker = blindTable.lobc_has_sold_joker
    blind_loadref(self, blindTable)
end

-- Load text midgame
local set_textref = Blind.set_text
function Blind.set_text(self)
    if self.config.blind and (self.config.blind.key == "bl_lobc_red_mist" or self.config.blind.key == "bl_lobc_apocalypse_bird" or find_passive("psv_lobc_cracking_eggs")) then -- shitty bandage fix
        local loc_vars = nil
        local obj = self.config.blind
        if obj.loc_vars and type(obj.loc_vars) == 'function' then
        	local res = obj:loc_vars() or {}
        	loc_vars = res.vars or {}
        end
        local loc_key = self.config.blind.key.."_effect"
        if self.lobc_current_effect and self.config.blind.phases and G.GAME.current_round.lobc_phases_beaten < self.config.blind.phases then
            loc_key = loc_key.."_"..self.lobc_current_effect
        end
        local loc_target = localize{type = 'raw_descriptions', key = loc_key, set = 'Blind', vars = loc_vars or self.config.blind.vars}
        if loc_target then 
            self.loc_name = self.name == '' and self.name or localize{type = 'name_text', key = self.config.blind.key, set = 'Blind'}
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

-- Apocalypse Bird cutscenes
function display_cutscene(pos)
    G.lobc_displaying_cutscene = true
    G.lobc_cutscene_transparency = 0
    G.lobc_cutscene_timer = 0

    G.lobc_cutscene = Sprite(0, 0, 14.2*(1024/654), 14.2, G.ASSET_ATLAS["lobc_LobotomyCorp_cutscenes"], pos)
    G.lobc_cutscene.states.drag.can = false
    G.lobc_cutscene.draw_self = function(self, overlay)
        if not self.states.visible then return end
        if self.sprite_pos.x ~= self.sprite_pos_copy.x or self.sprite_pos.y ~= self.sprite_pos_copy.y then
            self:set_sprite_pos(self.sprite_pos)
        end
        prep_draw(self, 1)
        love.graphics.scale(1/(self.scale.x/self.VT.w), 1/(self.scale.y/self.VT.h))
        love.graphics.setColor({1, 1, 1, G.lobc_cutscene_transparency})
        love.graphics.draw(
            self.atlas.image,
            self.sprite,
            0, 0,
            0,
            self.VT.w/(self.T.w),
            self.VT.h/(self.T.h)
        )
        love.graphics.pop()
        add_to_drawhash(self)
        self:draw_boundingrect()
        if self.shader_tab then love.graphics.setShader() end
    end

    G.SETTINGS.paused = true
    -- copied from G.FUNCS.overlay_menu just to remove the pop-in anim
    if G.OVERLAY_MENU then G.OVERLAY_MENU:remove() end
    G.CONTROLLER.locks.frame_set = true
    G.CONTROLLER.locks.frame = true
    G.CONTROLLER.cursor_down.target = nil
    G.CONTROLLER:mod_cursor_context_layer(G.NO_MOD_CURSOR_STACK and 0 or 1)
    G.OVERLAY_MENU = UIBox{
        definition = {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={
            {n=G.UIT.R, config={align = "cm", colour = G.C.CLEAR}, nodes={
                {n=G.UIT.O, config={object = G.lobc_cutscene}},
            }},
        }},
        config = {
            align = "cm",
            offset = {x = 0, y = 0},
            major = G.ROOM_ATTACH,
            bond = 'Strong',
            no_esc = true
        }
    }
end

--=============== BLIND PASSIVE UI ===============--
function info_from_passive(passive)
    local width = G.GAME.blind.config.blind.key == "bl_lobc_erlking_heathcliff" and 7.5 or 6
    local desc_nodes = {}
    localize{type = 'descriptions', key = passive, set = "Passive", nodes = desc_nodes, vars = {}}
    local desc = {}
    for _, v in ipairs(desc_nodes) do
        desc[#desc+1] = {n=G.UIT.R, config={align = "cl"}, nodes=v}
    end
    return 
    {n=G.UIT.R, config={align = "cl", colour = lighten(G.C.GREY, 0.4), r = 0.1, padding = 0.05}, nodes={
        {n=G.UIT.R, config={align = "cl", padding = 0.05, r = 0.1}, nodes = localize{type = 'name', key = passive, set = "Passive", name_nodes = {}, vars = {}}},
        {n=G.UIT.R, config={align = "cl", minw = width, minh = 0.4, r = 0.1, padding = 0.05, colour = desc_nodes.background_colour or G.C.WHITE}, nodes={{n=G.UIT.R, config={align = "cm", padding = 0.03}, nodes=desc}}}
    }}
end

function create_UIBox_blind_passive(blind)
    local passive_lines = {}
    for _, v in ipairs(blind.passives) do
        passive_lines[#passive_lines+1] = info_from_passive(v)
    end
    return
    {n=G.UIT.ROOT, config = {align = 'cm', colour = lighten(G.C.JOKER_GREY, 0.5), r = 0.1, emboss = 0.05, padding = 0.05}, nodes={
        {n=G.UIT.R, config={align = "cm", emboss = 0.05, r = 0.1, minw = 2.5, padding = 0.05, colour = G.C.GREY}, nodes={
            {n=G.UIT.C, config = {align = "lm", padding = 0.1}, nodes = passive_lines}
        }}
    }}
end

local blind_hoverref = Blind.hover
function Blind.hover(self)
    if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then 
        if not self.hovering and self.states.visible and self.children.animatedSprite.states.visible then
            if self.passives then
                G.blind_passive = UIBox{
                    definition = create_UIBox_blind_passive(self),
                    config = {
                        major = self,
                        parent = nil,
                        offset = {
                            x = 0.15,
                            y = 0.2 + 0.38*#self.passives,
                        },  
                        type = "cr",
                    }
                }
                G.blind_passive.attention_text = true
                G.blind_passive.states.collide.can = false
                G.blind_passive.states.drag.can = false
                if self.children.alert then
                    self.children.alert:remove()
                    self.children.alert = nil
                end
            end
        end
    end
    blind_hoverref(self)
end

local blind_stop_hoverref = Blind.stop_hover
function Blind.stop_hover(self)
    if G.blind_passive then
        G.blind_passive:remove()
        G.blind_passive = nil
    end
    blind_stop_hoverref(self)
end

--=============== JOKERS ===============--

-- E.G.O Gift sell costs / Fairy Festival
local set_costref = Card.set_cost
function Card.set_cost(self)
    set_costref(self)
    if self.ability.set == "EGO_Gift" then self.sell_cost = 0 end
    if self.ability.lobc_fairy_festival and self.cost > 0 then self.cost = 0 end
end

-- Front sprites thing (Today's Shy Look / You Must Be Happy)
local alignref = Card.align
function Card.align(self)  
    if self.children.mood then 
        self.children.mood.T.y = self.T.y
        self.children.mood.T.x = self.T.x
        self.children.mood.T.r = self.T.r
    end

    alignref(self)
end

local sprite_drawref = Sprite.draw
function Sprite.draw(self, overlay)
    if self.atlas == G.ASSET_ATLAS["lobc_LobotomyCorp_moodboard"] then return end
    if self.atlas == G.ASSET_ATLAS["lobc_LobotomyCorp_yes_no"] then return end
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
            for i = 1, (G.GAME.blind and G.GAME.blind.config.blind.key == "bl_lobc_red_mist" and G.GAME.current_round.lobc_phases_beaten >= 2) and 2 or 1 do
                local chosen_card, chosen_card_key = pseudorandom_element(available_cards, pseudoseed("lobc_gebura_destroy"))
                table.remove(available_cards, chosen_card_key)
                destroyed_cards[#destroyed_cards+1] = chosen_card
                chosen_card:start_dissolve() 
                if first then play_sound("lobc_gebura_slash", math.random(90, 110)/100, 0.5) end
                first = nil
            end
            delay(0.2)
            for i = 1, #G.jokers.cards do
                G.jokers.cards[i]:calculate_joker({remove_playing_cards = true, removed = {chosen_card}})
            end
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
        for i = 1, 4 * #children_of_the_galaxy do
            if #available_cards > 0 then
                local chosen_card, chosen_card_key = pseudorandom_element(available_cards, pseudoseed("random_card"))
                chosen_card.ability.child_galaxy_pebble = true
                chosen_card:juice_up()
                table.remove(available_cards, chosen_card_key)
            end
        end
    end

    G.GAME.lobc_prepped = nil
end

local play_cards_from_highlightedref = G.FUNCS.play_cards_from_highlighted
function G.FUNCS.play_cards_from_highlighted(e)
    play_cards_from_highlightedref(e)
    G.GAME.lobc_prepped = true
end

-- Card popup UI effects
local card_h_popupref = G.UIDEF.card_h_popup
function G.UIDEF.card_h_popup(card)
    local t = card_h_popupref(card)
    -- Yesod remove UI
    if G.GAME and G.GAME.modifiers.lobc_yesod and G.GAME.round_resets.ante > 3 then
        return {n=G.UIT.ROOT, config = {align = 'cm', colour = G.C.CLEAR}, nodes={}}
    end
    -- CENSORED
    if (next(SMODS.find_card("j_lobc_censored", true)) and (not card.config or not card.config.center or card.config.center.key ~= "j_lobc_censored"))
       or (card.ability and card.ability.lobc_censored) then
        local name_nodes = localize{type = 'name', key = "j_lobc_censored", set = "Joker", name_nodes = {}, vars = {}}
        name_nodes[1].config.object.colours = {G.C.RED}
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
function Card.generate_UIBox_ability_table(self)
    if (next(SMODS.find_card("j_lobc_censored", true)) and self.config.center.key ~= "j_lobc_censored") 
    or (G.GAME and G.GAME.modifiers.lobc_yesod and G.GAME.round_resets.ante > 3) 
    or (self.ability and self.ability.lobc_censored) then return end
    return generate_UIBox_ability_tableref(self)
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
        if G.GAME.modifiers.lobc_gebura then G.GAME.win_ante = 9 end
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
                hold = 15*G.SETTINGS.GAMESPEED,
                major = G.play,
                align = 'cm',
                offset = {x = 0.3, y = -3.5},
                noisy = false,
                float = false,
            })
            lobc_screen_text({
                text = localize('k_lobc_first_time_2'),
                scale = 0.35, 
                hold = 15*G.SETTINGS.GAMESPEED,
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
        elseif G.GAME.blind.lobc_original_blind == "bl_lobc_apocalypse_bird" then
            ease_background_colour({new_colour = darken(HEX("C8831B"), 0.1), special_colour = darken(HEX("C8831B"), 0.3), contrast = 1})
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

    -- Nameless Fetus
    G.nameless_hand_type = nil
    -- Production last pack Ante
    G.production_last_pack = 1
    -- Effect multi
    G.lobc_hod_modifier = 1

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
    -- Reset hands for on death summon bosses
    G.GAME.current_round.lobc_hands_given = 0
    G.GAME.current_round.lobc_phases_beaten = 0
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
function play_sound(sound_code, per, vol)
    if sound_code and sound_code:find('lobc') then
        -- No SFX toggle
        if config.no_sfx then return end
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

    -- Update cutscene transparency
    if G.lobc_displaying_cutscene then
        G.lobc_cutscene_timer = G.lobc_cutscene_timer + dt
        if G.lobc_cutscene_timer < 0.5 then G.lobc_cutscene_transparency = G.lobc_cutscene_timer * 2 end
        if G.lobc_cutscene_timer >= 0.5 and G.lobc_cutscene_timer < 5 then G.lobc_cutscene_transparency = 1 end
        if G.lobc_cutscene_timer >= 5 and G.lobc_cutscene_timer <= 6 then G.lobc_cutscene_transparency = 6 - G.lobc_cutscene_timer end
        if G.lobc_cutscene_timer >= 6 then 
            G.lobc_cutscene_transparency = 0
            G.lobc_displaying_cutscene = false
            G.SETTINGS.paused = false
            if G.OVERLAY_MENU then G.OVERLAY_MENU:remove() end
        end
    end

    -- i hate chicot
    if find_passive("psv_lobc_fixed_encounter") then G.GAME.blind.disabled = nil end
    game_updateref(self, dt)
end

-- Reduce return values for card evals
local eval_cardref = eval_card
function eval_card(card, context)
    local eval = eval_cardref(card, context)
    if eval and G.GAME.lobc_hod_modifier and G.GAME.lobc_hod_modifier ~= 1 then
        if eval.chips then eval.chips = eval.chips * G.GAME.lobc_hod_modifier end
        if eval.mult then eval.mult = eval.mult * G.GAME.lobc_hod_modifier end
        if eval.x_mult then 
            if eval.x_mult < 1 then eval.x_mult = eval.x_mult * G.GAME.lobc_hod_modifier
            else eval.x_mult = 1 + (eval.x_mult - 1) * G.GAME.lobc_hod_modifier end
        end
        if eval.h_mult then eval.h_mult = eval.h_mult * G.GAME.lobc_hod_modifier end
        if eval.h_x_mult then 
            if eval.h_x_mult < 1 then eval.h_x_mult = eval.h_x_mult * G.GAME.lobc_hod_modifier
            else eval.h_x_mult = 1 + (eval.h_x_mult - 1) * G.GAME.lobc_hod_modifier end
        end
    end
    return eval
end

local calculate_jokerref = Card.calculate_joker
function Card.calculate_joker(self, context)
    if context.callback then
        local callbackref = context.callback
        context.callback = function(self, eval, the_j)
            if eval and G.GAME.lobc_hod_modifier and G.GAME.lobc_hod_modifier ~= 1 then
                if eval then 
                    if eval.chips then eval.chips = eval.chips * G.GAME.lobc_hod_modifier end
                    if eval.mult then eval.mult = eval.mult * G.GAME.lobc_hod_modifier end
                    if eval.mult_mod then eval.mult_mod = eval.mult_mod * G.GAME.lobc_hod_modifier end
                    if eval.chip_mod then eval.chip_mod = eval.chip_mod * G.GAME.lobc_hod_modifier end
                    if eval.h_mult then eval.h_mult = eval.h_mult * G.GAME.lobc_hod_modifier end
                    if eval.h_x_mult then
                        if eval.h_x_mult < 1 then eval.h_x_mult = eval.h_x_mult * G.GAME.lobc_hod_modifier
                        else eval.h_x_mult = 1 + (eval.h_x_mult - 1) * G.GAME.lobc_hod_modifier end
                    end
                    if eval.Xmult_mod then
                        if eval.Xmult_mod < 1 then eval.Xmult_mod = eval.Xmult_mod * G.GAME.lobc_hod_modifier
                        else eval.Xmult_mod = 1 + (eval.Xmult_mod - 1) * G.GAME.lobc_hod_modifier end
                    end
                    if eval.x_mult then
                        if eval.x_mult < 1 then eval.x_mult = eval.x_mult * G.GAME.lobc_hod_modifier
                        else eval.x_mult = 1 + (eval.x_mult - 1) * G.GAME.lobc_hod_modifier end
                    end
                end
                if eval.jokers then
                    if eval.jokers.chips then eval.jokers.chips = eval.jokers.chips * G.GAME.lobc_hod_modifier end
                    if eval.jokers.mult then eval.jokers.mult = eval.jokers.mult * G.GAME.lobc_hod_modifier end
                    if eval.jokers.mult_mod then eval.jokers.mult_mod = eval.jokers.mult_mod * G.GAME.lobc_hod_modifier end
                    if eval.jokers.chip_mod then eval.jokers.chip_mod = eval.jokers.chip_mod * G.GAME.lobc_hod_modifier end
                    if eval.jokers.h_mult then eva.jokersl.h_mult = eval.jokers.h_mult * G.GAME.lobc_hod_modifier end
                    if eval.jokers.h_x_mult then
                        if eval.jokers.h_x_mult < 1 then eval.jokers.h_x_mult = eval.jokers.h_x_mult * G.GAME.lobc_hod_modifier
                        else eval.jokers.h_x_mult = 1 + (eval.jokers.h_x_mult - 1) * G.GAME.lobc_hod_modifier end
                    end
                    if eval.jokers.Xmult_mod then
                        if eval.jokers.Xmult_mod < 1 then eval.jokers.Xmult_mod = eval.jokers.Xmult_mod * G.GAME.lobc_hod_modifier
                        else eval.jokers.Xmult_mod = 1 + (eval.jokers.Xmult_mod - 1) * G.GAME.lobc_hod_modifier end
                    end
                    if eval.jokers.x_mult then
                        if eval.jokers.x_mult < 1 then eval.jokers.x_mult = eval.jokers.x_mult * G.GAME.lobc_hod_modifier
                        else eval.jokers.x_mult = 1 + (eval.jokers.x_mult - 1) * G.GAME.lobc_hod_modifier end
                    end
                end
            end
            callbackref(self, eval, the_j)
        end
    end
    return calculate_jokerref(self, context)
end

local get_editionref = Card.get_edition
function Card.get_edition(self)
    local eval = get_editionref(self)
    if eval and G.GAME.lobc_hod_modifier and G.GAME.lobc_hod_modifier ~= 1 then
        if eval.mult_mod then eval.mult_mod = eval.mult_mod * G.GAME.lobc_hod_modifier end
        if eval.chip_mod then eval.chip_mod = eval.chip_mod * G.GAME.lobc_hod_modifier end
        if eval.x_mult_mod then 
            if eval.x_mult_mod < 1 then eval.x_mult_mod = eval.x_mult_mod * G.GAME.lobc_hod_modifier
            else eval.x_mult_mod = 1 + (eval.x_mult_mod - 1) * G.GAME.lobc_hod_modifier end
        end
    end
    return eval
end

local eval_thisref = SMODS.eval_this
function SMODS.eval_this(_card, effects)
    if effects and G.GAME.lobc_hod_modifier and G.GAME.lobc_hod_modifier ~= 1 then
        if effects.mult_mod then effects.mult_mod = effects.mult_mod * G.GAME.lobc_hod_modifier end
        if effects.chip_mod then effects.chip_mod = effects.chip_mod * G.GAME.lobc_hod_modifier end
        if effects.Xmult_mod then 
            if effects.Xmult_mod < 1 then effects.Xmult_mod = effects.Xmult_mod * G.GAME.lobc_hod_modifier
            else effects.Xmult_mod = 1 + (effects.Xmult_mod - 1) * G.GAME.lobc_hod_modifier end
        end
    end
    return eval_thisref(_card, effects)
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

    -- Card flipped (Malkuth)
    if G.GAME and G.GAME.modifiers.lobc_malkuth then
        if (self.ability.consumeable and G.GAME.round_resets.ante > 3) or
           (self.ability.set == "Joker" and G.GAME.round_resets.ante > 6) then
            self.facing = 'back'
            self.sprite_facing = 'back'
            self.pinch.x = false
        end
    end

    -- Restore Enchanted particles on reload (Big Bird)
    if self.ability.big_bird_enchanted and not self.children.lobc_big_bird_particles then
        self.children.lobc_big_bird_particles = Particles(0, 0, 0,0, {
            timer = 0.3,
            scale = 0.45,
            speed = 0.3,
            lifespan = 4,
            attach = self,
            colours = {darken(G.C.MONEY, 0.1), darken(G.C.MONEY, 0.3), darken(G.C.MONEY, 0.5)},
            fill = true
        })
    end
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
    local _pool, _starting_pool, _pool_key, _pool_size = G.ARGS.TEMP_POOL, {}, 'Abnormality', 0
    for _, v in ipairs(joker_list) do
        _starting_pool[#_starting_pool+1] = G.P_CENTERS["j_lobc_"..v]
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