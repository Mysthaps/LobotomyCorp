local joker = {
    name = "Scorched Girl",
    config = {extra = 30}, rarity = 2, cost = 5,
    pos = {x = 1, y = 0}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "teth",
    discover_rounds = {2, 4},
}

joker.calculate = function(self, card, context)
    if context.setting_blind and not card.getting_sliced then
        G.E_MANAGER:add_event(Event({
            func = function() 
                card:juice_up()
                -- i took this from TheAutumnCircus' Mr. Bones' Stamp
                local chips = (G.GAME.blind.chips * ((100 - card.ability.extra)/100))
                if type(chips) == 'table' then chips:ceil() else chips = math.ceil(chips) end
                G.GAME.blind.chips = chips
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips)
                G.HUD_blind:recalculate() 
                G.hand_text_area.blind_chips:juice_up()
                play_sound('chips2')
            return true
            end
        }))
    end
    if context.first_hand_drawn then
        G.E_MANAGER:add_event(Event({
            func = function() 
                for _, v in ipairs(G.hand.cards) do
                    SMODS.debuff_card(v, true, 'scorched_girl_debuff')
                end
            return true
            end
        }))
    end
    if context.end_of_round and not context.blueprint and context.main_eval then
        for _, v in ipairs(G.playing_cards) do
            SMODS.debuff_card(v, false, 'scorched_girl_debuff')
        end
    end
end

joker.remove_from_deck = function(self, card, from_debuff)
    for _, v in ipairs(G.playing_cards) do
        SMODS.debuff_card(v, false, 'scorched_girl_debuff')
    end
end

joker.loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra}}
end

if JokerDisplay then
    JokerDisplay.Definitions.j_lobc_scorched_girl = {
        text = {
            { text = "-" },
            { ref_table = "card.ability", ref_value = "extra" },
            { text = "%" },
        },
        text_config = { colour = G.C.IMPORTANT },
        style_function = function(card, text, reminder_text, extra)
            if text then 
                text.states.visible = card:check_rounds(2) >= 2
            end
            if reminder_text then
            end
            if extra then
            end
            return false
        end
    }
end

return joker

-- I AM FIRE
-- BURN THOSE WHO DARE TO CARE FOR ME

-- AND MY FUEL ARE MEMORIES
-- FUEL ARE MEMORIES OF YOU

-- THEY PERISH WITH THE HEAT
-- PERISH WITH THE HEAT

-- SO I CAN MOVE ON