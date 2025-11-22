local joker = {
    name = "Nothing There",
    config = {extra = {
        pos = 0,
        copying = "j_lobc_nothing_there",
        left_compat = false,
        right_compat = false,
        shield = 0.2,
        shield_mult = 1.2,
        denom = 4,
        moved = false,
    }}, rarity = 3, cost = 11,
    pos = {x = 0, y = 1}, 
    blueprint_compat = false, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "aleph",
    discover_rounds = {2, 4, 5, 7, 8},
}

joker.calculate = function(self, card, context)
    if context.before and context.cardarea == G.jokers and not context.blueprint then
        card.ability.extra.moved = false
        G.GAME.blind.shield_value = math.floor(math.floor(card.ability.extra.shield * 100)/100 * G.GAME.blind.chips)
        card:juice_up()
    end

    local effects = {}
    local left_joker = G.jokers.cards[card.ability.extra.pos-1]
    local right_joker = G.jokers.cards[card.ability.extra.pos+1]

    if left_joker and left_joker ~= card then 
        local effect = SMODS.blueprint_effect(card, left_joker, context)
        if effect then
            effect.colour = G.C.RED
            card.ability.extra.shield = card.ability.extra.shield * card.ability.extra.shield_mult
            effects[#effects+1] = effect
        end
    end
    if right_joker and right_joker ~= card then 
        local effect = SMODS.blueprint_effect(card, right_joker, context)
        if effect then
            effect.colour = G.C.RED
            card.ability.extra.shield = card.ability.extra.shield * card.ability.extra.shield_mult
            effects[#effects+1] = effect
        end
    end

    if context.end_of_round and not context.blueprint and not card.ability.extra.moved then
        card.ability.extra.moved = true
        if left_joker and not left_joker.ability.abno and (right_joker and pseudorandom("nothing_there_select", 1, 2) == 1 or not right_joker) then
            G.E_MANAGER:add_event(Event({trigger = "after", func = function()
                card.ability.extra.copying = left_joker.config.center.key
                card:set_sprites(left_joker.config.center)
                card:juice_up()
                if SMODS.pseudorandom_probability(card, "nothing_there_swap", 1, card.ability.extra.denom) then
                    local tmp = G.jokers.cards[card.ability.extra.pos]
                    G.jokers.cards[card.ability.extra.pos] = G.jokers.cards[card.ability.extra.pos-1]
                    G.jokers.cards[card.ability.extra.pos-1] = tmp
                end
            return true end })) 
        elseif right_joker and not right_joker.ability.abno then
            G.E_MANAGER:add_event(Event({trigger = "after", func = function()
                card.ability.extra.copying = right_joker.config.center.key
                card:set_sprites(right_joker.config.center)
                card:juice_up()
                if SMODS.pseudorandom_probability(card, "nothing_there_swap", 1, card.ability.extra.denom) then
                    local tmp = G.jokers.cards[card.ability.extra.pos]
                    G.jokers.cards[card.ability.extra.pos] = G.jokers.cards[card.ability.extra.pos+1]
                    G.jokers.cards[card.ability.extra.pos+1] = tmp
                end
            return true end })) 
        end

        if card.ability.extra.shield >= 20 then check_for_unlock({type = "lobc_mimicry"}) end
    end
    if next(effects) then return SMODS.merge_effects(effects) end
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

joker.loc_vars = function(self, info_queue, card)
    if not card.fake_card and card:check_rounds() >= 7 then info_queue[#info_queue+1] = {key = 'lobc_shield', set = 'Other'} end
    local numer, denom = SMODS.get_probability_vars(card, 1, card.ability.extra.denom)
    return {vars = {card.ability.extra.shield, card.ability.extra.shield_mult, numer, denom}}
end

return joker

-- Hello?
-- I love you.