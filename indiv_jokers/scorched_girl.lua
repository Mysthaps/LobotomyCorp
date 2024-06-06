local joker = {
    name = "Scorched Girl",
    config = {extra = 20}, rarity = 2, cost = 5,
    pos = {x = 1, y = 0}, 
    blueprint_compat = true, 
    eternal_compat = false,
    perishable_compat = false,
    abno = true,
    discover_rounds = 3,
    loc_txt = {
        name = "Scorched Girl",
        text = {
            "{C:attention}-#1#%{} Blind Size",
            "{C:attention}(#2#/3){} Debuffs first hand drawn"
        }
    },
}

joker.process_loc_text = function(self)
    SMODS.Joker.process_loc_text(self)
    SMODS.process_loc_text(G.localization.descriptions["Other"], "und_j_lobc_scorched_girl", {
        name = "F-01-02",
        text = {
            "I'm coming for you.",
            "You, who will be reduced",
            "to ashes like me."
        }
    })
    SMODS.process_loc_text(G.localization.descriptions["Joker"], "dis_j_lobc_scorched_girl", {
        name = "F-01-02",
        text = {
            "{C:attention}-#1#%{} Blind Size",
            "{C:attention}(#2#/3){} ..."
        }
    })
end

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
    local vars = { card.ability.extra, card:check_rounds(3) }
    local desc_key = self.key
    if card:check_rounds(3) < 3 then
        desc_key = 'dis_'..desc_key
    end

    if not card.config.center.discovered then
        full_UI_table.name = localize{type = 'name', key = 'und_'..self.key, set = "Other", name_nodes = {}, vars = specific_vars or {}}
    else
        full_UI_table.name = localize{type = 'name', key = self.key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    end
    localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
end

return joker