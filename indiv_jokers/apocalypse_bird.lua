local joker = {
    name = "Apocalypse Bird",
    config = {extra = {x_mult = 2, x_mult_sin = 0.1}}, rarity = 4, cost = 20,
    pos = {x = 6, y = 3}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = false,
    abno = true,
    risk = "aleph",
    discover_rounds = {0, 3, 5},
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
    if context.individual and context.cardarea == G.play then
        local id = context.other_card:get_id()
        local temp = context.other_card.ability.big_bird_enchanted and card.ability.extra.x_mult or 1
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

joker.loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.x_mult, "unused", "unused", "unused", card.ability.extra.x_mult_sin}}
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
                if scoring_hand[i].ability.big_bird_enchanted and not scoring_hand[i].debuff then
                    x_mult = x_mult * card.ability.extra.x_mult
                end
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

