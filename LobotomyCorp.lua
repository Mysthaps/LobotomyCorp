--- STEAMODDED HEADER
--- MOD_NAME: Lobotomy Corporation
--- MOD_ID: LobotomyCorp
--- PREFIX: lobc
--- MOD_AUTHOR: [Mysthaps]
--- MOD_DESCRIPTION: Face the Fear, Build the Future. Most art is from Lobotomy Corporation and Library of Ruina by Project Moon.
--- DISPLAY_NAME: L Corp.
--- BADGE_COLOR: FC3A3A
--- VERSION: 0.7.0

local mod_path = SMODS.current_mod.path

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
    "shy_look",
    "iron_maiden", -- We Can Change Anything
    "youre_bald",

    --- Uncommon
    "scorched_girl",
    "happy_teddy_bear",
    "red_shoes",
    "nameless_fetus",
    "all_around_helper",

    --- Rare
    --[[
        Nothing There is commented out because while technically it works,
        it will not calculate other effects until the better_calc branch is merged.
        Until then, the secondary effect of Nothing There will not be implemented
    ]]--
    "queen_of_hatred",
    --"nothing_there",
    "price_of_silence",
    "laetitia",
    "mosb",
    "servant_of_wrath",

    --- Legendary
    "whitenight",
}

local blind_list = {
    -- Abnormalities
    "whitenight",

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
}

local sound_list = {
    music_first_warning = "Emergency1",
    music_second_warning = "Emergency2",
    music_third_warning = "Emergency3",
    music_abno_choice = "AbnormalityChoice",

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
    "dark_days"
}

local badge_colors = {
    lobc_gift = HEX("A0243A"),
    lobc_blessed = HEX("380D36"),
    lobc_blessed_wn = HEX("EDA9D3"),
    lobc_apostle = HEX("FF0000"),
    lobc_amplified = HEX("004d00"),
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
}
-- Badge colors
local get_badge_colourref = get_badge_colour
function get_badge_colour(key)
    return badge_colors[key] or get_badge_colourref(key)
end

