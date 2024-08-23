local config = SMODS.current_mod.config

return {
    -- Violation of Black Colors: Antes 4-6 of Malkuth Core Suppression
    {
        key = "music_malkuth_1",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.modifiers.lobc_malkuth and G.GAME.round_resets.ante >= 4 and G.GAME.round_resets.ante <= 6)
        end,
    },

    -- Red Dots: Antes 7+ of Malkuth Core Suppression
    {
        key = "music_malkuth_2",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.modifiers.lobc_malkuth and G.GAME.round_resets.ante > 6)
        end,
    },

    -- Untitled9877645623413123325: Antes 4-6 of Yesod Core Suppression
    {
        key = "music_yesod_1",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.modifiers.lobc_yesod and G.GAME.round_resets.ante >= 4 and G.GAME.round_resets.ante <= 6)
        end,
    },

    -- Faded: Antes 7+ of Yesod Core Suppression
    {
        key = "music_yesod_2",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.modifiers.lobc_yesod and G.GAME.round_resets.ante > 6)
        end,
    },

    -- Theme - Retro Time ALT: Antes 4-6 of Hod Core Suppression
    {
        key = "music_hod_1",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.modifiers.lobc_hod and G.GAME.round_resets.ante >= 4 and G.GAME.round_resets.ante <= 6)
        end,
    },

    -- Theme - Retro Time ALT Mix 1: Antes 7+ of Hod Core Suppression
    {
        key = "music_hod_2",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.modifiers.lobc_hod and G.GAME.round_resets.ante > 6)
        end,
    },

    -- Abandoned: Antes 4-6 of Netzach Core Suppression
    {
        key = "music_netzach_1",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.modifiers.lobc_netzach and G.GAME.round_resets.ante >= 4 and G.GAME.round_resets.ante <= 6)
        end,
    },

    -- Blue Dots: Antes 7+ of Netzach Core Suppression
    {
        key = "music_netzach_2",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.modifiers.lobc_netzach and G.GAME.round_resets.ante > 6)
        end,
    },

    -- Distorted Night: Phases 2 & 3 of The Red Mist
    {
        key = "music_gebura_1",
        select_music_track = function()
            if config.no_music then return false end
            local phase = G.GAME.current_round.lobc_phases_beaten
            return (G.GAME.blind and G.GAME.blind.config.blind.key == "bl_lobc_red_mist" and (phase == 1 or phase == 2))
        end,
    },

    -- Insignia Decay: Phase 4 of The Red Mist
    {
        key = "music_gebura_2",
        select_music_track = function()
            if config.no_music then return false end
            local phase = G.GAME.current_round.lobc_phases_beaten
            return (G.GAME.blind and G.GAME.blind.config.blind.key == "bl_lobc_red_mist" and phase >= 3)
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
            return (G.STATE == G.STATES.SMODS_BOOSTER_OPENED and SMODS.OPENED_BOOSTER.config.center.group_key == "k_lobc_extraction_pack")
        end,
    },

    -- Third Warning: WhiteNight
    {
        key = "music_third_warning",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.blind and G.GAME.blind.config.blind.key == "bl_lobc_whitenight")
        end,
    },

    -- Second Warning: Antes 1-3 of Asiyah Core Suppressions, Midnight Ordeals, Phase 1 of The Red Mist and An Arbiter
    {
        key = "music_second_warning",
        select_music_track = function()
            if config.no_music then return false end
            for _, v in pairs({"malkuth", "yesod", "hod", "netzach"}) do
                if G.GAME and G.GAME.modifiers["lobc_"..v] and G.GAME.round_resets.ante <= 3 then return true end
            end
            if G.GAME.blind and G.GAME.blind.config.blind.phases and G.GAME.current_round.lobc_phases_beaten == 0 then return true end
            return (G.GAME and G.GAME.blind and G.GAME.blind.config.blind.time and G.GAME.blind.config.blind.time == "midnight")
        end,
    },

    -- First Warning: Dusk Ordeals
    {
        key = "music_first_warning",
        select_music_track = function()
            if config.no_music then return false end
            return (G.GAME and G.GAME.blind and 
            ((G.GAME.blind.config.blind.time and G.GAME.blind.config.blind.time == "dusk") or
            (G.GAME.blind.lobc_original_blind and G.GAME.blind.lobc_original_blind == "bl_lobc_dusk_crimson")))
        end,
    },
}