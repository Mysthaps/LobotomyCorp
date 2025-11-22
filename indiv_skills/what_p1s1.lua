local skill = {
    name = "Undying Soul",
    config = {extra = {triggers = 2}},
    atlas = "what_skills",
    pos = {x = 0, y = 2},
}

skill.set_ability = function(self, skill, initial, delay_sprites)
    skill.ability.extra.triggers = 2
end

skill.loc_vars = function(self, info_queue, skill)
    return {vars = {50 + G.GAME.blind.b_sp}}
end

skill.calculate = function(self, skill, context)
    if G.STATE == G.STATES.HAND_PLAYED and context.modify_scoring_hand and skill.ability.extra.triggers > 0 then 
            for _, card in pairs(context.scoring_hand) do
                -- Activate effect on scoring cards only
                if card == context.other_card or SMODS.always_scores(context.other_card) or next(find_joker('Splash')) and not context.other_card.ability.what_activated then 
                    skill.triggered = true
                    if not context.other_card.ability.p1s1_activated then
                        if not SMODS.has_no_rank(context.other_card) and context.other_card:get_id() <= 8
                        and pseudorandom("what_evade") > 0.5 + G.GAME.blind.b_sp * 0.01 then
                            G.E_MANAGER:add_event(Event({trigger = 'before', func = function() 
                                play_sound("lobc_evade", 1, 0.8)
                            return true end }))
                            SMODS.calculate_effect({
                                message = localize("k_lobc_evade"),
                                colour = G.C.RED,
                            }, context.other_card)
                            delay(0.2)
                            context.other_card.ability.p1s1_activated = true
                            return {
                                remove_from_hand = true,
                            }
                        else
                            G.E_MANAGER:add_event(Event({trigger = 'before', func = function() 
                                play_sound("lobc_coin_fail", 1, 0.9)
                                mod_ego("add", -2)
                            return true end }))
                            SMODS.calculate_effect({
                                message = localize("k_lobc_fail_evade"),
                                colour = G.C.BLUE,
                                extra = (skill.ability.extra.triggers == 1 and {message = localize("k_lobc_skill_disable"), colour = G.C.RED})
                            }, context.other_card)
                            delay(0.2)
                            
                            skill.ability.extra.triggers = skill.ability.extra.triggers - 1
                            context.other_card.ability.p1s1_activated = true
                            return {}
                        end
                    end
                end
            end
    end
end

return skill