local joker = {
    name = "Judgement Bird",
    config = {extra = 10}, rarity = 3, cost = 7,
    pos = {x = 5, y = 3}, 
    blueprint_compat = false, 
    eternal_compat = false,
    perishable_compat = true,
    abno = true,
    risk = "waw",
    discover_rounds = 7,
    no_pool_flag = "apocalypse_bird_event",
}

joker.calculate = function(self, card, context)
    if context.card_destroyed and not context.blueprint and G.GAME.blind and G.GAME.blind.in_blind and not find_passive("psv_lobc_fixed_encounter") then
        local incr = 0
        for _, v in ipairs(context.glass_shattered) do
            if v.config.center ~= G.P_CENTERS.c_base then incr = incr + 1 end
            if v.seal then incr = incr + 1 end
            if v.edition then incr = incr + 1 end
        end

        if incr > 0 then
            local chips = (G.GAME.blind.chips * (card.ability.extra / 100)) * incr
            if type(chips) == 'table' then chips:ceil() else chips = math.ceil(chips) end
            G.GAME.chips = G.GAME.chips + chips
            G.GAME.chips_text = number_format(G.GAME.chips)
            G.hand_text_area.game_chips.config.scale = math.min(0.8, scale_number(G.GAME.chips, 1.1))
            card:juice_up()

            local chips_check = (to_big(G.GAME.chips) >= to_big(G.GAME.blind.chips))
            if chips_check and G.STATE == G.STATES.SELECTING_HAND then
                G.STATE = G.STATES.NEW_ROUND
                G.STATE_COMPLETE = false
            end
        end
    end

    if context.remove_playing_cards and not context.blueprint and G.GAME.blind and G.GAME.blind.in_blind and not find_passive("psv_lobc_fixed_encounter") then
        local incr = 0
        for _, v in ipairs(context.removed) do
            if v.config.center ~= G.P_CENTERS.c_base then incr = incr + 1 end
            if v.seal then incr = incr + 1 end
            if v.edition then incr = incr + 1 end
        end

        if incr > 0 then
            local chips = (G.GAME.blind.chips * (card.ability.extra / 100)) * incr
            if type(chips) == 'table' then chips:ceil() else chips = math.ceil(chips) end
            G.GAME.chips = G.GAME.chips + chips
            G.GAME.chips_text = number_format(G.GAME.chips)
            G.hand_text_area.game_chips.config.scale = math.min(0.8, scale_number(G.GAME.chips, 1.1))
            card:juice_up()

            local chips_check = (to_big(G.GAME.chips) >= to_big(G.GAME.blind.chips))
            if chips_check and G.STATE == G.STATES.SELECTING_HAND then
                G.STATE = G.STATES.NEW_ROUND
                G.STATE_COMPLETE = false
            end
        end
    end
end

joker.add_to_deck = function(self, card, from_debuff)
    if not G.GAME.pool_flags["apocalypse_bird_event"] and not from_debuff and next(SMODS.find_card("j_lobc_punishing_bird")) and next(SMODS.find_card("j_lobc_big_bird")) then
        for _, v in ipairs(SMODS.find_card("j_lobc_punishing_bird")) do
            v.ability.extra.start_apoc = true
            v.children.alert = UIBox{
                definition = create_UIBox_card_alert(), 
                config = {
                    align = "tri",
                    offset = {
                        x = 0.1, y = 0
                    },
                    parent = v
                }
            }
        end
    end
end

-- Destroy drawn cards
local cardarea_emplaceref = CardArea.emplace
function CardArea.emplace(self, card, location, stay_flipped)
    cardarea_emplaceref(self, card, location, stay_flipped)
    if next(SMODS.find_card("j_lobc_judgement_bird")) and self == G.hand and G.GAME.blind and G.GAME.blind.in_blind and (card.config.center ~= G.P_CENTERS.c_base or card.seal or card.edition) then
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            func = function()
                if G.GAME.current_round.discards_left >= 1 then
                    card:start_dissolve({G.C.GOLD})
                    ease_discard(-1, true)
                    G.FUNCS.draw_from_deck_to_hand(1)
                    delay(0.15*G.SETTINGS.GAMESPEED)
                    SMODS.calculate_context({remove_playing_cards = true, removed = {card}})
                end
            return true
            end
        }))
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { card.ability.extra, card:check_rounds(3), card:check_rounds(5), card:check_rounds(7) }
    local desc_key = self.key
    if card:check_rounds(3) < 3 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(5) < 5 then
        desc_key = 'dis_'..desc_key..'_2'
    elseif card:check_rounds(7) < 7 then
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
    -- tba
end

return joker

-- you know My Form Empties? from Limbus Company?
-- yeah if you think about it, that fight is just the same as Judgement Bird from Library of Ruina
-- the gimmick of transferring a status effect to enemies
-- it's a shame you can't attack allies in Limbus but it's piss easy anyway