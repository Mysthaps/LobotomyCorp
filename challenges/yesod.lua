local chal = {
    name = "Information",
    rules = {
        custom = {
            {id = "lobc_yesod"},
            {id = "lobc_yesod_2"},
            {id = "lobc_yesod_3"},
            {id = "lobc_yesod_4"},
            {id = "lobc_fast_ante_1"},
        },
    },
    restrictions = {
        banned_tags = {
            {id = 'tag_foil'},
            {id = 'tag_holo'},
            {id = 'tag_polychrome'},
            {id = 'tag_negative'}
        },
        banned_cards = {
            {id = 'c_wheel_of_fortune'},
            {id = 'c_aura'},
            {id = 'c_ectoplasm'},
            {id = 'c_hex'},
            {id = 'j_perkeo'},
            {id = 'j_lobc_old_faith'},
            {id = 'j_lobc_scarecrow_searching'},
            {id = 'v_hone'},
            {id = 'v_glow_up'},
        },
    },
    unlocked = function(self)
        return true
    end
}

if (SMODS.Mods.Cryptid or {}).can_load then
    local cry_config = SMODS.load_mod_config({id = "Cryptid", path = SMODS.Mods.Cryptid.path})

    if cry_config["Code Cards"] then
        table.insert(chal.restrictions.banned_cards, {id = 'c_cry_malware'})
        table.insert(chal.restrictions.banned_cards, {id = 'c_cry_rework'})
        table.insert(chal.restrictions.banned_cards, {id = 'c_cry_machinecode'})
        if cry_config["Misc."] then
            table.insert(chal.restrictions.banned_cards, {id = 'c_cry_spaghetti'})
        end
    end

    if cry_config["Spectrals"] then
        table.insert(chal.restrictions.banned_cards, {id = 'c_cry_typhoon'})
    end

    if cry_config["Misc. Jokers"] then
        table.insert(chal.restrictions.banned_cards, {id = 'j_cry_meteor'})
        table.insert(chal.restrictions.banned_cards, {id = 'j_cry_exoplanet'})
        table.insert(chal.restrictions.banned_cards, {id = 'j_cry_stardust'})
        table.insert(chal.restrictions.banned_cards, {id = 'j_cry_queens_gambit'})
    end
end

if (SMODS.Mods.Bunco or {}).can_load then
    table.insert(chal.restrictions.banned_cards, {id = 'c_bunc_cleanse'})
    table.insert(chal.restrictions.banned_cards, {id = 'j_bunc_juggalo'})
    table.insert(chal.restrictions.banned_cards, {id = 'j_bunc_puzzle_board'})
    table.insert(chal.restrictions.banned_cards, {id = 'j_bunc_running_joke'})
    table.insert(chal.restrictions.banned_cards, {id = 'j_bunc_roygbiv'})
    table.insert(chal.restrictions.banned_cards, {id = 'v_bunc_lamination'})
    table.insert(chal.restrictions.banned_cards, {id = 'v_bunc_supercoating'})
    
    table.insert(chal.restrictions.banned_tags, {id = 'tag_bunc_glitter'})
    table.insert(chal.restrictions.banned_tags, {id = 'tag_bunc_fluorescent'})
end

if (SMODS.Mods.JankJonklersMod or {}).can_load then
    table.insert(chal.restrictions.banned_cards, {id = 'j_jank_shady_dealer'})
end

if (SMODS.Mods.TWEWY or {}).can_load then
    table.insert(chal.restrictions.banned_cards, {id = 'j_twewy_aquaGhost'})
    table.insert(chal.restrictions.banned_cards, {id = 'j_twewy_live'})
    table.insert(chal.restrictions.banned_cards, {id = 'j_twewy_topGear'})
    table.insert(chal.restrictions.banned_cards, {id = 'j_twewy_chaos'})
    table.insert(chal.restrictions.banned_cards, {id = 'j_twewy_cutieBeam'})
    table.insert(chal.restrictions.banned_cards, {id = 'j_twewy_playmateBeam'})
end

-- Atlases and Shaders not affected by Pixelation (Yesod)
local blacklist_atlas = {
    "cards_1",
    "cards_2",
    "ui_1",
    "ui_2",
    "balatro",
    "gamepad_ui",
    "icons",
    "centers",
}
local blacklist_shader = {
    "lobc_pixelation",
    "vortex",
    "flame",
    "splash",
    "flash",
    "background",
}

-- Apply Pixelation shader
local draw_shaderref = Sprite.draw_shader
function Sprite.draw_shader(self, _shader, _shadow_height, _send, _no_tilt, other_obj, ms, mr, mx, my, custom_shader, tilt_shadow)
    local check = G.GAME and G.GAME.modifiers.lobc_yesod
    for _, v in ipairs(blacklist_atlas) do if self.atlas == G.ASSET_ATLAS[v] then check = false end end
    if self.atlas == G.ANIMATION_ATLAS["shop_sign"] then check = false end
    for _, v in ipairs(blacklist_shader) do if _shader == v then check = false end end
    draw_shaderref(self, _shader, _shadow_height, _send, _no_tilt, other_obj, ms, mr, mx, my, custom_shader, tilt_shadow)
    if check then draw_shaderref(self, "lobc_pixelation", _shadow_height, nil, nil, other_obj, ms, mr, mx, my) end
end

-- Remove blank font when appropriate
local overlay_menuref = G.FUNCS.overlay_menu
function G.FUNCS.overlay_menu(args)
    if G.LANG and G.FONTS and G.LANG.font == G.FONTS["blank"] and G.LANGUAGES and G.SETTINGS.paused then G.LANG.font = G.LANGUAGES[G.SETTINGS.language or "en_us"].font end
    overlay_menuref(args)
end

-- No editions
local set_editionref = Card.set_edition
function Card.set_edition(self, edition, immediate, silent)
    if G.GAME.modifiers.lobc_yesod then return end
    set_editionref(self, edition, immediate, silent)
end

return chal