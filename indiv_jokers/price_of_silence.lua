-- hokma balls

local joker = {
    name = "The Price of Silence",
    config = {extra = {
        elapsed = 0, seconds = 0, active = false
    }}, rarity = 3, cost = 7,
    pos = {x = 5, y = 8}, 
    blueprint_compat = false, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "he",
    discover_rounds = 7,
    loc_txt = {},
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
                        attention_text({
                            text = localize('k_lobc_price_of_silence_1'),
                            scale = 0.35, 
                            hold = 4*G.SETTINGS.GAMESPEED,
                            major = G.play,
                            backdrop_colour = G.C.CLEAR,
                            align = 'cm',
                            offset = {x = 0, y = -3.5},
                            silent = true
                        })
                        attention_text({
                            text = localize('k_lobc_price_of_silence_2'),
                            scale = 0.35, 
                            hold = 4*G.SETTINGS.GAMESPEED,
                            major = G.play,
                            backdrop_colour = G.C.CLEAR,
                            align = 'cm',
                            offset = {x = 0, y = -3.1},
                            silent = true
                        })
                        return true 
                        end 
                    }))

                    play_sound("lobc_silence_destroy", 1, 0.5)
                end
            end
        end
    end
end

joker.calculate = function(self, card, context)
    if context.setting_blind and not card.getting_sliced then
        card.ability.extra.elapsed = 0
        card.ability.extra.seconds = 0
        card.ability.extra.active = true
    end
    
    if context.before and context.cardarea == G.jokers and not context.blueprint then
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
                    rightmost.ability.price_of_silence_amplified = true
                    rightmost:lobc_check_amplified()
                    rightmost:flip()
                return true end }))
            end
        end
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { 
        card:check_rounds(2), card:check_rounds(5), card:check_rounds(7),
        colours = {HEX("004d00")}
    }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(5) < 5 then
        desc_key = 'dis_'..desc_key..'_2'
    else
        info_queue[#info_queue+1] = {key = 'lobc_amplified', set = 'Other'}
        if card:check_rounds(7) < 7 then
            desc_key = 'dis_'..desc_key..'_3'
        end
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
        local check = (card.ability.extra.active and G.STAGE == G.STAGES.RUN and G.STATE == G.STATES.SELECTING_HAND)
        desc_nodes[#desc_nodes+1] = {
            {n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
                {n=G.UIT.C, config={ref_table = self, align = "m", colour = check and G.C.GREEN or G.C.RED, r = 0.05, padding = 0.06}, nodes={
                    {n=G.UIT.T, config={text = ' '..localize(check and 'k_lobc_active' or 'k_lobc_inactive')..' ',colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.9}},
                }}
            }}
        }
    end
end

return joker

-- p + space: the fight