-- Load all jokers
for _, v in ipairs(joker_list) do
    local joker = NFS.load(mod_path .. "indiv_jokers/" .. v .. ".lua")()

    if not joker then
        sendErrorMessage("[LobotomyCorp] Cannot find joker with shorthand: " .. v)
    else
        --joker.discovered = true
        joker.key = v
        joker.atlas = "LobotomyCorp_Jokers"
        --[[
        if not joker.yes_pool_flag then
            joker.yes_pool_flag = "allow_abnormalities_in_shop"
        end
        ]]--
        --joker.config.discover_rounds = 0
        
        if not joker.pos then
            joker.pos = {x = 0, y = 0}
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
                local count = G.PROFILES[G.SETTINGS.profile].joker_usage[card.config.center_key] and G.PROFILES[G.SETTINGS.profile].joker_usage[card.config.center_key].count or 0
                if count < card.config.center.discover_rounds then
                    card.children.center.atlas = G.ASSET_ATLAS["lobc_LobotomyCorp_Undiscovered"]
                end
                card.children.center:set_sprite_pos(card.config.center.pos)
            end
        end

        if joker.risk then
            joker_obj.set_badges = function(self, card, badges)
                local color = nil
                if joker.risk == "he" or joker.risk == "zayin" then color = G.C.UI.TEXT_DARK end
                badges[#badges+1] = create_badge(localize("lobc_"..joker.risk, "labels"), get_badge_colour("lobc_"..joker.risk), color)
            end
        end
    end
end

-- Load all blinds
for _, v in ipairs(blind_list) do
    local blind = NFS.load(mod_path .. "indiv_blinds/" .. v .. ".lua")()

    if not blind --[[or v ~= "whitenight"]] then
        sendErrorMessage("[LobotomyCorp] Cannot find blind with shorthand: " .. v)
    else
        blind.key = v
        blind.atlas = "LobotomyCorp_Blind"
        --blind.discovered = true
        if blind.color then
            blind.boss_colour = badge_colors["lobc_"..blind.color]
        end

        local blind_obj = SMODS.Blind(blind)

        for k_, v_ in pairs(blind) do
            if type(v_) == 'function' then
                blind_obj[k_] = blind[k_]
            end
        end
    end
end

-- Load all sounds
for k, v in pairs(sound_list) do
    SMODS.Sound({
        key = k,
        path = v..".ogg"
    })
end

-- Load challenges
for _, v in ipairs(challenge_list) do
    local chal = NFS.load(mod_path .. "challenges/" .. v .. ".lua")()

    if not chal then
        sendErrorMessage("[LobotomyCorp] Cannot find challenge with shorthand: " .. v)
    else
        chal.key = v
        chal.loc_txt = ""
        local chal_obj = SMODS.Challenge(chal)
    end
end

-- Make Extraction Pack
SMODS.Center({
    prefix = 'p',
    key = 'extraction_normal',
    name = "Extraction Pack",
    weight = 3,
    kind = "Abnormality",
    cost = 5,
    discovered = true,
    alerted = true,
    set = "Booster",
    atlas = "LobotomyCorp_Booster",
    config = {extra = 3, choose = 1},
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        local vars = { self.config.choose, self.config.extra }
        full_UI_table.name = localize{type = 'name', set = 'Other', key = self.key, nodes = full_UI_table.name}
        localize{type = 'other', key = self.key, nodes = desc_nodes, vars = vars}
    end
})

--=============== BLINDS ===============--
-- Overwrite blind spawning for Abnormality Boss Blinds if requirements are met
local get_new_bossref = get_new_boss
function get_new_boss()
    if G.GAME.modifiers.lobc_all_whitenight or 
    (G.GAME.pool_flags["plague_doctor_breach"] and not G.GAME.pool_flags["whitenight_defeated"]) then return "bl_lobc_whitenight" end
    return get_new_bossref()
    --return "bl_lobc_dusk_crimson"
end

-- Overwrite blind select for Ordeals
local reset_blindsref = reset_blinds
function reset_blinds()
    reset_blindsref()
    if G.GAME.round_resets.blind_states.Small == 'Upcoming' then
        if G.GAME.round_resets.ante % 8 == 2 and G.GAME.round_resets.ante > 0 then
            if G.GAME.modifiers.lobc_ordeals or pseudorandom("dawn_ordeal") < 0.125 then
                G.GAME.round_resets.blind_choices.Small = 'bl_lobc_dawn_base'
            else
                G.GAME.round_resets.blind_choices.Small = 'bl_small'
            end
        end

        if G.GAME.round_resets.ante % 8 == 4 and G.GAME.round_resets.ante > 0 then
            if G.GAME.modifiers.lobc_ordeals or pseudorandom("noon_ordeal") < 0.125 then
                G.GAME.round_resets.blind_choices.Big = 'bl_lobc_noon_base'
            else
                G.GAME.round_resets.blind_choices.Big = 'bl_big'
            end
        end

        -- don't overwrite whitenight
        if G.GAME.round_resets.blind_choices.Boss == "bl_lobc_whitenight" then return end

        if G.GAME.round_resets.ante % 8 == 6 and G.GAME.round_resets.ante > 0 then
            if G.GAME.modifiers.lobc_ordeals or pseudorandom("dusk_ordeal") < 0.125 then
                G.GAME.bosses_used[G.GAME.round_resets.blind_choices.Boss] = G.GAME.bosses_used[G.GAME.round_resets.blind_choices.Boss] - 1
                G.GAME.round_resets.blind_choices.Boss = 'bl_lobc_dusk_base'
            end
        end

        if G.GAME.round_resets.ante % 8 == 0 and G.GAME.round_resets.ante > 0 then
            if G.GAME.modifiers.lobc_ordeals or pseudorandom("midnight_ordeal") < 0.125 then
                G.GAME.bosses_used[G.GAME.round_resets.blind_choices.Boss] = G.GAME.bosses_used[G.GAME.round_resets.blind_choices.Boss] - 1
                G.GAME.round_resets.blind_choices.Boss = 'bl_lobc_midnight_base'
            end
        end
    end
end

-- Make Lobcorp blinds unable to spawn normally
local init_game_objectref = Game.init_game_object
function Game.init_game_object(self)
    local G = init_game_objectref(self)
    for _, v in ipairs(blind_list) do
        G.bosses_used["bl_lobc_"..v] = 1e300
    end
    return G
end

-- Ordeals
local set_blindref = Blind.set_blind
function Blind.set_blind(self, blind, reset, silent)
    if blind and blind.color and blind.color == "base" then
        local chosen_blind = pseudorandom_element(blind.blind_list, pseudoseed("dusk_ordeal"))
        return set_blindref(self, G.P_BLINDS['bl_lobc_'..chosen_blind], reset, silent)
    end
    return set_blindref(self, blind, reset, silent)
end

-- Amber Dusk's debuff per card drawn
local draw_from_deck_to_handref = G.FUNCS.draw_from_deck_to_hand
function G.FUNCS.draw_from_deck_to_hand(e)
    draw_from_deck_to_handref(e)
    if G.GAME.blind.config.blind.key == "bl_lobc_dusk_amber" then
        local cards_drawn = e or math.min(#G.deck.cards, G.hand.config.card_limit - #G.hand.cards)
        local available_cards = {}
        local proc = false

        for _, v in ipairs(G.hand.cards) do
            if not v.ability.amber_debuff then available_cards[#available_cards+1] = v end
        end
        for _, v in ipairs(G.deck.cards) do
            if not v.ability.amber_debuff then available_cards[#available_cards+1] = v end
        end

        for i = 1, cards_drawn do
            if #available_cards > 0 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function() 
                        local chosen_card, chosen_card_key = pseudorandom_element(available_cards, pseudoseed("dusk_amber"))
                        chosen_card.debuff = true
                        chosen_card.ability.amber_debuff = true
                        table.remove(available_cards, chosen_card_key)
                        proc = true
                        return true
                    end 
                }))
            end
        end

        if proc then G.GAME.blind:wiggle() end
    end
end

-- Indigo Noon
local discard_cards_from_highlightedref = G.FUNCS.discard_cards_from_highlighted
G.FUNCS.discard_cards_from_highlighted = function(e, hook)
    if G.GAME.blind.config.blind.key == "bl_lobc_noon_indigo" then
        local proc = false
        for _ = 1, math.min(#G.hand.highlighted, G.discard.config.card_limit - #G.play.cards) do
            local chips = get_blind_amount(G.GAME.round_resets.ante)*G.GAME.starting_params.ante_scaling*0.1
            if type(chips) == 'table' then chips:ceil() else chips = math.ceil(chips) end
            G.GAME.blind.chips = G.GAME.blind.chips + chips
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips)
            G.HUD_blind:recalculate() 
            G.hand_text_area.blind_chips:juice_up()
            proc = true
        end
        if proc then G.GAME.blind:wiggle() end
    end
    discard_cards_from_highlightedref(e, hook)
end

-- Crimson Noon and Crimson Dusk switching to lower tier
local update_new_roundref = Game.update_new_round
function Game.update_new_round(self, dt)
    if self.buttons then self.buttons:remove(); self.buttons = nil end
    if self.shop then self.shop:remove(); self.shop = nil end

    if not G.STATE_COMPLETE and 
    (G.GAME.blind.config.blind.color and G.GAME.blind.config.blind.color == "crimson") then
        local original_blind = G.GAME.blind.lobc_original_blind and G.GAME.blind.lobc_original_blind or G.GAME.blind.config.blind.key
        sendDebugMessage(original_blind)
        if G.GAME.blind.config.blind.time == "dawn" then
            if original_blind ~= "bl_lobc_dawn_crimson" then
                -- For Noon and Dusk, reset to the original blind's values
                G.GAME.blind:set_blind(G.P_BLINDS[original_blind])
                G.GAME.blind.chips = get_blind_amount(G.GAME.round_resets.ante)*0.8*G.GAME.starting_params.ante_scaling
                G.GAME.blind.lobc_original_blind = nil
            end
        else
            G.STATE = G.STATES.DRAW_TO_HAND
            G.E_MANAGER:add_event(Event({
                trigger = 'ease',
                blocking = false,
                ref_table = G.GAME,
                ref_value = 'chips',
                ease_to = 0,
                delay = 0.5,
                func = (function(t) return math.floor(t) end)
            }))
            G.GAME.blind:set_blind(G.P_BLINDS["bl_lobc_"..(G.GAME.blind.config.blind.time == "dusk" and "noon" or "dawn").."_crimson"])
            G.GAME.blind.dollars = G.P_BLINDS[original_blind].dollars
            G.GAME.current_round.dollars_to_be_earned = G.GAME.blind.dollars > 0 and (string.rep(localize('$'), G.GAME.blind.dollars)..'') or ('')
            G.GAME.blind.lobc_original_blind = original_blind
        end
    end

    if G.STATE ~= G.STATES.DRAW_TO_HAND then
        update_new_roundref(self, dt)
    end
end

-- Crimson Dusk selling card
local sell_cardref = Card.sell_card
function Card.sell_card(self)
    if self.ability.set == 'Joker' and G.GAME.blind and G.GAME.blind.config.blind.key == "bl_lobc_dawn_crimson" then 
        G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
            G.GAME.blind.hands_sub = 0
            for _, v in ipairs(G.playing_cards) do
                v:set_debuff(false)
            end
            return true
        end}))
    end
    sell_cardref(self)
