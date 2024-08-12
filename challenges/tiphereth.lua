local chal = {
    rules = {
        custom = {
            {id = "lobc_ordeals"},
            {id = "lobc_fast_ante_2"},
            {id = "lobc_midnight_endgame"},
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
        banned_other = {
            {id = 'bl_final_acorn', type = 'blind'},
        }
    },
    unlocked = function(self)
        return true
    end
}

return chal