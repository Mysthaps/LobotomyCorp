local skill = {
    name = "Clouded Path",
    atlas = "what_skills",
    pos = {x = 2, y = 0},
}

skill.loc_vars = function(self, info_queue, skill)
    info_queue[#info_queue+1] = {key = 'lobc_prey_mark', set = 'Other'}
end

skill.calculate = function(self, skill, context)
    if G.STATE == G.STATES.HAND_PLAYED and context.modify_scoring_hand and not context.other_card.ability.p3s1_activated then
        if #context.scoring_hand <= 2 then
            local destroyed_cards = {}
            local first = true
            for _, card in pairs(context.scoring_hand) do
                if card == context.other_card or SMODS.always_scores(context.other_card) or next(find_joker('Splash')) then
                    context.other_card.ability.p3s1_activated = true
                    context.other_card:start_dissolve()
                    skill.triggered = true
                    destroyed_cards[#destroyed_cards+1] = context.other_card
                    if first then play_sound("lobc_what_p3s1", math.random(90, 110)/100, 0.5) end
                    first = nil
                    delay(0.23)
                end
            end
            mod_sp("p", "add", -10)
            SMODS.calculate_effect({
                message = "-10 SP",
                colour = G.C.RED,
                no_juice = true
            }, G.deck)
            SMODS.calculate_context({remove_playing_cards = true, removed = destroyed_cards})
            return {
                remove_from_hand = true
            }
        end
    end

    if context.before then
        prey_mark_card(context)
    end

    if context.after then return {} end
end

return skill