local blind = {
    name = "Indigo Noon",
    lobc_color = "indigo",
    lobc_time = "noon",
    pos = {x = 0, y = 14},
    dollars = 4, 
    mult = 1.5, 
    vars = {}, 
    debuff = {},
    loc_txt = {}
}

-- Indigo Noon
local discard_cards_from_highlightedref = G.FUNCS.discard_cards_from_highlighted
G.FUNCS.discard_cards_from_highlighted = function(e, hook)
    if G.GAME.blind.config.blind.key == "bl_lobc_noon_indigo" and not G.GAME.blind.disabled then
        local proc = false
        for _ = 1, math.min(#G.hand.highlighted, G.discard.config.card_limit - #G.play.cards) do
            local chips = get_blind_amount(G.GAME.round_resets.ante)*G.GAME.starting_params.ante_scaling*0.1
            if type(chips) == 'table' then chips:ceil() else chips = math.ceil(chips) end
            G.GAME.blind.chips = G.GAME.blind.chips + chips
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips)
            G.HUD_blind:recalculate() 
            G.hand_text_area.blind_chips:juice_up()
            proc = true
        end
        if proc then G.GAME.blind:wiggle() end
    end
    discard_cards_from_highlightedref(e, hook)
end

return blind