local joker = {
    name = "Skin Prophecy",
    config = {extra = 0}, rarity = 2, cost = 4,
    pos = {x = 2, y = 6}, 
    blueprint_compat = false, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "teth",
    discover_rounds = {2, 4},
    discover_override = {"lobc_obs_active_1", nil}
}

joker.calculate = function(self, card, context)
    if context.ending_shop and not context.blueprint and G.GAME.current_round.skin_prophecy_uses then
        G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost * math.pow(2, G.GAME.current_round.skin_prophecy_uses)
        G.GAME.current_round.skin_prophecy_uses = nil
        card.ability.extra = 0
    end
end

joker.lobc_active = function(self, card)
    G.GAME.current_round.reroll_cost_increase = G.GAME.current_round.reroll_cost_increase / 2
    G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost / 2
    G.GAME.current_round.skin_prophecy_uses = (G.GAME.current_round.skin_prophecy_uses or 0) + 1
    calculate_reroll_cost(true)
    card.ability.extra = card.ability.extra + 1
    SMODS.calculate_effect({
        message = localize("k_activated"),
        colour = G.C.IMPORTANT,
    }, card)
end

joker.lobc_can_use_active = function(self, card)
    return (G.STATE == G.STATES.SHOP and not G.GAME.lobc_fairy_lock_reroll)
end

local calculate_reroll_costref = calculate_reroll_cost
function calculate_reroll_cost(skip_increment)
    if G.GAME.current_round.skin_prophecy_uses then
        if G.GAME.current_round.free_rerolls < 0 then G.GAME.current_round.free_rerolls = 0 end
        if G.GAME.current_round.free_rerolls > 0 then G.GAME.current_round.reroll_cost = 0; return end
        G.GAME.current_round.reroll_cost_increase = G.GAME.current_round.reroll_cost_increase or 0
        if not skip_increment then G.GAME.current_round.reroll_cost_increase = G.GAME.current_round.reroll_cost_increase + math.pow(2, G.GAME.current_round.skin_prophecy_uses) end
        G.GAME.current_round.reroll_cost = math.floor((G.GAME.round_resets.temp_reroll_cost or G.GAME.round_resets.reroll_cost) + G.GAME.current_round.reroll_cost_increase)
    else
        calculate_reroll_costref(skip_increment)
    end
end

joker.loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = {key = 'lobc_active_ability', set = 'Other'}
    return {}
end

return joker

-- 9:2 faust..... save me....... save me 9:2 faust...........