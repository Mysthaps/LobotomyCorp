local joker = {
    name = "The King of Greed",
    config = {extra = {dollars = 4, decrease = 0.4, this = 0, last = -1, proc = false}}, rarity = 3, cost = 8,
    pos = {x = 7, y = 3}, 
    blueprint_compat = true, 
    eternal_compat = false,
    perishable_compat = false,
    abno = true,
    risk = "waw",
    discover_rounds = {3, 5, 7},
    no_pool_flag = "king_of_greed_breach",
}

joker.calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play and context.other_card and context.other_card:get_id() == 13 then
        card.ability.extra.proc = true
        if context.other_card.debuff then
            return {
                message = localize('k_debuffed'),
                colour = G.C.RED,
                card = context.blueprint_card or card,
            }
        else
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
            if not Handy or (Handy and not Handy.animation_skip.should_skip_messages()) then
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        G.GAME.dollar_buffer = 0
                        return true
                    end)
                }))
            else
                G.GAME.dollar_buffer = 0
            end
            return {
                dollars = card.ability.extra.dollars,
                card = context.blueprint_card or card
            }
        end
    end

    if context.after and not context.blueprint then
        if card.ability.extra.proc and card.ability.extra.dollars > 0 then
            card.ability.extra.proc = false
            card.ability.extra.dollars = card.ability.extra.dollars - card.ability.extra.decrease
            return {
                message = localize("k_lobc_downgrade"),
            }
        end
    end
    
    if context.ending_shop and not context.blueprint then
        if card.ability.extra.this > card.ability.extra.last then
            card.ability.extra.last = card.ability.extra.this
            card.ability.extra.this = 0
        else
            abno_breach(card, 1)
        end
    end
end

local ease_dollarsref = ease_dollars
function ease_dollars(mod, instant)
    if G.STATE ~= G.STATES.SHOP and G.STATE ~= G.STATES.PLAY_TAROT then return ease_dollarsref(mod, instant) end
    local greeds = SMODS.find_card("j_lobc_king_of_greed")
    if greeds[1] and mod < 0 then
        for _, v in ipairs(greeds) do
            v.ability.extra.this = v.ability.extra.this - mod
        end
    end
    return ease_dollarsref(mod, instant)
end

joker.loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = {key = 'lobc_magical_girl', set = 'Other'}
    return {vars = {card.ability.extra.dollars, card.ability.extra.decrease}}
end

return joker

-- tiphxodia gaming