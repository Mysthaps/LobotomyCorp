local blind = {
    name = "Crimson Dawn",
    lobc_color = "crimson",
    lobc_time = "dawn",
    pos = {x = 0, y = 8},
    dollars = 3, 
    mult = 1, 
    vars = {}, 
    debuff = {},
}

blind.set_blind = function(self)
    if G.GAME.current_round.hands_played >= 4 then
        G.GAME.blind.hands_sub = 1
        for _, v in ipairs(G.playing_cards) do
            v.ability.lobc_dawn_crimson = true
            SMODS.recalc_debuff(v)
        end
        --G.GAME.blind:wiggle()
    else
        G.GAME.blind.hands_sub = 0
    end
end

blind.recalc_debuff = function(self, card)
    if card.ability.lobc_dawn_crimson then
        return true
    end
end

blind.drawn_to_hand = function(self)
    if G.GAME.current_round.hands_played >= 4 and G.GAME.blind.hands_sub == 0 then
        G.GAME.blind.hands_sub = 1
        for _, v in ipairs(G.playing_cards) do
            v.ability.lobc_dawn_crimson = true
            SMODS.recalc_debuff(v)
        end
        G.GAME.blind:wiggle()
    end
end

-- Crimson Dawn selling card
local sell_cardref = Card.sell_card
function Card.sell_card(self)
    if self.ability.set == 'Joker' and G.GAME.blind then
        if G.GAME.blind.config.blind.key == "bl_lobc_dawn_crimson" and not G.GAME.blind.disabled then 
            G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
                G.GAME.blind.hands_sub = 2
                for _, v in ipairs(G.playing_cards) do
                    v.ability.lobc_dawn_crimson = false
                    SMODS.recalc_debuff(v)
                end
                return true
            end}))
        end
    end
    sell_cardref(self)
end

return blind