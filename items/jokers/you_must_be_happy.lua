local joker = {
    name = "You Must Be Happy",
    config = {extra = {
        pos = 1.2, neg = 0.85, state = true,
        elapsed = 0, held = 0, is_sold = false, is_bought = true
    }}, rarity = 1, cost = 6,
    pos = {x = 6, y = 6}, 
    blueprint_compat = false, 
    eternal_compat = false,
    perishable_compat = true,
    abno = true,
    risk = "zayin",
    discover_rounds = {2, 3, 5},
}

joker.calculate = function(self, card, context)
    if context.end_of_round and not context.blueprint and context.main_eval then
        card:juice_up()
        card.ability.extra.held = card.ability.extra.held + 1
        if card.ability.extra.held > 5 then
            card.ability.extra.state = false
            card.children.mood:set_sprite_pos({x = 1, y = 0})
            card:calculate_joker{selling_self = true}
            G.E_MANAGER:add_event(Event({func = function()
                card:start_dissolve({G.C.GOLD})
                return true
                end
            }))
        end
    end
    if context.selling_self and not context.blueprint then
        card.ability.extra.is_sold = true
        card_eval_status_text(card, 'extra', nil, nil, nil, {
            message = card.ability.extra.state and "YES" or "NO", 
            colour = card.ability.extra.state and G.C.BLUE or G.C.RED
        })
        local mod = card.ability.extra.state and card.ability.extra.pos^(card.ability.extra.held+1) or card.ability.extra.neg^(card.ability.extra.held+1)
        G.GAME.you_must_be_happy = G.GAME.you_must_be_happy or 1
        G.GAME.you_must_be_happy = G.GAME.you_must_be_happy * mod
        G.GAME.lobc_hod_modifier = G.GAME.lobc_hod_modifier * mod
    end
end

joker.add_to_deck = function(self, card, from_debuff)
    if not from_debuff then
        card.children.mood = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS["lobc_LobotomyCorp_yes_no"], {x = (card.ability and card.ability.extra and card.ability.extra.state) and 0 or 1, y = 0})
        card.children.mood.role.draw_major = card
        card.children.mood.states.hover.can = false
        card.children.mood.states.click.can = false
        card.ability.extra.is_bought = true
    end
end

joker.set_sprites = function(self, card, front)
    if card.ability and card.ability.extra and card.ability.extra.is_bought then
        card.children.mood = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS["lobc_LobotomyCorp_yes_no"], {x = ((card.ability and card.ability.extra) and card.ability.extra.face or 1) - 1, y = 0})
        card.children.mood.role.draw_major = card
        card.children.mood.states.hover.can = false
        card.children.mood.states.click.can = false
    end

    card.children.center.atlas = G.ASSET_ATLAS["lobc_LobotomyCorp_Jokers"]
    local count = lobc_get_usage_count(card.config.center_key)
    if count < card.config.center.discover_rounds[#card.config.center.discover_rounds] and not SMODS.Mods.LobotomyCorp.config.show_art_undiscovered then
        card.children.center.atlas = G.ASSET_ATLAS["lobc_LobotomyCorp_Undiscovered"]
    end
    card.children.center:set_sprite_pos(card.config.center.pos)
end

joker.update = function(self, card, dt)
    if G.STAGE == G.STAGES.RUN and not card.ability.extra.is_sold and card.ability.extra.is_bought then
        card.ability.extra.elapsed = card.ability.extra.elapsed + (dt / G.SETTINGS.GAMESPEED)
        if card.ability.extra.elapsed >= (2 - card.ability.extra.held*0.35) then
            card.ability.extra.elapsed = card.ability.extra.elapsed - (2 * 0.55^card.ability.extra.held)

            card.ability.extra.state = not card.ability.extra.state
            if card.children.mood then
                card.children.mood:set_sprite_pos({x = card.ability.extra.state and 0 or 1, y = 0})
            end

            -- Update JokerDisplay text
            --[[if card.joker_display_values then
                card.joker_display_values.sign_chips = card.ability.extra.chips >= 0 and "+" or ""
                card.joker_display_values.sign_mult = card.ability.extra.mult >= 0 and "+" or ""
            end]]
        end
    end
end

joker.loc_vars = function(self, info_queue, card)
    return {vars = {
        card.ability.extra.pos^(card.ability.extra.held+1), card.ability.extra.neg^(card.ability.extra.held+1), 
        card.ability.extra.pos, card.ability.extra.neg, 
        "unused", "unused", "unused", card.ability.extra.held
    }}
end

if JokerDisplay then
    -- tba
end

return joker

-- DO YOU LOVE THE CITY YOU LIVE IN?
-- [YES]
-- [NO]