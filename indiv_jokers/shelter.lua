local joker = {
    name = "Shelter from the 27th of March",
    config = {extra = {x_mult = 1, active = false}}, rarity = 2, cost = 8,
    pos = {x = 4, y = 5}, 
    blueprint_compat = false, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "he",
    discover_rounds = {2, 4, 6},
    discover_override = {"lobc_obs_active_1", nil, nil}
}

joker.calculate = function(self, card, context)
    if card.ability.extra.active and not context.blueprint then
        if context.cardarea == G.jokers then
            if context.before and not G.GAME.blind.disabled then
                -- From Chicot
                G.GAME.blind:disable()
                play_sound('timpani')
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled')})
            end
            if context.after then
                card.ability.extra.x_mult = card.ability.extra.x_mult / 2
                return {
                    message = localize("k_lobc_downgrade"),
                    colour = G.C.MULT
                }
            end
        end
        if context.final_scoring_step then
            return {
                x_mult = card.ability.extra.x_mult
            }
        end
        
    end
end

joker.lobc_active = function(self, card)
    if not card.ability.extra.active then
        card.ability.extra.x_mult = card.ability.extra.x_mult / 2
        card.ability.extra.active = true
        SMODS.calculate_effect({
            message = localize("k_lobc_shelter"),
            colour = G.C.IMPORTANT,
        }, card)
    else
        card.ability.extra.x_mult = card.ability.extra.x_mult * 2
        card.ability.extra.active = false
        card:juice_up()
    end
end

joker.lobc_can_use_active = function(self, card)
    return G.STATE ~= G.STATES.HAND_PLAYED
end

joker.loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = {key = 'lobc_active_ability', set = 'Other'}
    return {vars = {card.ability.extra.x_mult}}
end

return joker

-- WHO WILL WIN?
-- One highly experienced color fixer
-- or
-- BongBong in a shelter