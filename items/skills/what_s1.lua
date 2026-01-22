local skill = {
    name = "Strike Me Down!",
    atlas = "what_skills",
    pos = {x = 0, y = 0},
}

skill.set_ability = function(self, skill, initial, delay_sprites)
    skill.ability.rank = "Ace"
    skill.ability.id = 14
    local valid_cards = {}
    for k, v in ipairs(G.hand.cards) do
        if not SMODS.has_no_rank(v) and not SMODS.is_eternal(v) then
            valid_cards[#valid_cards+1] = v
        end
    end
    if valid_cards[1] then 
        local _card = pseudorandom_element(valid_cards, pseudoseed('what_s1'..G.GAME.round_resets.ante))
        skill.ability.rank = _card.base.value
        skill.ability.id = _card.base.id
    end
end

skill.loc_vars = function(self, info_queue, skill)
    return {vars = {localize(skill.ability.rank, 'ranks')}}
end

skill.calculate = function(self, skill, context)
    if context.press_play then
        local destroyed_cards = {}
        local first = true
        G.E_MANAGER:add_event(Event({
            delay = 0.5,
            func = function()
                for _, v in ipairs(G.play.cards) do
                    if v.base.id == skill.ability.id and not SMODS.is_eternal(v) then
                        skill.triggered = true
                        destroyed_cards[#destroyed_cards+1] = v
                        v:start_dissolve() 
                        if first then play_sound("lobc_what_s1", math.random(90, 110)/100, 0.5) end
                        first = nil
                        delay(0.23)
                    end
                end
                delay(0.2)
                if #destroyed_cards > 0 then
                    mod_sp("p", "add", -5 * #destroyed_cards)
                    SMODS.calculate_effect({
                        message = localize{type = 'variable', key = 'lobc_a_sp_minus', vars = {5 * #destroyed_cards}},
                        colour = G.C.RED,
                        no_juice = true
                    }, G.deck)
                end
                SMODS.calculate_context({remove_playing_cards = true, removed = destroyed_cards})
            return true 
            end 
        }))
        return {}
    end
end

return skill