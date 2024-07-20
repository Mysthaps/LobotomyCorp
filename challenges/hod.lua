local chal = {
    rules = {
        custom = {
            {id = "lobc_hod"},
            {id = "lobc_hod_2"},
            {id = "lobc_hod_3"},
            {id = "lobc_ordeals"},
            {id = "lobc_fast_ante_2"},
        },
    },
    restrictions = {
        banned_tags = {
            {id = 'tag_boss'}
        },
        banned_cards = {
            {id = 'j_chicot'},
            {id = 'j_lobc_iron_maiden'},
            {id = 'v_directors_cut'},
            {id = 'v_retcon'},
        },
    },
    unlocked = function(self)
        return true
    end
}

return chal