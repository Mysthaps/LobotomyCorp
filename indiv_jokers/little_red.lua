local function mark_card()
    G.GAME.lobc_little_red_marked_card = nil
    local wolves = SMODS.find_card("j_lobc_big_bad_wolf", true)
    local available_cards = {}
    if next(wolves) then
        for _, v in ipairs(wolves) do
            if not SMODS.is_eternal(v) then available_cards[#available_cards + 1] = v end
        end
    end
    if #available_cards == 0 then -- all wolves are eternal, or no wolves
        for _, v in ipairs(G.playing_cards) do
            if not SMODS.is_eternal(v) then available_cards[#available_cards + 1] = v end
        end
    end

    if #available_cards > 0 then
        local selected_card = pseudorandom_element(available_cards, pseudoseed("little_red_card"))
        if selected_card.config.center.key == "j_lobc_big_bad_wolf" then
            for _, v in ipairs(G.playing_cards) do
                v.ability.little_red_marked = nil
                if v.children.lobc_prey then v.children.lobc_prey:remove(); v.children.lobc_prey = nil end
            end
        end
        selected_card.ability.little_red_marked = true
        selected_card.children.lobc_prey = Sprite(selected_card.T.x, selected_card.T.y, selected_card.T.w, selected_card.T.h, G.ASSET_ATLAS["lobc_LobotomyCorp_modifiers"], {x = 4, y = 0})
        selected_card.children.lobc_prey.role.major = selected_card
        selected_card.children.lobc_prey.states.hover.can = false
        selected_card.children.lobc_prey.states.click.can = false
    end
end

local joker = {
    name = "Little Red Riding Hooded Mercenary",
    config = {extra = {
        money = 7, cost = 7, mult = 0, mult_gain = 15, cost_increase = 7
    }}, rarity = 3, cost = 7,
    pos = {x = 1, y = 3}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = false,
    abno = true,
    risk = "waw",
    discover_rounds = {1, 3, 7},
    discover_override = {nil, "lobc_obs_active_2", nil}
}

joker.calculate = function(self, card, context)
    if context.remove_playing_cards and not context.blueprint then
        local removed = 0
        for _, v in ipairs(context.removed) do
            if v.ability.little_red_marked then
                removed = removed + 1
            end
        end
        if removed > 0 then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain * removed
            return {
                dollars = card.ability.extra.money * removed,
                message = localize("k_upgrade_ex"),
            }
        end
    end

    if context.remove_big_bad_wolf and not context.blueprint then
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain * 3
        check_for_unlock({type = 'lobc_crimson_scar'})
        return {
            dollars = card.ability.extra.money * 3,
            message = localize("k_upgrade_ex"),
        }
    end

    if context.joker_main then
        return {
            mult = card.ability.extra.mult,
            card = context.blueprint_card or card,
        }
    end
end

joker.lobc_can_use_active = function(self, card)
    local can_use = false
    for _, v in ipairs(G.hand.cards) do
        if v.ability.little_red_marked then can_use = true end
    end
    for _, v in ipairs(G.jokers.cards) do
        if v.ability.little_red_marked then can_use = true end
    end
    return can_use and to_big(G.GAME.dollars) >= to_big(card.ability.extra.cost)
end

joker.lobc_active = function(self, card)
    ease_dollars(-card.ability.extra.cost)
    card.ability.extra.cost = card.ability.extra.cost + card.ability.extra.cost_increase
    local _card = nil
    for _, v in ipairs(G.hand.cards) do
        if v.ability.little_red_marked then _card = v; break; end
    end
    for _, v in ipairs(G.jokers.cards) do
        if v.ability.little_red_marked then v.destroyed_by_little_red = true; _card = v; break; end
    end
    play_sound("lobc_littlered_gun", 1, 0.6)
    delay(0.2*G.SETTINGS.GAMESPEED)
    G.E_MANAGER:add_event(Event({
        func = function()
            _card:start_dissolve()
            delay(0.2)
            SMODS.calculate_context({ 
                remove_playing_cards = _card.playing_card and true or nil, 
                remove_big_bad_wolf = (_card.config.center.key == "j_lobc_big_bad_wolf") and true or nil, 
                removed = { _card } 
            })
            return true
        end
    }))
    G.FUNCS.draw_from_deck_to_hand(1)
end

joker.update = function(self, card, dt)
    if G.STAGE == G.STAGES.RUN and card.area == G.jokers and not card.debuff and not G.GAME.lobc_little_red_marked_card then
        local has_prey = nil
        for _, v in ipairs(G.playing_cards) do
            if v.ability.little_red_marked then has_prey = true; break; end
        end
        local wolves = SMODS.find_card("j_lobc_big_bad_wolf")
        for _, v in ipairs(wolves) do
            if not v.ability.little_red_marked then has_prey = false; break; end
        end
        if not has_prey then mark_card() end
    end
end

-- When BaWbBW is removed not from LRRHM
local card_start_dissolveref = Card.start_dissolve
function Card.start_dissolve(self, ...)
    if self.config.center.key == "j_lobc_big_bad_wolf" and not self.destroyed_by_little_red then
        for _, v in ipairs(SMODS.find_card("j_lobc_little_red")) do
            v.ability.extra.mult = v.ability.extra.mult - 200
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.1,
                func = function()
                    card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize("k_lobc_downgrade")})
                    v.ability.eternal = true
                return true
                end
            }))
        end
    end
    card_start_dissolveref(self, ...)
end

joker.loc_vars = function(self, info_queue, card)
    if not card.fake_card and card:check_rounds() >= 1 then info_queue[#info_queue+1] = {key = 'lobc_marked', set = 'Other'} end
    info_queue[#info_queue+1] = {key = 'lobc_active_ability', set = 'Other'}
    local bw = next(SMODS.find_card("j_lobc_big_bad_wolf"))
    return {vars = {card.ability.extra.money * (bw and 3 or 1), card.ability.extra.mult_gain * (bw and 3 or 1), 
                card.ability.extra.mult, card.ability.extra.cost,
                "unused", "unused", "unused",
                "F-02-58", card.ability.extra.cost_increase, (card.ability.extra.mult >= 0 and "+" or "")
    }, key = (bw and "j_lobc_little_red_alt" or nil)}
end

return joker

-- holy shit is that the red mist