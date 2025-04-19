local joker = {
    name = "Skin Prophecy",
    config = {extra = 0}, rarity = 2, cost = 4,
    pos = {x = 2, y = 6}, 
    blueprint_compat = false, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "teth",
    discover_rounds = 4,
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

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { 
        card:check_rounds(2), card:check_rounds(4)
    }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(4) < 4 then
        desc_key = 'dis_'..desc_key..'_2'
    end
    info_queue[#info_queue+1] = {key = 'lobc_active_ability', set = 'Other'}

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

-- 9:2 faust..... save me....... save me 9:2 faust...........