local joker = {
    name = "Rudolta of the Sleigh",
    config = {extra = 2}, rarity = 2, cost = 5,
    pos = {x = 3, y = 2}, 
    blueprint_compat = false, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "he",
    discover_rounds = 6,
}

joker.calculate = function(self, card, context)
    if context.selling_card and not context.blueprint and not context.card.ability.rudolta_created and context.card.sell_cost > 0 then
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

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { 
        card:check_rounds(3), card:check_rounds(6), card.ability.extra
    }
    local desc_key = self.key
    if card:check_rounds(3) < 3 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(6) < 6 then
        desc_key = 'dis_'..desc_key..'_2'
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if not self.discovered and card.area ~= G.jokers then
        localize{type = 'descriptions', key = 'und_'..self.key, set = "Other", nodes = desc_nodes, vars = vars}
    elseif specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
    end
end

return joker

-- merry chrimmas and happy halloweens