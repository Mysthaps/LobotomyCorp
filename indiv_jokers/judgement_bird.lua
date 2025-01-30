local joker = {
    name = "Judgement Bird",
    config = {extra = {x_mult = 1, x_mult_gain = 0.05}}, rarity = 3, cost = 8,
    pos = {x = 5, y = 3}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = false,
    abno = true,
    risk = "waw",
    discover_rounds = 7,
    no_pool_flag = "apocalypse_bird_event",
}

joker.calculate = function(self, card, context)
    if context.remove_playing_cards and not context.blueprint then
        local sins = 0
        for _, v in ipairs(context.removed) do
            local id = v:get_id()
            if G.GAME.lobc_long_arms[id] then
                sins = sins + G.GAME.lobc_long_arms[id]
            end
        end
        card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain * sins
        if sins > 0 then
            return {
                message = localize("k_upgrade_ex")
            }
        end
    end

    if context.joker_main then
        return {
            x_mult = card.ability.extra.x_mult,
            card = context.blueprint_card or card,
        }
    end

    if context.after and context.cardarea == G.jokers and not context.blueprint then
        for _, v in ipairs(context.full_hand) do
            local id = v:get_id()
            G.GAME.lobc_long_arms[id] = G.GAME.lobc_long_arms[id] or 0
            G.GAME.lobc_long_arms[id] = G.GAME.lobc_long_arms[id] + 1
        end
    end

    if context.destroying_card and not context.blueprint and not context.destroying_card.ability.eternal then
        local id = context.destroying_card:get_id()
        if G.GAME.lobc_long_arms[id] and G.GAME.lobc_long_arms[id] >= 5 then
            return true
        end
    end
end

joker.add_to_deck = function(self, card, from_debuff)
    if not G.GAME.pool_flags["apocalypse_bird_event"] and not from_debuff and next(SMODS.find_card("j_lobc_punishing_bird")) and next(SMODS.find_card("j_lobc_big_bird")) then
        for _, v in ipairs(SMODS.find_card("j_lobc_punishing_bird")) do
            v.ability.extra.start_apoc = true
            v.children.alert = UIBox{
                definition = create_UIBox_card_alert(), 
                config = {
                    align = "tri",
                    offset = {
                        x = 0.1, y = 0
                    },
                    parent = v
                }
            }
            check_for_unlock({type = "lobc_through_the_dark_twilight"})
        end
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { card.ability.extra.x_mult_gain, card.ability.extra.x_mult, card:check_rounds(2), card:check_rounds(4), card:check_rounds(7) }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    else
        info_queue[#info_queue+1] = {key = 'lobc_sin', set = 'Other'}
        if card:check_rounds(4) < 4 then
            desc_key = 'dis_'..desc_key..'_2'
        elseif card:check_rounds(7) < 7 then
            desc_key = 'dis_'..desc_key..'_3'
        end
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

if JokerDisplay then
    -- tba
end

return joker

-- you know My Form Empties? from Limbus Company?
-- yeah if you think about it, that fight is just the same as Judgement Bird from Library of Ruina
-- the gimmick of transferring a status effect to enemies
-- it's a shame you can't attack allies in Limbus but it's piss easy anyway