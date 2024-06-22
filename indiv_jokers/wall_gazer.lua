local joker = {
    name = "The Lady Facing the Wall",
    config = {extra = {min_retrigger = 1, max_retrigger = 4}}, rarity = 1, cost = 6,
    pos = {x = 9, y = 0}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "teth",
    discover_rounds = 4,
    loc_txt = {},
}

joker.calculate = function(self, card, context)
    if context.cardarea == G.play and context.repetition and G.GAME.current_round.hands_played == 0 then
        -- Taken from Raised Fist
        local temp_ID = 1e308
        local raised_card = nil
        for i = 1, #context.scoring_hand do
            if temp_ID >= context.scoring_hand[i].base.id and (context.scoring_hand[i].ability.effect ~= 'Stone Card' and not context.scoring_hand[i].config.center.no_rank) then
                temp_ID = context.scoring_hand[i].base.id
                raised_card = context.scoring_hand[i]
            end
        end
        
        if context.other_card == raised_card then
            return {
                message = localize('k_again_ex'),
                repetitions = pseudorandom("wall_gazer", card.ability.extra.min_retrigger, card.ability.extra.max_retrigger),
                card = card
            }
        end
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { card.ability.extra.min_retrigger, card.ability.extra.max_retrigger, card:check_rounds(2), card:check_rounds(4) }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(4) < 4 then
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