local joker = {
    name = "One Sin and Hundreds of Good Deeds",
    config = {extra = {mult = 3}}, rarity = 1, cost = 4,
    pos = {x = 2, y = 0}, 
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "zayin",
    discover_rounds = 2,
    no_pool_flag = "plague_doctor_breach",
    loc_txt = {},
}

joker.calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
        return {
            mult = card.ability.extra.mult,
            card = card
        }
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { card.ability.extra.mult, card:check_rounds(2), card:check_rounds(666) }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif not G.P_BLINDS["bl_lobc_whitenight"].discovered then
        desc_key = 'dis_'..desc_key..'_2'
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
    end
end

return joker

-- you know you fucked up when you let one sin breach