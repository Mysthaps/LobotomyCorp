local joker = {
    name = "WhiteNight",
    config = {extra = {mult = 20, retriggers = 3}}, rarity = 4, cost = 20,
    pos = {x = 3, y = 8}, 
    blueprint_compat = true, 
    eternal_compat = false,
    perishable_compat = false,
    abno = true,
    risk = "aleph",
    discover_rounds = 8,
    yes_pool_flag = "whitenight_defeated",
    no_pool_flag = "whitenight_confessed",
    loc_txt = {},
}

joker.calculate = function(self, card, context)
    if context.cardarea == G.play and context.other_card.ability.plague_doctor_baptism then
        if context.individual then
            return {
                message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
                mult = card.ability.extra.mult,
                card = card
            }
        elseif context.repetition then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retriggers,
                card = card
            }
        end
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
        end
    end
end

joker.add_to_deck = function(self, card, from_debuff)
    G.jokers.config.card_limit = G.jokers.config.card_limit + 1
end

joker.remove_from_deck = function(self, card, from_debuff)
    G.jokers.config.card_limit = G.jokers.config.card_limit - 1
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { card.ability.extra.mult, card.ability.extra.retriggers, card:check_rounds(8) }
    local desc_key = self.key
    local count = G.PROFILES[G.SETTINGS.profile].joker_usage["j_lobc_plague_doctor"] and G.PROFILES[G.SETTINGS.profile].joker_usage["j_lobc_plague_doctor"].count or 0
    if count == 0 then
        desc_key = 'dis_'..desc_key..'_1'
    else
        info_queue[#info_queue+1] = {key = 'lobc_bless_order', set = 'Other'}
        if card:check_rounds(8) < 8 then
            desc_key = 'dis_'..desc_key..'_2'
        end
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
    end
end

return joker