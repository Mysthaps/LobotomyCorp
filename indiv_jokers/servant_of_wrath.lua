local joker = {
    name = "The Servant of Wrath",
    config = {extra = {counter = 0, xmult = 2.5}}, rarity = 3, cost = 8,
    pos = {x = 3, y = 0}, 
    blueprint_compat = true, 
    eternal_compat = false,
    perishable_compat = false,
    abno = true,
    risk = "waw",
    discover_rounds = 7,
    no_pool_flag = "servant_of_wrath_breach",
    loc_txt = {
        name = "The Servant of Wrath",
        text = {
            "When round starts, plays a random",
            "highest poker hand from your hand",
            "Scored cards this way give {X:red,C:white} X#1# {} Mult",
            "If #2# is played three times this way,",
            "destroys itself and permanent {X:red,C:white} X2 {} Blind Size"
        }
    },
}

joker.calculate = function(self, card, context)

end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { card.ability.extra.x_mult, card:check_rounds(2), card:check_rounds(3), card:check_rounds(7) }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(3) < 3 then
        desc_key = 'dis_'..desc_key..'_2'
    else
        info_queue[#info_queue+1] = {key = 'lobc_hysteria', set = 'Other'}
        if card:check_rounds(7) < 7 then
            desc_key = 'dis_'..desc_key..'_3'
        end
    end
    

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
    end
end

return joker