end

-- WhiteNight confession win round
local alert_debuffref = Blind.alert_debuff
function Blind.alert_debuff(self, first)
    if self.config.blind.color and self.config.blind.color == "base" then return end
    if self.config.blind.key == "bl_lobc_whitenight" and next(SMODS.find_card("j_lobc_one_sin")) then
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
        if self.config.blind.color then
            self:ordeal_alert()
        else 
            alert_debuffref(self, first) 
        end
    end
end

--=============== JOKERS ===============--

-- Wall Gazer face down
local stay_flippedref = Blind.stay_flipped
function Blind.stay_flipped(self, area, card)
    if area == G.hand and next(SMODS.find_card("j_lobc_wall_gazer")) and G.GAME.current_round.hands_played == 0 then
        return true
    end
    return stay_flippedref(self, area, card)
end

-- Remove Queen of Hatred's sell button
local can_sell_cardref = Card.can_sell_card
function Card.can_sell_card(self, context)
    if self.ability and self.ability.extra and type(self.ability.extra) == 'table' and self.ability.extra.hysteria then
        return false
    end
    return can_sell_cardref(self, context)
end

-- Check for Old Lady's bullshit
local add_to_deckref = Card.add_to_deck
function Card.add_to_deck(self, from_debuff)
    if not self.added_to_deck and self.ability.set == "Joker" then
        for _, v in ipairs(SMODS.find_card("j_lobc_old_lady")) do
            if self ~= v then
                v.ability.extra.mult = v.ability.extra.mult - v.ability.extra.loss
                card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize('k_lobc_downgrade')})
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('lobc_old_lady_downgrade', 1, 0.6)
                        return true
                    end
                }))
            end
        end
    end
    add_to_deckref(self, from_debuff)
