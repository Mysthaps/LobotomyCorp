local blind = {
    name = "Hatred",
    pos = {x = 0, y = 20},
    dollars = 8, 
    mult = 4, 
    vars = {}, 
    debuff = {
        akyrs_cannot_be_disabled = true,
        akyrs_blind_difficulty = "expert",
    },
    boss = {showdown = true, min = 10, max = 10},
    boss_colour = HEX('CB34B4'),
    passives = {
        "psv_lobc_fixed_encounter",
        "psv_lobc_hatred",
        "psv_lobc_adverse",
        "psv_lobc_arcana",
        "psv_lobc_power",
        "psv_lobc_magical_girl"
    },
    lobc_bg = {new_colour = darken(HEX("CB34B4"), 0.1), special_colour = darken(HEX("CB34B4"), 0.3), contrast = 0.7}
}

local run_once = false
local lamped = false
blind.set_blind = function(self)
    local eval_func = function()
        return G.GAME.blind and G.GAME.blind.config.blind.key == 'bl_lobc_mg_hatred' and not G.GAME.blind.transformed
    end
    lobc_abno_text("hatred", eval_func, 2, 6)
    G.GAME.blind.prepped = true
    G.GAME.blind.hysteria = 0
    G.GAME.blind.hands_sub = -2 -- Hands passed
    G.GAME.blind.transformed = false
    G.GAME.blind.alt_skill = false
    G.GAME.blind:set_text()
    run_once = false
end

