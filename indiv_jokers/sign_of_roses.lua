local function mf()
    return not not (next(SMODS.find_mod("MoreFluff")) and mf_config["Colour Cards"])
end

local joker = {
    name = "Sign of Roses",
    config = {extra = {rounds = 1, x_mult = 1, gain = 0.1, penalty = 0.8}}, rarity = 2, cost = 6,
    pos = {x = 7, y = 8}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = not not next(SMODS.find_mod("MoreFluff")),
    abno = true,
    risk = "waw",
    discover_rounds = {3, 6},
    dependencies = {
        "MoreFluff"
    }
}

local suits_scoring = {}
joker.calculate = function(self, card, context)
    if not mf() then self.perishable_compat = false end
    -- Reset
    if context.before and not context.blueprint then
        local suits = {}
        suits_scoring = {}
        local suits_count = 0
        for _, v in ipairs(context.scoring_hand) do
            if SMODS.has_any_suit(v) then suits_count = suits_count + 1
            elseif not SMODS.has_no_suit(v) and not suits[v.base.suit] then
                suits[v.base.suit] = true
                suits_count = suits_count + 1
            end
        end
        if not mf() then
            card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.gain * math.floor(suits_count / 2)
        else
            local rounds = (card.ability.extra.rounds * math.floor(suits_count / 2))
            if rounds > 0 then
                SMODS.calculate_effect({
                    message = localize{type = 'variable', key = 'lobc_round', vars = {rounds, (rounds > 1 and "s" or nil)}},
                    colour = G.C.SECONDARY_SET.ColourCard,
                }, context.blueprint_card or card)
                -- Taken from MoreFluff's colours.lua
                for _, _card in ipairs(G.consumeables.cards) do
                    if _card.ability.mf_halted then break end
                    if _card.ability.set == "Colour" or _card.ability.set == "Shape" then
                        for _ = 1, rounds do
                            -- all of them that go up over time
                            if _card.ability.upgrade_rounds then
                                _card.ability.partial_rounds = _card.ability.partial_rounds + 1
                                local upgraded = false
                                while _card.ability.partial_rounds >= _card.ability.upgrade_rounds do
                                    upgraded = true
                                    _card.ability.val = _card.ability.val + 1
                                    if _card.ability.val >= 10 then
                                        check_for_unlock({type = 'mf_ten_colour_rounds'})
                                    end
                                    _card.ability.partial_rounds = _card.ability.partial_rounds - _card.ability.upgrade_rounds
                                    
                                    if _card.ability.name == "col_Yellow" then
                                        _card.ability.extra_value = _card.ability.extra_value + _card.ability.value_per
                                        _card:set_cost()
                                        card_eval_status_text(_card, 'extra', nil, nil, nil, {
                                            message = localize('k_val_up'),
                                            colour = G.C.MONEY,
                                            card = _card
                                        }) 
                                    else
                                        card_eval_status_text(_card, 'extra', nil, nil, nil, {
                                            message = localize('k_upgrade_ex'),
                                            colour = G.C.SECONDARY_SET.ColourCard,
                                            card = _card
                                        }) 
                                    end
                                end
                                if not upgraded then
                                    local str = _card.ability.partial_rounds..'/'.._card.ability.upgrade_rounds
                                    card_eval_status_text(_card, 'extra', nil, nil, nil, {
                                        message = str,
                                        colour = G.C.SECONDARY_SET.ColourCard,
                                        card = _card
                                    }) 
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if context.individual and context.cardarea == G.play and not context.blueprint then
        local v = context.other_card
        if not SMODS.has_any_suit(v) and not SMODS.has_no_suit(v) and not context.other_card.ability.sign_of_roses_safe then
            if not suits_scoring[v.base.suit] then
                suits_scoring[v.base.suit] = true
                v.ability.sign_of_roses_safe = true
            else
                return {
                    x_mult = card.ability.extra.penalty,
                    card = context.blueprint_card or card,
                }
            end
        end
    end

    if not mf() and context.joker_main then
        return {
            x_mult = card.ability.extra.x_mult,
            card = context.blueprint_card or card,
        }
    end
end

joker.loc_vars = function(self, info_queue, card)
    return {vars = {card.ability.extra.rounds, card.ability.extra.penalty, card.ability.extra.gain, card.ability.extra.x_mult},
            key = (not mf() and "j_lobc_sign_of_roses_alt")}
end

return joker

-- shoutouts to Wrath-drenched Rose for "When defeated by a direct hit, return the damage to the attacker and inflict 5 Burn"