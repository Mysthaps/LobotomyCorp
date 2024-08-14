local chal = {
    rules = {
        custom = {
            {id = "lobc_yesod"},
            {id = "lobc_yesod_2"},
            {id = "lobc_yesod_3"},
            {id = "lobc_yesod_4"},
            {id = "lobc_ordeals"},
            {id = "lobc_fast_ante_1"},
        },
    },
    restrictions = {
        banned_tags = {
            {id = 'tag_boss'},
            {id = 'tag_foil'},
            {id = 'tag_holo'},
            {id = 'tag_polychrome'},
            {id = 'tag_negative'}
        },
        banned_cards = {
            {id = 'c_wheel_of_fortune'},
            {id = 'c_aura'},
            {id = 'c_ectoplasm'},
            {id = 'c_hex'},
            {id = 'j_luchador'},
            {id = 'j_chicot'},
            {id = 'j_perkeo'},
            {id = 'j_lobc_old_faith'},
            {id = 'j_lobc_scarecrow_searching'},
            {id = 'v_hone'},
            {id = 'v_glow_up'},
            {id = 'v_directors_cut'},
            {id = 'v_retcon'},
        },
    },
    unlocked = function(self)
        return true
    end
}

if (SMODS.Mods.Cryptid or {}).can_load then
    local cry_config = Cryptid_config or SMODS.Mods.Cryptid.config

    if cry_config["Code Cards"] then
        table.insert(chal.restrictions.banned_cards, {id = 'c_cry_malware'})
        table.insert(chal.restrictions.banned_cards, {id = 'c_cry_spaghetti'})
        table.insert(chal.restrictions.banned_cards, {id = 'c_cry_machinecode'})
    end

    if cry_config["Spectrals"] then
        table.insert(chal.restrictions.banned_cards, {id = 'c_cry_typhoon'})
    end

    if cry_config["Misc. Jokers"] then
        table.insert(chal.restrictions.banned_cards, {id = 'j_cry_meteor'})
        table.insert(chal.restrictions.banned_cards, {id = 'j_cry_exoplanet'})
        table.insert(chal.restrictions.banned_cards, {id = 'j_cry_stardust'})
        table.insert(chal.restrictions.banned_cards, {id = 'j_cry_queens_gambit'})
    end
end

if (SMODS.Mods.Bunco or {}).can_load then
    table.insert(chal.restrictions.banned_cards, {id = 'c_bunc_cleanse'})
    table.insert(chal.restrictions.banned_cards, {id = 'j_bunc_juggalo'})
    table.insert(chal.restrictions.banned_cards, {id = 'j_bunc_puzzle_board'})
    table.insert(chal.restrictions.banned_cards, {id = 'j_bunc_running_joke'})
    table.insert(chal.restrictions.banned_cards, {id = 'j_bunc_roygbiv'})
    table.insert(chal.restrictions.banned_cards, {id = 'v_bunc_lamination'})
    table.insert(chal.restrictions.banned_cards, {id = 'v_bunc_supercoating'})
    
    table.insert(chal.restrictions.banned_tags, {id = 'tag_bunc_glitter'})
    table.insert(chal.restrictions.banned_tags, {id = 'tag_bunc_fluorescent'})
end

if (SMODS.Mods.JankJonklersMod or {}).can_load then
    table.insert(chal.restrictions.banned_cards, {id = 'j_jank_shady_dealer'})
end

if (SMODS.Mods.TWEWY or {}).can_load then
    table.insert(chal.restrictions.banned_cards, {id = 'j_twewy_aquaGhost'})
    table.insert(chal.restrictions.banned_cards, {id = 'j_twewy_live'})
    table.insert(chal.restrictions.banned_cards, {id = 'j_twewy_topGear'})
    table.insert(chal.restrictions.banned_cards, {id = 'j_twewy_chaos'})
    table.insert(chal.restrictions.banned_cards, {id = 'j_twewy_cutieBeam'})
    table.insert(chal.restrictions.banned_cards, {id = 'j_twewy_playmateBeam'})
end

return chal