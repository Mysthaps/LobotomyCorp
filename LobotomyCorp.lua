local current_mod = SMODS.current_mod
local mod_path = SMODS.current_mod.path
local config = SMODS.current_mod.config
local folder = string.match(mod_path, "[Mm]ods.*")
SMODS.load_file("libs/helper.lua")()

local joker_list = {
    --- Lobotomy Corporation Abnos
    "scorched_girl",
    "one_sin",
    "queen_of_hatred",
    "happy_teddy_bear",
    "red_shoes",
    "theresia",
    "old_lady",
    "nameless_fetus",
    "wall_gazer", -- The Lady Facing the Wall
    "nothing_there",
    "mhz",
    --"silent_orchestra",
    "woodsman", -- Warm-hearted Woodsman
    "big_bird",
    "all_around_helper",
    "spider_bud",
    "plague_doctor",
    "whitenight",
    "rudolta", -- Rudolta of the Sleigh
    "queen_bee",
    "bloodbath",
    "wellcheers", -- Opened Can of WellCheers
    "forsaken_murderer",
    "child_galaxy", -- Child of the Galaxy
    "punishing_bird",
    "little_red", -- Little Red Riding Hooded Mercenary
    "big_bad_wolf",
    "fragment_universe", -- Fragment of the Universe
    "judgement_bird",
    "apocalypse_bird",
    "king_of_greed",
    "price_of_silence",
    "laetitia",
    "fotdb", -- Funeral of the Dead Butterflies
    "der_freischutz",
    "knight_of_despair",
    "mosb", -- The Mountain of Smiling Bodies
    "heart_of_aspiration",
    "giant_tree_sap",
    "shelter", -- Shelter from the 27th of March
    "fairy_festival",
    "meat_lantern",
    "iron_maiden", -- We Can Change Anything
    "express_train", -- Express Train to Hell
    "scarecrow_searching", -- Scarecrow Searching for Wisdom
    "censored",
    "skin_prophecy",
    "shy_look", -- Today's Shy Look
    "you_must_be_happy",
    "old_faith", -- Old Faith and Promise
    "void_dream",
    "firebird",
    "servant_of_wrath",
    "youre_bald",
    --- Fanmade / Mod Crossover Abnos
    "jolliest_jester",
    "sign_of_roses",
    "electric_sheep"
}
local blind_list = {
    -- Abnormalities
    "whitenight",
    "apocalypse_bird",
    "ab_beak",
    "ab_eyes",
    "ab_arms",
    "mg_hatred",
    "mg_wrath",
    -- Meltdowns
    "red_mist",
    --"an_arbiter",
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
    -- ???
    "erlking_heathcliff",
    "what_blind",
}
local sound_list = {
    music_first_warning = "Emergency1",
    music_second_warning = "Emergency2",
    music_third_warning = "Emergency3",
    music_abno_choice = "AbnormalityChoice",
    music_story1 = "Story1",
    music_neutral1 = "Neutral1",
    music_neutral2 = "Neutral2",
    music_neutral3 = "Neutral3",
    music_neutral4 = "Neutral4",
    music_roland1 = "Roland01",
    music_roland2 = "Roland02",
    music_roland3 = "Roland03",

    music_malkuth_1 = "Violation of Black Colors",
    music_malkuth_2 = "Red Dots",
    music_yesod_1 = "Untitled9877645623413123325",
    music_yesod_2 = "Faded",
    music_hod_1 = "Theme - Retro Time ALT",
    music_hod_2 = "Theme - Retro Time ALT Mix 1",
    music_netzach_1 = "Abandoned",
    music_netzach_2 = "Blue Dots",
    music_tiphereth_1 = "Eternal",
    music_tiphereth_2 = "Dark Fantasy Scene",
    music_gebura_1 = "Distorted Night",
    music_gebura_2 = "Insignia Decay",
    music_tpov = "Through Patches of Violet",
    music_compass = "what/compass",
    music_second_warning_ruina = "Second Warning (Ruina)",
    --music_funky = "HYPERHASTIGHETS UPPGRADERINGAR",

    meltdown_start = "Boss_StartButton",
    overload_alert = "OverloadAlert3",

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
    butterfly_attack = "Butterfly_Attack",
    censored = "Censored_Atk",
    big_bird_attract = "Bigbird_Attract",
    big_bird_destroy = "Bigbird_HeadCut",
    train_sell = "Train_Sell",
    train_start = "Train_Start",
    littlered_gun = "RedHood_Gun",
    wolf_bite = "Wolf_Bite",
    wolf_out = "Wolf_EatOut",
    wolf_scratch = "Wolf_Scratch",
    queen_bee = "QueenBee_Funga_01",
    electric_sheep = "sheep_3_1-1",
    meat_lantern = "Bunny_Start",
    freischutz_create = "Freischutz_Create",
    freischutz_shot = "Freischutz_Shot",
    woodsman = "WoodMachine_Kill",

    evade = "what/evade",
    coin_fail = "what/coin_fail",
    what_1 = "what/what_1",
    what_2 = "what/what_2",
    what_sfx_1 = "what/what_sfx_1",
    what_sfx_2 = "what/what_sfx_2",
    what_sfx_3 = "what/what_sfx_3",
    what_s1 = "what/what_s1",
    what_s2 = "what/what_s2",
    what_p1 = "what/what_p1",
    what_p2 = "what/what_p2",
    what_p3 = "what/what_p3",
    what_p1s2 = "what/what_p1s2",
    what_p1s3 = "what/what_p1s3",
    what_p2s1 = "what/what_p2s1",
    what_p2s3 = "what/what_p2s3",
    what_p3s1 = "what/what_p3s1",
    what_p3s2 = "what/what_p3s2",
    what_p3s3 = "what/what_p3s3",
    what_death = "what/what_death",

    hatred_entry = "Hatred/hatred_entry",
    hatred_s1 = "Hatred/hatred_s1",
    hatred_s2 = "Hatred/hatred_s2",
    hatred_s3 = "Hatred/hatred_s3",
    hatred_alt = "Hatred/hatred_alt",
    hatred_switch = "Hatred/hatred_switch",

    gebura_slash = "Gebura_Phase2_Atk1",
    dice_roll = "Dice_Roll",
    apoc_birth = "Bossbird_Birth",

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
    "production",
    "dark_days",
    "malkuth",
    "yesod",
    "hod",
    "netzach",
    "tiphereth",
    "gebura",
}
local consumable_list = {
    "wisdom",
    "tt2",
}