end

-- Today's Shy Look's sprite thing
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
    sprite_drawref(self, overlay)
end

-- You're Bald...
local set_spritesref = Card.set_sprites
function Card.set_sprites(self, _center, _front)
    set_spritesref(self, _center, _front)
    if next(SMODS.find_card("j_lobc_youre_bald")) then
        if _center and _center.set == "Joker" and self.children.center.atlas == G.ASSET_ATLAS["Joker"] then
            self.children.center.atlas = G.ASSET_ATLAS["lobc_LobotomyCorp_jokersbald"]
            self.children.center:set_sprite_pos(_center.pos)
        end
    end
end

-- The Price of Silence amplification
local amplified_values = {
    "mult",
    "h_mult",
    "h_x_mult",
    "h_chips",
    "h_dollars",
    "p_dollars",
    "t_mult",
    "t_chips",
    "x_mult",
    "h_size",
    "d_size",
    "bonus",
}
function Card:lobc_check_amplified()
    if self.ability.price_of_silence_amplified then
        for _, v in ipairs(amplified_values) do
            if self.ability[v] and self.config.center.config[v] then
                self.ability[v] = self.ability[v] + self.config.center.config[v]
            end
        end
        -- glass card moment
        if self.ability.x_mult and self.config.center.config.Xmult then
            self.ability.x_mult = self.ability.x_mult + self.config.center.config.Xmult
        end
    end
end

--=============== MECHANICAL ===============--

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

