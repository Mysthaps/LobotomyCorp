local lights = {
    {x_mult = 1.25, dollars = 2},
    {x_mult = 1.5, dollars = 4},
    {x_mult = 2, dollars = 8},
    {x_mult = 3, dollars = 15}
}

local joker = {
    name = "Express Train to Hell",
    config = {extra = {
        active_light = 0, light = 0,
        elapsed = 0, interval = 10,
        achievement_check = 0
    }}, rarity = 3, cost = 7,
    pos = {x = 8, y = 5}, 
    blueprint_compat = true, 
    eternal_compat = false,
    perishable_compat = true,
    abno = true,
    risk = "waw",
    discover_rounds = 6,
}

joker.calculate = function(self, card, context)
    if context.joker_main then
        if card.ability.extra.light == 4 then
            card.ability.extra.achievement_check = card.ability.extra.achievement_check + 1
            if card.ability.extra.achievement_check >= 10 then
                --check_for_unlock({type = "lobc_todays_expression"})
            end
        else
            card.ability.extra.achievement_check = 0
        end

        if card.ability.extra.active_light == 0 then return nil end
        local light = lights[card.ability.extra.active_light]
        card.ability.extra.active_light = 0
        return {
            x_mult = light.x_mult,
            dollars = light.dollars
        }
    end
    if context.selling_self and not context.blueprint then
        if card.ability.extra.active_light < card.ability.extra.light then
            card.ability.extra.active_light = card.ability.extra.light
        end
        card.ability.extra.light = 0
        card.ability.extra.elapsed = 0
        card.children.mood:set_sprite_pos({x = 0, y = 0})
        card:juice_up()
        play_sound("lobc_train_sell", 1, 0.6)
    end
end

joker.add_to_deck = function(self, card, from_debuff)
    if not from_debuff then
        card.children.mood = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS["lobc_LobotomyCorp_lights"], {x = card.ability.extra.light, y = 0})
        card.children.mood.role.draw_major = card
        card.children.mood.states.hover.can = false
        card.children.mood.states.click.can = false
        card.ability.extra.is_bought = true
    end
end

local funcs_sell_cardref = G.FUNCS.sell_card
function G.FUNCS.sell_card(e)
    local card = e.config.ref_table
    if card.config.center.key == "j_lobc_express_train" and card.ability.extra.light > 0 then
        stop_use()
        if card.children.sell_button then card.children.sell_button:remove(); card.children.sell_button = nil end
        
        local eval, post = eval_card(card, {selling_self = true})
        SMODS.trigger_effects({eval, post}, card)
        card.area:remove_from_highlighted(card)
        return
    end
    funcs_sell_cardref(e)
end

joker.set_sprites = function(self, card, front)
    if card.ability and card.ability.extra and card.ability.extra.is_bought then
        card.children.mood = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS["lobc_LobotomyCorp_lights"], {x = card.ability.extra.light, y = 0})
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

joker.update = function(self, card, dt)
    if G.STAGE == G.STAGES.RUN and not card.ability.extra.is_sold and card.ability.extra.is_bought and
    not ((G.play and #G.play.cards > 0) or (G.CONTROLLER.locked) or (G.GAME.STOP_USE and G.GAME.STOP_USE > 0))  then
        card.ability.extra.elapsed = card.ability.extra.elapsed + (dt / G.SETTINGS.GAMESPEED)
        if card.ability.extra.elapsed >= card.ability.extra.interval then
            card.ability.extra.elapsed = card.ability.extra.elapsed - card.ability.extra.interval

            card.ability.extra.light = card.ability.extra.light + 1
            if card.ability.extra.light > 4 then
                local available_cards = {}
                for _, v in ipairs(G.jokers.cards) do
                    if v ~= card and not v.ability.eternal then available_cards[#available_cards+1] = v end
                end

                G.E_MANAGER:add_event(Event({trigger = 'before', blockable = false, delay = 1, timer = "REAL", func = function()
                    play_sound("lobc_train_start", 1, 0.6)
                return true end}))

                for i = 1, math.ceil(#G.jokers.cards / 2) do
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 1, func = function()
                        if #available_cards > 0 then
                            local selected_card = pseudorandom_element(available_cards, pseudoseed("express_train"))
                            selected_card:start_dissolve()
                        end
                    return true end}))
                end

                card.ability.extra.light = 0
                G.E_MANAGER:add_event(Event({trigger = 'after', func = function()
                    save_run()
                return true end}))
            end
            card.children.mood:set_sprite_pos({x = card.ability.extra.light, y = 0})
            card:juice_up(0.07, 0.07)
        end
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { 
        card.ability.extra.active_light > 0 and lights[card.ability.extra.active_light].x_mult or 1,
        card.ability.extra.active_light > 0 and lights[card.ability.extra.active_light].dollars or 0,
        card.ability.extra.interval, card:check_rounds(2), card:check_rounds(4), card:check_rounds(6)
    }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(4) < 4 then
        desc_key = 'dis_'..desc_key..'_2'
    elseif card:check_rounds(6) < 6 then
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
    JokerDisplay.Definitions.j_lobc_express_train = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.joker_display_values", ref_value = "x_mult" }
                }
            },
            { text = " $", colour = G.C.MONEY },
            { ref_table = "card.joker_display_values", ref_value = "dollars", colour = G.C.MONEY }
        },
        calc_function = function(card)
            card.joker_display_values.x_mult = card.ability.extra.active_light > 0 and lights[card.ability.extra.active_light].x_mult or 1
            card.joker_display_values.dollars = card.ability.extra.active_light > 0 and lights[card.ability.extra.active_light].dollars or 0
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