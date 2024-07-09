--- STEAMODDED HEADER
--- MOD_NAME: Lobotomy Corporation
--- MOD_ID: LobotomyCorp
--- PREFIX: lobc
--- MOD_AUTHOR: [Mysthaps]
--- MOD_DESCRIPTION: Face the Fear, Build the Future. Most art is from Lobotomy Corporation and Library of Ruina by Project Moon.
--- DISPLAY_NAME: L Corp.
--- BADGE_COLOR: FC3A3A
--- VERSION: 0.7.0

-- Talisman compat
to_big = to_big or function(num)
    return num
end

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
    "ordeals",
    "dark_days",
    "malkuth",
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
                local count = lobc_get_usage_count(card.config.center_key)
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
    if G.GAME.round_resets.blind_states.Small == 'Upcoming' or G.GAME.round_resets.blind_states.Small == 'Hide' then
        if G.GAME.round_resets.ante % 8 == 2 and G.GAME.round_resets.ante > 0 and
           (G.GAME.modifiers.lobc_ordeals or pseudorandom("dawn_ordeal") < 0.125) then
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
    if G.GAME.blind.config.blind.key == "bl_lobc_dusk_amber" and not G.GAME.blind.disabled then
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
                        chosen_card:set_debuff(true)
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
    if G.GAME.blind.config.blind.key == "bl_lobc_noon_indigo" and not G.GAME.blind.disabled then
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
       (G.GAME.blind.config.blind.color and G.GAME.blind.config.blind.color == "crimson") and
       not G.GAME.blind.disabled then
        local original_blind = G.GAME.blind.lobc_original_blind and G.GAME.blind.lobc_original_blind or G.GAME.blind.config.blind.key
        if G.GAME.blind.config.blind.time == "dawn" then
            if original_blind ~= "bl_lobc_dawn_crimson" then
                -- For Noon and Dusk, reset to the original blind's values
                G.GAME.blind:set_blind(G.P_BLINDS[original_blind])
                G.GAME.blind.chips = get_blind_amount(G.GAME.round_resets.ante)*0.8*G.GAME.starting_params.ante_scaling
                G.GAME.blind.lobc_original_blind = nil
            end
        else
            if G.GAME.current_round.hands_left == 0 then 
                -- Original hand count must be less than 2 (Noon) or 3 (Dusk)
                if G.GAME.current_round.hands_played < (G.P_BLINDS[original_blind].time == "dusk" and 3 or 2) and
                -- Must win blind
                   to_big(G.GAME.chips) >= to_big(G.GAME.blind.chips) then
                    ease_hands_played(1)
                    G.GAME.current_round.lobc_hands_given = G.GAME.current_round.lobc_hands_given + 1
                else
                    G.GAME.blind.lobc_original_blind = nil
                    G.STATE_COMPLETE = true
                    end_round()
                    return
                end
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

-- Reset hands for Crimson Dusk/Noon
local new_roundref = new_round
function new_round()
    new_roundref()
    G.GAME.current_round.lobc_hands_given = 0
end

-- Crimson Dawn selling card
local sell_cardref = Card.sell_card
function Card.sell_card(self)
    if self.ability.set == 'Joker' and G.GAME.blind and G.GAME.blind.config.blind.key == "bl_lobc_dawn_crimson"and not G.GAME.blind.disabled then 
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

-- Make Ordeals not end the game on win ante hopefully
local get_typeref = Blind.get_type
function Blind.get_type(self)
    if self.config.blind.color then
        return G.GAME.blind_on_deck
    end
    return get_typeref(self)
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

local can_sell_cardref = Card.can_sell_card
function Card.can_sell_card(self, context)
    -- Remove Queen of Hatred's sell button
    if self.ability and self.ability.extra and type(self.ability.extra) == 'table' and self.ability.extra.hysteria then
        return false
    end
    -- Malkuth
    if G.GAME.modifiers.lobc_malkuth and G.GAME.round_resets.ante > 6 then
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

--=============== CHALLENGES ===============--

-- Apply Modifiers to run
local start_runref = Game.start_run
function Game.start_run(self, args)
    start_runref(self, args)
    if not args.savetext then
        if G.GAME.modifiers.lobc_fast_ante_1 then G.GAME.modifiers.scaling = 2 end
        if G.GAME.modifiers.lobc_fast_ante_2 then G.GAME.modifiers.scaling = 3 end
    end
end

-- Cards flipped (Malkuth)
local card_initref = Card.init
function Card.init(self, X, Y, W, H, card, center, params)
    card_initref(self, X, Y, W, H, card, center, params)
    if G.GAME and G.GAME.modifiers.lobc_malkuth then
        if self.ability.consumeable or
           (self.ability.set == "Joker" and G.GAME.round_resets.ante > 3) then
            self.facing = 'back'
            self.sprite_facing = 'back'
            self.pinch.x = false
        end
    end
end

-- Card shuffle (Malkuth)
local ease_anteref = ease_ante
function ease_ante(mod)
    ease_anteref(mod)
    G.E_MANAGER:add_event(Event({
        trigger = "immediate",
        func = function()
            if G.GAME.modifiers.lobc_malkuth and G.GAME.round_resets.ante > 3 then
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
            return true
        end
    }))
