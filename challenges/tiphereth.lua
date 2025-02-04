local config = SMODS.current_mod.config
local chal = {
    name = "Central Command",
    rules = {
        custom = {
            {id = "lobc_end_ante", value = 10},
            {id = "lobc_tiphereth"},
            {id = "lobc_fast_ante_2"},
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
}

return chal