--- STEAMODDED HEADER
--- MOD_NAME: Lobotomy Corporation
--- MOD_ID: LobotomyCorp
--- PREFIX: lobc
--- MOD_AUTHOR: [Mysthaps]
--- MOD_DESCRIPTION: Face the Fear, Build the Future. Most art is from Lobotomy Corporation by Project Moon.
--- DISPLAY_NAME: L Corp.
--- BADGE_COLOR: FC3A3A
--- VERSION: 0.6.0

local mod_path = SMODS.current_mod.path
-- To disable a Joker, comment it out by adding -- at the start of the line.
local joker_list = {
    --- Common
    "one_sin",
    "theresia",
    "old_lady",
    "wall_gazer", -- The Lady Facing the Wall
    "plague_doctor",
    "punishing_bird",
    "shy_look",

    --- Uncommon
    "scorched_girl",
    "happy_teddy_bear",
    "red_shoes",
    "nameless_fetus",
    "iron_maiden", -- We Can Change Anything

    --- Rare
    "queen_of_hatred",
    "laetitia",
    "mosb",
    "servant_of_wrath",

    --- Legendary
    "whitenight",
}

local blind_list = {
    "whitenight"
}

local sound_list = {
    music_third_warning = "Emergency3",
    music_abno_choice = "AbnormalityChoice",
    mosb_upgrade = "Danggo_Lv2",
    old_lady_downgrade = "OldLady_effect01",
    plague_doctor_bell = "Lucifer_Bell0",
    punishing_bird_hit = "SmallBird_Hit",
    iron_maiden_tick = "Iron_Generate",
    iron_maiden_end = "Iron_End",
    nameless_cry = "nameless_cry",
}

-- Badge colors
local get_badge_colourref = get_badge_colour
function get_badge_colour(key)
    if key == 'lobc_gift' then return HEX("A0243A") end
    if key == 'lobc_blessed' then return HEX("380D36") end
    if key == 'lobc_blessed_wn' then return HEX("EDA9D3") end
    if key == 'lobc_zayin' then return HEX("1DF900") end
    if key == 'lobc_teth' then return HEX("13A2FF") end
    if key == 'lobc_he' then return HEX("FFF900") end
    if key == 'lobc_waw' then return HEX("7B2BF3") end
    if key == 'lobc_aleph' then return HEX("FF0000") end
    return get_badge_colourref(key)
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

    if not blind then
        sendErrorMessage("[LobotomyCorp] Cannot find blind with shorthand: " .. v)
    else
        blind.key = v
        blind.atlas = "LobotomyCorp_Blind"
        --blind.discovered = true

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

-- Make Extraction Pack
SMODS.Center({
    prefix = 'p',
    key = 'extraction_normal',
    name = "Extraction Pack",
    weight = 3,
    kind = "Abnormality",
    cost = 5,
    discovered = true,
    set = "Booster",
    atlas = "LobotomyCorp_Booster",
    config = {extra = 3, choose = 1},
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        local vars = { self.config.choose, self.config.extra }
        full_UI_table.name = localize{type = 'name', set = 'Other', key = self.key, nodes = full_UI_table.name}
        localize{type = 'other', key = self.key, nodes = desc_nodes, vars = vars}
    end
})

-- Clear all Cathys
sendInfoMessage("Loaded LobotomyCorp~")

---- Other functions ----

-- oops
local init_game_objectref = Game.init_game_object
function Game.init_game_object(self)
    local G = init_game_objectref(self)
    G.bosses_used["bl_lobc_whitenight"] = 1e300
    return G
end

-- Overwrite blind spawning for Abnormality Boss Blinds if requirements are met
local get_new_bossref = get_new_boss
function get_new_boss()
    if G.GAME.pool_flags["plague_doctor_breach"] and not G.GAME.pool_flags["whitenight_defeated"] then return "bl_lobc_whitenight" end
    return get_new_bossref()
    --return "bl_lobc_whitenight"
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

function SMODS.current_mod.set_debuff(card, should_debuff)
    if card.ability then
        -- Scorched Girl's debuff first hand drawn
        if card.ability.scorched_girl_debuff then
            card.debuff = true
            return true
        end
    end
    return nil
end

-- Wall Gazer face down
local stay_flippedref = Blind.stay_flipped
function Blind.stay_flipped(self, area, card)
    if area == G.hand and next(SMODS.find_card("j_lobc_wall_gazer")) and G.GAME.current_round.hands_played == 0 then
        return true
    end
    return stay_flippedref(self, area, card_updateref)
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
                        play_sound('lobc_old_lady_downgrade', 1, 0.7)
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

-- WhiteNight confession win round
local alert_debuffref = Blind.alert_debuff
function Blind.alert_debuff(self, first)
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
        alert_debuffref(self, first)
    end
end

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

        if add then
           _pool[#_pool+1] = v.key
        end
    end

    for k,v in pairs(_pool) do
        _pool_size = _pool_size + 1
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
    if G.pack_cards and G.pack_cards.cards[1] and G.STATE == G.STATES.EXTRACTION_PACK then
        e.config.colour = G.C.GREY
        e.config.button = 'skip_booster'
    else
        can_skip_boosterref(e)
    end
end
