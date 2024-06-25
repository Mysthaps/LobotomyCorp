local chal = {
    rules = {
        custom = {
            {id = "lobc_all_whitenight"},
            {id = "lobc_all_whitenight_2"},
            {id = "lobc_all_whitenight_3"},
            {id = "lobc_all_whitenight_4"},
            {id = "lobc_all_whitenight_5"},
        },
        modifiers = {
            {id = 'dollars', value = 25},
            {id = 'hands', value = 5},
        }
    },
    jokers = {
        {id = 'j_lobc_plague_doctor', eternal = true, edition = 'negative'},
    },
    restrictions = {
        banned_cards = {
            {id = 'j_lobc_one_sin'},
            {id = 'j_luchador'},
            {id = 'j_chicot'},
        },
        banned_tags = {
            {id = 'tag_boss'}
        },
    },
    unlocked = function(self)
        return G.P_BLINDS.bl_lobc_whitenight.discovered
    end
}

return chal