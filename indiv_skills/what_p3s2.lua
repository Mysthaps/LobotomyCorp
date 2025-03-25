local skill = {
    name = "Bleached Atonement",
    atlas = "what_skills",
    pos = {x = 2, y = 2},
}

skill.loc_vars = function(self, info_queue, skill)
    return {vars = {G.GAME.blind.ego*2}}
end

skill.calculate = function(self, skill, context)
    if context.before then
        mod_ego("add", -5)
        play_sound("lobc_what_p3", 1, 0.7)
    end

    if context.destroying_card then
        local sum = 0
        for _, v in ipairs(context.scoring_hand) do
            if not SMODS.has_no_rank(v) then
                sum = sum + v:get_id()
            end
        end
        if sum <= G.GAME.blind.ego*2 then
            skill.triggered = true
            G.E_MANAGER:add_event(Event({trigger = 'before', func = function() 
                play_sound("lobc_what_p3s2", 1, 0.5)
            return true end }))
            return {
                remove = true
            }
        end
    end

    if context.after then 
        G.E_MANAGER:add_event(Event({trigger = 'after', func = function() 
            if skill.triggered then
                mod_sp("p", "add", -15)
                SMODS.calculate_effect({
                    message = "-15 SP",
                    colour = G.C.RED,
                    no_juice = true
                }, G.deck)
            else
                mod_sp("b", "add", -5)
                SMODS.calculate_effect({
                    message = "-5 SP",
                    colour = G.C.RED,
                }, G.GAME.blind)
            end
        return true end }))
        return {}
    end
end

return skill