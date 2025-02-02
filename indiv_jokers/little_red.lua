local config = SMODS.current_mod.config
local joker = {
    name = "Little Red Riding Hooded Mercenary",
    config = {extra = {
        money = 5, cost = 5, xmult = 1, xmult_gain = 0.5
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
    
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { card.ability.extra.money, card.ability.extra.xmult_gain, 
                card.ability.extra.xmult, card.ability.extra.cost,
                card:check_rounds(1), card:check_rounds(3), card:check_rounds(7),
                "F-02-58"
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