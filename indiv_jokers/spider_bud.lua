local joker = {
    name = "Spider Bud",
    config = {extra = {cards = 0, card_gain = 1, first = true}}, rarity = 2, cost = 6,
    pos = {x = 9, y = 1}, 
    blueprint_compat = false, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "teth",
    discover_rounds = 5,
}

joker.calculate = function(self, card, context)
    if context.pre_discard and not context.blueprint then
        card.ability.extra.first = true
    end

    if context.discard and not context.blueprint then
        if card.ability.extra.first then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
                context.other_card:start_dissolve()
            return true end}))
            card.ability.extra.cards = card.ability.extra.cards + card.ability.extra.card_gain
            card.ability.extra.first = false
        end
    end

    if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
        card.ability.extra.cards = 0
    end
end

local draw_from_deck_to_handref = G.FUNCS.draw_from_deck_to_hand
function G.FUNCS.draw_from_deck_to_hand(self, e)
	draw_from_deck_to_handref(self, e)
	for _, v in ipairs(SMODS.find_card("j_lobc_spider_bud")) do
        for i = 1, v.ability.extra.cards do
            draw_card(G.deck, G.hand, 100, 'up', true)
        end
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { card.ability.extra.cards, card.ability.extra.card_gain, card:check_rounds(2), card:check_rounds(5) }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(5) < 5 then
        desc_key = 'dis_'..desc_key..'_2'
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

-- why does lobotomy e.g.o::red eyes & penitence ryoshu's kit have NO BIND in it