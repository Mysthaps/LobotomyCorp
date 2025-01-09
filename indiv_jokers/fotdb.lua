local joker = {
    name = "Funeral of the Dead Butterflies",
    config = {extra = {x_mult = 1, gain = 1}}, rarity = 2, cost = 7,
    pos = {x = 0, y = 4}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "he",
    discover_rounds = 6,
    loc_txt = {},
}

joker.calculate = function(self, card, context)
    if context.end_of_round and context.main_scoring and G.GAME.blind.boss then
        local available_cards = {}
        for _, v in ipairs(G.jokers.cards) do
            if v.config.center.eternal_compat and not v.ability.eternal and not v.ability.perishable then 
                available_cards[#available_cards+1] = v 
            end
        end

        if #available_cards > 0 then
            local selected_card = pseudorandom_element(available_cards, pseudoseed("fotdb"))
            selected_card:set_eternal(true)
            selected_card:juice_up()
            play_sound("lobc_butterfly_attack", 1, 0.2)
        end

        return nil, true
    end

    if context.joker_main and card.ability.extra.x_mult > 1 then
        return {
            message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.extra.x_mult}},
            Xmult_mod = card.ability.extra.x_mult, 
            colour = G.C.MULT
        }
    end
end

joker.set_ability = function(self, card, initial, delay_sprites)
    card.ability.eternal = true
end

joker.update = function(self, card, dt)
    if G.STAGE == G.STAGES.RUN then
        card.ability.extra.x_mult = 0
        for k, v in pairs(G.jokers.cards) do
            if v.ability.eternal then card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.gain end
        end
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { 
        card.ability.extra.x_mult, card.ability.extra.gain, card:check_rounds(1), card:check_rounds(3), card:check_rounds(6)
    }
    local desc_key = self.key
    if card:check_rounds(1) < 1 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(3) < 3 then
        desc_key = 'dis_'..desc_key..'_2'
    elseif card:check_rounds(6) < 6 then
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

if JokerDisplay then
    JokerDisplay.Definitions.j_lobc_fotdb = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "x_mult" }
                }
            }
        },
        style_function = function(card, text, reminder_text, extra)
            if text then 
                text.states.visible = card:check_rounds(3) >= 3
            end
            if reminder_text then
            end
            if extra then
            end
            return false
        end
    }
end

return joker

--[[text = {
    "This Abnormality is always {C:dark_edition}Eternal{}",
    "{s:0.15} {}",
    "Starts with {C:attention}10{} {C:tarot}The Living{} and {C:tarot}The Departed{}",
    "{s:0.15} {}",
    "When a card is {C:blue}played{} or {C:red}discarded{}, randomly",
    "transfer 1 {C:tarot}The Living{} or {C:tarot}The Departed{}",
    "to the current {C:attention}Blind{}",
    "{s:0.15} {}",
    "After scoring ends, increase score by {C:attention}2%{}",
    "for every {C:tarot}The Living{} and decrease {C:attention}Blind Size",
    "by {C:attention}2%{} for every {C:tarot}The Departed{}",
    "on the current {C:attention}Blind{}, then convert",
    "all {C:tarot}The Living{} into {C:tarot}The Departed{}",
    "{s:0.15} {}",
    "When all {C:tarot}The Living{} and {C:tarot}The Departed{} are",
    "depleted, or when {C:attention}Blind{} is defeated, reset both",
    "{C:tarot}The Living{} and {C:tarot}The Departed{} values to {C:attention}0{},",
    "then gain a sum of {C:attention}20{} {C:tarot}The Living{} and {C:tarot}The Departed{}",
    "based on the following probabilities",
    "(calculate separately for each stack):",
    "{s:0.15} {}",
    "- At score {X:mult,C:white} X5 {} or higher than {C:attention}Blind Size{},",
    "more chance to gain {C:tarot}The Departed{} over {C:tarot}The Living{}",
    "- At score {X:mult,C:white} X2 {} or lower than {C:attention}Blind Size{},",
    "more chance to gain {C:tarot}The Living{} over {C:tarot}The Departed{}",
}]]--
