local current_mod = SMODS.current_mod
local config = SMODS.current_mod.config

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

G.FUNCS.lobc_discover_all = function(e)
    for k, v in pairs(SMODS.Centers) do
        if v.mod == current_mod and v.discover_rounds and type(v.discover_rounds) == "table" then
            if G.PROFILES[G.SETTINGS.profile].joker_usage[v.key] then
                G.PROFILES[G.SETTINGS.profile].joker_usage[v.key].count = v.discover_rounds[#v.discover_rounds]
            else
                G.PROFILES[G.SETTINGS.profile].joker_usage[v.key] = {count = v.discover_rounds[#v.discover_rounds], order = v.order, wins = {}, losses = {}}
            end
            v.discovered = true
            v.alerted = true
        end
    end
    G:save_settings()
end

G.FUNCS.lobc_reset_achievements = function(e)
    for k, v in pairs(SMODS.Achievements) do
        if v.mod == current_mod then
            if G.SETTINGS.ACHIEVEMENTS_EARNED[v.key] then G.SETTINGS.ACHIEVEMENTS_EARNED[v.key] = nil end
            if G.ACHIEVEMENTS[v.key].earned then G.ACHIEVEMENTS[v.key].earned = nil end
        end
    end
    G:save_settings()
end

SMODS.current_mod.config_tab = function()
    return {n = G.UIT.ROOT, config = {r = 0.1, align = "c", padding = 0.1, colour = G.C.BLACK, minh = 6}, nodes = {
        {n = G.UIT.R, config = {align = "tm", padding = 0}, nodes = {
            {n = G.UIT.C, config = {align = "t", padding = 0.1}, nodes = {
                create_config_node("no_music"),
                create_config_node("no_sfx"),
                create_config_node("disable_meltdown_color"),
                create_config_node("disable_abno_text"),
            }},
    
            {n = G.UIT.C, config = {align = "t", padding = 0.1}, nodes = {
                create_config_node("show_art_undiscovered"),
                create_config_node("disable_ordeals"),
                create_config_node("lobcorp_music"),
                create_config_node("enable_crossovers"),
            }},
        }},
        {n = G.UIT.R, config = {align = "tm", padding = 0.1}, nodes = {
            --[[{n=G.UIT.C, config = {align = "cm", padding = 0.1, r = 0.1, minw = 6, minh = 0.8, hover = true, shadow = true, colour = G.C.RED, one_press = true, button = 'lobc_discover_all'}, nodes={
                {n=G.UIT.T, config={text = localize('b_lobc_discover_all'),colour = G.C.UI.TEXT_LIGHT, scale = 0.45, shadow = true}}
            }},]]--
            {n=G.UIT.C, config = {align = "cm", padding = 0.1, r = 0.1, minw = 6, minh = 0.8, hover = true, shadow = true, colour = G.C.RED, one_press = true, button = 'lobc_reset_achievements'}, nodes={
                {n=G.UIT.T, config={text = localize('b_lobc_reset_ach'),colour = G.C.UI.TEXT_LIGHT, scale = 0.45, shadow = true}}
            }},
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
        {n = G.UIT.R, config = {align = "cl", padding = 0.05}, nodes = {
            {n = G.UIT.T, config = { text = localize('lobc_credits_9'), scale = 0.3, colour = G.C.UI.TEXT_LIGHT}},
            {n = G.UIT.T, config = { text = localize('lobc_credits_a26'), scale = 0.3, colour = G.C.DARK_EDITION}},
            {n = G.UIT.T, config = { text = " | ", scale = 0.3, colour = G.C.UI.TEXT_LIGHT}},
            {n = G.UIT.T, config = { text = localize('lobc_credits_10'), scale = 0.3, colour = G.C.UI.TEXT_LIGHT}},
            {n = G.UIT.T, config = { text = localize('lobc_credits_pix'), scale = 0.3, colour = G.C.DARK_EDITION}},
        }},
    }}
end