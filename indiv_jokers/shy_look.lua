local faces = {
    {chips = 30, mult = 15},
    {chips = 15, mult = 5},
    {chips = 5, mult = 1},
    {chips = -15, mult = -5},
    {chips = -30, mult = -15}
}

local joker = {
    name = "Today's Shy Look",
    config = {extra = {
        chips = 30, mult = 15, face = 1,
        elapsed = 0, interval = 2,
        achievement_check = 0
    }}, rarity = 1, cost = 5,
    pos = {x = 4, y = 6}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "teth",
    discover_rounds = {2, 4, 6},
}

joker.calculate = function(self, card, context)
    if context.joker_main then
        if card.ability.extra.face == 1 then
            card.ability.extra.achievement_check = card.ability.extra.achievement_check + 1
            if card.ability.extra.achievement_check >= 10 then
                check_for_unlock({type = "lobc_todays_expression"})
            end
        else
            card.ability.extra.achievement_check = 0
        end

        return {
            chips = card.ability.extra.chips,
            mult = card.ability.extra.mult
        }
    end
end

joker.set_sprites = function(self, card, front)
    card.children.mood = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS["lobc_LobotomyCorp_moodboard"], {x = ((card.ability and card.ability.extra) and card.ability.extra.face or 1) - 1, y = 0})
    card.children.mood.role.draw_major = card
    card.children.mood.states.hover.can = false
    card.children.mood.states.click.can = false

    card.children.center.atlas = G.ASSET_ATLAS["lobc_LobotomyCorp_Jokers"]
    local count = lobc_get_usage_count(card.config.center_key)
    if count < card.config.center.discover_rounds[#card.config.center.discover_rounds] and not SMODS.Mods.LobotomyCorp.config.show_art_undiscovered then
        card.children.center.atlas = G.ASSET_ATLAS["lobc_LobotomyCorp_Undiscovered"]
    end
    card.children.center:set_sprite_pos(card.config.center.pos)
end

joker.update = function(self, card, dt)
    if G.STAGE == G.STAGES.RUN and G.STATE ~= G.STATES.HAND_PLAYED then
        card.ability.extra.elapsed = card.ability.extra.elapsed + (dt / G.SETTINGS.GAMESPEED)
        if card.ability.extra.elapsed >= card.ability.extra.interval then
            card.ability.extra.elapsed = card.ability.extra.elapsed - card.ability.extra.interval

            local old_face = card.ability.extra.face
            while card.ability.extra.face == old_face do
                card.ability.extra.face = math.random(1, 5)
            end
            card.ability.extra.chips = faces[card.ability.extra.face].chips
            card.ability.extra.mult = faces[card.ability.extra.face].mult
            card.children.mood:set_sprite_pos({x = card.ability.extra.face - 1, y = 0})

            -- Update JokerDisplay text
            if card.joker_display_values then
                card.joker_display_values.sign_chips = card.ability.extra.chips >= 0 and "+" or ""
                card.joker_display_values.sign_mult = card.ability.extra.mult >= 0 and "+" or ""
            end
        end
    end
end

joker.loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.interval}}
end

if JokerDisplay then
    JokerDisplay.Definitions.j_lobc_shy_look = {
        text = {
            { ref_table = "card.joker_display_values", ref_value = "sign_chips", colour = G.C.CHIPS },
            { ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS },
            { text = " " },
            { ref_table = "card.joker_display_values", ref_value = "sign_mult", colour = G.C.MULT },
            { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT }
        },
        calc_function = function(card)
            card.joker_display_values.sign_chips = card.ability.extra.chips >= 0 and "+" or ""
            card.joker_display_values.sign_mult = card.ability.extra.mult >= 0 and "+" or ""
        end,
        style_function = function(card, text, reminder_text, extra)
            if text then 
                text.states.visible = card:check_rounds(6) >= 6
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

-- hod realization reading comprehension