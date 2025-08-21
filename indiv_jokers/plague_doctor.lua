local joker = {
    name = "Plague Doctor",
    config = {extra = {mult = 20, apostles = 0}}, rarity = 1, cost = 4,
    pos = {x = 1, y = 2}, 
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    abno = true,
    risk = "zayin",
    discover_rounds = {2, 4, 4},
    no_pool_flag = "plague_doctor_breach",
}

joker.calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card and context.other_card.ability.plague_doctor_baptism then
        return {
            mult = card.ability.extra.mult,
            card = context.blueprint_card or card,
        }
    end

    if context.cardarea == G.jokers and not context.blueprint then
        if context.before and context.full_hand then
            local card_to_mark = nil

            -- Check in played
            for k, v in ipairs(context.full_hand) do
                if v.ability and not v.ability.plague_doctor_baptism then
                    card_to_mark = context.full_hand[k]
                    break
                end
            end

            -- Check in hand
            if not card_to_mark then
                for k, v in ipairs(G.hand.cards) do
                    if v.ability and not v.ability.plague_doctor_baptism then
                        card_to_mark = G.hand.cards[k]
                        break
                    end
                end
            end

            -- Check in deck
            if not card_to_mark then
                for k, v in ipairs(G.deck.cards) do
                    if v.ability and not v.ability.plague_doctor_baptism then
                        card_to_mark = G.deck.cards[k]
                        break
                    end
                end
            end

            if card_to_mark then
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = function()
                        card:juice_up()
                        card_to_mark:juice_up()
                        card_to_mark.ability.plague_doctor_baptism = true
                    return true
                    end
                }))
            end

            -- Increase the apostle count regardless of blessed cards
            card.ability.extra.apostles = card.ability.extra.apostles + 1
            -- Show text. I don't care if you go so fast that it overlaps
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('lobc_plague_doctor_bell', 1, 0.4)
                    return true
                end
            }))
            if not G.GAME.modifiers.lobc_all_whitenight then
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    lobc_screen_text({
                        text = localize('k_lobc_plague_apostle_'..card.ability.extra.apostles..'_1'),
                        scale = 0.35, 
                        hold = 6*G.SETTINGS.GAMESPEED,
                        major = G.play,
                        backdrop_colour = G.C.CLEAR,
                        align = 'cm',
                        offset = {x = 0, y = -3.5},
                        noisy = false,
                        float = false
                    })
                    lobc_screen_text({
                        text = localize('k_lobc_plague_apostle_'..card.ability.extra.apostles..'_2'),
                        scale = 0.35, 
                        hold = 6*G.SETTINGS.GAMESPEED,
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
            end

            -- Breach.
            if card.ability.extra.apostles >= 12 and not G.GAME.modifiers.lobc_all_whitenight then
                for _, v in ipairs(G.jokers.cards) do
                    if v.config.center.key == "j_lobc_plague_doctor" then
                        abno_breach(v, 1)
                    end
                end
                G.GAME.pool_flags["plague_doctor_breach"] = true
                check_for_unlock({type = "lobc_bless"})
            end
        end
    end
end

joker.add_to_deck = function(self, card, from_debuff)
    -- Debuffs self if another Plague Doctor already exists
    local found_dupe = false
    for _, v in ipairs(G.jokers.cards) do
        if v ~= card and v.config.center.key == "j_lobc_plague_doctor" then
            SMODS.debuff_card(v, true, 'plague_doctor_perma_debuff')
            card.ability.perma_debuff = true
            card.ability.eternal = false
            found_dupe = true
        end
    end

    if G.GAME.modifiers.lobc_all_whitenight and not found_dupe then
        G.E_MANAGER:add_event(Event({
            func = function()
                card.ability.eternal = true
                return true
            end
        }))
    end
end

joker.discover_override = function(self, level, card)
    if level == 3 and (not G.P_BLINDS["bl_lobc_whitenight"].discovered or card:check_rounds() < 4) then
        return "lobc_obs_plague_doctor_3"
    end
end

joker.loc_vars = function(self, info_queue, card)
    if card:check_rounds() >= 2 then info_queue[#info_queue+1] = {key = 'lobc_bless_order', set = 'Other'} end
    return {vars = {card.ability.extra.mult, card.ability.extra.apostles}}
end

if JokerDisplay then
    JokerDisplay.Definitions.j_lobc_plague_doctor = {
        text = {
            { text = "+", colour = G.C.MULT },
            {
                ref_table = "card.joker_display_values",
                ref_value = "mult",
                colour = G.C.MULT
            }
        },

        calc_function = function(card)
            local mult = 0
            local hand = next(G.play.cards) and G.play.cards or G.hand.highlighted
            local _, _, scoring_hand = JokerDisplay.evaluate_hand(hand)

            for i = 1, #scoring_hand do
                if not scoring_hand[i].debuff and scoring_hand[i].ability.plague_doctor_baptism then
                    mult = mult + card.ability.extra.mult
                end
            end

            card.joker_display_values.mult = mult
        end,

        style_function = function(card, text, reminder_text, extra)
            if text then 
                text.states.visible = card:check_rounds(4) >= 4
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

-- day 11 jumpscare