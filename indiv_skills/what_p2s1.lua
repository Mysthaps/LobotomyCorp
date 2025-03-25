local skill = {
    name = "Swathed Fear",
    atlas = "what_skills",
    pos = {x = 1, y = 1},
}

skill.loc_vars = function(self, info_queue, skill)
    info_queue[#info_queue+1] = {key = 'lobc_prey_mark', set = 'Other'}
end

skill.calculate = function(self, skill, context)
    if context.before then
        prey_mark_card(context)
    end

    if context.after then
        local available_cards = {}
        for _, v in ipairs(context.scoring_hand) do
            if not v.ability.prey_marked and not v.ability.eternal then available_cards[#available_cards+1] = v end
        end

        if #available_cards > 0 then
            local selected_card = pseudorandom_element(available_cards, pseudoseed("what_p2s1"))
            skill.triggered = true
            G.E_MANAGER:add_event(Event({
                trigger = "before",
                delay = 0.5,
                func = function()
                    selected_card:start_dissolve()
                    play_sound("lobc_what_p2s1", math.random(90, 110)/100, 0.5)
                    delay(0.2)
                    SMODS.calculate_context({remove_playing_cards = true, removed = {selected_card}})
                return true 
                end 
            }))
        end
        return {}
    end
end

return skill