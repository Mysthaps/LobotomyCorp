local chal = {
    name = "Safety",
    rules = {
        modifiers = {
            {id = 'hands', value = 7},
            {id = 'discards', value = 7},
        },
        custom = {
            {id = "lobc_netzach"},
            {id = "lobc_netzach_2"},
            {id = "lobc_netzach_3"},
            {id = "lobc_netzach_4"},
            {id = "lobc_fast_ante_1"},
        },
    },
    restrictions = {
        banned_cards = {
            {id = 'j_burglar'},
            {id = 'j_lobc_heart_of_aspiration'},
            {id = 'v_hieroglyph'},
            {id = 'v_petroglyph'},
        },
    },
    unlocked = function(self)
        return true
    end
}

if (SMODS.Mods.Cryptid or {}).can_load then
    local cry_config = SMODS.load_mod_config({id = "Cryptid", path = SMODS.Mods.Cryptid.path})

    if cry_config["Misc. Jokers"] then
        table.insert(chal.restrictions.banned_cards, {id = 'j_cry_blurred'})
    end
end

if (SMODS.Mods.Bunco or {}).can_load then
    table.insert(chal.restrictions.banned_cards, {id = 'j_bunc_carnival'})
end

if (SMODS.Mods.TWEWY or {}).can_load then
    table.insert(chal.restrictions.banned_cards, {id = 'j_twewy_earthshake'})
    table.insert(chal.restrictions.banned_cards, {id = 'j_twewy_iceRisers'})
    table.insert(chal.restrictions.banned_cards, {id = 'j_twewy_iceBlow'})
    table.insert(chal.restrictions.banned_cards, {id = 'j_twewy_straitjacket'})
end

return chal