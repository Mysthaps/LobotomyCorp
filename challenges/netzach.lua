local chal = {
    rules = {
        custom = {
            {id = "lobc_netzach"},
            {id = "lobc_netzach_2"},
            {id = "lobc_netzach_3"},
            {id = "lobc_netzach_4"},
            {id = "lobc_ordeals"},
            {id = "lobc_fast_ante_1"},
        },
    },
    restrictions = {
        banned_tags = {
            {id = 'tag_boss'}
        },
        banned_cards = {
            {id = 'j_burglar'},
            {id = 'j_chicot'},
            {id = 'v_directors_cut'},
            {id = 'v_retcon'},
            {id = 'v_hieroglyph'},
            {id = 'v_petroglyph'},
        },
    },
    unlocked = function(self)
        return true
    end
}

return chal