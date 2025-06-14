local joker = {
    name = "Nothing There",
    config = {extra = {
        pos = 0,
        copying = "j_lobc_nothing_there",
        copied_cur = {},
        copied_last = {},
        left_compat = false,
        right_compat = false
    }}, rarity = 3, cost = 11,
    pos = {x = 0, y = 1}, 
    blueprint_compat = false, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "aleph",
    discover_rounds = 9,
}

joker.calculate = function(self, card, context)
    local left_joker = G.jokers.cards[card.ability.extra.pos-1]
    if left_joker and left_joker ~= card and left_joker ~= card.ability.extra.copying then
        context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
        context.blueprint_card = context.blueprint_card or card
        if context.blueprint > #G.jokers.cards + 1 then return end
        local left_joker_ret = left_joker:calculate_joker(context)
        context.blueprint = nil
        local eff_card = context.blueprint_card or card
        context.blueprint_card = nil
        if left_joker_ret then
            left_joker_ret.card = eff_card
            left_joker_ret.colour = G.C.RED
            SMODS.calculate_effect(left_joker_ret)
            if not card.ability.extra.copied_last[card.sort_id] then 
                card.ability.extra.copied_last[card.sort_id] = true
            end
        end
    end

    local right_joker = G.jokers.cards[card.ability.extra.pos+1]
    if right_joker and right_joker ~= card and left_joker ~= card.ability.extra.copying then
        context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
        context.blueprint_card = context.blueprint_card or card
        if context.blueprint > #G.jokers.cards + 1 then return end
        local right_joker_ret = right_joker:calculate_joker(context)
        context.blueprint = nil
        local eff_card = context.blueprint_card or card
        context.blueprint_card = nil
        if right_joker_ret then
            right_joker_ret.card = eff_card
            right_joker_ret.colour = G.C.RED
            SMODS.calculate_effect(right_joker_ret)
        end
    end
end

joker.update = function(self, card, dt)
    if G.STAGE == G.STAGES.RUN and not card.debuff then
        -- check for Nothing There's position
        for k, v in ipairs(G.jokers.cards) do
            if v == card then card.ability.extra.pos = k end
        end
        local left_joker = G.jokers.cards[card.ability.extra.pos-1]
        local right_joker = G.jokers.cards[card.ability.extra.pos+1]
        card.ability.extra.left_compat = false
        card.ability.extra.right_compat = false

        if left_joker and left_joker ~= card and left_joker.config.center.blueprint_compat then
            card.ability.extra.left_compat = true
        end

        if right_joker and right_joker ~= card and right_joker.config.center.blueprint_compat then
            card.ability.extra.right_compat = true
        end
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { 
        card:check_rounds(4), card:check_rounds(7), card:check_rounds(9),
    }
    local desc_key = self.key
    if card:check_rounds(4) < 4 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(7) < 7 then
        desc_key = 'dis_'..desc_key..'_2'
    elseif card:check_rounds(9) < 9 then
        desc_key = 'dis_'..desc_key..'_3'
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if not self.discovered and card.area ~= G.jokers then
        localize{type = 'descriptions', key = 'und_'..self.key, set = "Other", nodes = desc_nodes, vars = vars}
    elseif specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars, AUT = full_UI_table}
        if card.area and card.area == G.jokers then
            -- left compat
            desc_nodes[#desc_nodes+1] = {
                {n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
                    {n=G.UIT.C, config={align = "cm", colour = G.C.CLEAR}, nodes={
                        {n=G.UIT.T, config={text = 'left card ',colour = G.C.UI.TEXT_INACTIVE, scale = 0.32*0.8}},
                    }},
                    {n=G.UIT.C, config={ref_table = self, align = "m", colour = card.ability.extra.left_compat and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06}, nodes={
                        {n=G.UIT.T, config={text = ' '..localize(card.ability.extra.left_compat and 'k_compatible' or 'k_incompatible')..' ',colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.8}},
                    }}
                }}
            }

            -- right compat
            desc_nodes[#desc_nodes+1] = {
                {n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
                    {n=G.UIT.C, config={align = "cm", colour = G.C.CLEAR}, nodes={
                        {n=G.UIT.T, config={text = 'right card ',colour = G.C.UI.TEXT_INACTIVE, scale = 0.32*0.8}},
                    }},
                    {n=G.UIT.C, config={ref_table = self, align = "m", colour = card.ability.extra.right_compat and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06}, nodes={
                        {n=G.UIT.T, config={text = ' '..localize(card.ability.extra.right_compat and 'k_compatible' or 'k_incompatible')..' ',colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.8}},
                    }}
                }}
            }
        end
    end
end

return joker

-- Hello?
-- I love you.