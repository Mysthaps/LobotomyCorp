local joker = {
    name = "Forsaken Murderer",
    config = {extra = {x_mult = 2}}, rarity = 1, cost = 6,
    pos = {x = 8, y = 2}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "teth",
    discover_rounds = 4,
}

joker.calculate = function(self, card, context)
    if context.before and not context.blueprint then
        SMODS.debuff_card(context.scoring_hand[#context.scoring_hand], true, "forsaken_murderer")
        card:juice_up()
    end

    if context.individual and context.cardarea == G.play and context.other_card == context.scoring_hand[1] then
        return {
            x_mult = card.ability.extra.x_mult,
            card = context.blueprint_card or card,
        }
    end

    if context.after and not context.blueprint then
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            if context.scoring_hand[1] == context.scoring_hand[#context.scoring_hand] then
                check_for_unlock({type = "lobc_regret"})
            end
            SMODS.debuff_card(context.scoring_hand[#context.scoring_hand], false, "forsaken_murderer")
        return true end }))
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { card.ability.extra.x_mult, card:check_rounds(2), card:check_rounds(4) }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(4) < 4 then
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

--[[
Regret
20+10 Blunt
1 Coin
52 (50+2) Atk Weight ⯀
[Before Attack] Remove 2 random removable negative effects applied to self
[Coin 1]
    [On Hit] Inflict +3 Tremor Count; Inflict (Wrath A-Reson. /3) additional Tremor Count
    [On Hit] Trigger Tremor Burst
    If the target does not have a Stagger Threshold upon Tremor Burst,
    Deal Wrath Damage by (12 + 3x(Wrath A-Reson.))% of the final Stagger Threshold raised.

"This straight-jacket... isn’t nearly enough to hold back my violence."
]]