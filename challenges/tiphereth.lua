local config = SMODS.current_mod.config
local chal = {
    name = "Central Command",
    rules = {
        custom = {
            {id = "lobc_tiphereth"},
            {id = "lobc_ordeals"},
            {id = "lobc_fast_ante_2"},
            {id = "lobc_end_ante", value = 10}
        },
    },
    restrictions = {
        banned_tags = {
            {id = 'tag_boss'}
        },
        banned_cards = {
            {id = 'j_luchador'},
            {id = 'j_chicot'},
            {id = 'v_directors_cut'},
            {id = 'v_retcon'},
        },
    },
    unlocked = function(self)
        local count = 0
        for _, v in pairs({"malkuth", "yesod", "netzach", "hod"}) do
            if G.PROFILES[G.SETTINGS.profile].challenge_progress.completed["c_lobc_"..v] then count = count + 1 end
        end
        return count >= 3 or config.unlock_challenges
    end
}

return chal