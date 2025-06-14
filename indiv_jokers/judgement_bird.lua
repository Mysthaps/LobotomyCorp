local joker = {
    name = "Judgement Bird",
    config = {extra = {x_mult = 1, x_mult_gain = 0.15}}, rarity = 3, cost = 8,
    pos = {x = 5, y = 3}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = false,
    abno = true,
    risk = "waw",
    discover_rounds = {2, 4, 7},
    no_pool_flag = "apocalypse_bird_event",
}

joker.calculate = function(self, card, context)
    if context.remove_playing_cards and not context.blueprint then
        local sins = 0
        for _, v in ipairs(context.removed) do
            local id = v:get_id()
            if G.GAME.lobc_long_arms[id] then
                sins = sins + G.GAME.lobc_long_arms[id]
            end
        end
        card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain * sins
        if sins > 0 then
            return {
                message = localize("k_upgrade_ex")
            }
        end
    end

    if context.joker_main then
        return {
            x_mult = card.ability.extra.x_mult,
            card = context.blueprint_card or card,
        }
    end

    if context.after and context.cardarea == G.jokers and not context.blueprint then
        for _, v in ipairs(context.full_hand) do
            local id = v:get_id()
            G.GAME.lobc_long_arms[id] = G.GAME.lobc_long_arms[id] or 0
            G.GAME.lobc_long_arms[id] = G.GAME.lobc_long_arms[id] + 1
        end
    end

    if context.destroying_card and not context.blueprint and not context.destroying_card.ability.eternal then
        local id = context.destroying_card:get_id()
        if G.GAME.lobc_long_arms[id] and G.GAME.lobc_long_arms[id] >= 5 then
            return {
                remove = true
            }
        end
    end
end

joker.add_to_deck = function(self, card, from_debuff)
    if not G.GAME.pool_flags["apocalypse_bird_event"] and not from_debuff and next(SMODS.find_card("j_lobc_punishing_bird")) and next(SMODS.find_card("j_lobc_big_bird")) then
        for _, v in ipairs(SMODS.find_card("j_lobc_punishing_bird")) do
            v.ability.extra.start_apoc = true
            v.children.alert = UIBox{
                definition = create_UIBox_card_alert(), 
                config = {
                    align = "tri",
                    offset = {
                        x = 0.1, y = 0
                    },
                    parent = v
                }
            }
            check_for_unlock({type = "lobc_through_the_dark_twilight"})
        end
    end
end

joker.loc_vars = function(self, info_queue, card)
    if card:check_rounds() >= 2 then info_queue[#info_queue+1] = {key = 'lobc_sin', set = 'Other'} end
    return {vars = {card.ability.extra.x_mult_gain, card.ability.extra.x_mult}}
end

if JokerDisplay then
    -- tba
end

return joker

-- you know My Form Empties? from Limbus Company?
-- yeah if you think about it, that fight is just the same as Judgement Bird from Library of Ruina
-- the gimmick of transferring a status effect to enemies
-- it's a shame you can't attack allies in Limbus but it's piss easy anyway