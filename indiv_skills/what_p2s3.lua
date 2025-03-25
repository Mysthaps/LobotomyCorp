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
    end
    
    if context.individual and context.cardarea == G.play and not skill.disabled then
        if not context.other_card.ability.prey_marked then
            skill.triggered = true
            local skip_sub = false
            if G.GAME.hands[context.scoring_name].level == 0 then skip_sub = true end
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize('k_all_hands'),chips = '...', mult = '...', level=''})
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
                play_sound('tarot1')
                G.TAROT_INTERRUPT_PULSE = true
                return true end }))
            update_hand_text({delay = 0}, {mult = '-', StatusText = true, neg = true})
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
                play_sound('tarot1')
                return true end }))
            update_hand_text({delay = 0}, {chips = '-', StatusText = true, neg = true})
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
                play_sound('tarot1')
                G.TAROT_INTERRUPT_PULSE = nil
                return true end }))
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level='-1', neg = true})
            delay(1.3)
            for k, v in pairs(G.GAME.hands) do
                level_up_hand(skill, k, true, -1)
            end

            if not skip_sub then
                mult = mult - (G.GAME.hands[context.scoring_name].level == 0 and G.GAME.hands[context.scoring_name].s_mult-1 or G.GAME.hands[context.scoring_name].l_mult)
                hand_chips = hand_chips - (G.GAME.hands[context.scoring_name].level == 0 and G.GAME.hands[context.scoring_name].s_chips or G.GAME.hands[context.scoring_name].l_chips)
            end
            update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = mult, chips = hand_chips, handname = context.scoring_name, level = G.GAME.hands[context.scoring_name].level})
        end
    end

    if context.destroying_card and not skill.disabled then
        for _ = 1, 5 do
            local roll = pseudorandom("what_p2s3")
            if roll < (G.GAME.blind.b_sp - G.GAME.blind.p_sp) * 0.02 then
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
                    mod_ego("add", -2)
                return true end }))
                SMODS.calculate_effect({
                    message = "Missed!",
                    colour = G.C.BLUE,
                }, context.destroying_card)
                delay(0.2)
            end
        end
        skill.disabled = true
        SMODS.calculate_effect({
            message = "Skill Disabled!",
            colour = G.C.RED,
        }, skill)
        G.E_MANAGER:add_event(Event({trigger = 'after', func = function() 
            mod_sp("b", "add", -10)
            SMODS.calculate_effect({
                message = "-10 SP",
                colour = G.C.RED,
            }, G.GAME.blind)
        return true end }))
        return {}
    end
end

return skill