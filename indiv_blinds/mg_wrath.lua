local blind = {
    name = "Wrath",
    pos = {x = 0, y = 21},
    dollars = 8, 
    mult = 4, 
    vars = {}, 
    debuff = {
        akyrs_cannot_be_disabled = true,
        akyrs_blind_difficulty = "expert",
    },
    boss = {showdown = true, min = 10, max = 10},
    boss_colour = HEX('413536'),
    passives = {
        "psv_lobc_fixed_encounter",
        "psv_lobc_realm",
        "psv_lobc_blind_rage",
        "psv_lobc_today_play",
        "psv_lobc_exploited",
        "psv_lobc_magical_girl"
    },
    lobc_bg = {new_colour = darken(HEX("413536"), 0.15), special_colour = lighten(HEX("413536"), 0.1), contrast = 0.7}
}

local eval_func = function()
    return G.GAME.blind and G.GAME.blind.config.blind.key == 'bl_lobc_mg_wrath'
end

blind.set_blind = function(self)
    lobc_abno_text("wrath_alt", eval_func, 2, 4)
    G.GAME.blind.prepped = nil
    G.GAME.blind.hands_sub = 0 -- Hands passed
    G.GAME.blind.discards_sub = 1 -- Can proc
    G.GAME.servant_triggered = true

    G.GAME.blind:set_text()
end

blind.drawn_to_hand = function(self)
    if G.GAME.blind.prepped then
        G.GAME.blind.hands_sub = G.GAME.blind.hands_sub + 1
        -- [The Exploited] Set score to 50% Blind Size
        if G.GAME.blind.hands_sub == G.GAME.blind.discards_sub and to_big(G.GAME.chips) >= to_big(G.GAME.blind.chips) * 0.9 then
            local ease_to = to_big(G.GAME.blind.chips) / 2
            G.E_MANAGER:add_event(Event({trigger = 'ease', ease = "outback", blockable = false, ref_table = G.GAME, ref_value = 'chips', ease_to = ease_to, delay = 4, func = (function(t) return math.floor(t) end)}))
        end
        G.GAME.blind.prepped = nil
    end
    G.GAME.blind:set_text()
end

blind.press_play = function(self)
    G.GAME.blind.prepped = true
    -- [Today's Play] Disable winning on non-Wrath hands
    if G.GAME.blind.hands_sub == G.GAME.blind.discards_sub then
        G.GAME.lobc_maiden_active = true
    end 
end

blind.calculate = function(self, blind, context)
    if context.after then
        -- Creates The Servant of Wrath
        if G.GAME.blind.hands_sub == 0 then
            G.E_MANAGER:add_event(Event({func = function()
                local card = SMODS.add_card({
                    key = "j_lobc_servant_of_wrath",
                    no_edition = true,
                    area = G.jokers,
                    stickers = {"eternal"},
                })
                card.ability.extra.from_blind = true
                lobc_abno_text("wrath", eval_func, 2, 4)
            return true end }))
        -- Procs The Servant of Wrath
        elseif G.GAME.blind.discards_sub == G.GAME.blind.hands_sub then
            G.GAME.servant_triggered = nil 
            G.GAME.blind.discards_sub = G.GAME.blind.discards_sub + 2
        end
    end
end

blind.mod_score = function(self, score)
    -- [When Two Realms Meet] No scoring
    if G.GAME.blind.hands_sub == 0 then return 0 end
    return score
end

blind.defeat = function(self)
    G.GAME.lobc_maiden_active = nil
    -- Remove The Servant of Wraths
    for _, v in ipairs(SMODS.find_card("j_lobc_servant_of_wrath", true)) do
        v:start_dissolve()
    end
    G.GAME.pool_flags["wrath_defeated"] = true
end

blind.lobc_loc_txt = function(self)
    if not G.GAME.blind.hands_sub then return end
    return {
        key = G.GAME.blind.hands_sub > 0 and "bl_lobc_mg_wrath_alt" or "bl_lobc_mg_wrath_effect",
    }
end

-- [Blind Rage] Do not draw cards, then trigger The Servant of Wrath
local draw_from_deck_to_handref = G.FUNCS.draw_from_deck_to_hand
function G.FUNCS.draw_from_deck_to_hand(e)
    -- Original function, handle no more cards to draw
    if not (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
        G.hand.config.card_limit <= 0 and #G.hand.cards == 0 then 
        G.STATE = G.STATES.GAME_OVER; G.STATE_COMPLETE = false 
        return true
    end

    if G.GAME.blind.config.blind.key == "bl_lobc_mg_wrath" and G.GAME.blind.hands_sub > 0 and not G.GAME.servant_triggered then
        SMODS.calculate_context({lobc_proc_wrath = true})
        return
    end

    return draw_from_deck_to_handref(e)
end

return blind