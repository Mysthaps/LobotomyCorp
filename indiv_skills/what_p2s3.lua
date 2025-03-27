local skill = {
    name = "Echoing Cry",
    atlas = "what_skills",
    pos = {x = 1, y = 2},
}

skill.loc_vars = function(self, info_queue, skill)
    return {vars = {math.min(math.max((G.GAME.blind.b_sp - G.GAME.blind.p_sp)*2, 0), 100)}}
end

skill.calculate = function(self, skill, context)
    if context.before then
        play_sound("lobc_what_p2", 1, 0.7)
        mod_sp("b", "add", 10)
        SMODS.calculate_effect({
            message = "+10 SP",
            colour = G.C.BLUE,
        }, G.GAME.blind)
    end

    if context.destroying_card and not skill.disabled then
        for _ = 1, 5 do
            local roll = pseudorandom("what_p2s3")
            if roll < (G.GAME.blind.b_sp - G.GAME.blind.p_sp) * 0.02 or not context.destroying_card.ability.prey_marked then
                skill.triggered = true
                G.E_MANAGER:add_event(Event({trigger = 'before', func = function() 
                    play_sound("lobc_what_p2s3", 1, 0.5)
                return true end }))
                SMODS.calculate_effect({
                    message = "Stabbed!",
                    colour = G.C.RED,
                }, context.destroying_card)
                mod_sp("p", "add", -5)
                SMODS.calculate_effect({
                    message = "-5 SP",
                    colour = G.C.RED,
                    no_juice = true
                }, G.deck)
                delay(0.2)
                return {
                    remove = true
                }
            else
                G.E_MANAGER:add_event(Event({trigger = 'before', func = function() 
                    play_sound("lobc_evade", 1, 0.8)
                    mod_ego("add", -1)
                return true end }))
                SMODS.calculate_effect({
                    message = "Missed!",
                    colour = G.C.BLUE,
                }, context.destroying_card)
                delay(0.2)
            end
        end
        G.E_MANAGER:add_event(Event({trigger = 'before', func = function() 
            mod_sp("b", "add", -5)
            SMODS.calculate_effect({
                message = "-5 SP",
                colour = G.C.RED,
            }, G.GAME.blind)
        return true end }))
    end

    if context.after then return {} end
end

return skill