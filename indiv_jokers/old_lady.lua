local joker = {
    name = "Old Lady",
    config = {extra = {mult = 5, gain = 2, loss = 20}}, rarity = 1, cost = 6,
    pos = {x = 7, y = 0}, 
    blueprint_compat = true, 
    eternal_compat = false,
    perishable_compat = false,
    abno = true,
    discover_rounds = 5,
    loc_txt = {
        name = "Old Lady",
        text = {
            "This Abnormality gains",
            "{C:mult}+#2#{} Mult each hand",
            "When another Joker is added,",
            "this Abnormality loses {C:mult}#3#{} Mult",
            "{C:inactive}(Currently {C:mult}#6##1#{C:inactive} Mult)"
        }
    },
}

joker.process_loc_text = function(self)
    SMODS.Joker.process_loc_text(self)
    SMODS.process_loc_text(G.localization.descriptions["Other"], "und_j_lobc_old_lady", {
        name = "O-01-12",
        text = {
            "She was so talkative before,",
            "yet in the end,",
            "loneliness was the only listener.",
        }
    })
    SMODS.process_loc_text(G.localization.descriptions["Joker"], "dis_j_lobc_old_lady_1", {
        name = "O-01-12",
        text = {
            "{C:attention}(#4#/2){} ...",
            "{C:attention}(#5#/5){} ...",
        }
    })
    SMODS.process_loc_text(G.localization.descriptions["Joker"], "dis_j_lobc_old_lady_2", {
        name = "O-01-12",
        text = {
            "This Abnormality gains",
            "{C:mult}+#2#{} Mult each hand",
            "{C:attention}(#5#/5){} ...",
            "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
        }
    })
end

joker.calculate = function(self, card, context)
    if context.cardarea == G.jokers and not context.blueprint then
        if context.before then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT,
                card = card
            }
        end
    end

    if context.joker_main then
        return {
            message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
            mult_mod = card.ability.extra.mult, 
            colour = G.C.MULT
        }
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local sign = card.ability.extra.mult >= 0 and "+" or ""
    local vars = { card.ability.extra.mult, card.ability.extra.gain, card.ability.extra.loss, card:check_rounds(2), card:check_rounds(5), sign }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(5) < 5 then
        desc_key = 'dis_'..desc_key..'_2'
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
end

return joker