local badge_colors = {
    lobc_gift = HEX("A0243A"),
    lobc_blessed = HEX("380D36"),
    lobc_blessed_wn = HEX("EDA9D3"),
    lobc_apostle = HEX("FF0000"),
    lobc_amplified = HEX("004d00"),
    lobc_pebble = HEX("AAAAAA"),
    lobc_enchanted = HEX("C8831B"),
    lobc_perma_enchanted = HEX("C8831B"),
    lobc_marked = HEX("C3181B"),
    lobc_devoured = HEX("174D7D"),
    lobc_prey_mark = HEX("1506A5"),
    lobc_lantern = HEX("88CA42"),
    lobc_villain = HEX("CB34B4"),
    lobc_blessing = HEX("1506A5"),
    lobc_warm_heart = HEX("EF2439"),
    lobc_zayin = HEX("1DF900"),
    lobc_teth = HEX("13A2FF"),
    lobc_he = HEX("FFF900"),
    lobc_waw = HEX("7B2BF3"),
    lobc_aleph = HEX("FF0000"),
    lobc_o_green = HEX("008000"),
    lobc_o_amber = HEX("FFA500"),
    lobc_o_crimson = HEX("DC143C"),
    lobc_o_violet = HEX("800080"),
    lobc_o_indigo = HEX("1E90FF"),
    lobc_o_base = HEX('C4C4C4'),
    EGO_Gift = HEX('DD4930'),
}
-- Badge colors
local get_badge_colourref = get_badge_colour
function get_badge_colour(key)
    return badge_colors[key] or get_badge_colourref(key)
end
-- Localization colors
local loc_colourref = loc_colour
function loc_colour(_c, _default)
    return (_c and badge_colors['lobc_'.._c]) or loc_colourref(_c, _default)
end

