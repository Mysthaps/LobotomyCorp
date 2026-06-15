local current_mod = SMODS.current_mod
local config = SMODS.current_mod.config

-- Overwrite blind spawning for Abnormality Boss Blinds if requirements are met
local get_new_bossref = get_new_boss
function get_new_boss()
    if (string.lower(G.PROFILES[G.SETTINGS.profile].name or '') == "ishmael" or (os.date("%d%m") == "0104" and not config.seen_what)) and G.GAME.round_resets.ante == G.GAME.win_ante then return "bl_lobc_what_blind" end
    if G.GAME.modifiers.lobc_gebura and G.GAME.round_resets.ante >= G.GAME.win_ante then return "bl_lobc_red_mist" end
    if G.GAME.modifiers.lobc_all_whitenight or 
    (G.GAME.pool_flags["plague_doctor_breach"] and not G.GAME.pool_flags["whitenight_defeated"]) then return "bl_lobc_whitenight" end
    if G.GAME.modifiers.lobc_placeholder or 
    (G.GAME.pool_flags["apocalypse_bird_event"] and not G.GAME.pool_flags["apocalypse_bird_defeated"]) then return "bl_lobc_apocalypse_bird" end
    if G.GAME.modifiers.lobc_placeholder or
    (G.GAME.pool_flags["queen_of_hatred_breach"] and not G.GAME.pool_flags["hatred_defeated"]) then return "bl_lobc_mg_hatred" end
    if G.GAME.modifiers.lobc_placeholder or
    (G.GAME.pool_flags["servant_of_wrath_breach"] and not G.GAME.pool_flags["wrath_defeated"]) then return "bl_lobc_mg_wrath" end
    if G.GAME.modifiers.lobc_production then
        local ante = G.GAME.round_resets.ante
        if ante <= 2 then return "bl_lobc_dawn_base" end
        if ante <= 4 then return "bl_lobc_noon_base" end
        if ante <= 6 then return "bl_lobc_dusk_base" end
        return "bl_lobc_midnight_base"
    end
    if string.lower(G.PROFILES[G.SETTINGS.profile].name or '') == "heathcliff" then return "bl_lobc_erlking_heathcliff" end
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
    if (G.GAME.modifiers.lobc_gebura and G.GAME.round_resets.ante >= G.GAME.win_ante) or 
       ((string.lower(G.PROFILES[G.SETTINGS.profile].name or '') == "ishmael" or (os.date("%d%m") == "0104" and not config.seen_what)) and G.GAME.round_resets.ante == G.GAME.win_ante) then
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
        elseif G.GAME.round_resets.blind_choices.Small == 'bl_lobc_dawn_base' then
            G.GAME.round_resets.blind_choices.Small = 'bl_small'
        end

        if G.GAME.round_resets.ante % 8 == 4 and G.GAME.round_resets.ante > 0 and
           (G.GAME.modifiers.lobc_ordeals or pseudorandom("noon_ordeal") < 0.125) then
            G.GAME.round_resets.blind_choices.Big = 'bl_lobc_noon_base'
        elseif G.GAME.round_resets.blind_choices.Big == 'bl_lobc_noon_base' then
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
        if blind and blind.lobc_color and blind.lobc_color == "base" then
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
    if not reset and blind and (blind.lobc_time == "dusk" or blind.lobc_time == "midnight") then
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
                if v.children.lobc_big_bird_particles then v.children.lobc_big_bird_particles:remove() end
                v.children.lobc_big_bird_particles = nil
                v.ability.big_bird_enchanted = nil
            end
        end
    end
end

-- WhiteNight confession win round
local alert_debuffref = Blind.alert_debuff
function Blind.alert_debuff(self, first)
    if self.config.blind.lobc_color and self.config.blind.lobc_color == "base" then return end
    if self.config.blind.phases then return end
    if self.config.blind.key == "bl_lobc_apocalypse_bird" or find_passive("psv_lobc_cracking_eggs") then return end
    if self.config.blind.key == "bl_lobc_mg_hatred" then
        self.block_play = true
        G.E_MANAGER:add_event(Event({
            blocking = false,
            blockable = false,
            func = function() 
                if G.STATE == G.STATES.SELECTING_HAND then
                    play_sound("lobc_hatred_entry", 1, 0.8)
                    lobc_screen_text({text = localize('k_lobc_hatred_entry'), scale = 0.35, hold = 5*G.SETTINGS.GAMESPEED, major = G.play, align = 'cm', offset = {x = 0, y = -3.5}, noisy = false, colour = HEX("ffedf5")})
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 3*G.SETTINGS.GAMESPEED,
                        blocking = false,
                        blockable = false,
                        func = function() 
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
                                end)
                            }))
                            return true
                        end
                    }))
                    return true
                end
            end
        }))
    end
    if find_passive("psv_lobc_magical_girl") then return end
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
                            self.chips = to_big(0)
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
        if self.config.blind.lobc_color and not config.disable_all_text then
            self:ordeal_alert()
        else 
            alert_debuffref(self, first) 
        end
    end
