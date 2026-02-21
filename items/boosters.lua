-- Get Abnormality pool
-- Implementation somewhat borrowed from Sylvie's Sillyness and based on get_current_pool()
local function get_abno_pool(_type, _rarity, legendary, key_append)
    --create the pool
    G.ARGS.TEMP_POOL = EMPTY(G.ARGS.TEMP_POOL)
    local _pool, _starting_pool, _pool_key, _pool_size = G.ARGS.TEMP_POOL, {}, 'Abnormality'..(_rarity or ''), 0

    if #_starting_pool == 0 then
        for _, v in pairs(G.P_CENTERS) do
            if v.abno and ((_rarity and v.risk == string.lower(_rarity)) or not _rarity) then 
                _starting_pool[#_starting_pool+1] = v
            end
        end
    end

    --cull the pool
    for k, v in ipairs(_starting_pool) do
        local add = true
        
        if G.GAME.used_jokers[v.key] and not SMODS.showman(v.key) then
            add = false
        end

        if v.yes_pool_flag and v.yes_pool_flag ~= "allow_abnormalities_in_shop" 
           and not G.GAME.pool_flags[v.yes_pool_flag] then 
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
        _pool[#_pool + 1] = "j_lobc_youre_bald"
    end

    return _pool, _pool_key..G.GAME.round_resets.ante
end

local get_current_poolref = get_current_pool
function get_current_pool(_type, _rarity, _legendary, _append)
    if _type == "Abnormality" then return get_abno_pool(_type, _rarity, _legendary, _append) end
    if _append == "lobc_rudolta" then _rarity = ({"Common", "Uncommon", "Rare", "Legendary"})[_rarity] or _rarity end
    return get_current_poolref(_type, _rarity, _legendary, _append)
end

local ExtractionPack = SMODS.Booster:extend({
    kind = "Abnormality",
    atlas = "lobc_LobotomyCorp_Booster",
    create_card = function(self, card)
        G.GAME.current_round.lobc_extraction = "USED"
        local _card
        -- Taken from poll_edition from overrides.lua @ SMODS
        local edition_poll = pseudorandom(pseudoseed(self.key))

        -- Calculate total weight (usually 100)
        local total_weight = 0
        for _, v in ipairs(card.config.center.config.risk) do
            total_weight = total_weight + v
        end

        local weight_i = 0
        for k, v in ipairs(card.config.center.config.risk) do
            weight_i = weight_i + v * G.GAME.lobc_risk_modifier[k]
            if edition_poll > 1 - (weight_i) / total_weight then
                _card = SMODS.create_card { set = 'Abnormality', area = G.pack_cards, rarity = ({"ZAYIN", "TETH", "HE", "WAW", "ALEPH"})[k], skip_materialize = true, soulable = true, key_append = 'abn' }
                if self.config.elite then
                    _card:set_edition('e_negative')
                    if not G.GAME.modifiers.lobc_production then
                        for _ = 1, pseudorandom("elite_sticker_count", 1, 3) do
                            local sticker = pseudorandom_element(SMODS.Stickers, pseudoseed("elite_sticker")).key
                            if not card.ability[sticker] then
                                _card:add_sticker(sticker, true)
                            end
                        end
                    end
                end
                return _card
            end
        end

        -- Default return
        sendErrorMessage("Something went wrong with generating Abnormalities, falling back to default", "LobotomyCorp")
        return { set = 'Abnormality', area = G.pack_cards, skip_materialize = true, soulable = true, key_append = 'abn' }
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.PLANET_PACK)
    end,
    loc_vars = function(self, info_queue, card)
        local total_weight = 0
        local shown_risk = {}
        for _, v in ipairs(card.config.center.config.risk) do
            total_weight = total_weight + v
        end
        for k, v in ipairs(card.config.center.config.risk) do
            shown_risk[k] = (v * (G.GAME.lobc_risk_modifier and G.GAME.lobc_risk_modifier[k] or 1)) / total_weight * 100
        end
		return { 
            vars = {
                card.config.center.config.choose, card.ability.extra,
                shown_risk[1], 
                shown_risk[2], 
                shown_risk[3], 
                shown_risk[4], 
                shown_risk[5],
                colours = {
                    (shown_risk[1] > 0 and G.C.FILTER or G.C.UI.TEXT_DARK),
                    (shown_risk[2] > 0 and G.C.FILTER or G.C.UI.TEXT_DARK),
                    (shown_risk[3] > 0 and G.C.FILTER or G.C.UI.TEXT_DARK),
                    (shown_risk[4] > 0 and G.C.FILTER or G.C.UI.TEXT_DARK),
                    (shown_risk[5] > 0 and G.C.FILTER or G.C.UI.TEXT_DARK),
                }
            }
        }
	end,
    group_key = "k_lobc_extraction_pack",
    in_pool = function(self, args)
        return args and args.kind and args.kind == "Abnormality"
    end
})

-- Normal Extraction Packs
ExtractionPack({
    key = 'extraction_base',
    weight = 0.6,
    cost = 4,
    pos = {x = 0, y = 0},
    config = {extra = 3, choose = 1, risk = {30, 25, 20, 15, 10}},
})

ExtractionPack({
    key = 'extraction_risky',
    weight = 0.6,
    cost = 6,
    pos = {x = 2, y = 0},
    config = {extra = 3, choose = 1, risk = {0, 0, 40, 35, 25}},
})

ExtractionPack({
    key = 'extraction_calm',
    weight = 0.6,
    cost = 4,
    pos = {x = 0, y = 1},
    config = {extra = 3, choose = 1, risk = {60, 30, 10, 0, 0}},
})

ExtractionPack({
    key = 'extraction_mega',
    weight = 0.15,
    cost = 8,
    pos = {x = 2, y = 1},
    config = {extra = 5, choose = 2, risk = {15, 20, 30, 20, 15}},
})

-- Elite Extraction Packs
ExtractionPack({
    key = 'extraction_base_elite',
    weight = 0, --0.2,
    cost = 6,
    pos = {x = 1, y = 0},
    config = {extra = 3, choose = 1, risk = {15, 20, 30, 20, 15}, elite = true},
    no_collection = true
})

ExtractionPack({
    key = 'extraction_risky_elite',
    weight = 0, --0.2,
    cost = 8,
    pos = {x = 3, y = 0},
    config = {extra = 3, choose = 1, risk = {0, 0, 30, 40, 30}, elite = true},
    no_collection = true
})

ExtractionPack({
    key = 'extraction_calm_elite',
    weight = 0, --0.2,
    cost = 6,
    pos = {x = 1, y = 1},
    config = {extra = 3, choose = 1, risk = {40, 30, 30, 0, 0}, elite = true},
    no_collection = true
})

ExtractionPack({
    key = 'extraction_mega_elite',
    weight = 0, --0.05,
    cost = 10,
    pos = {x = 3, y = 1},
    config = {extra = 5, choose = 2, risk = {10, 15, 30, 25, 20}, elite = true},
    no_collection = true
})

local card_openref = Card.open
function Card.open(self)
    if self.config.center.config.elite then
        G.GAME.lobc_no_pack_skip = true
    else
        G.GAME.lobc_no_pack_skip = false
    end
    return card_openref(self)
end

-- Disable skipping
local can_skip_boosterref = G.FUNCS.can_skip_booster
function G.FUNCS.can_skip_booster(e)
    if G.GAME.lobc_no_pack_skip then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        can_skip_boosterref(e)
    end
end