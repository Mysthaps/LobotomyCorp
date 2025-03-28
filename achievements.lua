local achievements = {
    -- Penitence / One Sin and Hundred of Good Deeds
    penitence = {
        hidden_text = true,
    },
    -- Paradise Lost / WhiteNight
    paradise_lost = {
        hidden_text = true,
        unlock_condition = function(self, args)
            return (args.type == "lobc_observe_abno" and args.card.config.center.key == "j_lobc_whitenight")
        end
    },
    -- Beak / Punishing Bird
    beak = {
        hidden_text = true,
    },
    -- Twilight & Through the Dark Twilight / Apocalypse Bird
    twilight = {
        hidden_text = true,
    },
    through_the_dark_twilight = {
        hidden_text = true,
        unlock_condition = function(self, args)
            return (args.type == "lobc_observe_abno" and args.card.config.center.key == "j_lobc_apocalypse_bird")
        end
    },
    -- Laetitia / Laetitia
    laetitia = {
        unlock_condition = function(self, args)
            if args.type == 'modify_deck' then
                local count = 0
                for _, v in pairs(G.playing_cards) do
                    if v.ability.lobc_gift then count = count + 1 end
                end
                return count >= 30
            end
        end
    },
    -- CENSORED / CENSORED
    censored = {
        unlock_condition = function(self, args)
            if args.type == 'modify_deck' then
                local count = 0
                for _, v in pairs(G.playing_cards) do
                    if v.ability.lobc_censored then count = count + 1 end
                end
                return count >= 30
            end
        end
    },
    -- Tough / You're Bald...
    tough = {
        unlock_condition = function(self, args)
            return args.type == "lobc_observe_abno" and args.card.config.center.key == "j_lobc_youre_bald"
        end
    },
    -- Midnight Vanquisher
    midnight = {
        unlock_condition = function(self, args)
            if args.type == "round_win" then
                if G.GAME.blind.config.blind.time and G.GAME.blind.config.blind.time == 'midnight' then
                    return true
                end
            end
        end
    },
    -- White Nights / Dark Days
    white_nights = {
        hidden_text = true,
        unlock_condition = function(self, args)
            if args.type == "win_challenge" or args.type == "win_challenge_startup" then
                return G.PROFILES[G.SETTINGS.profile].challenge_progress.completed["c_lobc_dark_days"]
            end
        end
    },
    -- The Will to Stand up Straight / Control
    malkuth = {
        hidden_text = true,
        unlock_condition = function(self, args)
            if args.type == "win_challenge" or args.type == "win_challenge_startup" then
                return G.PROFILES[G.SETTINGS.profile].challenge_progress.completed["c_lobc_malkuth"]
            end
        end
    },
    -- The Rationality to Maintain Discretion / Information
    yesod = {
        hidden_text = true,
        unlock_condition = function(self, args)
            if args.type == "win_challenge" or args.type == "win_challenge_startup" then
                return G.PROFILES[G.SETTINGS.profile].challenge_progress.completed["c_lobc_yesod"]
            end
        end
    },
    -- The Hope to be a Better Person / Training
    hod = {
        hidden_text = true,
        unlock_condition = function(self, args)
            if args.type == "win_challenge" or args.type == "win_challenge_startup" then
                return G.PROFILES[G.SETTINGS.profile].challenge_progress.completed["c_lobc_hod"]
            end
        end
    },
    -- The Fearlessness to Keep on Living / Safety
    netzach = {
        hidden_text = true,
        unlock_condition = function(self, args)
            if args.type == "win_challenge" or args.type == "win_challenge_startup" then
                return G.PROFILES[G.SETTINGS.profile].challenge_progress.completed["c_lobc_netzach"]
            end
        end
    },
    -- The Expectation for the Meaning of Existance / Central Command
    tiphereth = {
        hidden_text = true,
        unlock_condition = function(self, args)
            if args.type == "win_challenge" or args.type == "win_challenge_startup" then
                return G.PROFILES[G.SETTINGS.profile].challenge_progress.completed["c_lobc_tiphereth"]
            end
        end
    },
    -- The Courage to Protect / Discipline
    gebura = {
        hidden_text = true,
        unlock_condition = function(self, args)
            if args.type == "win_challenge" or args.type == "win_challenge_startup" then
                return G.PROFILES[G.SETTINGS.profile].challenge_progress.completed["c_lobc_gebura"]
            end
        end
    },
}

local achievement_list = {
    --"fourth_match_flame",
    "penitence",
    "love_and_hate",
    "bear_paws",
    --"sanguine_desire",
    "solitude",
    --"syrinx",
    --"screaming_wedge",
    --"mimicry",
    "lamp",
    "grinder_mk4",
    "red_eyes",
    "red_eyes_open",
    "bless",
    "paradise_lost",
    --"christmas",
    "regret",
    --"soda",
    "our_galaxy",
    "beak",
    "crimson_scar",
    "cobalt_scar",
    --"justitia",
    "twilight",
    "through_the_dark_twilight",
    "dead_silence",
    "laetitia",
    "solemn_lament",
    "smile",
    "aspiration",
    "wingbeat",
    --"harvest",
    "censored",
    "todays_expression",
    "tough",
    "blind_rage",
    "midnight",
    "white_nights",
    "malkuth",
    "yesod",
    "hod",
    "netzach",
    "tiphereth",
    "gebura",
}

for k, v in ipairs(achievement_list) do
    local unlock_condition = function(self, args)
        return args.type == "lobc_"..v
    end
    local ach = SMODS.Achievement({
        key = v,
        order = k,
        bypass_all_unlocked = true,
        hidden_text = false,
        unlock_condition = unlock_condition
    })
    for k_, v_ in pairs(achievements[v] or {}) do
        ach[k_] = v_
    end
end