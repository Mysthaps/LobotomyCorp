local chal = {
    rules = {
        custom = {
            {id = "lobc_malkuth"},
            {id = "lobc_malkuth_2"},
            {id = "lobc_malkuth_3"},
            {id = "lobc_malkuth_4"},
            {id = "lobc_ordeals"},
            {id = "lobc_fast_ante_1"},
        },
    },
    restrictions = {
        banned_other = {
            {id = 'bl_final_acorn', type = 'blind'},
        }
    },
    unlocked = function(self)
        return true
    end
}

return chal