-- Load all jokers
SMODS.Joker.discover_override = nil
SMODS.Joker.discover_rounds = nil
for _, v in ipairs(joker_list) do
    local joker = SMODS.load_file("items/jokers/" .. v .. ".lua")()

    --joker.discovered = true
    joker.alerted = true
    joker.key = v
    joker.atlas = "LobotomyCorp_Jokers"
    --[[if not joker.yes_pool_flag then
        joker.yes_pool_flag = "allow_abnormalities_in_shop"
    end]]--
    --joker.config.discover_rounds = 0

    if not joker.pos then
        joker.pos = { x = 0, y = 0 }
    end
    if config.enable_crossovers then
        joker.dependencies = nil
        joker.or_dependencies = nil
    end

    if joker.or_dependencies then
        local can = lobc_deep_copy(config).enable_crossovers
        for _, v in ipairs(joker.or_dependencies or {}) do
            if next(SMODS.find_mod(v)) then can = true; break end
        end
        if not can then joker.dependencies = {"THIS_JOKER_WILL_NOT_LOAD_HOPEFULLY"} end
    end

    local joker_obj = SMODS.Joker(joker)

    for k_, v_ in pairs(joker) do
        if type(v_) == 'function' then
            joker_obj[k_] = joker[k_]
        end
    end

    -- Custom UI for Observation Levels
    joker_obj.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        if not card then
            card = self:create_fake_card()
        end
        local res = {}
        if self.loc_vars and type(self.loc_vars) == 'function' then
            res = self:loc_vars(info_queue, card) or {}
        end
        res.vars = res.vars or {}
        local name = false
        
        if specific_vars and specific_vars.debuffed then
            if self.key == "j_lobc_plague_doctor" then
                localize{type = 'other', key = 'lobc_plague_doctor_debuffed', nodes = desc_nodes}
            else
                localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
            end
        -- Fill undiscovered description
        elseif not self.discovered and not (card.area == G.jokers or card.area == G.consumeables) then
            localize{type = 'descriptions', key = 'und_'..self.key, set = "Other", nodes = desc_nodes, vars = res.vars, AUT = full_UI_table}
        else
            localize{type = 'descriptions', key = res.key or self.key, set = self.set, nodes = desc_nodes, vars = res.vars, AUT = full_UI_table}
        end

        -- Nothing There
        if self.key == "j_lobc_nothing_there" then
            if card.area and card.area == G.jokers and not specific_vars.debuffed then
                desc_nodes[#desc_nodes+1] = {
                    {n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
                        {n=G.UIT.C, config={ref_table = self, align = "m", colour = card.ability.extra.left_compat and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06}, nodes={
                            {n=G.UIT.T, config={text = ' '..localize(card.ability.extra.left_compat and 'k_compatible' or 'k_incompatible')..' ',colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.8}},
                        }},
                        {n=G.UIT.C, config={minw = 0.3, align = "m", padding = 0.06}},
                        {n=G.UIT.C, config={ref_table = self, align = "m", colour = card.ability.extra.right_compat and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06}, nodes={
                            {n=G.UIT.T, config={text = ' '..localize(card.ability.extra.right_compat and 'k_compatible' or 'k_incompatible')..' ',colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.8}},
                        }}
                    }}
                }
            end
        end

        -- For Undiscovered Abnormalities
        for k, v in ipairs(self.discover_rounds) do
            local override, true_override
            if self.discover_override then
                if type(self.discover_override) == "table" then
                    override = self.discover_override[k]
                elseif type(self.discover_override) == "function" then
                    override = self:discover_override(k, card)
                    if override then true_override = true end
                end
            end
            if (card:check_rounds() < v or true_override) and not card.debuff then
                if card.area == G.jokers or card.area == G.consumeables or self.discovered then
                    -- First level is in desc_nodes
                    if k == 1 then
                        full_UI_table.main = {}
                        localize{type = 'descriptions', key = (override or "lobc_obs"), set = "Other", nodes = full_UI_table.main, vars = {card:check_rounds(), v, k}}
                        full_UI_table.main.main_box_flag = true
                    else
                    -- The rest are in AUT.multi_box
                        full_UI_table.multi_box[k-1] = {}
                        localize{type = 'descriptions', key = (override or "lobc_obs"), set = "Other", nodes = full_UI_table.multi_box[k-1], vars = {card:check_rounds(), v, k}}
                    end
                end
            end
            -- If the Abno has a custom name for early Observation Levels
            if not self.discovered and card:check_rounds() >= v and G.localization.descriptions.Joker[self.key.."_name_"..k] then
                full_UI_table.name = localize{type = 'name', key = self.key.."_name_"..k, set = self.set, name_nodes = {}, vars = specific_vars or {}}
                name = true
            end
        end
        -- No custom names available, fill name with Classification Code from undiscovered description
        if not self.discovered then
            if not name then
                full_UI_table.name = localize{type = 'name', key = "und_"..self.key, set = "Other", name_nodes = {}, vars = specific_vars or {}}
            end
        else
            full_UI_table.name = localize{type = 'name', key = self.key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
        end
    end

    if not joker.set_sprites then
        joker_obj.set_sprites = function(self, card, front)
            card.children.center.atlas = G.ASSET_ATLAS["lobc_LobotomyCorp_Jokers"]
            local count = lobc_get_usage_count(card.config.center_key)
            if count < card.config.center.discover_rounds[#card.config.center.discover_rounds] and not config.show_art_undiscovered then
                card.children.center.atlas = G.ASSET_ATLAS["lobc_LobotomyCorp_Undiscovered"]
            end
            card.children.center:set_sprite_pos(card.config.center.pos)
        end
    end

    --if not joker.in_pool then
        joker_obj.in_pool = function(self, args)
            --if not args then return true end
            --if args.source == "lobc_rudolta" then return false end
            --return true
            return false
        end
   -- end

    if joker.risk then
        joker_obj.set_badges = function(self, card, badges)
            if self.discovered then
                local color = nil
                if joker.risk == "he" or joker.risk == "zayin" then color = G.C.UI.TEXT_DARK end
                badges[#badges + 1] = create_badge(localize("lobc_" .. joker.risk, "labels"), get_badge_colour("lobc_" .. joker.risk), color)
            end
        end
    end
end

-- Load all blinds
for _, v in ipairs(blind_list) do
    local blind = SMODS.load_file("items/blinds/" .. v .. ".lua")()
    blind.key = v
    blind.atlas = blind.atlas or "LobotomyCorp_Blind"
    if not blind.pos then blind.pos = { x = 0, y = 0 } end
    if blind.atlas == "v" then blind.atlas = nil end
    --blind.discovered = true
    if blind.lobc_color then
        blind.boss_colour = badge_colors["lobc_o_" .. blind.lobc_color]
    end

    local blind_obj = SMODS.Blind(blind)

    for k_, v_ in pairs(blind) do
        if type(v_) == 'function' then
            blind_obj[k_] = blind[k_]
        end
    end
end

-- Load all sounds
for k, v in pairs(sound_list) do
    local sound = SMODS.Sound({
        key = k,
        path = v..".ogg",
        pitch = 1,
        volume = 0.6,
        sync = false,
        no_sync = true,
    })
    
    for _, vv in ipairs(SMODS.load_file("items/sounds.lua")()) do
        if k == vv.key then
            sound.select_music_track = vv.select_music_track
            sound.bpm = vv.bpm
            sound.offset = vv.offset
            sound.sync_events = vv.sync_events
            sound.sync = vv.sync
            sound.pitch = vv.pitch or 0.7
        end
    end
end

-- Load challenges
for _, v in ipairs(challenge_list) do
    local chal = SMODS.load_file("items/challenges/" .. v .. ".lua")()
    chal.key = v
    local chal_obj = SMODS.Challenge(chal)
end

-- Load consumables
for _, v in ipairs(consumable_list) do
    local cons = SMODS.load_file("items/consumables/" .. v .. ".lua")()

    cons.key = v
    cons.atlas = "LobotomyCorp_consumable"
    if not cons.set then cons.set = "EGO_Gift" end
    cons.discovered = true
    cons.alerted = true
    local cons_obj = SMODS.Consumable(cons)

    for k_, v_ in pairs(cons) do
        if type(v_) == 'function' then
            cons_obj[k_] = cons[k_]
        end
    end
end

SMODS.load_file("items/achievements.lua")()
SMODS.load_file("items/boosters.lua")()

SMODS.load_file("libs/drawstep.lua")()
SMODS.load_file("libs/blinds.lua")()
SMODS.load_file("libs/jokers.lua")()
SMODS.load_file("libs/challenges.lua")()
SMODS.load_file("libs/observation.lua")()
SMODS.load_file("libs/ui.lua")()
SMODS.load_file("libs/lyrics.lua")()

-- Restore several modifiers on card reload
local card_updateref = Card.update
function Card.update(self, dt)
    card_updateref(self, dt)
    -- Enchanted
    if self.ability.big_bird_enchanted and not self.children.lobc_big_bird_particles and G.GAME.blind and G.GAME.blind.in_blind then
        self.children.lobc_big_bird_particles = Particles(0, 0, 0,0, {
            timer = self.ability.permanent_enchanted and 0.4 or 0.3,
            scale = self.ability.permanent_enchanted and 0.3 or 0.45,
            speed = 0.3,
            lifespan = self.ability.permanent_enchanted and 3 or 4,
            attach = self,
            colours = {darken(G.C.MONEY, 0.1), darken(G.C.MONEY, 0.3), darken(G.C.MONEY, 0.5)},
            fill = true
        })
    end
    -- Marked
    if self.ability.little_red_marked and not self.children.lobc_prey then
        self.children.lobc_prey = Sprite(self.T.x, self.T.y, self.T.w, self.T.h, G.ASSET_ATLAS["lobc_LobotomyCorp_modifiers"], {x = 4, y = 0})
        self.children.lobc_prey.role.major = self
        self.children.lobc_prey.states.hover.can = false
        self.children.lobc_prey.states.click.can = false
    end
    -- Lantern
    if self.ability.meat_lantern_lantern and not self.children.lobc_lantern then
        self.children.lobc_lantern = Sprite(self.T.x, self.T.y, self.T.w, self.T.h, G.ASSET_ATLAS["lobc_LobotomyCorp_modifiers"], {x = 7, y = 0})
        self.children.lobc_lantern.role.major = self
        self.children.lobc_lantern.states.hover.can = false
        self.children.lobc_lantern.states.click.can = false
    end
    -- Villain
    if self.ability.hatred_villain and not self.children.lobc_villain then
        self.children.lobc_villain = Sprite(self.T.x, self.T.y, self.T.w, self.T.h, G.ASSET_ATLAS["lobc_LobotomyCorp_modifiers"], {x = 8, y = 0})
        self.children.lobc_villain.role.major = self
        self.children.lobc_villain.states.hover.can = false
        self.children.lobc_villain.states.click.can = false
    end
    -- Prey Mark
    if self.ability.prey_marked and not self.children.lobc_prey_mark then
        self.children.lobc_prey_mark = Sprite(self.T.x, self.T.y, self.T.w, self.T.h, G.ASSET_ATLAS["lobc_LobotomyCorp_modifiers"], {x = 5, y = 0})
        self.children.lobc_prey_mark.role.major = self
        self.children.lobc_prey_mark.states.hover.can = false
        self.children.lobc_prey_mark.states.click.can = false
    end
end

-- Global start of hand effect
local drawn_to_handref = Blind.drawn_to_hand
function Blind.drawn_to_hand(self)
    drawn_to_handref(self)
    if not G.GAME.lobc_prepped then return end

    -- Gebura's effect
    if G.GAME.modifiers.lobc_gebura then
        local available_cards = {}
        local destroyed_cards = {}
        local first = true
        for _, v in ipairs(G.hand.cards) do
            if not v.highlighted then available_cards[#available_cards+1] = v end
        end
        if #available_cards > 0 then
            for i = 1, (G.GAME.blind and G.GAME.blind.config.blind.key == "bl_lobc_red_mist" and G.GAME.current_round.phases_beaten >= 2) and 2 or 1 do
                local chosen_card, chosen_card_key = pseudorandom_element(available_cards, pseudoseed("lobc_gebura_destroy"))
                table.remove(available_cards, chosen_card_key)
                destroyed_cards[#destroyed_cards+1] = chosen_card
                if first then play_sound("lobc_gebura_slash", math.random(80, 120)/100, 0.5) end
                first = nil
            end
            delay(0.2)
            SMODS.destroy_cards(destroyed_cards)
        end
    end

    -- Child of the Galaxy add new pebbles
    local children_of_the_galaxy = SMODS.find_card('j_lobc_child_galaxy')
    if next(children_of_the_galaxy) then
        for _, v in ipairs(G.playing_cards) do
            v.ability.child_galaxy_pebble = nil
        end
        local available_cards = {}
        for _, v in ipairs(G.hand.cards) do
            if not v.ability.child_galaxy_pebble then
                available_cards[#available_cards + 1] = v
            end
        end
        for i = 1, 5 * #children_of_the_galaxy do
            if #available_cards > 0 then
                local chosen_card, chosen_card_key = pseudorandom_element(available_cards, pseudoseed("random_card"))
                chosen_card.ability.child_galaxy_pebble = true
                chosen_card:juice_up()
                table.remove(available_cards, chosen_card_key)
            end
        end
    end

    G.GAME.lobc_prepped = nil
    save_run()
end

-- Remove the topleft message when CENSORED/Yesod is active
local generate_UIBox_ability_tableref = Card.generate_UIBox_ability_table
function Card.generate_UIBox_ability_table(self, ...)
    if (next(SMODS.find_card("j_lobc_censored", true)) and self.config.center.key ~= "j_lobc_censored") 
    or (G.GAME and G.GAME.modifiers.lobc_yesod and G.GAME.round_resets.ante > 3) 
    or (self.ability and self.ability.lobc_censored) then return end

    -- Add "Sin" info_queue
    local full_UI_table = generate_UIBox_ability_tableref(self, ...)
    if self.playing_card then
        local id = self:get_id()
        if G.GAME.lobc_long_arms and G.GAME.lobc_long_arms[id] then
            generate_card_ui({key = 'lobc_sin', set = 'Other'}, full_UI_table)
        end
    end
    return full_UI_table
end

-- When the game is loaded
local init_game_objectref = Game.init_game_object
function Game.init_game_object(self)
    local G = init_game_objectref(self)
    
    -- Make Lobcorp blinds unable to spawn normally
    for _, v in ipairs(blind_list) do
        G.bosses_used["bl_lobc_"..v] = 1e300
    end

    -- Add separate chance for Jolliest Jester
    G.probabilities["jolliest_jester"] = 1
    G.probabilities["jolliest_jester_inc"] = 1

    -- Yesod font
    self.FONTS["blank"] = {
        file = folder.."assets/fonts/AdobeBlank.ttf", 
        render_scale = self.TILESIZE*10, 
        TEXT_HEIGHT_SCALE = 0.83, 
        TEXT_OFFSET = {x=10,y=-20}, 
        FONTSCALE = 0.1, 
        squish = 1, 
        DESCSCALE = 1,
        FONT = love.graphics.newFont(folder.."assets/fonts/AdobeBlank.ttf", self.TILESIZE*10)
    }

    return G
end

-- Global vars, end of round effect
function current_mod.reset_game_globals(start_run)
    if start_run then
        -- Nameless Fetus
        G.GAME.nameless_hand_type = nil
        -- Production last pack Ante
        G.GAME.production_last_pack = 1
        -- Effect multi
        G.GAME.lobc_hod_modifier = 1
        -- Rank's Sin
        G.GAME.lobc_long_arms = {}
        -- Risk multi
        G.GAME.lobc_risk_modifier = {1, 1, 1, 1, 1}
    else
        for k, _ in pairs(G.GAME.lobc_long_arms) do
            if G.GAME.lobc_long_arms[k] >= 10 then G.GAME.lobc_long_arms[k] = G.GAME.lobc_long_arms[k] / 2 end
            G.GAME.lobc_long_arms[k] = G.GAME.lobc_long_arms[k] - 1
            if G.GAME.lobc_long_arms[k] <= 0 then G.GAME.lobc_long_arms[k] = nil end
        end
    end
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

-- New round stuff
local new_roundref = new_round
function new_round()
    new_roundref()
    -- Reset death text if any
    G.GAME.lobc_death_text = nil

    -- Kill on new round if hands is 0
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            if G.GAME.current_round.hands_left <= 0 and G.GAME.lobc_no_hands_reset then
                G.STATE = G.STATES.NEW_ROUND
                G.STATE_COMPLETE = false
            end
        return true
        end
    }))

    G.GAME.lobc_prepped = true
end

-- Update every frame
local game_updateref = Game.update
function Game.update(self, dt)
    -- Apply blank font (Yesod)
    if not G.SETTINGS.paused and G.GAME and G.GAME.modifiers.lobc_yesod and G.GAME.round_resets.ante > 6 and G.STATE ~= G.STATES.GAME_OVER and G.LANGUAGES and G.LANG and G.FONTS and G.SETTINGS then
        G.LANG.font = G.FONTS["blank"]
    else
        G.LANG.font = G.LANGUAGES[G.SETTINGS.language] and G.LANGUAGES[G.SETTINGS.language].font or G.FONTS[1]
    end

    -- Handle cutscenes
    if G.lobc_displaying_cutscene then
        -- Apocalypse Bird
        if G.lobc_displaying_cutscene == "ab" then
            if G.lobc_cutscene_timer < 0.5 then G.lobc_cutscene_transparency = G.lobc_cutscene_timer * 2 end
            if G.lobc_cutscene_timer >= 0.5 and G.lobc_cutscene_timer < 5 then G.lobc_cutscene_transparency = 1 end
            if G.lobc_cutscene_timer >= 5 and G.lobc_cutscene_timer <= 6 then G.lobc_cutscene_transparency = 6 - G.lobc_cutscene_timer end
            if G.lobc_cutscene_timer >= 6 then 
                G.lobc_cutscene_transparency = 0
                G.lobc_displaying_cutscene = false
                G.SETTINGS.paused = false
                if G.OVERLAY_MENU then G.OVERLAY_MENU:remove() end
            end
        -- what
        elseif G.lobc_displaying_cutscene == "what" then
            if G.lobc_cutscene_timer < 2 then
                if G.lobc_what_txt ~= "bl_lobc_what_blind_name" then 
                    G.ROOM_ORIG.y = 0
                    G.ROOM_ORIG.x = (G.original_orig_x - 1) / 3 + 1
                    G.CANV_SCALE = 3.75
                    G.lobc_what_txt = "bl_lobc_what_blind_name"
                    G.GAME.blind:set_text()
                end
                G.lobc_cutscene_transparency = 1 - G.lobc_cutscene_timer / 2
            end
            if G.lobc_cutscene_timer >= 2 and G.lobc_cutscene_timer < 7.5 then 
                if G.lobc_what_txt ~= "bl_lobc_what_blind_cutscene_1" then 
                    G.lobc_cutscene_transparency = 0
                    G.lobc_what_txt = "bl_lobc_what_blind_cutscene_1"
                    play_sound("lobc_what_1", 1, 0.6)
                    play_sound("lobc_what_sfx_1", 1, 0.6)
                    G.GAME.blind:set_text()
                end
            end
            if G.lobc_cutscene_timer >= 7.5 and G.lobc_cutscene_timer < 10.5 then 
                if G.lobc_what_txt ~= "bl_lobc_what_blind_cutscene_2" then 
                    G.lobc_what_txt = "bl_lobc_what_blind_cutscene_2"
                    play_sound("lobc_what_2", 1, 0.6)
                    G.GAME.blind:set_text()
                    G.E_MANAGER:add_event(Event({trigger = 'ease', ease = 'inexpo', blocking = false, blockable = false, ref_table = G.ROOM_ORIG, ref_value = 'x', ease_to = G.original_orig_x, delay = 2.5, timer = "REAL", func = (function(t) return t end)}))
                    G.E_MANAGER:add_event(Event({trigger = 'ease', ease = 'inexpo', blocking = false, blockable = false, ref_table = G.ROOM_ORIG, ref_value = 'y', ease_to = G.original_orig_y, delay = 2.5, timer = "REAL", func = (function(t) return t end)}))
                    G.E_MANAGER:add_event(Event({trigger = 'ease', ease = 'inexpo', blocking = false, blockable = false, ref_table = G, ref_value = 'CANV_SCALE', ease_to = 1, delay = 2.5, timer = "REAL", func = (function(t) return t end)}))
                end
            end
            if G.lobc_cutscene_timer >= 10.5 then
            --if G.lobc_cutscene_timer >= 0.4 then -- remove this
                G.ROOM_ORIG.x = G.original_orig_x
                G.ROOM_ORIG.y = G.original_orig_y
                G.CANV_SCALE = 1
                G.lobc_cutscene_transparency = 0
                G.lobc_displaying_cutscene = false
                G.SETTINGS.paused = false
                if G.OVERLAY_MENU then G.OVERLAY_MENU:remove() end
                G.lobc_what_txt = nil
            end
        -- what (Phase 2)
        elseif G.lobc_displaying_cutscene == "what_2" then
            if G.lobc_cutscene_timer < 3.5 then
                if G.lobc_what_txt ~= "bl_lobc_what_blind_name" then 
                    G.ROOM_ORIG.x = (G.original_orig_x - 1) / 3 + 1
                    G.ROOM_ORIG.y = 0
                    G.CANV_SCALE = 3.75
                    play_sound("lobc_what_sfx_2", 1, 0.6)
                    G.lobc_what_txt = "bl_lobc_what_blind_name"
                    G.GAME.blind:set_text()
                end
            end
            if G.lobc_cutscene_timer >= 3.5 and G.lobc_cutscene_timer < 6.5 then 
                if G.lobc_what_txt ~= "bl_lobc_what_blind_name_copy" then 
                    G.lobc_what_txt = "bl_lobc_what_blind_name_copy"
                    G.GAME.blind:set_text()
                    G.E_MANAGER:add_event(Event({trigger = 'ease', ease = 'inexpo', blocking = false, blockable = false, ref_table = G.ROOM_ORIG, ref_value = 'x', ease_to = G.original_orig_x, delay = 2.5, timer = "REAL", func = (function(t) return t end)}))
                    G.E_MANAGER:add_event(Event({trigger = 'ease', ease = 'inexpo', blocking = false, blockable = false, ref_table = G.ROOM_ORIG, ref_value = 'y', ease_to = G.original_orig_y, delay = 2.5, timer = "REAL", func = (function(t) return t end)}))
                    G.E_MANAGER:add_event(Event({trigger = 'ease', ease = 'inexpo', blocking = false, blockable = false, ref_table = G, ref_value = 'CANV_SCALE', ease_to = 1, delay = 2.5, timer = "REAL", func = (function(t) return t end)}))
                end
            end
            if G.lobc_cutscene_timer >= 6.5 then
                G.ROOM_ORIG.x = G.original_orig_x
                G.ROOM_ORIG.y = G.original_orig_y
                G.CANV_SCALE = 1
                G.lobc_displaying_cutscene = false
                G.SETTINGS.paused = false
                if G.OVERLAY_MENU then G.OVERLAY_MENU:remove() end
                G.lobc_what_txt = nil
            end
        -- what (Phase 3)
        elseif G.lobc_displaying_cutscene == "what_3" then
            if G.lobc_cutscene_timer < 6 then
                if G.lobc_what_txt ~= "bl_lobc_what_blind_name" then 
                    G.ROOM_ORIG.x = (G.original_orig_x - 1) / 3 + 1
                    G.ROOM_ORIG.y = 0
                    G.CANV_SCALE = 3.75
                    play_sound("lobc_what_sfx_3", 1, 0.6)
                    G.lobc_what_txt = "bl_lobc_what_blind_name"
                    G.GAME.blind:set_text()
                end
            end
            if G.lobc_cutscene_timer >= 6 and G.lobc_cutscene_timer < 9.5 then 
                if G.lobc_what_txt ~= "bl_lobc_what_blind_name_copy" then 
                    G.lobc_what_txt = "bl_lobc_what_blind_name_copy"
                    G.GAME.blind:set_text()
                    G.E_MANAGER:add_event(Event({trigger = 'ease', ease = 'inexpo', blocking = false, blockable = false, ref_table = G.ROOM_ORIG, ref_value = 'x', ease_to = G.original_orig_x, delay = 2.5, timer = "REAL", func = (function(t) return t end)}))
                    G.E_MANAGER:add_event(Event({trigger = 'ease', ease = 'inexpo', blocking = false, blockable = false, ref_table = G.ROOM_ORIG, ref_value = 'y', ease_to = G.original_orig_y, delay = 2.5, timer = "REAL", func = (function(t) return t end)}))
                    G.E_MANAGER:add_event(Event({trigger = 'ease', ease = 'inexpo', blocking = false, blockable = false, ref_table = G, ref_value = 'CANV_SCALE', ease_to = 1, delay = 2.5, timer = "REAL", func = (function(t) return t end)}))
                end
            end
            if G.lobc_cutscene_timer >= 9.5 then
                G.ROOM_ORIG.x = G.original_orig_x
                G.ROOM_ORIG.y = G.original_orig_y
                G.CANV_SCALE = 1
                G.lobc_displaying_cutscene = false
                G.SETTINGS.paused = false
                if G.OVERLAY_MENU then G.OVERLAY_MENU:remove() end
                G.lobc_what_txt = nil
            end
        end
        if not G.lobc_update_lock then G.lobc_cutscene_timer = G.lobc_cutscene_timer + dt end
    end

    -- i hate chicot
    if find_passive("psv_lobc_fixed_encounter") then G.GAME.blind.disabled = nil end
    game_updateref(self, dt)
end

-- Reduce return values for card evals
local eval_cardref = eval_card
function eval_card(card, context)
    local eval, post_trig = eval_cardref(card, context)
    if type(eval) ~= "table" then return eval, post_trig end
    if eval and G.GAME.lobc_hod_modifier and G.GAME.lobc_hod_modifier ~= 1 then
        for _, v in pairs(eval) do
            if type(v) ~= "table" then goto continue end
            if v.chips then v.chips = v.chips * G.GAME.lobc_hod_modifier end
            if v.h_chips then v.h_chips = v.h_chips * G.GAME.lobc_hod_modifier end
            if v.chip_mod then v.chip_mod = v.chip_mod * G.GAME.lobc_hod_modifier end
            if v.mult then v.mult = v.mult * G.GAME.lobc_hod_modifier end
            if v.h_mult then v.h_mult = v.h_mult * G.GAME.lobc_hod_modifier end
            if v.mult_mod then v.mult_mod = v.mult_mod * G.GAME.lobc_hod_modifier end
            if v.x_mult then 
                if v.x_mult < 1 then v.x_mult = v.x_mult * G.GAME.lobc_hod_modifier
                else v.x_mult = 1 + (v.x_mult - 1) * G.GAME.lobc_hod_modifier end
            end
            if v.X_mult then 
                if v.X_mult < 1 then v.X_mult = v.X_mult * G.GAME.lobc_hod_modifier
                else v.X_mult = 1 + (v.X_mult - 1) * G.GAME.lobc_hod_modifier end
            end
            if v.xmult then 
                if v.xmult < 1 then v.xmult = v.xmult * G.GAME.lobc_hod_modifier
                else v.xmult = 1 + (v.xmult - 1) * G.GAME.lobc_hod_modifier end
            end
            if v.x_mult_mod then 
                if v.x_mult_mod < 1 then v.x_mult_mod = v.x_mult_mod * G.GAME.lobc_hod_modifier
                else v.x_mult_mod = 1 + (v.x_mult_mod - 1) * G.GAME.lobc_hod_modifier end
            end
            if v.Xmult_mod then 
                if v.Xmult_mod < 1 then v.Xmult_mod = v.Xmult_mod * G.GAME.lobc_hod_modifier
                else v.Xmult_mod = 1 + (v.Xmult_mod - 1) * G.GAME.lobc_hod_modifier end
            end
            if v.h_x_mult then 
                if v.h_x_mult < 1 then v.h_x_mult = v.h_x_mult * G.GAME.lobc_hod_modifier
                else v.h_x_mult = 1 + (v.h_x_mult - 1) * G.GAME.lobc_hod_modifier end
            end
            ::continue::
        end
    end
    return eval, post_trig
end

-- Late patches
local injectItemsref = SMODS.injectItems
function SMODS.injectItems()
    injectItemsref()
        -- Global variables
        G.lobc_global_modifiers = {
            "laetitia_gift",
            "price_of_silence_amplified",
            "plague_doctor_baptism",
            "child_galaxy_pebble",
            "knight_of_despair_blessing",
        }
        G.lobc_global_meltdowns = {
            "malkuth",
            "yesod",
            "hod",
            "netzach",
            "tiphereth",
            "gebura",
            "chesed",
            "binah",
            "hokma",
            "day_47",
            "day_48",
            "day_49"
        }
        local modifiers_atlas = G.ASSET_ATLAS["lobc_LobotomyCorp_modifiers"]
        G.lobc_shared_modifiers = {
            laetitia_gift = Sprite(0, 0, G.CARD_W, G.CARD_H, modifiers_atlas, {x = 0, y = 0}),
            price_of_silence_amplified = Sprite(0, 0, G.CARD_W, G.CARD_H, modifiers_atlas, {x = 1, y = 0}),
            plague_doctor_baptism = Sprite(0, 0, G.CARD_W, G.CARD_H, modifiers_atlas, {x = 2, y = 0}),
            child_galaxy_pebble = Sprite(0, 0, G.CARD_W, G.CARD_H, modifiers_atlas, {x = 3, y = 0}),
            knight_of_despair_blessing = Sprite(0, 0, G.CARD_W, G.CARD_H, modifiers_atlas, {x = 0, y = 1}),
        }
        
        -- Card popup UI effects
        local card_h_popupref = G.UIDEF.card_h_popup
        function G.UIDEF.card_h_popup(card)
            local t = card_h_popupref(card)
            -- Yesod remove UI
            if G.GAME and G.GAME.modifiers.lobc_yesod and G.GAME.round_resets.ante > 3 then
                return {n=G.UIT.ROOT, config = {align = 'cm', colour = G.C.CLEAR}, nodes={}}
            end
            -- CENSORED
            if (next(SMODS.find_card("j_lobc_censored", true)) and (not card.config or not card.config.center or card.config.center.key ~= "j_lobc_censored"))
            or (card.ability and card.ability.lobc_censored) then
                local name_nodes = localize{type = 'name', key = "j_lobc_censored", set = "Joker", name_nodes = {}, vars = {}}
                name_nodes[1].nodes[1].nodes[1].config.object.colours = {G.C.RED}
                return {n=G.UIT.ROOT, config = {align = 'cm', colour = G.C.CLEAR}, nodes={
                    {n=G.UIT.C, config={align = "cm", object = Moveable(), ref_table = nil}, nodes = {
                        {n=G.UIT.R, config={padding = 0.05, r = 0.12, colour = G.C.BLACK, emboss = 0.07}, nodes={
                            {n=G.UIT.R, config={align = "cm", padding = 0.07, r = 0.1, colour = G.C.RED}, nodes={
                                {n=G.UIT.R, config={align = "cm", padding = 0.05, r = 0.1, colour = G.C.BLACK, emboss = 0.05}, nodes = name_nodes},
                            }}
                        }}
                    }},
                }}
            end
            -- Apocalypse Bird/Long Arms
            if G.GAME.lobc_long_arms and card.playing_card and G.GAME.lobc_long_arms[card:get_id()] then
                table.insert(
                    t.nodes[1].nodes[1].nodes[1].nodes[2].nodes[1].nodes,
                    {n=G.UIT.R, config={align = "cm"}, nodes={
                        {n=G.UIT.T, config={
                            text = localize("k_lobc_rank_sin"),
                            scale = 0.32*G.LANG.font.DESCSCALE*(G.F_MOBILE_UI and 1.5 or 1),
                            colour = G.C.UI.TEXT_DARK,
                        }},
                        {n=G.UIT.T, config={
                            text = G.GAME.lobc_long_arms[card:get_id()], 
                            scale = 0.32*G.LANG.font.DESCSCALE*(G.F_MOBILE_UI and 1.5 or 1),
                            colour = G.C.RED,
                        }}
                    }}
                )

            end
            return t
        end

        -- Add skills to blind description
        local HUD_blind_debuffref = G.FUNCS.HUD_blind_debuff
        function G.FUNCS.HUD_blind_debuff(e)
            HUD_blind_debuffref(e)
            if G.GAME.blind.skill_deck then
                if not G.skill_deck then
                    G.skill_deck = CardArea(0, 0, 4.2, 1.2, {card_limit = 5, type = 'title_2'})
                    local deck = {n = G.UIT.R, config = {align = "cm", maxh = 1.2, maxw = 4.2}, nodes = {}}
                    for _, v in ipairs(G.GAME.blind.skill_deck) do
                        local _card = SMODS.create_card({
                            set = "SkillLobc",
                            key = "sk_lobc_"..v,
                            area = G.skill_deck
                        })
                        G.skill_deck:emplace(_card)
                        _card.states.click.can = false
                        _card.states.drag.can = false
                        G.E_MANAGER:add_event(Event({trigger = "after", delay = 0.2, func = function() 
                            _card:juice_up()
                        return true end }))
                    end
                    for _, v in ipairs(G.skill_deck.cards) do
                        v.states.click.can = false
                        v.states.drag.can = false
                    end
                    table.insert(deck.nodes, {n=G.UIT.O, config = {object = G.skill_deck}})
                    e.UIBox:set_parent_child(deck, e)
                    e.UIBox:recalculate()
                end
            end
        end

        -- NotJustYet compat with phase blinds
        local njy_endround_ref = G.FUNCS.njy_attempt_endround
        if njy_endround_ref then
            print("NotJustYet found!")
            G.FUNCS.njy_attempt_endround = function(e)
                if (G.GAME.blind.config.blind.summon or G.GAME.blind.config.blind.phases or G.GAME.blind.original_blind) then
                    G.STATE = G.STATES.NEW_ROUND
                    G.STATE_COMPLETE = false
                else
                    njy_endround_ref()
                end
            end
        end

    -- Generate Compass lyrics
    SMODS.Sounds.lobc_music_compass.sync_events = lobc_generate_compass_lyrics()
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
SMODS.Atlas({
    key = "LobotomyCorp_yes_no",
    path = "LobotomyCorp_yes_no.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "LobotomyCorp_lights",
    path = "LobotomyCorp_lights.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "LobotomyCorp_wellcheers",
    path = "LobotomyCorp_wellcheers.png",
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
SMODS.Atlas({
    key = "LobotomyCorp_consumable",
    path = "LobotomyCorp_consumable.png",
    px = 71,
    py = 95
})
SMODS.Atlas({
    key = "LobotomyCorp_cutscenes",
    path = "LobotomyCorp_cutscenes.png",
    px = 1024,
    py = 654
})
SMODS.Atlas({
    key = "Erlking_Heathcliff", 
    atlas_table = "ANIMATION_ATLAS", 
    path = "Erlking_Heathcliff.png", 
    px = 1435, 
    py = 1042,
    frames = 1,
})
SMODS.Atlas({ 
    key = "LobotomyCorp_ApocBird", 
    atlas_table = "ANIMATION_ATLAS", 
    path = "LobotomyCorp_ApocBird.png", 
    px = 34, 
    py = 34,
    frames = 21,
})
SMODS.Atlas({
    key = "what", 
    atlas_table = "ANIMATION_ATLAS", 
    path = "what_asset.png", 
    px = 512, 
    py = 512,
    frames = 1,
})
SMODS.Atlas({
    key = "what_huh", 
    atlas_table = "ANIMATION_ATLAS", 
    path = "what_huh.png", 
    px = 34, 
    py = 34,
    frames = 21,
})
SMODS.Atlas({
    key = "black",
    path = "black.png",
    px = 2000,
    py = 2000
})
SMODS.Atlas({
    key = "what_skills",
    path = "Skills.png",
    px = 196,
    py = 196
})
SMODS.Atlas({
    key = "LobotomyCorp_movement",
    path = "LobotomyCorp_movement.png",
    px = 71,
    py = 95
})

-- ConsumableType (guh)
SMODS.ConsumableType({
    key = 'EGO_Gift', 
    primary_colour = HEX('424e54'),
    secondary_colour = HEX("dd4930"),
    loc_txt = {},
    shop_rate = 0,
    default = 'c_lobc_tt2',
    no_doe = true,
    no_collection = true,
})

-- Shaders
SMODS.Shader({
    key = "pixelation",
    path = "pixelation.fs"
})

