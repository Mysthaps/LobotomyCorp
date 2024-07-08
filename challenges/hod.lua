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
        banned_cards = {
            {id = 'j_chicot'},
        },
    },
    unlocked = function(self)
        return true
    end
}

return chal