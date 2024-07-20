local chal = {
    rules = {
        custom = {
            {id = "lobc_ordeals"},
            {id = "lobc_fast_ante_1"},
        },
    },
    restrictions = {
        banned_tags = {
            {id = 'tag_boss'}
        },
        banned_cards = {
            {id = 'j_chicot'},
            {id = 'v_directors_cut'},
            {id = 'v_retcon'},
        },
    },
    unlocked = function(self)
        return true
    end
}

return chal