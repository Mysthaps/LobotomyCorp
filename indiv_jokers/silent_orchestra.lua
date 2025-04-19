local mvm = {
    "first",
    "second",
    "third",
    "fourth",
    "finale",
}

SMODS.MovementLobc = SMODS.Center:extend({
    pos = { x = 0, y = 0 },
    class_prefix = 'mvm',
    set = 'MovementLobc',
    atlas = 'lobc_LobotomyCorp_movement',
    config = {},
    required_params = {
        'key',
    },
    no_collection = true,
    loc_vars = function(self, info_queue)
        return {}
    end,
    set_card_type_badge = function(self, card, badges)
        badges = {}
    end,
    no_mod_badges = true,
    inject = function(self)
		if not G.P_CENTER_POOLS[self.set] then
			G.P_CENTER_POOLS[self.set] = {}
		end
		SMODS.Center.inject(self)
	end,
})
for k, v in ipairs(mvm) do
    SMODS.MovementLobc({
        key = v, 
        pos = {x = k-1, y = 0},
        config = {extra = {
            chips = 10, mult = 4, x_mult = 0.5, money = 1
        }},
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.x_mult, card.ability.extra.money}}
        end
    })
end

local joker = {
    name = "The Silent Orchestra",
    config = {extra = 1}, rarity = 3, cost = 9,
    pos = {x = 7, y = 4}, 
    blueprint_compat = false, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "aleph",
    discover_rounds = 7,
}

joker.calculate = function(self, card, context)
    if context.first_hand_drawn and not context.blueprint then
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { card.ability.extra.chips, card.ability.extra.mult, 
                card.ability.extra.chips_gain, card.ability.extra.mult_gain,
                card:check_rounds(3), card:check_rounds(6), card:check_rounds(9),
                card.ability.extra.gain_scale
            }
    local desc_key = self.key
    if card:check_rounds(3) < 3 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(6) < 6 then
        desc_key = 'dis_'..desc_key..'_2'
    elseif card:check_rounds(9) < 9 then
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

return joker

-- https://www.youtube.com/watch?v=LvSuEqpq_TM&lc=Ugx2QAWifMsenWv297l4AaABAg