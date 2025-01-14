local joker = {
    name = "Opened Can of WellCheers",
    config = {extra = {
        chips = 90, mult = 15, face = 1,
        achievement_check = 0
    }}, rarity = 1, cost = 5,
    pos = {x = 6, y = 2}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "zayin",
    discover_rounds = 5,
}

joker.calculate = function(self, card, context)
    if (context.pre_discard or context.after) and not context.blueprint then
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
            local old_face = card.ability.extra.face
            while card.ability.extra.face == old_face do
                card.ability.extra.face = pseudorandom("wellcheers", 1, 3)
            end
            card.children.mood:set_sprite_pos({x = card.ability.extra.face - 1, y = 0})
            card:juice_up()
        return true end}))
    end

    if context.joker_main then
        if card.ability.extra.face == 1 then
            return {
                mult = card.ability.extra.mult
            }
        end

        if card.ability.extra.face == 2 then
            return {
                chips = card.ability.extra.chips
            }
        end

        if card.ability.extra.face == 3 and not context.blueprint then
            ease_hands_played(-2)
            ease_discard(-2)
        end
    end
end

joker.add_to_deck = function(self, card, from_debuff)
    if not from_debuff then
        card.ability.extra.face = pseudorandom("wellcheers", 1, 3)
        card.children.mood = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS["lobc_LobotomyCorp_wellcheers"], {x = card.ability.extra.face - 1, y = 0})
        card.children.mood.role.draw_major = card
        card.children.mood.states.hover.can = false
        card.children.mood.states.click.can = false
        card.ability.extra.is_bought = true
    end
end

joker.set_sprites = function(self, card, front)
    if card.ability and card.ability.extra and card.ability.extra.is_bought then
        card.children.mood = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS["lobc_LobotomyCorp_wellcheers"], {x = card.ability.extra.face - 1, y = 0})
        card.children.mood.role.draw_major = card
        card.children.mood.states.hover.can = false
        card.children.mood.states.click.can = false
    end

    card.children.center.atlas = G.ASSET_ATLAS["lobc_LobotomyCorp_Jokers"]
    local count = lobc_get_usage_count(card.config.center_key)
    if count < card.config.center.discover_rounds and not SMODS.Mods.LobotomyCorp.config.show_art_undiscovered then
        card.children.center.atlas = G.ASSET_ATLAS["lobc_LobotomyCorp_Undiscovered"]
    end
    card.children.center:set_sprite_pos(card.config.center.pos)
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { card.ability.extra.mult, card.ability.extra.chips, card:check_rounds(2), card:check_rounds(3), card:check_rounds(5)}
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(3) < 3 then
        desc_key = 'dis_'..desc_key..'_2'
    elseif card:check_rounds(5) < 5 then
        desc_key = 'dis_'..desc_key..'_3'
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
    JokerDisplay.Definitions.j_lobc_wellcheers = {
        text = {
            { text = "+", colour = G.C.CHIPS },
            { ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS },
            { text = " " },
            { text = "+", colour = G.C.MULT },
            { ref_table = "card.ability.extra", ref_value = "mult", colour = G.C.MULT }
        },
        calc_function = function(card)
            card.joker_display_values.chips = card.ability.extra.face == 2 and card.ability.extra.chips or 0
            card.joker_display_values.mult = card.ability.extra.face == 1 and card.ability.extra.mult or 0
        end,
        style_function = function(card, text, reminder_text, extra)
            if text then 
                text.states.visible = card:check_rounds(3) >= 3
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