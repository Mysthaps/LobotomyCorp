local config = SMODS.current_mod.config

return {
    -- Violation of Black Colors: Antes 4-6 of Malkuth Core Suppression
    {
        key = "music_malkuth_1",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.modifiers.lobc_malkuth and G.GAME.round_resets.ante >= 4 and G.GAME.round_resets.ante <= 6) and 10 or false
        end,
    },

    -- Red Dots: Antes 7+ of Malkuth Core Suppression
    {
        key = "music_malkuth_2",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.modifiers.lobc_malkuth and G.GAME.round_resets.ante > 6) and 10 or false
        end,
    },

    -- Untitled9877645623413123325: Antes 4-6 of Yesod Core Suppression
    {
        key = "music_yesod_1",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.modifiers.lobc_yesod and G.GAME.round_resets.ante >= 4 and G.GAME.round_resets.ante <= 6) and 10 or false
        end,
    },

    -- Faded: Antes 7+ of Yesod Core Suppression
    {
        key = "music_yesod_2",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.modifiers.lobc_yesod and G.GAME.round_resets.ante > 6) and 10 or false
        end,
    },

    -- Theme - Retro Time ALT: Antes 4-6 of Hod Core Suppression
    {
        key = "music_hod_1",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.modifiers.lobc_hod and G.GAME.round_resets.ante >= 4 and G.GAME.round_resets.ante <= 6) and 10 or false
        end,
    },

    -- Theme - Retro Time ALT Mix 1: Antes 7+ of Hod Core Suppression
    {
        key = "music_hod_2",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.modifiers.lobc_hod and G.GAME.round_resets.ante > 6) and 10 or false
        end,
    },

    -- Abandoned: Antes 4-6 of Netzach Core Suppression
    {
        key = "music_netzach_1",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.modifiers.lobc_netzach and G.GAME.round_resets.ante >= 4 and G.GAME.round_resets.ante <= 6) and 10 or false
        end,
    },

    -- Blue Dots: Antes 7+ of Netzach Core Suppression
    {
        key = "music_netzach_2",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.modifiers.lobc_netzach and G.GAME.round_resets.ante > 6) and 10 or false
        end,
    },

    -- Eternal: Antes 4-6 of Tiphereth Core Suppression
    {
        key = "music_tiphereth_1",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.modifiers.lobc_tiphereth and G.GAME.round_resets.ante >= 4 and G.GAME.round_resets.ante <= 6) and 10 or false
        end,
    },
    
    -- Dark Fantasy Scene: Antes 7+ of Tiphereth Core Suppression
    {
        key = "music_tiphereth_2",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.modifiers.lobc_tiphereth and G.GAME.round_resets.ante > 6) and 10 or false
        end,
    },

    -- Distorted Night: Phases 2 & 3 of The Red Mist
    {
        key = "music_gebura_1",
        select_music_track = function()
            if config.no_music then return false end
            local phase = G.GAME.current_round.lobc_phases_beaten
            return (G.GAME.blind and G.GAME.blind.config.blind.key == "bl_lobc_red_mist" and (phase == 1 or phase == 2)) and 10 or false
        end,
    },

    -- Insignia Decay: Phase 4 of The Red Mist
    {
        key = "music_gebura_2",
        select_music_track = function()
            if config.no_music then return false end
            local phase = G.GAME.current_round.lobc_phases_beaten
            return (G.GAME.blind and G.GAME.blind.config.blind.key == "bl_lobc_red_mist" and phase >= 3) and 10 or false
        end,
    },

    -- Abnormality Choice: Extraction Packs
    {
        key = "music_abno_choice",
        select_music_track = function()
            if config.no_music then return false end
            for _, v in pairs(G.lobc_global_meltdowns) do
                if G.GAME and G.GAME.modifiers["lobc_"..v] then return false end
            end
            return (G.STATE == G.STATES.SMODS_BOOSTER_OPENED and SMODS.OPENED_BOOSTER.config.center.group_key == "k_lobc_extraction_pack") and 1 or false
        end,
    },

    -- Third Warning: WhiteNight
    {
        key = "music_third_warning",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.blind and G.GAME.blind.config.blind.key == "bl_lobc_whitenight") and 5 or false
        end,
    },

    -- Second Warning: Antes 1-3 of most Core Suppressions, Midnight Ordeals, Antes 1-8/10 and Phase 1 of The Red Mist and An Arbiter
    {
        key = "music_second_warning",
        select_music_track = function()
            if config.no_music then return false end
            for _, v in pairs({"malkuth", "yesod", "hod", "netzach", "tiphereth"}) do
                if G.GAME and G.GAME.modifiers["lobc_"..v] and G.GAME.round_resets.ante <= 3 then return 10 end
            end
            for _, v in pairs({"gebura"}) do
                if G.GAME and G.GAME.modifiers["lobc_"..v] and not G.GAME.blind.lobc_current_effect then return 10 end
            end
            if G.GAME.blind and G.GAME.blind.config.blind.phases and G.GAME.current_round.lobc_phases_beaten == 0 then return 10 end
            return (G.GAME and G.GAME.blind and G.GAME.blind.config.blind.time and G.GAME.blind.config.blind.time == "midnight") and 2 or false
        end,
    },

    -- First Warning: Dusk Ordeals
    {
        key = "music_first_warning",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.blind and 
            ((G.GAME.blind.config.blind.time and G.GAME.blind.config.blind.time == "dusk") or
            (G.GAME.blind.lobc_original_blind and G.GAME.blind.lobc_original_blind == "bl_lobc_dusk_crimson"))) and 1 or false
        end,
    },
}