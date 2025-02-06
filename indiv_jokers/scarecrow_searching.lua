local joker = {
    name = "Scarecrow Searching for Wisdom",
    config = {extra = {created = 0, active = true}}, rarity = 2, cost = 7,
    pos = {x = 9, y = 5}, 
    blueprint_compat = false, 
    eternal_compat = true,
    perishable_compat = false,
    abno = true,
    risk = "he",
    discover_rounds = 6,
}

joker.calculate = function(self, card, context)
    if context.setting_blind and not card.getting_sliced and not context.blueprint then
        card.ability.extra.active = true
    end

    if context.cardarea == G.jokers and context.after and not context.blueprint then
        local _card = SMODS.find_card("c_lobc_wisdom")[1]
        if _card then
            _card:start_dissolve()
            
            for _, v in ipairs(context.scoring_hand) do
                local options = {}
                local chosen = nil
                if v.config.center == G.P_CENTERS.c_base then options[#options+1] = "enhancement" end
                if not v.seal then options[#options+1] = "seal" end
                if not v.edition then options[#options+1] = "edition" end

                if next(options) then chosen = pseudorandom_element(options, pseudoseed("scarecrow_choose")) end

                if chosen == "enhancement" then
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                        local ret = pseudorandom_element(G.P_CENTER_POOLS['Enhanced'], pseudoseed("scarecrow_enhancement"))
                        v:set_ability(ret)
                        v:juice_up()
                        return true 
                    end }))
                elseif chosen == "seal" then
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                        local seal_type = pseudorandom(pseudoseed("scarecrow_seal"))
                        v:set_seal(SMODS.Seal.rng_buffer[math.ceil(seal_type*#SMODS.Seal.rng_buffer) or 1])
                        v:juice_up()
                        return true 
                    end }))
                elseif chosen == "edition" then
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                        local edition = poll_edition("scarecrow_edition", nil, nil, true)
                        v:set_edition(edition, true)
                        v:juice_up()
                        return true 
                    end }))
                end
            end
            card:juice_up()
        else
            if card.ability.extra.active then
                card.ability.extra.active = false
                local chips = (G.GAME.blind.chips * (1 + (2*card.ability.extra.created) / 10))
                if type(chips) == 'table' then chips:ceil() else chips = math.ceil(chips) end
                G.GAME.blind.chips = chips
                G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips)
                G.HUD_blind:recalculate() 
                G.hand_text_area.blind_chips:juice_up()
                play_sound('chips2')
                card:juice_up()
            end
        end
        return nil, true
    end

    if context.end_of_round and not context.blueprint and context.main_eval then
        play_sound('timpani')
        for i = 1, math.min(2, G.consumeables.config.card_limit - #G.consumeables.cards) do
            local _card = create_card('EGO_Gift', G.consumeables, nil, nil, nil, nil, 'c_lobc_wisdom', 'scarecrow')
            _card:add_to_deck()
            G.consumeables:emplace(_card)
            card.ability.extra.created = card.ability.extra.created + 1
        end
        card:juice_up(0.3, 0.5)
        return nil, true
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { 
        card.ability.extra.created,
        card:check_rounds(2), card:check_rounds(4), card:check_rounds(6)
    }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    else
        info_queue[#info_queue+1] = G.P_CENTERS["c_lobc_wisdom"]
        if card:check_rounds(4) < 4 then
            desc_key = 'dis_'..desc_key..'_2'
        elseif card:check_rounds(6) < 6 then
            desc_key = 'dis_'..desc_key..'_3'
        end
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
    JokerDisplay.Definitions.j_lobc_scarecrow_searching = {
        reminder_text = {
            { text = "(" },
            { ref_table = "card.ability.extra", ref_value = "created", colour = G.C.PURPLE },
            { text = ")" },
        },
        style_function = function(card, text, reminder_text, extra)
            if text then 
            end
            if reminder_text then
                reminder_text.states.visible = card:check_rounds(6) >= 6
            end
            if extra then
            end
            return false
        end
    }
end

return joker

-- free prudence grinder ngl