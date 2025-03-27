local skill = {
    name = "Murky Innocence",
    atlas = "what_skills",
    pos = {x = 3, y = 0},
}

skill.set_ability = function(self, skill, initial, delay_sprites)
    skill.ability.chosen_hand = "High Card"
    local size = 0
    for _, v in ipairs(G.handlist) do
        size = size + G.GAME.hands[v].played
    end
    local chosen_num = pseudorandom("what_p1s3", 1, size)
    for _, v in ipairs(G.handlist) do
        chosen_num = chosen_num - G.GAME.hands[v].played
        if chosen_num <= 0 then
            skill.ability.chosen_hand = v
            break
        end
    end
end

skill.loc_vars = function(self, info_queue, skill)
    return {vars = {localize(skill.ability.chosen_hand, 'poker_hands')}}
end

skill.calculate = function(self, skill, context)
    if context.after then
        if context.scoring_name == skill.ability.chosen_hand then
            skill.triggered = true
            G.E_MANAGER:add_event(Event({trigger = "before", delay = 0.5, func = function() 
                G.E_MANAGER:add_event(Event({trigger = 'before', func = function() 
                    play_sound("lobc_what_p1s3", 1, 0.5)
                return true end }))
                mod_sp("p", "add", -10)
                SMODS.calculate_effect({
                    message = "-10 SP",
                    colour = G.C.RED,
                    no_juice = true
                }, G.deck)
            return true end }))
        end
        return {}
    end
end

return skill