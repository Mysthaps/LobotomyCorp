local joker = {
    name = "Punishing Bird",
    config = {extra = {mult = 15, rounds_played = 0}}, rarity = 1, cost = 5,
    pos = {x = 0, y = 3}, 
    blueprint_compat = true, 
    eternal_compat = false,
    perishable_compat = false,
    abno = true,
    discover_rounds = 8,
    loc_txt = {
        name = "Punishing Bird",
        text = {
            "{C:mult}+#1#{} Mult",
            "{C:attention}(#3#/3){} This Abnormality gains",
            "{C:dark_edition}Negative{} after {C:attention}6{} rounds",
            "{C:attention}(#4#/8){} If this Abnormality is {C:attention}sold{},",
            "immediately {C:attention}lose{} the game",
            "{C:inactive}(Currently {C:attention}#2#{C:inactive} Rounds){}"
        }
    },
}

joker.process_loc_text = function(self)
    SMODS.Joker.process_loc_text(self)
    SMODS.process_loc_text(G.localization.descriptions["Other"], "und_j_lobc_punishing_bird", {
        name = "O-02-56",
        text = {
            "People have been committing",
            "sins since long ago.",
            "\"Why do they commit sins,",
            "knowing it's wrong?\""
        }
    })
    SMODS.process_loc_text(G.localization.descriptions["Joker"], "dis_j_lobc_punishing_bird_1", {
        name = "F-01-02",
        text = {
            "{C:mult}+#1#{} Mult",
            "{C:attention}(#3#/3){} ...",
            "{C:attention}(#4#/8){} ...",
        }
    })
    SMODS.process_loc_text(G.localization.descriptions["Joker"], "dis_j_lobc_punishing_bird_2", {
        name = "F-01-02",
        text = {
            "{C:chips}+#1#{} Mult",
            "{C:attention}(#3#/3){} This Abnormality gains",
            "{C:dark_edition}Negative{} after {C:attention}6{} rounds",
            "{C:attention}(#4#/8){} ...",
            "{C:inactive}(Currently {C:attention}#2#{C:inactive} Rounds){}"
        }
    })
end

joker.calculate = function(self, card, context)
    if context.joker_main then
        return {
            message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
            mult_mod = card.ability.extra.mult,
        }
    end

    if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
        card.ability.extra.rounds_played = card.ability.extra.rounds_played + 1
        if card.ability.extra.rounds_played == 6 then
            card:set_edition({negative = true})
        end
    end

    if context.selling_self and G.STATE ~= G.STATES.GAME_OVER then
        G.STATE = G.STATES.GAME_OVER
        if not G.GAME.won and not G.GAME.seeded and not G.GAME.challenge then 
            G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt = 0
        end
        G:save_settings()
        G.FILE_HANDLER.force = true
        G.STATE_COMPLETE = false
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { card.ability.extra.mult, card.ability.extra.rounds_played, card:check_rounds(3), card:check_rounds(8) }
    local desc_key = self.key
    if card:check_rounds(3) < 3 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(8) < 8 then
        desc_key = 'dis_'..desc_key..'_2'
    end

    if not card.config.center.discovered then
        full_UI_table.name = localize{type = 'name', key = 'und_'..self.key, set = "Other", name_nodes = {}, vars = specific_vars or {}}
    else
        full_UI_table.name = localize{type = 'name', key = self.key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    end
    localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
end

return joker