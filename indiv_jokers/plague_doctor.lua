local joker = {
    name = "Plague Doctor",
    config = {extra = {mult = 20, apostles = 0}}, rarity = 1, cost = 4,
    pos = {x = 1, y = 2}, 
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    abno = true,
    discover_rounds = 4,
    no_pool_flag = "plague_doctor_breach",
    loc_txt = {
        name = "Plague Doctor",
        text = {
            "{C:attention}Blesses{} a playing card",
            "each hand",
            "Played {C:attention}blessed{} cards",
            "give {C:mult}+#1#{} Mult",
            "After {C:attention}12{} cards are {C:attention}blessed{},",
            "{C:attention}breach{}."
        }
    },
}

joker.calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card.ability.plague_doctor_baptism then
        return {
            mult = card.ability.extra.mult,
            card = card
        }
    end

    if context.cardarea == G.jokers and not context.blueprint then
        if context.before and context.full_hand then
            local card_to_mark = nil

            -- Check in played
            for k, v in ipairs(context.full_hand) do
                if v.ability and not v.ability.plague_doctor_baptism then
                    card_to_mark = context.full_hand[k]
                end
            end

            -- Check in hand
            if not card_to_mark then
                for k, v in ipairs(G.hand.cards) do
                    if v.ability and not v.ability.plague_doctor_baptism then
                        card_to_mark = G.hand.cards[k]
                    end
                end
            end

            -- Check in deck
            if not card_to_mark then
                for k, v in ipairs(G.deck.cards) do
                    if v.ability and not v.ability.plague_doctor_baptism then
                        card_to_mark = G.deck.cards[k]
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
                    play_sound('lobc_plague_doctor_bell', 1, 0.6)
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                attention_text({
                    text = localize('k_lobc_plague_apostle_'..card.ability.extra.apostles..'_1'),
                    scale = 0.35, 
                    hold = 8*G.SETTINGS.GAMESPEED,
                    major = G.play,
                    backdrop_colour = G.C.CLEAR,
                    align = 'cm',
                    offset = {x = 0, y = -3.5},
                    silent = true
                })
                attention_text({
                    text = localize('k_lobc_plague_apostle_'..card.ability.extra.apostles..'_2'),
                    scale = 0.35, 
                    hold = 8*G.SETTINGS.GAMESPEED,
                    major = G.play,
                    backdrop_colour = G.C.CLEAR,
                    align = 'cm',
                    offset = {x = 0, y = -3.1},
                    silent = true
                })
                return true 
                end 
            }))

            -- Breach.
            if card.ability.extra.apostles >= 12 then
                for _, v in ipairs(G.jokers.cards) do
                    if v.config.center.key == "j_lobc_plague_doctor" then
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after', 
                            delay = 1*G.SETTINGS.GAMESPEED,
                            func = function()
                                play_sound('tarot1')
                                v.T.r = -0.2
                                v:juice_up(0.3, 0.4)
                                v.states.drag.is = true
                                v.children.center.pinch.x = true
                                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                                    func = function()
                                        G.jokers:remove_card(v)
                                        v:remove()
                                        v = nil
                                    return true 
                                    end
                                })) 
                                return true
                            end
                        }))
                        SMODS.eval_this(v, {
                            message = localize('k_lobc_breached'),
                            colour = G.C.FILTER
                        })
                    end
                end
                G.GAME.pool_flags["plague_doctor_breach"] = true
            end
        end
    end
end

joker.add_to_deck = function(self, card, from_debuff)
    -- Debuffs self if another Plague Doctor already exists
    for _, v in ipairs(G.jokers.cards) do
        if v ~= card and v.config.center.key == "j_lobc_plague_doctor" then
            card.debuff = true
            card.ability.perma_debuff = true
        end
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { card.ability.extra.mult, card:check_rounds(2), card:check_rounds(4), card:check_rounds(666) }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    else
        info_queue[#info_queue+1] = {key = 'lobc_bless_order', set = 'Other'}
        if card:check_rounds(4) < 4 then
            desc_key = 'dis_'..desc_key..'_2'
        else
            local count = G.PROFILES[G.SETTINGS.profile].joker_usage["j_lobc_whitenight"] and G.PROFILES[G.SETTINGS.profile].joker_usage["j_lobc_whitenight"].count or 0
            if count == 0 then
                desc_key = 'dis_'..desc_key..'_3'
            end
        end
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'lobc_plague_doctor_debuffed', nodes = desc_nodes}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
    end
end

return joker