-- Debuffing effects
local should_debuff_ability = {
    "scorched_girl_debuff",
    "theresia_debuff",
}
function SMODS.current_mod.set_debuff(card, should_debuff)
    if card.ability then
        for _, v in ipairs(should_debuff_ability) do
            if card.ability[v] then 
                card.debuff = true 
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
                        play_sound('lobc_'..self.config.blind.color..'_start', 1, 0.5)
                        local hold_time = G.SETTINGS.GAMESPEED * 6
                        local loc_key = 'k_lobc_'..self.config.blind.time..'_'..self.config.blind.color
                        attention_text({scale = 0.3, text = localize(loc_key), hold = hold_time, align = 'cm', offset = { x = 0, y = -3.5 }, major = G.play, silent = true})
                        attention_text({scale = 1, text = localize(loc_key..'_name'), hold = hold_time, align = 'cm', offset = { x = 0, y = -2.5 }, major = G.play, silent = true})
                        attention_text({scale = 0.35, text = localize(loc_key..'_start_1'), hold = hold_time, align = 'cm', offset = { x = 0, y = -1 }, major = G.play, silent = true})
                        attention_text({scale = 0.35, text = localize(loc_key..'_start_2'), hold = hold_time, align = 'cm', offset = { x = 0, y = -0.6 }, major = G.play, silent = true})
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = hold_time/3,
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
            delay = G.SETTINGS.GAMESPEED * 5,
            blockable = false,
            func = (function()
                local hold_time = G.SETTINGS.GAMESPEED * 6
                local blind = G.GAME.blind
                local loc_key = 'k_lobc_'..blind.config.blind.time..'_'..blind.config.blind.color
                play_sound('lobc_'..blind.config.blind.color..'_end', 1, 0.5)
                attention_text({scale = 0.3, text = localize(loc_key), hold = hold_time, align = 'cm', offset = { x = 0, y = -3.5 }, major = G.play, silent = true})
                attention_text({scale = 1, text = localize(loc_key..'_name'), hold = hold_time, align = 'cm', offset = { x = 0, y = -2.5 }, major = G.play, silent = true})
                attention_text({scale = 0.35, text = localize(loc_key..'_end_1'), hold = hold_time, align = 'cm', offset = { x = 0, y = -1 }, major = G.play, silent = true})
                attention_text({scale = 0.35, text = localize(loc_key..'_end_2'), hold = hold_time, align = 'cm', offset = { x = 0, y = -0.6 }, major = G.play, silent = true})
                return true
            end)
        }))
    end
    draw_from_hand_to_discardref(e)
end

-- Talisman compat
to_big = to_big or function(num)
    return num
end

--=============== OBSERVATION ===============--

-- Check rounds until observation unlock
function Card:check_rounds(comp)
    local val = G.PROFILES[G.SETTINGS.profile].joker_usage[self.config.center_key] and G.PROFILES[G.SETTINGS.profile].joker_usage[self.config.center_key].count or 0
    return math.min(val, comp)
end

-- Card updates
local card_updateref = Card.update
function Card.update(self, dt)
    if G.STAGE == G.STAGES.RUN then
        -- Check if enough rounds have passed, should be saving
        if self.config.center.abno then
            local count = G.PROFILES[G.SETTINGS.profile].joker_usage[self.config.center_key] and G.PROFILES[G.SETTINGS.profile].joker_usage[self.config.center_key].count or 0
            self.config.center.discovered = (count >= self.config.center.discover_rounds)
        end
    end
    card_updateref(self, dt)
end

-- Update round count for abnos
local set_joker_usageref = set_joker_usage
function set_joker_usage()
    set_joker_usageref()
    for k, v in pairs(G.jokers.cards) do
        if v.config.center_key and v.ability.set == 'Joker' and v.config.center.abno and not v.config.center.discovered and 
          G.PROFILES[G.SETTINGS.profile].joker_usage[v.config.center_key].count >= v.config.center.discover_rounds then
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
        _pool[#_pool + 1] = "j_lobc_punishing_bird" -- teehee
    end

    return _pool, _pool_key..G.GAME.round_resets.ante
end

local get_current_poolref = get_current_pool
function get_current_pool(_type, _rarity, _legendary, _append)
    if _type == "Abnormality" then return get_abno_pool(_type, _rarity, _legendary, _append) end
    return get_current_poolref(_type, _rarity, _legendary, _append)
end

-- Open Extraction Pack
local openref = Card.open
function Card.open(self)
    if self.ability.set == "Booster" and self.ability.name:find('Extraction') then
        stop_use()
        G.STATE_COMPLETE = false 
        self.opening = true

        if not self.config.center.discovered then
            discover_card(self.config.center)
        end
        self.states.hover.can = false

        if not G.STATES.EXTRACTION_PACK then
            G.STATES.EXTRACTION_PACK = 727
        end

        G.STATE = G.STATES.EXTRACTION_PACK
        G.GAME.pack_size = self.ability.extra

        G.GAME.pack_choices = self.config.center.config.choose or 1
        -- Cryptid compat
        if G.GAME.modifiers.cry_misprint_min then
            G.GAME.pack_size = self.config.center.config.extra
            if G.GAME.pack_size < 1 then G.GAME.pack_size = 1 end
            self.ability.extra = G.GAME.pack_size
            G.GAME.pack_choices = math.min(math.floor(G.GAME.pack_size), G.GAME.pack_choices)
        end

        if self.cost > 0 then 
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
                inc_career_stat('c_shop_dollars_spent', self.cost)
                self:juice_up()
            return true end }))
            ease_dollars(-self.cost) 
        else
            delay(0.2)
        end

        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            self:explode()
            local pack_cards = {}

            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 1.3*math.sqrt(G.SETTINGS.GAMESPEED), blockable = false, blocking = false, func = function()
                local _size = self.ability.extra
                
                for i = 1, _size do
                    local card = create_card("Abnormality", G.pack_cards, nil, nil, true, true, nil, 'abn')
                    card.T.x = self.T.x
                    card.T.y = self.T.y
                    card:start_materialize({G.C.WHITE, G.C.WHITE}, nil, 1.5*G.SETTINGS.GAMESPEED)
                    pack_cards[i] = card
                end
                return true
            end}))

            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 1.3*math.sqrt(G.SETTINGS.GAMESPEED), blockable = false, blocking = false, func = function()
                if G.pack_cards then 
                    if G.pack_cards and G.pack_cards.VT.y < G.ROOM.T.h then 
                    for k, v in ipairs(pack_cards) do
                        G.pack_cards:emplace(v)
                    end
                    return true
                    end
                end
            end}))

            for i = 1, #G.jokers.cards do
                G.jokers.cards[i]:calculate_joker({open_booster = true, card = self})
            end

            if G.GAME.modifiers.inflation then 
                G.GAME.inflation = G.GAME.inflation + 1
                G.E_MANAGER:add_event(Event({func = function()
                    for k, v in pairs(G.I.CARD) do
                        if v.set_cost then v:set_cost() end
                    end
                return true end }))
            end
        return true end }))
    else
        openref(self)
    end
