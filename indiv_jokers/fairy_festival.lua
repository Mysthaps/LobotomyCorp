local joker = {
    name = "Fairy Festival",
    config = {}, rarity = 1, cost = 5,
    pos = {x = 5, y = 5}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "zayin",
    discover_rounds = {2, 4},
}

joker.calculate = function(self, card, context)
    if context.starting_shop then
        G.GAME.lobc_fairy_lock_reroll = nil
        local shop_items = {}
        for _, area in pairs(G.I.CARDAREA) do
            if area.config.type == 'shop' then
                for _, item in pairs(area.cards) do
                    if item.ability and item.ability.set ~= "Voucher" and item.cost > 1 then
                        shop_items[#shop_items+1] = item
                    end
                end
            end
        end

        if #shop_items > 0 then
            local selected_card = pseudorandom_element(shop_items, pseudoseed("fairy_festival"))
            selected_card.ability.lobc_fairy_festival = true
            selected_card.children.lobc_fairy_particles = Particles(0, 0, 0,0, {
                timer = 0.05,
                scale = 0.25,
                speed = 0.75,
                lifespan = 1.5,
                attach = selected_card,
                colours = {G.C.GREEN, darken(G.C.GREEN, 0.2), darken(G.C.GREEN, 0.4)},
                fill = true
            })
            selected_card:set_cost()
        end
    end
end

joker.load = function(self, card)
    for _, area in pairs(G.I.CARDAREA) do
        if area.config.type == 'shop' then
            for _, item in pairs(area.cards) do
                if item.ability.lobc_fairy_festival then
                    item.children.lobc_fairy_particles = Particles(0, 0, 0,0, {
                        timer = 0.05,
                        scale = 0.25,
                        speed = 0.75,
                        lifespan = 1.5,
                        attach = item,
                        colours = {G.C.GREEN, darken(G.C.GREEN, 0.2), darken(G.C.GREEN, 0.4)},
                        fill = true
                    })
                end
            end
        end
    end
end

local function fairy_check(card)
    if card.ability.lobc_fairy_festival then
        card.ability.lobc_fairy_festival = nil
        card.children.lobc_fairy_particles:remove()
        card.children.lobc_fairy_particles = nil
        G.GAME.fairy_festival_counter = (G.GAME.fairy_festival_counter or 0) + 1
        if G.GAME.fairy_festival_counter >= 8 then
            check_for_unlock({type = "lobc_wingbeat"})
        end
    else
        local shop_items = {}
        local destroy_others = false
        for _, area in pairs(G.I.CARDAREA) do
            if area.config.type == 'shop' then
                for _, item in ipairs(area.cards) do
                    if item ~= card then
                        if item.ability.lobc_fairy_festival then destroy_others = true end
                        shop_items[#shop_items+1] = item
                    end
                end
            end
        end

        if destroy_others then
            local first_dissolve = nil
            for _, item in ipairs(shop_items) do
                item:start_dissolve({G.C.GREEN, darken(G.C.GREEN, 0.2), darken(G.C.GREEN, 0.4)}, first_dissolve)
                first_dissolve = true
            end
            G.GAME.lobc_fairy_lock_reroll = true
            for k, _ in pairs(G.GAME.current_round.voucher.spawn or {}) do
                G.GAME.current_round.voucher.spawn[k] = false
            end
            G.GAME.fairy_festival_counter = nil
        end
    end
end

-- Remove Fairy Festival effect when bought
local buy_from_shopref = G.FUNCS.buy_from_shop
function G.FUNCS.buy_from_shop(e)
    local card = e.config.ref_table
    if card and ((e.config.id ~= 'buy_and_use' and G.FUNCS.check_for_buy_space(card)) or e.config.id == 'buy_and_use') then
        fairy_check(card)
    end
    buy_from_shopref(e)
end

local use_cardref = G.FUNCS.use_card
function G.FUNCS.use_card(e, mute, nosave)
    local card = e.config.ref_table
    if (card.ability.set == 'Voucher' or card.ability.set == 'Booster') and not nosave and G.STATE == G.STATES.SHOP then
        fairy_check(card)
    end
    use_cardref(e, mute, nosave)
end

-- Fairy Festival rerolling cards
local reroll_shopref = G.FUNCS.reroll_shop
function G.FUNCS.reroll_shop(e)
    local shop_items = {}
    local destroy_others = false
    for _, area in pairs(G.I.CARDAREA) do
        if area.config.type == 'shop' then
            for _, item in ipairs(area.cards) do
                if item ~= card then
                    if item.ability.lobc_fairy_festival and area == G.shop_jokers then destroy_others = true end
                    shop_items[#shop_items+1] = item
                end
            end
        end
    end

    if destroy_others then
        local first_dissolve = nil
        for _, item in ipairs(shop_items) do
            item:start_dissolve({G.C.GREEN, darken(G.C.GREEN, 0.2), darken(G.C.GREEN, 0.4)}, first_dissolve)
            first_dissolve = true
        end
        G.GAME.lobc_fairy_lock_reroll = true
        for k, _ in pairs(G.GAME.current_round.voucher.spawn or {}) do
            G.GAME.current_round.voucher.spawn[k] = false
        end

        G.CONTROLLER.locks.shop_reroll = true
        if G.CONTROLLER:save_cardarea_focus('shop_jokers') then G.CONTROLLER.interrupt.focus = true end
        if G.GAME.current_round.reroll_cost > 0 then 
            inc_career_stat('c_shop_dollars_spent', G.GAME.current_round.reroll_cost)
            inc_career_stat('c_shop_rerolls', 1)
            ease_dollars(-G.GAME.current_round.reroll_cost)
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
            local final_free = G.GAME.current_round.free_rerolls > 0
            G.GAME.current_round.free_rerolls = math.max(G.GAME.current_round.free_rerolls - 1, 0)
            G.GAME.round_scores.times_rerolled.amt = G.GAME.round_scores.times_rerolled.amt + 1
            calculate_reroll_cost(final_free)
            play_sound('coin2')
            play_sound('other1')
            return true
            end
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.3,
            func = function()
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.CONTROLLER.interrupt.focus = false
                        G.CONTROLLER.locks.shop_reroll = false
                        G.CONTROLLER:recall_cardarea_focus('shop_jokers')
                        for i = 1, #G.jokers.cards do
                        G.jokers.cards[i]:calculate_joker({reroll_shop = true})
                        end
                        return true
                    end
                }))
            return true
        end
        }))
        G.E_MANAGER:add_event(Event({ func = function() save_run(); return true end}))
    else
        reroll_shopref(e)
    end 
end

-- Fairy Festival lock rerolls
local can_rerollref = G.FUNCS.can_reroll
function G.FUNCS.can_reroll(e)
    if G.GAME.lobc_fairy_lock_reroll then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
        return
    end
    return can_rerollref(e)
end

return joker

-- the one with three! fightable versions in limbus
-- this and two aberrations