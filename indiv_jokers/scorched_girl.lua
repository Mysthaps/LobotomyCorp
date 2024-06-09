local joker = {
    name = "Scorched Girl",
    config = {extra = 30}, rarity = 2, cost = 5,
    pos = {x = 1, y = 0}, 
    blueprint_compat = true, 
    eternal_compat = false,
    perishable_compat = false,
    abno = true,
    discover_rounds = 4,
    loc_txt = {
        name = "Scorched Girl",
        text = {
            "{C:attention}-#1#%{} Blind Size",
            "Debuffs first hand drawn"
        }
    },
}

joker.calculate = function(self, card, context)
    if context.setting_blind and not card.getting_sliced then
        G.E_MANAGER:add_event(Event({
            func = function() 
                card:juice_up()
                -- i took this from TheAutumnCircus' Mr. Bones' Stamp
                G.GAME.blind.chips = math.floor(G.GAME.blind.chips * ((100 - card.ability.extra)/100))
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips)
                G.HUD_blind:recalculate() 
                G.hand_text_area.blind_chips:juice_up()
                play_sound('chips2')
            return true
            end
        }))
    end
    if context.first_hand_drawn then
        G.E_MANAGER:add_event(Event({
            func = function() 
                for _, v in ipairs(G.hand.cards) do
                    if not v.debuff then
                        v.debuff = true
                        v:juice_up()
                    end
                end
            return true
            end
        }))
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { card.ability.extra, card:check_rounds(2), card:check_rounds(4) }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(4) < 4 then
        desc_key = 'dis_'..desc_key..'_2'
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
end

return joker