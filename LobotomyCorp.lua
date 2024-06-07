--- STEAMODDED HEADER
--- MOD_NAME: Lobotomy Corporation
--- MOD_ID: LobotomyCorp
--- PREFIX: lobc
--- MOD_AUTHOR: [Mysthaps]
--- MOD_DESCRIPTION: Face The Fear, Build The Future. Most art is from Lobotomy Corporation by Project Moon.
--- DISPLAY_NAME: Lobotomy Corp.
--- BADGE_COLOR: FC3A3A
--- VERSION: 0.1.1

-- To disable a Joker, comment it out by adding -- at the start of the line.
local joker_list = {
    --- Common
    "theresia",
    "punishing_bird",

    --- Uncommon
    "scorched_girl",
    "red_shoes", -- this shit is fucking broken lmaooo

    --- Rare
    "queen_of_hatred",
    "mosb",

    --- ???
}

local mod_path = SMODS.current_mod.path
SMODS.Atlas({ 
    key = "LobotomyCorp_Jokers", 
    atlas_table = "ASSET_ATLAS", 
    path = "LobotomyCorp_spritesheet.png", 
    px = 71, 
    py = 95 
})

SMODS.Atlas({
    key = "modicon",
    path = "LobotomyCorp_icon.png",
    px = 34,
    py = 34
}):register()

-- Load localization
function SMODS.current_mod.process_loc_text()
    SMODS.process_loc_text(G.localization.descriptions.Other, "lobc_hysteria", {
        name = "Hysteria",
        text = {
            "This Abnormality",
            "loses {X:red,C:white} X0.5 {} Mult",
            "after each blind",
            "and cannot be sold",
        }
    })
    SMODS.process_loc_text(G.localization.misc.dictionary, "k_lobc_breached", "Breached!")
end

for _, v in ipairs(joker_list) do
    local joker = NFS.load(mod_path .. "indiv_jokers/" .. v .. ".lua")()

    if not joker then
        sendErrorMessage("[LobotomyCorp] Cannot find joker with shorthand: " .. v)
    else
        --joker.discovered = true
        joker.key = v
        joker.atlas = "LobotomyCorp_Jokers"
        --joker.yes_pool_flag = "allow_abnormalities_in_shop"
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

        joker_obj.set_sprites = function(self, card, front)
            card.children.center.atlas = G.ASSET_ATLAS["lobc_LobotomyCorp_Jokers"]
            local count = G.PROFILES[G.SETTINGS.profile].joker_usage[card.config.center_key] and G.PROFILES[G.SETTINGS.profile].joker_usage[card.config.center_key].count or 0
            if count < card.config.center.discover_rounds then
                card.children.center:set_sprite_pos({x = 0, y = 0})
            else
                card.children.center:set_sprite_pos(card.config.center.pos)
            end
        end
    end
end

sendInfoMessage("Loaded LobotomyCorp~")

---- Other functions ----

-- find_joker but keys
local function find_joker_with_key(key, non_debuff)
    local jokers = {}
    if not G.jokers or not G.jokers.cards then return {} end
    for _, v in pairs(G.jokers.cards) do
        if v and type(v) == 'table' and v.config.center.key == key and (non_debuff or not v.debuff) then
            table.insert(jokers, v)
        end
    end
    for _, v in pairs(G.consumeables.cards) do
        if v and type(v) == 'table' and v.config.center.key == key and (non_debuff or not v.debuff) then
            table.insert(jokers, v)
        end
    end
    return jokers
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
        if v.config.center_key and v.ability.set == 'Joker' and v.config.center.abno and 
          G.PROFILES[G.SETTINGS.profile].joker_usage[v.config.center_key].count == v.config.center.discover_rounds then
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

-- Remove Queen of Hatred's sell button
local can_sell_cardref = Card.can_sell_card
function Card.can_sell_card(self, context)
    if self.ability and self.ability.extra and type(self.ability.extra) == 'table' and self.ability.extra.hysteria then
        return false
    end
    return can_sell_cardref(self, context)
end