local joker = {
    name = "You're Bald...",
    config = {}, rarity = 1, cost = 1,
    pos = {x = 2, y = 8}, 
    blueprint_compat = false, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "zayin",
    discover_rounds = {3},
}

joker.in_pool = function(self, args)
    return false
end

-- You're Bald...'s sprite-based effects
local set_spritesref = Card.set_sprites
function Card.set_sprites(self, _center, _front)
    set_spritesref(self, _center, _front)

    if next(SMODS.find_card("j_lobc_youre_bald")) and not (self.ability and self.ability.lobc_censored) then
        if _center and _center.set == "Joker" and self.children.center.atlas == G.ASSET_ATLAS["Joker"] then
            self.children.center.atlas = G.ASSET_ATLAS["lobc_LobotomyCorp_jokersbald"]
            self.children.center:set_sprite_pos(_center.pos)
            if self.children.floating_sprite and self.children.floating_sprite.atlas == G.ASSET_ATLAS["Joker"] then
                self.children.floating_sprite.atlas = G.ASSET_ATLAS["lobc_LobotomyCorp_jokersbald"]
                self.children.floating_sprite:set_sprite_pos(_center.soul_pos)
            end
        end
    end
end

return joker

-- this abno sucks why does it exist LMAO
-- apparently this is a northernlion reference now