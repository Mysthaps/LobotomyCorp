local joker = {
    name = "You're Bald...",
    config = {}, rarity = 1, cost = 1,
    pos = {x = 2, y = 8}, 
    blueprint_compat = false, 
    eternal_compat = true,
    perishable_compat = true,
    yes_pool_flag = "allow_abnormalities_in_shop",
    abno = true,
    risk = "zayin",
    discover_rounds = 3,
    loc_txt = {},
}

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { card:check_rounds(3) }
    local desc_key = self.key
    if card:check_rounds(3) < 3 then
        desc_key = 'dis_'..desc_key..'_1'
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