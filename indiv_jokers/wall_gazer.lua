local joker = {
    name = "The Lady Facing the Wall",
    config = {extra = {min_retrigger = 2, max_retrigger = 5, retriggers = 0}}, rarity = 1, cost = 6,
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
    if context.setting_blind and not context.getting_sliced and not context.blueprint then
        card.ability.extra.retriggers = pseudorandom("wall_gazer", card.ability.extra.min_retrigger, card.ability.extra.max_retrigger)
    end
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
                repetitions = card.ability.extra.retriggers,
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

if SMODS.Mods.JokerDisplay then
    JokerDisplay.Definitions.j_lobc_wall_gazer = {
        reminder_text = {
            { text = "(" },
            { ref_table = "card.ability.extra", ref_value = "min_retrigger" },
            { text = "-" },
            { ref_table = "card.ability.extra", ref_value = "max_retrigger" },
            { text = ")" },
        },

        retrigger_function = function(playing_card, scoring_hand, held_in_hand, joker_card)
            if held_in_hand then return 0 end
            local temp_ID = 1e308
            local raised_card = nil
            for i = 1, #scoring_hand do
                if temp_ID >= scoring_hand[i].base.id and (scoring_hand[i].ability.effect ~= 'Stone Card' and not scoring_hand[i].config.center.no_rank) then
                    temp_ID = scoring_hand[i].base.id
                    raised_card = scoring_hand[i]
                end
            end
            return raised_card and card == raised_card and joker_card.ability.extra.retriggers or 0
        end,

        style_function = function(card, text, reminder_text, extra)
            if text then 
            end
            if reminder_text then
                reminder_text.states.visible = card:check_rounds(2) >= 2
            end
            if extra then
            end
            return false
        end
    }
end

return joker

-- ass