end

-- Setup Extraction Pack background
function Game:update_extraction_pack(dt)
    if self.buttons then self.buttons:remove(); self.buttons = nil end
    if self.shop then G.shop.alignment.offset.y = G.ROOM.T.y+11 end

    if not G.STATE_COMPLETE then
        G.STATE_COMPLETE = true
        G.CONTROLLER.interrupt.focus = true
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                G.booster_pack = UIBox{
                    definition = create_UIBox_extraction_pack(),
                    config = {align="tmi", offset = {x=0,y=G.ROOM.T.y + 9},major = G.hand, bond = 'Weak'}
                }
                G.booster_pack.alignment.offset.y = -2.2
                G.ROOM.jiggle = G.ROOM.jiggle + 3
                ease_background_colour_blind(G.STATES.PLANET_PACK)
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.5,
                            func = function()
                                G.CONTROLLER:recall_cardarea_focus('pack_cards')
                                return true
                            end}))
                        return true
                    end
                }))  
                return true
            end
        }))  
    end
end

-- Setup Extraction Pack UI
function create_UIBox_extraction_pack()
    local _size = G.GAME.pack_size
    G.pack_cards = CardArea(
      G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
      math.max(1,math.min(_size,5))*G.CARD_W*1.1,
      1.05*G.CARD_H, 
      {card_limit = _size, type = 'consumeable', highlight_limit = 1})
  
      local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
        {n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
          {n=G.UIT.R, config={align = "cm"}, nodes={
          {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
            {n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
              {n=G.UIT.O, config={object = G.pack_cards}},
            }}
          }}
        }},
        {n=G.UIT.R, config={align = "cm"}, nodes={
        }},
        {n=G.UIT.R, config={align = "tm"}, nodes={
          {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
          {n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
          UIBox_dyn_container({
            {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
              {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                {n=G.UIT.O, config={object = DynaText({string = localize('k_lobc_extraction_pack'), colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}
              }},
              {n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
                {n=G.UIT.O, config={object = DynaText({string = {localize('k_choose')..' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
                {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}
              }},
            }}
          }),
        }},
          {n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
            {n=G.UIT.R,config={minh =0.2}, nodes={}},
            {n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
              {n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}
            }}
          }}
        }}
      }}
    }}
    return t
end

local can_skip_boosterref = G.FUNCS.can_skip_booster
function G.FUNCS.can_skip_booster(e)
    if G.pack_cards and G.pack_cards.cards and G.pack_cards.cards[1] and G.STATE == G.STATES.EXTRACTION_PACK then
        e.config.colour = G.C.GREY
        e.config.button = 'skip_booster'
    else
        can_skip_boosterref(e)
    end
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

-- Clear all Cathys
sendInfoMessage("Loaded LobotomyCorp~")