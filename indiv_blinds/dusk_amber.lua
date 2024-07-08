local blind = {
    name = "Amber Dusk",
    color = "amber",
    time = "dusk",
    pos = {x = 0, y = 3},
    dollars = 5, 
    mult = 2, 
    vars = {}, 
    debuff = {},
    loc_txt = {}
}

blind.press_play = function(self)
    local proc = false
    G.E_MANAGER:add_event(Event({
        func = function()
            for _, v in ipairs(G.play.cards) do
                if v.debuff then
                    proc = true
                    v:start_dissolve() 
                end
            end
            return true 
        end 
    }))
    if proc then G.GAME.blind:wiggle() end
    return proc
end

blind.defeat = function(self)
    for _, v in ipairs(G.playing_cards) do
        v.ability.amber_debuff = nil
    end
end

blind.disable = function(self)
    for _, v in ipairs(G.playing_cards) do
        v.ability.amber_debuff = nil
    end
end

blind.debuff_card = function(self, card, from_blind)
    if card.ability.amber_debuff then
        card:set_debuff(true)
        return true
    end
end

return blind