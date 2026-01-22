local config = SMODS.current_mod.config

return {
    -- Violation of Black Colors: Antes 4-6 of Malkuth Core Suppression
    {
        key = "music_malkuth_1",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.modifiers.lobc_malkuth and G.GAME.round_resets.ante >= 4 and G.GAME.round_resets.ante <= 6) and 1e5 or false
        end,
    },

    -- Red Dots: Antes 7+ of Malkuth Core Suppression
    {
        key = "music_malkuth_2",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.modifiers.lobc_malkuth and G.GAME.round_resets.ante > 6) and 1e5 or false
        end,
    },

    -- Untitled9877645623413123325: Antes 4-6 of Yesod Core Suppression
    {
        key = "music_yesod_1",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.modifiers.lobc_yesod and G.GAME.round_resets.ante >= 4 and G.GAME.round_resets.ante <= 6) and 1e5 or false
        end,
    },

    -- Faded: Antes 7+ of Yesod Core Suppression
    {
        key = "music_yesod_2",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.modifiers.lobc_yesod and G.GAME.round_resets.ante > 6) and 1e5 or false
        end,
    },

    -- Theme - Retro Time ALT: Antes 4-6 of Hod Core Suppression
    {
        key = "music_hod_1",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.modifiers.lobc_hod and G.GAME.round_resets.ante >= 4 and G.GAME.round_resets.ante <= 6) and 1e5 or false
        end,
    },

    -- Theme - Retro Time ALT Mix 1: Antes 7+ of Hod Core Suppression
    {
        key = "music_hod_2",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.modifiers.lobc_hod and G.GAME.round_resets.ante > 6) and 1e5 or false
        end,
    },

    -- Abandoned: Antes 4-6 of Netzach Core Suppression
    {
        key = "music_netzach_1",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.modifiers.lobc_netzach and G.GAME.round_resets.ante >= 4 and G.GAME.round_resets.ante <= 6) and 1e5 or false
        end,
    },

    -- Blue Dots: Antes 7+ of Netzach Core Suppression
    {
        key = "music_netzach_2",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.modifiers.lobc_netzach and G.GAME.round_resets.ante > 6) and 1e5 or false
        end,
    },

    -- Eternal: Antes 4-6 of Tiphereth Core Suppression
    {
        key = "music_tiphereth_1",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.modifiers.lobc_tiphereth and G.GAME.round_resets.ante >= 4 and G.GAME.round_resets.ante <= 6) and 1e5 or false
        end,
    },
    
    -- Dark Fantasy Scene: Antes 7+ of Tiphereth Core Suppression
    {
        key = "music_tiphereth_2",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.modifiers.lobc_tiphereth and G.GAME.round_resets.ante > 6) and 1e5 or false
        end,
    },

    -- Distorted Night: Phases 2 & 3 of The Red Mist
    {
        key = "music_gebura_1",
        select_music_track = function()
            if config.no_music then return false end
            local phase = G.GAME.current_round.phases_beaten
            return (G.GAME.blind and G.GAME.blind.config.blind.key == "bl_lobc_red_mist" and (phase == 1 or phase == 2)) and 1e5 or false
        end,
    },

    -- Insignia Decay: Phase 4 of The Red Mist
    {
        key = "music_gebura_2",
        select_music_track = function()
            if config.no_music then return false end
            local phase = G.GAME.current_round.phases_beaten
            return (G.GAME.blind and G.GAME.blind.config.blind.key == "bl_lobc_red_mist" and phase >= 3) and 1e5 or false
        end,
    },

    -- Abnormality Choice: Extraction Packs
    {
        key = "music_abno_choice",
        select_music_track = function()
            if config.no_music then return false end
            for _, v in pairs(G.lobc_global_meltdowns or {}) do
                if v ~= "gebura" and G.GAME and G.GAME.modifiers["lobc_"..v] then return false end
            end
            return (G.STATE == G.STATES.SMODS_BOOSTER_OPENED and SMODS.OPENED_BOOSTER.config.center.group_key == "k_lobc_extraction_pack") and 1e4 or false
        end,
    },

    -- Through Patches of Violet: ???
    {
        key = "music_tpov",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME.blind and G.GAME.blind.config.blind and G.GAME.blind.config.blind.key == "bl_lobc_erlking_heathcliff") and 644000 or false
        end,
    },

    -- Compass: ???
    {
        key = "music_compass",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME.blind and G.GAME.blind.config.blind and G.GAME.blind.config.blind.key == "bl_lobc_what_blind") and 536000 or false
        end,
        bpm = 176.25,
        offset = -0.180
    },

    -- Roland01, Roland02, Roland03: Apocalypse Bird
    {
        key = "music_roland1",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.apoc_music == 1) and 1e6 or false
        end,
    },
    {
        key = "music_roland2",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.apoc_music == 2) and 1e6 or false
        end,
    },
    {
        key = "music_roland3",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.apoc_music == 3) and 1e6 or false
        end,
    },

    -- Third Warning: WhiteNight
    {
        key = "music_third_warning",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.blind and G.GAME.blind.config.blind.key == "bl_lobc_whitenight") and 1e6 or false
        end,
    },

    -- Second Warning (Ruina): 
    {
        key = "music_second_warning_ruina",
        select_music_track = function()
            if config.no_music then return false end
            for _, v in pairs({"hatred", "despair", "greed", "wrath"}) do
                if G.GAME and G.GAME.blind and G.GAME.blind.config.blind.key == "bl_lobc_mg_"..v then return 1e6 end
            end
            return false
        end,
    },

    -- Second Warning: Antes 1-3 of most Core Suppressions, Midnight Ordeals, Antes 1-8/10 and Phase 1 of The Red Mist and An Arbiter
    {
        key = "music_second_warning",
        select_music_track = function()
            if config.no_music then return false end
            for _, v in pairs({"malkuth", "yesod", "hod", "netzach", "tiphereth"}) do
                if G.GAME and G.GAME.modifiers["lobc_"..v] and G.GAME.round_resets.ante <= 3 then return 1e5 end
            end
            if G.GAME.blind and G.GAME.blind.config.blind.phases and G.GAME.current_round.phases_beaten == 0 then return 1e5 end
            return (G.GAME and G.GAME.blind and 
            ((G.GAME.blind.config.blind.lobc_time and G.GAME.blind.config.blind.lobc_time == "midnight") or
            (config.lobcorp_music and G.GAME.blind.config.blind.boss and G.GAME.blind.config.blind.boss.showdown))) and 1e4 or false
        end,
    },

    -- First Warning: Dusk Ordeals
    {
        key = "music_first_warning",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.blind and 
            ((G.GAME.blind.config.blind.lobc_time and G.GAME.blind.config.blind.lobc_time == "dusk") or
            (G.GAME.blind.original_blind and G.GAME.blind.original_blind == "bl_lobc_dusk_crimson") or
            (config.lobcorp_music and G.GAME.blind.config.blind.boss and not G.GAME.blind.config.blind.boss.showdown))) and 1e3 or false
        end,
    },

    -- Story1
    {
        key = "music_story1",
        select_music_track = function()
            if config.no_music or not config.lobcorp_music then return false end
            return (G.STATE == G.STATES.MENU) and 1 or false
        end,
    },

    -- Neutral1, Neutral2, Neutral3, Neutral4
    {
        key = "music_neutral1",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.round_resets.ante <= 2 and (G.GAME.modifiers.lobc_production or config.lobcorp_music)) and 0 or false
        end,
        sync = {
            lobc_music_neutral1 = true,
            lobc_music_neutral2 = true,
            lobc_music_neutral3 = true,
            lobc_music_neutral4 = true,
        }
    },
    {
        key = "music_neutral2",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.round_resets.ante >= 3 and G.GAME.round_resets.ante <= 4 and (G.GAME.modifiers.lobc_production or config.lobcorp_music)) and 0 or false
        end,
        sync = {
            lobc_music_neutral1 = true,
            lobc_music_neutral2 = true,
            lobc_music_neutral3 = true,
            lobc_music_neutral4 = true,
        }
    },
    {
        key = "music_neutral3",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.round_resets.ante >= 5 and G.GAME.round_resets.ante <= 6 and (G.GAME.modifiers.lobc_production or config.lobcorp_music)) and 0 or false
        end,
        sync = {
            lobc_music_neutral1 = true,
            lobc_music_neutral2 = true,
            lobc_music_neutral3 = true,
            lobc_music_neutral4 = true,
        }
    },
    {
        key = "music_neutral4",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.round_resets.ante >= 7 and (G.GAME.modifiers.lobc_production or config.lobcorp_music)) and 0 or false
        end,
        sync = {
            lobc_music_neutral1 = true,
            lobc_music_neutral2 = true,
            lobc_music_neutral3 = true,
            lobc_music_neutral4 = true,
        }
    },

    -- HYPERHASTIGHETS UPPGRADERINGAR (Get Funky)
    {
        key = "music_funky",
        select_music_track = function()
            if config.no_music then return false end
            return G.get_funky and 100 or false
        end,
        pitch = 1,
        bpm = 120,
        offset = 0.033,
        sync_events = {}
    }
}