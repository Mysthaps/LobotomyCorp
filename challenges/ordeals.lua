local chal = {
    name = "Increased Ordeals",
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
            {id = 'j_luchador'},
            {id = 'j_chicot'},
            {id = 'j_lobc_shelter'},
            {id = 'v_directors_cut'},
            {id = 'v_retcon'},
        },
    },
    unlocked = function(self)
        return true
    end
}

return chal