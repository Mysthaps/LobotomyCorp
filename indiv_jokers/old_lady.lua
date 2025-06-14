local joker = {
    name = "Old Lady",
    config = {extra = {mult = 0, gain = 1, loss = 5}}, rarity = 1, cost = 4,
    pos = {x = 7, y = 0}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = false,
    abno = true,
    risk = "teth",
    discover_rounds = {2, 5},
}

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
            mult = card.ability.extra.mult,
            card = context.blueprint_card or card,
        }
    end
end

joker.loc_vars = function(self, info_queue, card)
    local sign = card.ability.extra.mult >= 0 and "+" or ""
    return {vars = {card.ability.extra.mult, card.ability.extra.gain, card.ability.extra.loss, "unused", "unused", sign}}
end

-- Check for Old Lady's bullshit
local add_to_deckref = Card.add_to_deck
function Card.add_to_deck(self, from_debuff)
    if not self.added_to_deck and not from_debuff and self.ability.set == "Joker" then
        for _, v in ipairs(SMODS.find_card("j_lobc_old_lady")) do
            if self ~= v then
                v.ability.extra.mult = v.ability.extra.mult - v.ability.extra.loss
                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    delay = 0.1,
                    func = function()
                        card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize("k_lobc_downgrade")})
                        play_sound('lobc_old_lady_downgrade', 1, 0.6)
                        return true
                    end
                }))
                if v.ability.extra.mult <= -20 then
                    check_for_unlock({type = "lobc_solitude"})
                end
            end
        end
    end
    add_to_deckref(self, from_debuff)
end

if JokerDisplay then
    JokerDisplay.Definitions.j_lobc_old_lady = {
        text = {
            { ref_table = "card.joker_display_values", ref_value = "sign" },
            { ref_table = "card.ability.extra", ref_value = "mult" }
        },
        text_config = { colour = G.C.MULT },
        calc_function = function(card)
            card.joker_display_values.sign = card.ability.extra.mult >= 0 and "+" or ""
        end,
        style_function = function(card, text, reminder_text, extra)
            if text then 
                text.states.visible = card:check_rounds(2) >= 2
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

-- the one that nobody cares