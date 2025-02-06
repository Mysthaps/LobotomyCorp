local function mark_card()
    G.GAME.lobc_little_red_marked_card = nil
    local wolves = SMODS.find_card("j_lobc_big_bad_wolf", true)
    local available_cards = {}
    if next(wolves) then
        for _, v in ipairs(wolves) do
            if v ~= card and not v.ability.eternal then available_cards[#available_cards + 1] = v end
        end
    end
    if #available_cards == 0 then -- all wolves are eternal, or no wolves
        for _, v in ipairs(G.playing_cards) do
            if v ~= card and not v.ability.eternal then available_cards[#available_cards + 1] = v end
        end
    end

    if #available_cards > 0 then
        local selected_card = pseudorandom_element(available_cards, pseudoseed("little_red_card"))
        G.GAME.lobc_little_red_marked_card = selected_card
        G.GAME.lobc_little_red_marked_card.ability.little_red_marked = true
        -- temporary
        G.GAME.lobc_little_red_marked_card.children.lobc_little_red_particles = Particles(0, 0, 0,0, {
            timer = 0.3,
            scale = 0.45,
            speed = 0.3,
            lifespan = 4,
            attach = G.GAME.lobc_little_red_marked_card,
            colours = {darken(G.C.RED, 0.1), darken(G.C.RED, 0.3), darken(G.C.RED, 0.5)},
            fill = true
        })
    end
    print(G.GAME.lobc_little_red_marked_card.base.value..G.GAME.lobc_little_red_marked_card.base.suit)
end

local joker = {
    name = "Little Red Riding Hooded Mercenary",
    config = {extra = {
        money = 5, cost = 5, mult = 0, mult_gain = 10, cost_increase = 10
    }}, rarity = 3, cost = 7,
    pos = {x = 1, y = 3}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "waw",
    discover_rounds = 7,
}

joker.calculate = function(self, card, context)
    if context.remove_playing_cards and not context.blueprint then
        local removed = 0
        for _, v in ipairs(context.removed) do
            if v.ability.little_red_marked then
                removed = removed + 1
            end
        end
        if removed > 0 then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain * removed
            return {
                dollars = card.ability.extra.money * removed,
                message = localize("k_upgrade_ex"),
            }
        end
    end

    if context.joker_main then
        return {
            mult = card.ability.extra.mult,
            card = context.blueprint_card or card,
        }
    end
end

joker.lobc_can_use_active = function(self, card)
    return G.GAME.dollars >= card.ability.extra.cost
end

joker.lobc_active = function(self, card)
    ease_dollars(-card.ability.extra.cost)
    card.ability.extra.cost = card.ability.extra.cost + card.ability.extra.cost_increase
    G.E_MANAGER:add_event(Event({
        func = function()
            G.GAME.lobc_little_red_marked_card:start_dissolve()
            delay(0.2)
            SMODS.calculate_context({ remove_playing_cards = true, removed = { G.GAME.lobc_little_red_marked_card } })
            G.GAME.lobc_little_red_marked_card = nil
            return true
        end
    }))
end

joker.update = function(self, card, dt)
    if G.STAGE == G.STAGES.RUN and card.area == G.jokers and not card.debuff and not G.GAME.lobc_little_red_marked_card then
        for _, v in ipairs(G.playing_cards) do
            if v.ability.little_red_marked then G.GAME.lobc_little_red_marked_card = v end
        end
        for _, v in ipairs(G.jokers.cards) do
            if v.ability.little_red_marked then G.GAME.lobc_little_red_marked_card = v end
        end
        if not G.GAME.lobc_little_red_marked_card then mark_card() end
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { card.ability.extra.money, card.ability.extra.mult_gain, 
                card.ability.extra.mult, card.ability.extra.cost,
                card:check_rounds(1), card:check_rounds(3), card:check_rounds(7),
                "F-02-58", card.ability.extra.cost_increase
            }
    local desc_key = self.key
    if card:check_rounds(1) < 1 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(3) < 3 then
        desc_key = 'dis_'..desc_key..'_2'
    elseif card:check_rounds(7) < 7 then
        desc_key = 'dis_'..desc_key..'_3'
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

-- holy shit is that the red mist