local joker = {
    name = "Meat Lantern",
    config = {extra = {cur = 0, max = 3, reduce = 1}}, rarity = 1, cost = 5,
    pos = {x = 6, y = 5}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "teth",
    discover_rounds = {2, 4, 6},
}

joker.calculate = function(self, card, context)
    if context.reroll_shop then
        if card.ability.extra.cur < card.ability.extra.max then
            card:juice_up()
            SMODS.add_booster_to_shop()
            card.ability.extra.cur = card.ability.extra.cur + 1
        end
        return {}
    end

    if context.ending_shop and not context.blueprint then
        card.ability.extra.cur = 0
    end

    if context.open_booster and not context.blueprint then
        G.E_MANAGER:add_event(Event({trigger = "after", delay = 1.3*math.sqrt(G.SETTINGS.GAMESPEED), blockable = false, blocking = false, func = function()
            if G.pack_cards then
                local available_cards = {}
                for _, v in ipairs(G.pack_cards.cards) do
                    if not v.ability.meat_lantern_lantern then available_cards[#available_cards+1] = v end
                end

                local _card = pseudorandom_element(available_cards, pseudoseed("meat_lantern"))
                _card.ability.meat_lantern_lantern = true
            return true end
        end}))
    end

    if context.card_added and not context.blueprint then
        if context.card and context.card.ability.meat_lantern_lantern then
            context.card.ability.meat_lantern_lantern = nil
            if context.card.children.lobc_lantern then context.card.children.lobc_lantern:remove(); context.card.children.lobc_lantern = nil end
            G.hand:change_size(-card.ability.extra.reduce)
            play_sound("lobc_meat_lantern", 1, 0.4)
            return {
                message = localize("k_ambush"),
            }
        end
    end

    if context.using_consumeable and context.area == G.pack_cards and not context.blueprint then
        if context.consumeable and context.consumeable.ability.meat_lantern_lantern then
            context.consumeable.ability.meat_lantern_lantern = nil
            if context.consumeable.children.lobc_lantern then context.consumeable.children.lobc_lantern:remove(); context.consumeable.children.lobc_lantern = nil end
            G.hand:change_size(-card.ability.extra.reduce)
            G.E_MANAGER:add_event(Event({func = function()
                play_sound("lobc_meat_lantern", 1, 0.4)
                return true
            end}))
            return {
                message = localize("k_ambush"),
            }
        end
    end

    if context.playing_card_added and not context.blueprint then
        for _, v in ipairs(context.cards or {}) do
            if type(v) == "table" and v.ability.meat_lantern_lantern then
                v.ability.meat_lantern_lantern = nil
                if v.children.lobc_lantern then v.children.lobc_lantern:remove(); v.children.lobc_lantern = nil end
                G.hand:change_size(-card.ability.extra.reduce)
                play_sound("lobc_meat_lantern", 1, 0.4)
                return {
                    message = localize("k_ambush"),
                }
            end
        end
    end
end

joker.loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.max, card.ability.extra.reduce}}
end

-- Remove Lantern
joker.remove_from_deck = function(self, card, from_blind)
    for _, v in ipairs(G.pack_cards or {}) do
        v.ability.meat_lantern_lantern = nil
        if v.children.lobc_lantern then v.children.lobc_lantern:remove(); v.children.lobc_lantern = nil end
    end
end

return joker

-- om nom nom
