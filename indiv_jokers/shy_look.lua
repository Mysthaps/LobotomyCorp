local faces = {
    {chips = 40, mult = 15},
    {chips = 20, mult = 5},
    {chips = 5, mult = 1},
    {chips = -20, mult = -5},
    {chips = -40, mult = -15}
}

local joker = {
    name = "Today's Shy Look",
    config = {extra = {
        chips = 5, mult = 1, face = 1,
        elapsed = 0, interval = 2
    }}, rarity = 1, cost = 4,
    pos = {x = 4, y = 6}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "teth",
    discover_rounds = 6,
    loc_txt = {},
}

joker.calculate = function(self, card, context)
    if context.joker_main then
        if card.ability.extra.chips > 0 then
            SMODS.eval_this(card, {
                message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}},
                chip_mod = card.ability.extra.chips, 
                colour = G.C.CHIPS
            })
        else
            SMODS.eval_this(card, {
                message = localize{type = 'variable', key = 'a_chips_minus', vars = {-card.ability.extra.chips}},
                chip_mod = card.ability.extra.chips, 
                colour = G.C.CHIPS
            })
        end

        if card.ability.extra.mult > 0 then
            SMODS.eval_this(card, {
                message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult, 
                colour = G.C.MULT
            })
        else
            SMODS.eval_this(card, {
                message = localize{type = 'variable', key = 'a_mult_minus', vars = {-card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult, 
                colour = G.C.MULT
            })
        end
        --return {}
    end
end

joker.set_sprites = function(self, card, front)
    card.children.mood = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS["lobc_LobotomyCorp_moodboard"], {x = ((card.ability and card.ability.extra) and card.ability.extra.face or 1) - 1, y = 0})
    card.children.mood.role.draw_major = card
    card.children.mood.states.hover.can = false
    card.children.mood.states.click.can = false

    card.children.center.atlas = G.ASSET_ATLAS["lobc_LobotomyCorp_Jokers"]
    local count = G.PROFILES[G.SETTINGS.profile].joker_usage[card.config.center_key] and G.PROFILES[G.SETTINGS.profile].joker_usage[card.config.center_key].count or 0
    if count < card.config.center.discover_rounds then
        card.children.center.atlas = G.ASSET_ATLAS["lobc_LobotomyCorp_Undiscovered"]
    end
    card.children.center:set_sprite_pos(card.config.center.pos)
end

joker.update = function(self, card, dt)
    if G.STAGE == G.STAGES.RUN and G.STATE ~= G.STATES.HAND_PLAYED then
        card.ability.extra.elapsed = card.ability.extra.elapsed + (dt / G.SETTINGS.GAMESPEED)
        if card.ability.extra.elapsed >= card.ability.extra.interval then
            card.ability.extra.elapsed = card.ability.extra.elapsed - card.ability.extra.interval

            card.ability.extra.face = pseudorandom("shy_today", 1, 5)
            card.ability.extra.chips = faces[card.ability.extra.face].chips
            card.ability.extra.mult = faces[card.ability.extra.face].mult
            card.children.mood:set_sprite_pos({x = card.ability.extra.face - 1, y = 0})
        end
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { card.ability.extra.interval, card:check_rounds(2), card:check_rounds(4), card:check_rounds(6)}
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(4) < 4 then
        desc_key = 'dis_'..desc_key..'_2'
    elseif card:check_rounds(6) < 6 then
        desc_key = 'dis_'..desc_key..'_3'
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
    end
end

return joker

-- hod realization reading comprehension