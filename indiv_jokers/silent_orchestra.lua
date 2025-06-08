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
        end,
        draw_func = function(self, card)
            if card.config.center.key == "mvm_lobc_first" then

            end
        end
    })
end

local joker = {
    name = "The Silent Orchestra",
    config = {extra = 1}, rarity = 3, cost = 9,
    pos = {x = 3, y = 1}, 
    blueprint_compat = false, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "aleph",
    discover_rounds = 7,
}

joker.calculate = function(self, card, context)
    if context.setting_blind and not context.blueprint and not card.getting_sliced then
        G.E_MANAGER:add_event(Event({func = function()
            local _card = SMODS.create_card({
                key = "mvm_lobc_"..mvm[card.ability.extra],
                bypass_discovery_center = true
            })
            _card:set_base()
            G.play:emplace(_card)
            G.deck.config.card_limit = G.deck.config.card_limit + 1
        return true end}))
        draw_card(G.play, G.deck, 90, 'up', nil)
    end
    
    if context.end_of_round and context.main_eval and not context.blueprint then
        for _, v in ipairs(G.deck.cards) do
            if v.ability.set == "MovementLobc" then
                v:start_dissolve()
            end
        end
    end 
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { 
        localize{type='name_text', key="mvm_lobc_"..mvm[card.ability.extra], set='MovementLobc'},
        localize{type='name_text', key="mvm_lobc_"..mvm[card.ability.extra == 5 and 1 or card.ability.extra + 1], set='MovementLobc'},
        card:check_rounds(2), card:check_rounds(5), card:check_rounds(7)
    }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(5) < 5 then
        desc_key = 'dis_'..desc_key..'_2'
    elseif card:check_rounds(7) < 7 then
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

-- https://www.youtube.com/watch?v=LvSuEqpq_TM