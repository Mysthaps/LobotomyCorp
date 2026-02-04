local joker = {
    name = "Rudolta of the Sleigh",
    config = {extra = 2}, rarity = 2, cost = 5,
    pos = {x = 3, y = 2}, 
    blueprint_compat = false, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "he",
    discover_rounds = {3, 6},
}

joker.calculate = function(self, card, context)
    if context.selling_card and not context.blueprint and context.card ~= card and not context.card.ability.rudolta_created and context.card.sell_cost > 0 then
        context.card.ability.rudolta_created = true
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
            ease_dollars(-(context.card.sell_cost * card.ability.extra))
            local _card = nil
            if context.card.config.center.abno then
                _card = SMODS.add_card({
                    set = "Abnormality",
                    rarity = context.card.config.center.risk,
                    area = context.card.area,
                    key_append = "lobc_rudolta",
                })
            else
                _card = SMODS.add_card({
                    set = context.card.ability.set,
                    rarity = context.card.config.center.rarity or nil,
                    area = context.card.area,
                    key_append = "lobc_rudolta",
                })
            end
            _card.ability.rudolta_created = true
            card:juice_up()
        return true end}))
    end
end

joker.loc_vars = function(self, info_queue, card)
    return {vars = {"unused", "unused", card.ability.extra}}
end

return joker

-- merry chrimmas and happy halloweens