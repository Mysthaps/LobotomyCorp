local joker = {
    name = "Queen Bee",
    config = {extra = {mult = 3}}, rarity = 2, cost = 6,
    pos = {x = 4, y = 2}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "waw",
    discover_rounds = {2, 4, 6},
}

joker.calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
        context.other_card.ability.perma_mult = context.other_card.ability.perma_mult or 0
        context.other_card.ability.perma_mult = context.other_card.ability.perma_mult + card.ability.extra.mult
        return {
            extra = {message = localize('k_upgrade_ex'), colour = G.C.MULT},
            card = context.blueprint_card or card
        }
    end

    if context.cardarea == G.jokers and context.after and context.scoring_hand and not context.blueprint then
        for k, v in ipairs(context.scoring_hand) do
            local rank_data = SMODS.Ranks[v.base.value]
            local behavior = rank_data.prev_behavior or {fixed = 1, ignore = false, random = false}
            local can = true
            G.E_MANAGER:add_event(Event({trigger = "before", delay = 1, func = function()
                -- nope, not doing the random edge case
                if not behavior.random and next(rank_data.prev) then
                    if SMODS.Ranks[rank_data.prev[behavior.fixed]].nominal > rank_data.nominal then can = false end
                end
                if v.config.center.key ~= "m_lobc_worker_bee" and not v.debuff then
                    if not SMODS.has_no_rank(v) and next(rank_data.prev) and not (rank_data.prev_behavior or {}).ignore and can then
                        assert(SMODS.modify_rank(v, -1)) 
                    else
                        v:set_ability(G.P_CENTERS["m_lobc_worker_bee"])
                    end
                    v:juice_up()
                    card:juice_up()
                    play_sound('lobc_queen_bee', 1, 0.4)
                end
            return true end }))
        end
    end
end

joker.loc_vars = function(self, info_queue, card)
    if not card.fake_card and card:check_rounds() >= 6 then info_queue[#info_queue+1] = G.P_CENTERS["m_lobc_worker_bee"] end
    return {vars = {card.ability.extra.mult}}
end

-- Worker Bee
SMODS.Enhancement{
    key = "worker_bee",
    atlas = "LobotomyCorp_modifiers",
    pos = {x = 6, y = 0},
    no_collection = true,
    replace_base_card = true,
    no_rank = true,
    no_suit = true,
    always_scores = true,
    weight = 0,
    in_pool = function() return false end
}

local card_set_abilityref = Card.set_ability
function Card.set_ability(self, center, initial, delay_sprites)
    if self.config and self.config.center and self.config.center.key == "m_lobc_worker_bee" then
        return
    end
    return card_set_abilityref(self, center, initial, delay_sprites)
end

return joker

-- theme of 99 burn + bleed stack when hit