local joker = {
    name = "Theresia",
    config = {extra = {chips = 0, gain = 6, hands_played = 0}}, rarity = 1, cost = 5,
    pos = {x = 6, y = 0}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = false,
    abno = true,
    risk = "teth",
    discover_rounds = 4,
    loc_txt = {},
}

joker.calculate = function(self, card, context)
    if context.cardarea == G.jokers and not context.blueprint then
        if context.before then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.gain
            card.ability.extra.hands_played = card.ability.extra.hands_played + 1
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.CHIPS,
                card = card
            }
        elseif context.after and card.ability.extra.hands_played >= 3 then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                func = function()
                    play_sound('card1', 1)
                    for _, v in ipairs(G.hand.cards) do
                        if not v.debuff then
                            SMODS.debuff_card(v, true, 'theresia_debuff')
                            v:juice_up()
                        end
                    end
                    for _, v in ipairs(G.deck.cards) do
                        SMODS.debuff_card(v, true, 'theresia_debuff')
                        v:set_debuff(true)
                    end
                return true 
                end 
            }))
        end
    end

    if context.joker_main then
        return {
            chips = card.ability.extra.chips,
            card = context.blueprint_card or card,
        }
    end

    if context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
        card.ability.extra.hands_played = 0
        for _, v in ipairs(G.playing_cards) do
            SMODS.debuff_card(v, false, 'theresia_debuff')
        end
    end
end

joker.remove_from_deck = function(self, card, from_debuff)
    for _, v in ipairs(G.playing_cards) do
        SMODS.debuff_card(v, false, 'theresia_debuff')
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { card.ability.extra.chips, card.ability.extra.gain, card:check_rounds(2), card:check_rounds(4) }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(4) < 4 then
        desc_key = 'dis_'..desc_key..'_2'
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
    JokerDisplay.Definitions.j_lobc_theresia = {
        text = {
            { text = "+", colour = G.C.CHIPS },
            { ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS },
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.ability.extra", ref_value = "hands_played" },
            { text = ")" }
        },
        style_function = function(card, text, reminder_text, extra)
            if text then 
                text.states.visible = card:check_rounds(2) >= 2
            end
            if reminder_text then
                reminder_text.states.visible = card:check_rounds(4) >= 4
            end
            if extra then
            end
            return false
        end
    }
end

return joker

-- Shelter from the 27th of March lite