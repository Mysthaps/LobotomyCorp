local skill = {
    name = "Insidious Pallidification",
    atlas = "what_skills",
    pos = {x = 3, y = 1},
}

skill.loc_vars = function(self, info_queue, skill)
    info_queue[#info_queue+1] = {key = 'lobc_shield', set = 'Other'}
end

skill.calculate = function(self, skill, context)
    if context.before then
        G.GAME.blind.shield_value = math.floor(G.GAME.blind.chips * (0.1 + 0.005 * G.GAME.blind.ego))
        skill.triggered = true
    end

    if context.after then 
        for _ = 1, math.floor(G.GAME.blind.ego/10) + 1 do
            --G.E_MANAGER:add_event(Event({trigger = "before", func = function() 
                if G.GAME.blind.shield_value > 0 then
                    local available_cards = {}
                    for _, v in ipairs(G.hand.cards) do
                        if not v.ability.eternal and not v.marked_destroy then available_cards[#available_cards+1] = v end
                    end

                    if #available_cards > 0 then
                        local selected_card = pseudorandom_element(available_cards, pseudoseed("what_p3s3"))
                        selected_card.marked_destroy = true
                        G.E_MANAGER:add_event(Event({
                            trigger = "before",
                            delay = 0.5,
                            func = function()
                                mod_sp("p", "add", -5)
                                card_eval_status_text(G.deck, 'extra', nil, nil, nil, {message = "-5 SP", colour = G.C.RED, instant = true, no_juice = true})
                                selected_card:start_dissolve()
                                play_sound("lobc_what_p3s3", math.random(90, 110)/100, 0.5)
                                delay(0.2)
                                SMODS.calculate_context({remove_playing_cards = true, removed = {selected_card}})
                            return true 
                            end 
                        }))
                    end
                end
            --return true end }))
        end
    end
end

return skill