blind.drawn_to_hand = function(self)
    if G.GAME.blind.prepped then
        lamped = false
        -- Reset marked cards
        for _, v in ipairs(G.playing_cards) do
            v.ability.hatred_villain = nil
            if v.children.lobc_villain then v.children.lobc_villain:remove(); v.children.lobc_villain = nil end
        end
        -- [Arcana Slave] Switch to alt skill every 3 hands
        G.GAME.blind.hands_sub = math.abs(G.GAME.blind.hands_sub + 1) % 3
        if G.GAME.blind.hands_sub == 0 then
            G.GAME.blind.alt_skill = true
        end

        -- [Adverse Change] Move to phase 2
        if to_big(G.GAME.chips) >= to_big(G.GAME.blind.chips) / 2 and not G.GAME.blind.transformed then
            G.GAME.blind.transformed = true
            -- [Arcana Slave] Switch to alt skill when Adverse Change triggers
            G.GAME.blind.alt_skill = true

            G.GAME.blind.hysteria = G.GAME.blind.hysteria + G.GAME.current_round.hands_left
            ease_hands_played(1)
            ease_discard(1)
            G.E_MANAGER:add_event(Event({func = function()
                play_sound("lobc_hatred_switch", 1, 0.8)
                lobc_screen_text({text = localize('k_lobc_hatred_switch'), scale = 0.35, hold = 7*G.SETTINGS.GAMESPEED, major = G.play, align = 'cm', offset = {x = 0, y = -3.1}, noisy = false, colour = HEX("ffedf5")})
                local eval_func = function()
                    return G.GAME.blind and G.GAME.blind.config.blind.key == 'bl_lobc_mg_hatred' and G.GAME.blind.transformed
                end
                lobc_abno_text("hatred_alt", eval_func, 2, 6)
                G.GAME.lobc_maiden_active = false
            return true end}))
        elseif G.GAME.current_round.hands_left <= 0 then
            G.STATE = G.STATES.NEW_ROUND
            G.STATE_COMPLETE = false
        end

        -- Mark cards
        if not G.GAME.blind.alt_skill then
            local available_cards = {}
            for _, v in ipairs(G.hand.cards) do
                if not v.ability.hatred_villain then
                    available_cards[#available_cards + 1] = v
                end
            end
            for _ = 1, G.GAME.blind.hysteria + 1 do
                if #available_cards > 0 then
                    local chosen_card, chosen_card_key = pseudorandom_element(available_cards, pseudoseed("random_card"))
                    chosen_card.ability.hatred_villain = true
                    chosen_card:juice_up()
                    table.remove(available_cards, chosen_card_key)
                end
            end
        end
        G.GAME.blind.prepped = nil
    end
    G.GAME.blind:set_text()
end

blind.press_play = function(self)
    G.GAME.blind.prepped = true
    if not G.GAME.blind.alt_skill then
        G.E_MANAGER:add_event(Event({func = function()
            local villains = {}
            for _, v in ipairs(G.hand.cards) do
                if v.ability.hatred_villain then
                    table.insert(villains, v)
                    if not SMODS.is_eternal(v, {destroy_cards = true}) then
                        G.GAME.blind.hysteria = math.max(G.GAME.blind.hysteria - 1, 0)
                    end
                end
            end
            if #villains > 0 then 
                SMODS.destroy_cards(villains) 
                if G.GAME.blind.transformed then return true end
                local skill = 3
                if #villains == 1 then skill = 1
                elseif #villains == 2 or #villains == 3 then skill = 2 end
                play_sound("lobc_hatred_s"..skill, 1, 0.8)
                lobc_screen_text({text = localize('k_lobc_hatred_s'..skill), scale = 0.35, hold = 1.5*G.SETTINGS.GAMESPEED, major = G.play, align = 'cm', offset = {x = 0, y = -3.5}, noisy = false, colour = HEX("ffedf5")})
            end
        return true end}))
    end
end

blind.calculate = function(self, blind, context)
    if context.before then
        -- Alt skill
        if G.GAME.blind.alt_skill then
            G.GAME.blind.alt_skill = false
            local count = 0
            for _, v in ipairs(context.scoring_hand) do
                if not SMODS.has_no_rank(v) then count = count + v.base.nominal end
                if v:is_suit("Hearts") then count = count + 5 end
            end
            if count <= math.min(G.GAME.starting_params.play_limit and 15*G.GAME.starting_params.play_limit or 75, G.GAME.blind.hysteria * 5) then 
                lamped = true
                G.E_MANAGER:add_event(Event({func = function()
                    play_sound("lobc_hatred_alt", 1, 0.8)
                    lobc_screen_text({text = localize('k_lobc_hatred_slave'), scale = 0.35, hold = 2*G.SETTINGS.GAMESPEED, major = G.play, align = 'cm', offset = {x = 0, y = -3.5}, noisy = false, colour = HEX("ffedf5")})
                    ease_hands_played(-(G.GAME.blind.hysteria >= 20 and G.GAME.blind.hysteria or math.max(1, math.min(math.ceil(G.GAME.current_round.hands_left / 2), math.floor(G.GAME.blind.hysteria / 2)))))
                return true end}))
            end
        end
    end
    if context.after then
        -- [In the Name of Hate] Increase Hysteria
        G.E_MANAGER:add_event(Event({func = function()
            for _, v in ipairs(G.playing_cards) do
                if v.ability.hatred_villain then
                    G.GAME.blind.hysteria = G.GAME.blind.hysteria + 1
                end
            end
            G.GAME.blind.hysteria = G.GAME.blind.hysteria + G.GAME.current_round.hands_played
        return true end}))
    end
end

blind.defeat = function(self)
    G.GAME.pool_flags["hatred_defeated"] = true
    for _, v in ipairs(G.playing_cards) do
        v.ability.hatred_villain = nil
        if v.children.lobc_villain then v.children.lobc_villain:remove(); v.children.lobc_villain = nil end
    end
end

blind.mod_score = function(self, score)
    if lamped then return 0 end
    -- [Adverse Change] Up to 50% Blind Size
    if to_big(G.GAME.chips) < to_big(G.GAME.blind.chips) / 2 and to_big(G.GAME.chips) + score >= to_big(G.GAME.blind.chips) / 2 then
        if G.GAME.current_round.hands_left == 0 then G.GAME.lobc_maiden_active = true; print("proc") end
        return to_big(G.GAME.blind.chips) / 2 - to_big(G.GAME.chips)
    end
    return score
end

blind.lobc_loc_txt = function(self)
    if not G.GAME.blind.hysteria then return end
    return {
        key = G.GAME.blind.alt_skill and "bl_lobc_mg_hatred_alt" or "bl_lobc_mg_hatred_effect", 
        vars = {
            G.GAME.blind.hysteria,
            G.GAME.blind.alt_skill and math.min(G.GAME.starting_params.play_limit and 15*G.GAME.starting_params.play_limit or 75, G.GAME.blind.hysteria * 5) or G.GAME.blind.hysteria + 1,
            G.GAME.blind.hysteria >= 20 and G.GAME.blind.hysteria or math.max(1, math.min(math.ceil(G.GAME.current_round.hands_left / 2), math.floor(G.GAME.blind.hysteria / 2))),
        }
    }
end

return blind