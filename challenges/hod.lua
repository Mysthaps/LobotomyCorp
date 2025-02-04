local chal = {
    name = "Training",
    rules = {
        custom = {
            {id = "lobc_hod"},
            {id = "lobc_hod_2"},
            {id = "lobc_hod_3"},
            {id = "lobc_fast_ante_1"},
        },
    },
    restrictions = {
    },
    unlocked = function(self)
        return true
    end
}

return chal