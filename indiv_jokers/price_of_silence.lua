local joker = {
    name = "The Price of Silence",
    config = {extra = {
        elapsed = 0, seconds = 0, active = false, converted = 0,
    }}, rarity = 3, cost = 8,
    pos = {x = 5, y = 8}, 
    blueprint_compat = false, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "he",
    discover_rounds = {3, 6, 7},
}

joker.update = function(self, card, dt)
    if card.area == G.jokers and G.STAGE == G.STAGES.RUN and G.STATE == G.STATES.SELECTING_HAND and not card.debuff then
        card.ability.extra.elapsed = card.ability.extra.elapsed + (dt / G.SETTINGS.GAMESPEED)

        local available_cards = {}
        for _, v in ipairs(G.jokers.cards) do
            if v ~= card and not v.ability.eternal then available_cards[#available_cards+1] = v end
        end

        if #available_cards == 0 then
            card.ability.extra.active = false
        end
        
        if card.ability.extra.elapsed >= 1 and card.ability.extra.active then
            card.ability.extra.elapsed = card.ability.extra.elapsed - 1
            card.ability.extra.seconds = card.ability.extra.seconds + 1

            if card.ability.extra.seconds < 13 then
                play_sound("lobc_silence_tick", 1, 0.7)
            else
                card.ability.extra.active = false
                
                if #available_cards > 0 then
                    local selected_card = pseudorandom_element(available_cards, pseudoseed("price_of_silence"))
                    selected_card:start_dissolve()

                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                        lobc_screen_text({
                            text = localize('k_lobc_price_of_silence_1'),
                            scale = 0.35, 
                            hold = 4*G.SETTINGS.GAMESPEED,
                            major = G.play,
                            backdrop_colour = G.C.CLEAR,
                            align = 'cm',
                            offset = {x = 0, y = -3.5},
                            noisy = false,
                            float = false
                        })
                        lobc_screen_text({
                            text = localize('k_lobc_price_of_silence_2'),
                            scale = 0.35, 
                            hold = 4*G.SETTINGS.GAMESPEED,
                            major = G.play,
                            backdrop_colour = G.C.CLEAR,
                            align = 'cm',
                            offset = {x = 0, y = -3.1},
                            noisy = false,
                            float = false
                        })
                        return true 
                        end 
                    }))

                    play_sound("lobc_silence_destroy", 1, 0.5)
                    card.ability.extra.converted = 0
                end
            end
        end
    end
end

joker.calculate = function(self, card, context)
    if context.setting_blind and not card.getting_sliced and not context.blueprint then
        card.ability.extra.elapsed = 0
        card.ability.extra.seconds = 0
        card.ability.extra.active = true
    end

    if context.discard and not context.blueprint then
        card.ability.extra.elapsed = 0
        card.ability.extra.seconds = 0
    end
    
    if context.after and context.cardarea == G.jokers and not context.blueprint then
        card.ability.extra.elapsed = 0
        card.ability.extra.seconds = 0

        if context.scoring_hand and #context.scoring_hand > 1 and card.ability.extra.active then
            -- Copied from Death haha funny XIII tarot
            local leftmost = context.scoring_hand[1]
            local rightmost = context.scoring_hand[#context.scoring_hand]
            for i=1, #context.scoring_hand do if context.scoring_hand[i].T.x < leftmost.T.x then leftmost = context.scoring_hand[i] end end
            for i=1, #context.scoring_hand do if context.scoring_hand[i].T.x > rightmost.T.x then rightmost = context.scoring_hand[i] end end
            if rightmost ~= leftmost and not rightmost.ability.eternal then
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    play_sound('card1')
                    rightmost:flip()
                return true end }))
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    copy_card(leftmost, rightmost)
                    --rightmost.ability.price_of_silence_amplified = true
                    --rightmost:lobc_check_amplified()
                    rightmost:flip()
                return true end }))
                card.ability.extra.converted = card.ability.extra.converted + 1
            end
            if card.ability.extra.converted >= 10 then
                check_for_unlock({type = "lobc_dead_silence"})
            end
        end
    end
end

joker.loc_vars = function(self, info_queue, card)
    --if card:check_rounds() >= 4 then info_queue[#info_queue+1] = {key = 'lobc_amplified', set = 'Other'} end
    local check = (card.ability.extra.active and G.STAGE == G.STAGES.RUN and G.STATE == G.STATES.SELECTING_HAND)
    return {}
end

-- The Price of Silence amplification
local amplified_values = {
    "mult",
    "h_mult",
    "h_x_mult",
    "h_chips",
    "h_dollars",
    "p_dollars",
    "t_mult",
    "t_chips",
    "x_mult",
    "h_size",
    "d_size",
    "bonus",
}
function Card:lobc_check_amplified()
    if self.ability.price_of_silence_amplified then
        for _, v in ipairs(amplified_values) do
            if self.ability[v] and self.config.center.config[v] then
                self.ability[v] = self.ability[v] + self.config.center.config[v]
            end
        end
        -- glass card moment
        if self.ability.x_mult and self.config.center.config.Xmult then
            self.ability.x_mult = self.ability.x_mult + self.config.center.config.Xmult
        end
    end
end

return joker

-- hokma balls
-- p + space: the fight