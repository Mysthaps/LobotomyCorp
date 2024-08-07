-- Penitence / One Sin and Hundred of Good Deeds
SMODS.Achievement({
    key = "penitence",
    order = 1,
    bypass_all_unlocked = true,
    hidden_text = true,
    unlock_condition = function(self, args)
        return args.type == "lobc_penitence"
    end
})

-- In the Name of Love and Hate / The Queen of Hatred
SMODS.Achievement({
    key = "love_and_hate",
    order = 2,
    bypass_all_unlocked = true,
    hidden_text = false,
    unlock_condition = function(self, args)
        return args.type == "lobc_love_and_hate"
    end
})

-- Bear Paws / Happy Teddy Bear
SMODS.Achievement({
    key = "bear_paws",
    order = 3,
    bypass_all_unlocked = true,
    hidden_text = false,
    unlock_condition = function(self, args)
        return args.type == "lobc_bear_paws"
    end
})

-- Solitude / Old Lady
SMODS.Achievement({
    key = "solitude",
    order = 4,
    bypass_all_unlocked = true,
    hidden_text = false,
    unlock_condition = function(self, args)
        return args.type == "lobc_solitude"
    end
})

-- Bless / Plague Doctor
SMODS.Achievement({
    key = "bless",
    order = 5,
    bypass_all_unlocked = true,
    hidden_text = false,
    unlock_condition = function(self, args)
        return args.type == "lobc_bless"
    end
})

-- Paradise Lost / WhiteNight
SMODS.Achievement({
    key = "paradise_lost",
    order = 6,
    bypass_all_unlocked = true,
    hidden_text = true,
    unlock_condition = function(self, args)
        return (args.type == "lobc_observe_abno" and args.card.config.center.key == "j_lobc_whitenight")
    end
})

-- Our Galaxy / Child of the Galaxy
SMODS.Achievement({
    key = "our_galaxy",
    order = 7,
    bypass_all_unlocked = true,
    hidden_text = false,
    unlock_condition = function(self, args)
        return args.type == "lobc_our_galaxy"
    end
})

-- Beak / Punishing Bird
SMODS.Achievement({
    key = "beak",
    order = 8,
    bypass_all_unlocked = true,
    hidden_text = true,
    unlock_condition = function(self, args)
        return args.type == "lobc_beak"
    end
})

-- Dead Silence / The Price of Silence
SMODS.Achievement({
    key = "dead_silence",
    order = 9,
    bypass_all_unlocked = true,
    hidden_text = false,
    unlock_condition = function(self, args)
        return args.type == "lobc_dead_silence"
    end
})

-- Laetitia / Laetitia
SMODS.Achievement({
    key = "laetitia",
    order = 10,
    bypass_all_unlocked = true,
    hidden_text = false,
    unlock_condition = function(self, args)
        if args.type == 'modify_deck' then
            local count = 0
            for _, v in pairs(G.playing_cards) do
                if v.ability.lobc_gift then count = count + 1 end
            end
            return count >= 30
        end
    end
})

-- Smile / The Mountain of Smiling Bodies
SMODS.Achievement({
    key = "smile",
    order = 11,
    bypass_all_unlocked = true,
    hidden_text = false,
    unlock_condition = function(self, args)
        return args.type == "lobc_smile"
    end
})

-- Aspiration / The Heart of Aspiration
SMODS.Achievement({
    key = "aspiration",
    order = 12,
    bypass_all_unlocked = true,
    hidden_text = false,
    unlock_condition = function(self, args)
        return args.type == "lobc_aspiration"
    end
})

-- Today's Expression / Today's Shy Look
SMODS.Achievement({
    key = "todays_expression",
    order = 13,
    bypass_all_unlocked = true,
    hidden_text = false,
    unlock_condition = function(self, args)
        return args.type == "lobc_todays_expression"
    end
})

-- Tough / You're Bald...
SMODS.Achievement({
    key = "tough",
    order = 14,
    bypass_all_unlocked = true,
    hidden_text = false,
    unlock_condition = function(self, args)
        return args.type == "lobc_observe_abno" and args.card.config.center.key == "j_lobc_youre_bald"
    end
})

-- Blind Rage / The Servant of Wrath
SMODS.Achievement({
    key = "blind_rage",
    order = 15,
    bypass_all_unlocked = true,
    hidden_text = false,
    unlock_condition = function(self, args)
        return args.type == "lobc_blind_rage"
    end
})