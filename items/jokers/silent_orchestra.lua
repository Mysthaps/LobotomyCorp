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
    discover_rounds = {2, 5, 7},
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

joker.loc_vars = function(self, info_queue, card)
    return {vars = {
        localize{type='name_text', key="mvm_lobc_"..mvm[card.ability.extra], set='MovementLobc'},
        localize{type='name_text', key="mvm_lobc_"..mvm[card.ability.extra == 5 and 1 or card.ability.extra + 1], set='MovementLobc'},
    }}
end

return joker

-- https://www.youtube.com/watch?v=LvSuEqpq_TM