end

-- Override flipping (Malkuth)
local card_flipref = Card.flip
function Card.flip(self)
    if G.GAME and G.GAME.modifiers.lobc_malkuth then
        if self.ability.consumeable or
           (self.ability.set == "Joker" and G.GAME.round_resets.ante > 3) then
            return
        end
    end
    card_flipref(self)
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
                        local hold_time = G.SETTINGS.GAMESPEED * 5
                        local loc_key = 'k_lobc_'..self.config.blind.time..'_'..self.config.blind.color
                        attention_text({scale = 0.3, text = localize(loc_key), hold = hold_time, align = 'cm', offset = { x = 0, y = -3.5 }, major = G.play, silent = true})
                        attention_text({scale = 1, text = localize(loc_key..'_name'), hold = hold_time, align = 'cm', offset = { x = 0, y = -2.5 }, major = G.play, silent = true})
                        attention_text({scale = 0.35, text = localize(loc_key..'_start_1'), hold = hold_time, align = 'cm', offset = { x = 0, y = -1 }, major = G.play, silent = true})
                        attention_text({scale = 0.35, text = localize(loc_key..'_start_2'), hold = hold_time, align = 'cm', offset = { x = 0, y = -0.6 }, major = G.play, silent = true})
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

--=============== OBSERVATION ===============--

function lobc_get_usage_count(key)
    return G.PROFILES[G.SETTINGS.profile].joker_usage[key] and G.PROFILES[G.SETTINGS.profile].joker_usage[key].count or 0
end

-- Check rounds until observation unlock
function Card:check_rounds(comp)
    local val = lobc_get_usage_count(self.config.center_key)
    return math.min(val, comp)
end

-- Card updates
local card_updateref = Card.update
function Card.update(self, dt)
    -- Check if enough rounds have passed, should be saving
    if self.config.center.abno then
        local count = lobc_get_usage_count(self.config.center_key)
        self.config.center.discovered = (count >= self.config.center.discover_rounds)
    end

    card_updateref(self, dt)

    -- Card flipped (Malkuth)
    if G.GAME and G.GAME.modifiers.lobc_malkuth then
        if self.ability.consumeable or
           (self.ability.set == "Joker" and G.GAME.round_resets.ante > 3) then
            self.facing = 'back'
            self.sprite_facing = 'back'
            self.pinch.x = false
        end
    end
end

-- Update round count for abnos
local set_joker_usageref = set_joker_usage
function set_joker_usage()
    set_joker_usageref()
    for k, v in pairs(G.jokers.cards) do
        if v.config.center_key and v.ability.set == 'Joker' and v.config.center.abno and not v.config.center.discovered and 
          lobc_get_usage_count(v.config.center_key) >= v.config.center.discover_rounds then
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

-- Make Extraction Pack
SMODS.Booster({
    key = 'extraction_normal',
    weight = 2.5,
    kind = "Abnormality",
    cost = 5,
    atlas = "LobotomyCorp_Booster",
    config = {extra = 3, choose = 1},
    create_card = function(self, card)
        return create_card("Abnormality", G.pack_cards, nil, nil, true, true, nil, 'abn')
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.PLANET_PACK)
    end,
    loc_vars = function(self, info_queue, card)
		return { vars = {card.config.center.config.choose, card.ability.extra} }
	end,
    group_key = "k_lobc_extraction_pack",
})

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

-- Shaders
--[[SMODS.Shader({
    key = "pixelation",
    path = "pixelation.fs"
})

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
-- shader test
local draw_shaderref = Sprite.draw_shader
function Sprite.draw_shader(self, _shader, _shadow_height, _send, _no_tilt, other_obj, ms, mr, mx, my, custom_shader, tilt_shadow)
    local check = true
    for _, v in ipairs(blacklist_atlas) do if self.atlas == G.ASSET_ATLAS[v] then check = false end end
    if self.atlas == G.ANIMATION_ATLAS["shop_sign"] then check = false end
    for _, v in ipairs(blacklist_shader) do if _shader == v then check = false end end
    draw_shaderref(self, _shader, _shadow_height, _send, _no_tilt, other_obj, ms, mr, mx, my, custom_shader, tilt_shadow)
    if check then draw_shaderref(self, "lobc_pixelation", _shadow_height, nil, nil, other_obj, ms, mr, mx, my) end
end

-- Load blank font
local set_languageref = Game.set_language
function Game.set_language(self)
    set_languageref(self)
    self.FONTS["lobc_blank"] = {
        file = "Mods/LobotomyCorp/assets/fonts/AdobeBlank.ttf", 
        render_scale = self.TILESIZE*10, 
        TEXT_HEIGHT_SCALE = 0.83, 
        TEXT_OFFSET = {x=10,y=-20}, 
        FONTSCALE = 0.1, 
        squish = 1, 
        DESCSCALE = 1,
        FONT = love.graphics.newFont("Mods/LobotomyCorp/assets/fonts/AdobeBlank.ttf", self.TILESIZE*10)
    }
    self.LANGUAGES["en-us"].font = self.FONTS[#self.FONTS]
end]]

-- Clear all Cathys
sendInfoMessage("Loaded LobotomyCorp~")