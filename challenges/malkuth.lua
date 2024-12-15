local chal = {
    rules = {
        custom = {
            {id = "lobc_malkuth"},
            {id = "lobc_malkuth_2"},
            {id = "lobc_malkuth_3"},
            {id = "lobc_ordeals"},
            {id = "lobc_fast_ante_1"},
        },
    },
    restrictions = {
        banned_tags = {
            {id = 'tag_boss'}
        },
        banned_cards = {
            {id = 'j_luchador'},
            {id = 'j_chicot'},
            {id = 'v_directors_cut'},
            {id = 'v_retcon'},
        },
        banned_other = {
            {id = 'bl_final_acorn', type = 'blind'},
        }
    },
    unlocked = function(self)
        return true
    end
}

-- Disable selling
local can_sell_cardref = Card.can_sell_card
function Card.can_sell_card(self, context)
    if G.GAME.modifiers.lobc_malkuth and G.GAME.round_resets.ante > 6 then
        return false
    end
    return can_sell_cardref(self, context)
end

-- Cards flipped
local card_initref = Card.init
function Card.init(self, X, Y, W, H, card, center, params)
    card_initref(self, X, Y, W, H, card, center, params)
    if G.GAME and G.GAME.modifiers.lobc_malkuth then
        if (self.ability.consumeable and G.GAME.round_resets.ante > 3) or
           (self.ability.set == "Joker" and G.GAME.round_resets.ante > 6) then
            self.facing = 'back'
            self.sprite_facing = 'back'
            self.pinch.x = false
        end
    end
end

-- Override flipping
local card_flipref = Card.flip
function Card.flip(self)
    if G.GAME and G.GAME.modifiers.lobc_malkuth then
        if self.ability.consumeable or
           (self.ability.set == "Joker" and G.GAME.round_resets.ante > 6) then
            return
        end
    end
    card_flipref(self)
end

return chal