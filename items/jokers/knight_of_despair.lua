local joker = {
    name = "The Knight of Despair",
    config = {extra = {charge = 0, breaching = false}}, rarity = 3, cost = 8,
    pos = {x = 5, y = 4}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "waw",
    discover_rounds = {1, 3, 5, 7},
    no_pool_flag = "knight_of_despair_breach",
}

joker.calculate = function(self, card, context)
    if context.joker_type_destroyed or context.selling_card or context.using_consumeable then
        if context.card ~= card and not card.ability.extra.breaching then
            card.ability.extra.charge = card.ability.extra.charge + 1
            if card.ability.extra.charge >= 30 then check_for_unlock({type = "lobc_sword_sharpened"}) end
            return {
                message = localize{type = 'variable', key = 'lobc_a_deep_tears', vars = {1}},
                colour = HEX("1506A5")
            }
        end
    end

    if context.remove_playing_cards and context.removed then
        local blessed = false
        for _, v in ipairs(context.removed) do
            if v.ability.knight_of_despair_blessing then
                blessed = true
                break
            end
        end

        if not blessed then
            card.ability.extra.charge = card.ability.extra.charge + #context.removed
            if card.ability.extra.charge >= 30 then check_for_unlock({type = "lobc_sword_sharpened"}) end
            return {
                message = localize{type = 'variable', key = 'lobc_a_deep_tears', vars = {#context.removed}},
                colour = HEX("1506A5")
            }
        elseif not card.ability.extra.breaching then
            abno_breach(card, 1)
            G.GAME.pool_flags["knight_of_despair_breach"] = true
            card.ability.extra.breaching = true
        end
    end

    if context.individual and context.cardarea == G.play and not context.blueprint and context.other_card and context.scoring_hand and context.other_card == context.scoring_hand[1] and not context.other_card.ability.knight_of_despair_blessing then
        if card.ability.extra.charge >= 10 then
            local _card = context.other_card
            card.ability.extra.charge = 0
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                func = function()
                    card:juice_up()
                    _card:juice_up()
                    _card.ability.knight_of_despair_blessing = true
                return true
                end
            }))
            return {
                message = localize("k_lobc_blessed"),
                colour = HEX("1506A5")
            }
        end
    end

    if context.selling_self and not context.blueprint then
        abno_breach(card, 1)
        G.GAME.pool_flags["knight_of_despair_breach"] = true
        card.ability.extra.breaching = true
    end
end

joker.remove_from_deck = function(self, card, from_debuff)
    if not from_debuff then
        local destroyed_cards = {}
        for _, v in ipairs(G.playing_cards) do
            if v.ability.knight_of_despair_blessing then
                destroyed_cards[#destroyed_cards+1] = v
            end
        end
        SMODS.destroy_cards(destroyed_cards)
    end
end

local get_chip_x_multref = Card.get_chip_x_mult
function Card.get_chip_x_mult(self, context)
    local ret = get_chip_x_multref(self, context)
    ret = SMODS.multiplicative_stacking(ret, self.ability.knight_of_despair_blessing and 2 or 0)
    return ret
end

joker.loc_vars = function(self, info_queue, card)
    if not card.fake_card then
        if card:check_rounds() >= 1 then info_queue[#info_queue+1] = {key = 'lobc_magical_girl_temp', set = 'Other'} end
        if card:check_rounds() >= 3 and card:check_rounds() < 7 then info_queue[#info_queue+1] = {key = 'lobc_blessing_1', set = 'Other'}
        elseif card:check_rounds() >= 7 then info_queue[#info_queue+1] = {key = 'lobc_blessing', set = 'Other'} end
    end
    return {vars = {card.ability.extra.charge}}
end

return joker

-- it's time for your daily mirror dungeon run!!! floor 3 hatred and despair or cease living