end

-- Make Ordeals not end the game on win ante hopefully
local get_typeref = Blind.get_type
function Blind.get_type(self)
    if self.config.blind.lobc_color and not self.config.bonus then
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
    blindTable.hysteria = self.hysteria
    blindTable.transformed = self.transformed
    blindTable.alt_skill = self.alt_skill
    return blindTable
end

local blind_loadref = Blind.load
function Blind.load(self, blindTable)
    self.lobc_score_cap = blindTable.lobc_score_cap
    self.lobc_current_effect = blindTable.lobc_current_effect
    self.lobc_has_sold_joker = blindTable.lobc_has_sold_joker
    -- GasHarpoon
    self.p_sp = blindTable.p_sp
    self.b_sp = blindTable.b_sp
    self.ego = blindTable.ego
    self.in_panic = blindTable.in_panic
    self.skill_deck = blindTable.skill_deck
    self.shield_value = blindTable.shield_value
    -- Hatred
    self.hysteria = blindTable.hysteria
    self.transformed = blindTable.transformed
    self.alt_skill = blindTable.alt_skill
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

-- Blind cutscenes
function create_UIBox_ab_cutscene(pos)
    return 
    {n=G.UIT.ROOT, config = {align = 'cm', colour = G.C.CLEAR}, nodes={
        {n=G.UIT.C, config = {align = 'cm', colour = G.C.CLEAR}, nodes = {
            {n=G.UIT.R, config={align = "cm", colour = G.C.CLEAR, padding = 0.08}, nodes={
                {n=G.UIT.T, config={text = localize("k_lobc_ab_cutscene_"..pos.x.."_"..pos.y.."_1"), scale = 0.55, colour = G.C.WHITE, float = true}}
            }},
            {n=G.UIT.R, config={align = "cm", colour = G.C.CLEAR, padding = 0.08}, nodes={
                {n=G.UIT.T, config={text = localize("k_lobc_ab_cutscene_"..pos.x.."_"..pos.y.."_2"), scale = 0.55, colour = G.C.WHITE, float = true}}
            }},
            {n=G.UIT.R, config={align = "cm", colour = G.C.CLEAR, padding = 0.08}, nodes={
                {n=G.UIT.T, config={text = localize("k_lobc_ab_cutscene_"..pos.x.."_"..pos.y.."_3"), scale = 0.55, colour = G.C.WHITE, float = true}}
            }},
        }}
    }}
end

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
        G.lobc_cutscene.children.text = UIBox{
            definition = create_UIBox_ab_cutscene(pos),
            config = {
                align = "tm",
                offset = {
                    x = -1, y = 11.8
                },
                parent = G.lobc_cutscene
            }
        }
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
            }
        }
    end
end

-- Blind passive UI size
function current_mod.passive_ui_size()
    return G.GAME.blind.config.blind.key == "bl_lobc_erlking_heathcliff" and 7.5 or 6
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
                        play_sound('lobc_'..self.config.blind.lobc_color..'_start', 1, 0.3)
                        local hold_time = G.SETTINGS.GAMESPEED * 5
                        local loc_key = 'k_lobc_'..self.config.blind.lobc_time..'_'..self.config.blind.lobc_color
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
    if G.GAME.blind.config.blind.lobc_color then
        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = not config.disable_all_text and G.SETTINGS.GAMESPEED * 4 or 0,
            blockable = false,
            func = (function()
                if config.disable_all_text then return true end
                local hold_time = G.SETTINGS.GAMESPEED * 5
                local blind = G.GAME.blind
                local loc_key = 'k_lobc_'..blind.config.blind.lobc_time..'_'..blind.config.blind.lobc_color
                play_sound('lobc_'..blind.config.blind.lobc_color..'_end', 1, 0.3)
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

local play_cards_from_highlightedref = G.FUNCS.play_cards_from_highlighted
function G.FUNCS.play_cards_from_highlighted(e)
    play_cards_from_highlightedref(e)
    G.GAME.lobc_prepped = true
end

--=============== SKILLS ===============--
-- Used for Gasharpoon.

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
    no_mod_badges = true,
    inject = function(self)
		if not G.P_CENTER_POOLS[self.set] then
			G.P_CENTER_POOLS[self.set] = {}
		end
		SMODS.Center.inject(self)
	end,
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
    local skill = SMODS.load_file("items/skills/" .. v .. ".lua")()
    skill.key = v
    local skill_obj = SMODS.SkillLobc(skill)
end

-- Skill infobox shows to the right
local align_h_popupref = Card.align_h_popup
function Card.align_h_popup(self)
    local ret = align_h_popupref(self)
    local focused_ui = self.children.focused_ui and true or false
    if self.ability.set == "SkillLobc" then
        ret.offset.x = 0
        ret.offset.y = 0
        ret.type = "cr"
    end
    return ret
end