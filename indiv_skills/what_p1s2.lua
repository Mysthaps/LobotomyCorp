local skill = {
    name = "Weight of Guilt",
    atlas = "what_skills",
    pos = {x = 0, y = 1},
}

skill.calculate = function(self, skill, context)
    if context.before then
        mod_ego("add", -3)
        play_sound("lobc_what_p1", 1, 0.7)
    end
    if context.after then
        local cards = shallow_copy(G.hand.cards)
        table.sort(cards, function(a, b) 
            if SMODS.has_no_rank(a) then return false end
            if SMODS.has_no_rank(b) then return true end
            return a:get_id() < b:get_id()
        end)
        -- Sort twice because Lua sorting is fucked up beyond repair
        table.sort(cards, function(a, b) 
            if SMODS.has_no_rank(a) then return false end
            if SMODS.has_no_rank(b) then return true end
            return a:get_id() < b:get_id()
        end)
        
        local destroyed_cards = {}
        local first = true
        local sp_loss = 0
        G.E_MANAGER:add_event(Event({
            trigger = "before",
            delay = 0.5,
            func = function()
                for i = 1, math.min(#cards, 3) do
                    local _card = cards[i]
                    if i <= 3 and not SMODS.is_eternal(_card) then
                        skill.triggered = true
                        if not SMODS.has_no_rank(_card) then
                            sp_loss = sp_loss + _card:get_id()
                        end
                        destroyed_cards[#destroyed_cards+1] = _card
                        _card:start_dissolve() 
                        if first then play_sound("lobc_what_p1s2", math.random(90, 110)/100, 0.5) end
                        first = nil
                        delay(0.23)
                    end
                end
                delay(0.2)
                if #destroyed_cards > 0 and sp_loss > 0 then
                    mod_sp("p", "add", -sp_loss)
                    SMODS.calculate_effect({
                        message = "-"..sp_loss.." SP",
                        colour = G.C.RED,
                        no_juice = true
                    }, G.deck)
                end
                SMODS.calculate_context({remove_playing_cards = true, removed = destroyed_cards})
            return true 
            end 
        }))
    end
end

return skill