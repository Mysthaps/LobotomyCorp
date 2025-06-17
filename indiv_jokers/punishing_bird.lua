local joker = {
    name = "Punishing Bird",
    config = {extra = {mult = 15, rounds_played = 0, start_apoc = false}}, rarity = 1, cost = 5,
    pos = {x = 0, y = 3}, 
    blueprint_compat = true, 
    eternal_compat = false,
    perishable_compat = false,
    abno = true,
    risk = "teth",
    discover_rounds = {2, 4, 6},
    no_pool_flag = "apocalypse_bird_event",
}

joker.calculate = function(self, card, context)
    if context.joker_main then
        return {
            mult = card.ability.extra.mult,
            card = context.blueprint_card or card,
        }
    end

    if context.end_of_round and not context.blueprint and context.main_eval then
        card.ability.extra.rounds_played = card.ability.extra.rounds_played + 1
        if card.ability.extra.rounds_played >= 9 then
            if not card.edition or (card.edition and not card.edition.negative) then
                card:set_edition("e_negative")
            end
        end
    end

    if context.selling_self and G.STATE ~= G.STATES.GAME_OVER then
        if card.ability.extra.start_apoc then
            for _, birb in ipairs({"j_lobc_punishing_bird", "j_lobc_big_bird", "j_lobc_judgement_bird"}) do
                for _, v in ipairs(SMODS.find_card(birb, true)) do
                    abno_breach(v, 0.5)
                end
            end
            G.GAME.pool_flags["apocalypse_bird_event"] = true
        else
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('lobc_punishing_bird_hit', 1, 0.8)
                    return true
                end
            }))
            G.GAME.lobc_death_text = "punishing_bird"
            check_for_unlock({type = "lobc_beak"})
            G.STATE = G.STATES.GAME_OVER
            if not G.GAME.won and not G.GAME.seeded and not G.GAME.challenge then 
                G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt = 0
            end
            G:save_settings()
            G.FILE_HANDLER.force = true
            G.STATE_COMPLETE = false
        end
    end
end

joker.add_to_deck = function(self, card, from_debuff)
    if not G.GAME.pool_flags["apocalypse_bird_event"] and not from_debuff and next(SMODS.find_card("j_lobc_judgement_bird")) and next(SMODS.find_card("j_lobc_big_bird")) then
        card.ability.extra.start_apoc = true
        card.children.alert = UIBox{
            definition = create_UIBox_card_alert(), 
            config = {
                align = "tri",
                offset = {
                    x = 0.1, y = 0
                },
                parent = card
            }
        }
        check_for_unlock({type = "lobc_through_the_dark_twilight"})
    end
end

local card_hoverref = Card.hover
function Card.hover(self)
    if self.config.center.key == "j_lobc_punishing_bird" and self.area == G.jokers and self.children.alert then
        self.children.alert = nil
    end
    card_hoverref(self)
end

joker.loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.mult, card.ability.extra.rounds_played}, key = (card.ability.extra.start_apoc and "j_lobc_punishing_bird_apoc" or nil)}
end

if JokerDisplay then
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