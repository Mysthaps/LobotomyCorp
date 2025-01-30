local joker = {
    name = "Apocalypse Bird",
    config = {extra = {x_mult = 2, x_mult_sin = 0.1}}, rarity = 4, cost = 20,
    pos = {x = 6, y = 3}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = false,
    abno = true,
    risk = "aleph",
    discover_rounds = 6,
    yes_pool_flag = "apocalypse_bird_defeated",
}

joker.in_pool = function(self, args)
    return false
end

joker.calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.after and not context.blueprint then
        for _, v in ipairs(context.scoring_hand) do
            if not v.ability.permanent_enchanted then
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                    v:set_edition('e_negative')
                    v.ability.big_bird_enchanted = true
                    v.ability.permanent_enchanted = true
                    v.children.lobc_big_bird_particles = Particles(0, 0, 0,0, {
                        timer = 0.4,
                        scale = 0.3,
                        speed = 0.3,
                        lifespan = 3,
                        attach = v,
                        colours = {darken(G.C.MONEY, 0.1), darken(G.C.MONEY, 0.3), darken(G.C.MONEY, 0.5)},
                        fill = true
                    })
                    v:juice_up()
                    return true
                end }))
                break
            end
        end
    end
    if context.after and context.cardarea == G.jokers and not context.blueprint then
        for _, v in ipairs(context.full_hand) do
            local id = v:get_id()
            G.GAME.lobc_long_arms[id] = G.GAME.lobc_long_arms[id] or 0
            G.GAME.lobc_long_arms[id] = G.GAME.lobc_long_arms[id] + 1
        end
    end
    if context.individual and context.cardarea == G.play then
        local id = context.other_card:get_id()
        local temp = context.other_card.ability.big_bird_enchanted and card.ability.extra.x_mult or 1
        temp = temp + (G.GAME.lobc_long_arms[id] and G.GAME.lobc_long_arms[id] * card.ability.extra.x_mult_sin or 0)
        return {
            x_mult = temp,
            card = context.blueprint_card or card,
        }
    end
end

joker.add_to_deck = function(self, card, from_debuff)
    G.jokers.config.card_limit = G.jokers.config.card_limit + 1
end

joker.remove_from_deck = function(self, card, from_debuff)
    G.jokers.config.card_limit = G.jokers.config.card_limit - 1
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { card.ability.extra.x_mult, "unused", card:check_rounds(3), card:check_rounds(6), card.ability.extra.x_mult_sin }
    local desc_key = self.key
    local count = lobc_get_usage_count("j_lobc_punishing_bird")
    if count == 0 then
        desc_key = 'dis_'..desc_key..'_1'
    else
        info_queue[#info_queue+1] = {key = 'lobc_sin', set = 'Other'}
        if card:check_rounds(3) < 3 then
            desc_key = 'dis_'..desc_key..'_2'
        elseif card:check_rounds(6) < 6 then
            desc_key = 'dis_'..desc_key..'_3'
        end
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if not self.discovered and card.area ~= G.jokers then
        localize{type = 'descriptions', key = 'und_'..self.key, set = "Other", nodes = desc_nodes, vars = vars}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
    end
end

if JokerDisplay then
    JokerDisplay.Definitions.j_lobc_apocalypse_bird = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.joker_display_values", ref_value = "x_mult" }
                }
            }
        },
        calc_function = function(card)
            local x_mult = 1
            local hand = next(G.play.cards) and G.play.cards or G.hand.highlighted
            local _, _, scoring_hand = JokerDisplay.evaluate_hand(hand)

            for i = 1, #scoring_hand do
                local id = scoring_hand[i]:get_id()
                local temp = 0
                if scoring_hand[i].ability.big_bird_enchanted and not scoring_hand[i].debuff then
                    temp = card.ability.extra.x_mult
                else
                    temp = 1
                end
                temp = temp + (G.GAME.lobc_long_arms[id] and G.GAME.lobc_long_arms[id] * card.ability.extra.x_mult_sin or 0)
                x_mult = x_mult * temp
            end

            card.joker_display_values.x_mult = x_mult
        end,
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

