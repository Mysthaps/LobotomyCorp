local joker = {
    name = "Der Freischütz",
    config = {extra = {
        active = false, x_mult = 1.4, cost = 25, min_cost = 5, bullet = 0, should_chamber = false, active_delay = false
    }}, rarity = 2, cost = 7,
    pos = {x = 1, y = 4}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "he",
    discover_rounds = {2, 4, 7, 8},
    discover_override = {"lobc_obs_active_1", nil, nil, nil}
}

joker.lobc_active = function(self, card)
    card.ability.extra.active = true
    ease_dollars(-math.floor(G.GAME.dollars * card.ability.extra.cost / 100))
    SMODS.calculate_effect({message = localize("k_lobc_active"), colour = get_badge_colour("lobc_prey_mark")}, card)
end

joker.lobc_can_use_active = function(self, card)
    return G.GAME.dollars >= card.ability.extra.min_cost * card.ability.extra.cost / 100 and not card.ability.extra.active
end

local function add_bullet(card)
    card.ability.extra.bullet = (card.ability.extra.bullet >= 7 and 0 or card.ability.extra.bullet + 1)
    SMODS.calculate_effect({ 
        message = card.ability.extra.bullet == 0 and localize('k_reset') or localize{type = 'variable', key = 'lobc_a_magic_bullet', vars = {1}},
        colour = get_badge_colour("lobc_prey_mark")
    }, card)
    if card.ability.extra.bullet >= 7 and not card.ability.extra.active then
        card.ability.extra.active = true
        SMODS.calculate_effect({
            message = localize("k_lobc_active"), 
            colour = get_badge_colour("lobc_prey_mark")
        }, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                juice_card_until(card, function() return card.ability.extra.active end)
            return true
            end
        }))
    end
end

joker.calculate = function(self, card, context)
    if context.press_play and card.ability.extra.active and not context.blueprint then
        play_sound("lobc_freischutz_create", 1, 0.7)
        G.E_MANAGER:add_event(Event({
            delay = 1,
            timer = 'REAL',
            func = function()
                local destroyed_cards = {}
                local to_iterate = {}
                if card.ability.extra.bullet >= 7 then
                    card.ability.extra.active_delay = true
                    local available_cards = {}
                    for _, v in ipairs(G.playing_cards) do
                        if v.config.center == G.P_CENTERS.c_base or not SMODS.is_eternal(v, card) then
                            available_cards[#available_cards + 1] = v
                        end
                    end

                    for _ = 1, 7 do
                        if #available_cards > 0 then
                            local chosen_card, chosen_card_key = pseudorandom_element(available_cards, pseudoseed("freischutz_random"))
                            to_iterate[#to_iterate+1] = chosen_card
                            table.remove(available_cards, chosen_card_key)
                        end
                    end
                else
                    to_iterate = G.play.cards
                end

                for _, v in ipairs(to_iterate) do
                    if v.debuff then
                        SMODS.calculate_effect({
                            message = localize('k_debuffed'),
                            colour = G.C.RED
                        }, v)
                    end
                    if v.config.center == G.P_CENTERS.c_base then
                        v:set_ability(G.P_CENTERS.m_mult)
                        v:juice_up()
                    else
                        destroyed_cards[#destroyed_cards + 1] = v
                    end
                end
                if #destroyed_cards >= 7 then check_for_unlock({type = "lobc_magic_bullet"}) end
                SMODS.destroy_cards(destroyed_cards)
                add_bullet(card)
                card.ability.extra.active = false
                play_sound("lobc_freischutz_shot", 1, 0.7)
                return true 
            end 
        }))
        return nil, true
    end

    if context.before and not context.blueprint then
        card.ability.extra.should_chamber = false
    end

    if context.individual and context.cardarea == G.play and context.other_card then
        if context.other_card.config.center == G.P_CENTERS.m_mult then
            return {
                xmult = card.ability.extra.x_mult,
                card = context.blueprint_card or card,
            }
        elseif not context.blueprint then
            card.ability.extra.should_chamber = true
        end
    end

    if context.after and card.ability.extra.should_chamber then
        if not card.ability.extra.active_delay then add_bullet(card) end
        card.ability.extra.active_delay = false
    end
end

joker.loc_vars = function(self, info_queue, card)
    info_queue[#info_queue+1] = {key = 'lobc_active_ability', set = 'Other'}
    return {vars = {
        card.ability.extra.x_mult, card.ability.extra.cost, card.ability.extra.bullet, card.ability.extra.min_cost
    }}
end

return joker

-- whose idea was it to make magic bullet id AND ego required to run burn