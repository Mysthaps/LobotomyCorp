local current_mod = SMODS.current_mod
local config = SMODS.current_mod.config

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
        if G.GAME.modifiers.lobc_gebura or (string.lower(G.PROFILES[G.SETTINGS.profile].name or '') == "ishmael" or (os.date("%d%m") == "0104" and not config.seen_what)) then G.GAME.win_ante = G.GAME.win_ante + 1 end
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
        if G.GAME.blind.config.blind.lobc_bg then
            ease_background_colour(G.GAME.blind.config.blind.lobc_bg)
            return
        elseif G.GAME.blind.config.blind.lobc_time and (G.GAME.blind.config.blind.lobc_time == "dawn" or G.GAME.blind.config.blind.lobc_time == "noon") and G.GAME.blind.config.blind.lobc_color ~= "base" then
            ease_background_colour{new_colour = lighten(mix_colours(G.GAME.blind.config.blind.boss_colour, G.C.BLACK, 0.3), 0.1), special_colour = G.GAME.blind.config.blind.boss_colour, contrast = 2}
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