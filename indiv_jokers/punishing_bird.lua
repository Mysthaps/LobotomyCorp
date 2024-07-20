local joker = {
    name = "Punishing Bird",
    config = {extra = {mult = 15, rounds_played = 0}}, rarity = 1, cost = 5,
    pos = {x = 0, y = 3}, 
    blueprint_compat = true, 
    eternal_compat = false,
    perishable_compat = false,
    abno = true,
    risk = "teth",
    discover_rounds = 8,
    loc_txt = {},
}

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
            if not card.edition or (card.edition and not card.edition.negative) then
                card:set_edition({negative = true})
            end
        end
    end

    if context.selling_self and G.STATE ~= G.STATES.GAME_OVER then
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('lobc_punishing_bird_hit', 1, 0.8)
                return true
            end
        }))
        G.GAME.lobc_death_text = localize("k_lobc_punishing_bird")
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
    local vars = { card.ability.extra.mult, card.ability.extra.rounds_played, card:check_rounds(2), card:check_rounds(4), card:check_rounds(8) }
    local desc_key = self.key
    if card:check_rounds(3) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(4) < 4 then
        desc_key = 'dis_'..desc_key..'_2'
    elseif card:check_rounds(8) < 8 then
        desc_key = 'dis_'..desc_key..'_3'
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
    end
end

if SMODS.Mods.JokerDisplay then
    JokerDisplay.Definitions.j_lobc_punishing_bird = {
        text = {
            { text = "+" },
            { ref_table = "card.ability.extra", ref_value = "mult" }
        },
        text_config = { colour = G.C.MULT },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.ability.extra", ref_value = "rounds_played", colour = G.C.IMPORTANT },
            { text = ")" }
        },
        style_function = function(card, text, reminder_text, extra)
            if text then 
                text.states.visible = card:check_rounds(2) >= 2
            end
            if reminder_text then
                reminder_text.states.visible = card:check_rounds(4) >= 4
            end
            if extra then
            end
            return false
        end
    }
end

return joker

-- birds are supposed to be high