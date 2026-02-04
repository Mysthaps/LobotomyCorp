local config = SMODS.current_mod.config
local chal = {
    name = "Energy Production",
    rules = {
        custom = {
            { id = "no_shop_jokers" },
            { id = "lobc_production" },
            { id = "lobc_production_2" },
            { id = "lobc_production_3" }
        },
    },
    restrictions = {
        banned_cards = {
            { id = 'j_luchador' },
            { id = 'j_chicot' },
            { id = 'j_lobc_shelter' },
            { id = 'v_directors_cut' },
            { id = 'v_retcon' },
            { id = 'c_judgement' },
            { id = 'c_wraith' },
            { id = 'c_soul' },
            { id = 'p_buffoon_normal_1', ids = {
                'p_buffoon_normal_1', 'p_buffoon_normal_2', 'p_buffoon_jumbo_1', 'p_buffoon_mega_1',
            }},
            { id = 'p_lobc_extraction_base', ids = {
                'p_lobc_extraction_base', 'p_lobc_extraction_base_elite', 'p_lobc_extraction_risky', 'p_lobc_extraction_risky_elite',
                'p_lobc_extraction_calm', 'p_lobc_extraction_calm_elite', 'p_lobc_extraction_mega', 'p_lobc_extraction_mega_elite'
            }}
        },
        banned_tags = {
            { id = 'tag_rare' },
            { id = 'tag_uncommon' },
            { id = 'tag_holo' },
            { id = 'tag_polychrome' },
            { id = 'tag_negative' },
            { id = 'tag_foil' },
            { id = 'tag_buffoon' },
            { id = 'tag_top_up' },
            { id = 'tag_boss' }
        },
    },
    unlocked = function(self)
        return true
    end
}

if (SMODS.Mods.Cryptid or {}).can_load then
    local cry_config = SMODS.load_mod_config({id = "Cryptid", path = SMODS.Mods.Cryptid.path})

    if cry_config["Misc."] then
        table.insert(chal.restrictions.banned_cards, {id = 'p_cry_meme_1', ids = {
            'p_cry_meme_1', 'p_cry_meme_two', 'p_cry_meme_three' -- i hate you so much
        }})
        table.insert(chal.restrictions.banned_tags, {id = 'tag_cry_empowered'})
        table.insert(chal.restrictions.banned_tags, {id = 'tag_cry_bundle'})
        table.insert(chal.restrictions.banned_tags, {id = 'tag_cry_schematic'})
        if cry_config["Epic Jokers"] then
            table.insert(chal.restrictions.banned_tags, {id = 'tag_cry_epic'})
        end
    end
    if cry_config["Code Cards"] then
        table.insert(chal.restrictions.banned_cards, {id = 'c_cry_commit'})
        table.insert(chal.restrictions.banned_cards, {id = 'c_cry_pointer'})
        if cry_config["Misc."] then
            table.insert(chal.restrictions.banned_cards, {id = 'c_cry_spaghetti'})
        end
    end
end
if (SMODS.Mods.MoreJokerPacks or {}).can_load then
    local packs = {
        'p_mjp_common_buffoon_pack', 'p_mjp_uncommon_buffoon_pack', 'p_mjp_rare_buffoon_pack', 'p_mjp_legendary_buffoon_pack'
    }
    if (SMODS.Mods.Cryptid or {}).can_load then
        table.insert(packs, 'p_mjp_epic_buffoon_pack')
        table.insert(packs, 'p_mjp_exotic_buffoon_pack')
    end
    table.insert(chal.restrictions.banned_cards, {id = 'p_mjp_common_buffoon_pack', ids = packs})
end

-- Open a Base Extraction Pack (Elite) after each Ante
local update_shopref = Game.update_shop
function Game.update_shop(self, dt)
    update_shopref(self, dt)
    if not G.GAME.modifiers.lobc_production then return end
    if G.GAME.round_resets.ante <= G.GAME.production_last_pack then return end
    G.GAME.production_last_pack = G.GAME.round_resets.ante
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        func = function()
            if G.STATE_COMPLETE then
                local card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W*1.27/2,
                G.play.T.y + G.play.T.h/2-G.CARD_H*1.27/2, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS["p_lobc_extraction_base_elite"], {bypass_discovery_center = true, bypass_discovery_ui = true})
                card.cost = 0
                G.FUNCS.use_card({config = {ref_table = card}})
                card:start_materialize()
                return true
            end
        end
    }))
end

return chal