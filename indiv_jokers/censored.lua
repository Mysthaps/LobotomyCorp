local joker = {
    name = "CENSORED",
    config = {extra = {
        mult = 40,
        x_mult = 2,
        chips = 25,
    }}, rarity = 3, cost = 8,
    pos = {x = 1, y = 6}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "aleph",
    discover_rounds = {2, 5, 8},
}

joker.calculate = function(self, card, context)
    if context.individual and context.cardarea == G.hand and not context.end_of_round and context.other_card.ability.lobc_censored then
        if context.other_card.debuff then
            return {
                message = localize('k_debuffed'),
                colour = G.C.RED,
                card = context.other_card,
            }
        else
            return {
                chips = card.ability.extra.chips, 
                card = context.other_card
            }, true
        end
    end

    if context.other_joker and card ~= context.other_joker and context.other_joker.ability.lobc_censored then
        G.E_MANAGER:add_event(Event({
            func = function()
                context.other_joker:juice_up(0.5, 0.5)
                return true
            end
        })) 
        return {
            mult = card.ability.extra.mult, 
            card = context.other_joker
        }
    end

    if context.other_consumeable and card ~= context.other_consumeable and context.other_consumeable.ability.lobc_censored then
        G.E_MANAGER:add_event(Event({
            func = function()
                context.other_consumeable:juice_up(0.5, 0.5)
            return true
            end
        })) 
        return {
            x_mult = card.ability.extra.x_mult, 
            card = context.other_consumeable
        }
    end

    if context.after and context.cardarea == G.jokers and not context.blueprint then
        local available_cards = {}
        for _, v in ipairs(G.jokers.cards) do
            if v ~= card and not v.ability.lobc_censored then available_cards[#available_cards+1] = v end
        end
        for _, v in ipairs(G.consumeables.cards) do
            if v ~= card and not v.ability.lobc_censored then available_cards[#available_cards+1] = v end
        end
        for _, v in ipairs(G.playing_cards) do
            if v ~= card and not v.ability.lobc_censored then available_cards[#available_cards+1] = v end
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after', 
            func = function()
                if #available_cards > 0 then
                    local selected_card = pseudorandom_element(available_cards, pseudoseed("censored_select"))
                    selected_card.ability.lobc_censored = true
                    selected_card:set_sprites(selected_card.config.center)
                    selected_card:juice_up()
                    play_sound("lobc_censored", 1, 0.3)
                    check_for_unlock({type = 'modify_deck'})
                end
            return true 
            end 
        }))

        return nil, true
    end
end

joker.add_to_deck = function(self, card, from_debuff)
    if not from_debuff then
        G.E_MANAGER:add_event(Event({
            trigger = 'after', 
            func = function()
                if JokerDisplay then JokerDisplay.update_all_joker_display(false, true, "j_lobc_censored") end
                
                local available_cards = {}
                for _, v in ipairs(G.jokers.cards) do
                    if v ~= card and not v.ability.lobc_censored then available_cards[#available_cards+1] = v end
                end
                for _, v in ipairs(G.consumeables.cards) do
                    if v ~= card and not v.ability.lobc_censored then available_cards[#available_cards+1] = v end
                end
                for _, v in ipairs(G.playing_cards) do
                    if v ~= card and not v.ability.lobc_censored then available_cards[#available_cards+1] = v end
                end

                G.E_MANAGER:add_event(Event({
                    trigger = 'after', 
                    func = function()
                        for i = 1, 10 do
                            if #available_cards <= 0 then break end
                            local selected_card, chosen_card_key = pseudorandom_element(available_cards, pseudoseed("censored_select"))
                            table.remove(available_cards, chosen_card_key)

                            selected_card.ability.lobc_censored = true
                            selected_card:set_sprites(selected_card.config.center)
                            selected_card:juice_up()
                        end
                        play_sound("lobc_censored", 1, 0.3)
                        check_for_unlock({type = 'modify_deck'})
                    return true 
                    end 
                }))
            return true 
            end
        }))
    end
end

joker.remove_from_deck = function(self, card, from_debuff)
    if JokerDisplay and not from_debuff then
        JokerDisplay.update_all_joker_display(false, true, "j_lobc_censored")
    end
end

joker.loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.mult, card.ability.extra.x_mult, card.ability.extra.chips}}
end

-- CENSORED sprite-based effects
local set_spritesref = Card.set_sprites
function Card.set_sprites(self, _center, _front)
    set_spritesref(self, _center, _front)

    if (self.ability and self.ability.lobc_censored) then
        self.children.center.atlas = G.ASSET_ATLAS["lobc_LobotomyCorp_modifiers"]
        self.children.center:set_sprite_pos({x = 9, y = 0})
        self.children.front = nil
        if self.children.floating_sprite then
            self.children.floating_sprite.atlas = G.ASSET_ATLAS["lobc_LobotomyCorp_modifiers"]
            self.children.floating_sprite:set_sprite_pos({x = 9, y = 0})
        end
    end
end

if JokerDisplay then
    JokerDisplay.Definitions.j_lobc_censored = {
        text = {
            { text = "+", colour = G.C.CHIPS },
            { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS },
            { text = " +", colour = G.C.MULT },
            { ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.MULT },
            { text = " " },
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.joker_display_values", ref_value = "x_mult" }
                }
            }
        },
        calc_function = function(card)
            local h_count = 0
            local j_count = 0
            local c_count = 0

            for k, v in pairs(G.hand.cards) do
                if not v.highlighted and not v.debuff and v.ability.censored then
                    h_count = h_count + 1
                end
            end

            for k, v in pairs(G.jokers.cards) do
                if not v.debuff and v.ability.censored then
                    j_count = j_count + 1
                end
            end

            for k, v in pairs(G.consumeables.cards) do
                if not v.debuff and v.ability.censored then
                    c_count = c_count + 1
                end
            end

            card.joker_display_values.chips = card.ability.extra.chips * h_count
            card.joker_display_values.mult = card.ability.extra.mult * j_count
            card.joker_display_values.x_mult = tonumber(string.format("%.2f", (card.ability.extra.x_mult ^ c_count)))
        end,
        style_function = function(card, text, reminder_text, extra)
            if text then 
                text.states.visible = card:check_rounds(5) >= 5
            end
            if reminder_text then
            end
            if extra then
            end
            return false
        end
    }

    JokerDisplay.Definitions.lobc_other_censored = {
        text = {
            { text = "CENSORED", colour = G.C.RED },
        },
    }
end

return joker

-- [CENSORED]
-- [CENSORED]
-- [CENSORED]
-- she [CENSORED] on my [CENSORED] till i [CENSORED]
