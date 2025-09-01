local joker = {
    name = "Big and Will be Bad Wolf",
    config = {extra = {
        chips = 0, chips_gain = 40,
    }}, rarity = 3, cost = 7,
    pos = {x = 2, y = 3}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = false,
    abno = true,
    risk = "waw",
    discover_rounds = {1, 3, 6},
    discover_override = {nil, "lobc_obs_active_2", nil}
}

local function create_cardarea(card)
    card.children.lobc_devoured = CardArea(
        0, 0,
        G.CARD_W/2, G.CARD_H/2,
        {card_limit = 1, type = 'title'}
    )
    local update_ref = card.children.lobc_devoured.update
    card.children.lobc_devoured.update = function(self, dt)
        self.T.x = card.T.x
        self.T.y = card.T.y + 2
        self.VT.x = card.VT.x
        self.VT.y = card.VT.y + 2
        update_ref(self, dt)
    end
    card.children.lobc_devoured.drag = function(self, offset)
        return nil
    end
end

joker.calculate = function(self, card, context)
    if context.setting_blind and not card.getting_sliced then
        local available_cards = {}
        -- Priority: Little Red > Non-Eternal > Eternal
        local little_red = {}
        local non_eternal = {}
        local eternal = {}
        for _, v in ipairs(G.jokers.cards) do
            if v.config.center.key == "j_lobc_little_red" and not SMODS.is_eternal(v, card) then little_red[#little_red+1] = v end
            if v ~= card and not v.being_devoured and not v.children.lobc_devoured then 
                if SMODS.is_eternal(v, card) then eternal[#eternal+1] = v 
                else non_eternal[#non_eternal+1] = v end
            end
        end
        if #little_red > 0 then available_cards = little_red
        elseif #non_eternal > 0 then available_cards = non_eternal
        else available_cards = eternal end

        if #available_cards > 0 then
            local selected_card = pseudorandom_element(available_cards, pseudoseed("bbw_select"))
            selected_card:remove_from_deck(true)
            selected_card.area:remove_card(selected_card)
            selected_card.being_devoured = true
            selected_card.getting_sliced = true
            SMODS.debuff_card(selected_card, true, "big_bad_wolf")
            create_cardarea(card)
            card.children.lobc_devoured:emplace(selected_card)
            play_sound("lobc_wolf_bite", 1, 0.4)
        end
        return nil, true
    end

    if context.end_of_round and context.main_eval and not context.blueprint then
        if card.children.lobc_devoured then
            if card.children.lobc_devoured.cards[1] then
                local _card = card.children.lobc_devoured.cards[1]
                _card:start_dissolve()
                if _card.config.center.key == "j_lobc_little_red" then 
                    card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain * 3
                    check_for_unlock({type = 'lobc_cobalt_scar'})
                else card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_gain end
                play_sound("lobc_wolf_scratch", 1, 0.4)
            end
            G.E_MANAGER:add_event(Event({func = (function()
                card.children.lobc_devoured:remove()
                card.children.lobc_devoured = nil
            return true end)}))
        end
    end

    if context.joker_main then
        return {
            chips = card.ability.extra.chips,
            card = context.blueprint_card or card,
        }
    end
end

joker.lobc_can_use_active = function(self, card)
    return card.children.lobc_devoured and card.children.lobc_devoured.cards[1]
end

joker.lobc_active = function(self, card)
    if card.children.lobc_devoured then
        if card.children.lobc_devoured.cards[1] then
            local _card = card.children.lobc_devoured.cards[1]
            _card.being_devoured = nil
            _card.getting_sliced = nil
            SMODS.debuff_card(_card, false, "big_bad_wolf")
            card.children.lobc_devoured:remove_card(_card)
            _card:add_to_deck(true)
            G.jokers:emplace(_card)
            play_sound("lobc_wolf_out", 1, 0.4)
        end
        card.children.lobc_devoured:remove()
        card.children.lobc_devoured = nil
    end
end

joker.remove_from_deck = function(self, card, from_debuff)
    if from_debuff then return end
    if card.children.lobc_devoured and card.children.lobc_devoured.cards then
        if card.children.lobc_devoured.cards[1] then
            local _card = card.children.lobc_devoured.cards[1]
            _card.being_devoured = nil
            _card.getting_sliced = nil
            SMODS.debuff_card(_card, false, "big_bad_wolf")
            card.children.lobc_devoured:remove_card(_card)
            _card:add_to_deck(true)
            G.jokers:emplace(_card)
            play_sound("lobc_wolf_out", 1, 0.4)
        end
        card.children.lobc_devoured:remove()
        card.children.lobc_devoured = nil
    end
end

-- Properly save/load devour card area
local card_save = Card.save
function Card.save(self)
    if self.config.center.name == "j_lobc_big_bad_wolf" then
        if self.children.lobc_devoured then
            self.ability.extra.area_save = self.children.lobc_devoured:save()
        else
            self.ability.extra.area_save = nil
        end
    end
    return card_save(self)
end

local card_load = Card.load
function Card.load(self, cardTable, other_card)
    card_load(self, cardTable, other_card)
    if self.config.center.name == "j_lobc_big_bad_wolf" then
        if self.ability and self.ability.extra and type(self.ability.extra) == "table" and self.ability.extra.area_save then
            create_cardarea(self)
            self.children.lobc_devoured:load(self.ability.extra.area_save)
            if self.children.lobc_devoured.cards then
                self.children.lobc_devoured.cards[1].being_devoured = true
                self.children.lobc_devoured.cards[1].getting_sliced = true
            end
            self.ability.extra.area_save = nil
        end
    end
end

joker.loc_vars = function(self, info_queue, card)
    if not card.fake_card and card:check_rounds() >= 1 then info_queue[#info_queue+1] = {key = 'lobc_devoured', set = 'Other'} end
    info_queue[#info_queue+1] = {key = 'lobc_active_ability', set = 'Other'}
    local lr = next(SMODS.find_card("j_lobc_little_red")) or (card.children.lobc_devoured and card.children.lobc_devoured.cards[1] and card.children.lobc_devoured.cards[1].config.center.key == "j_lobc_little_red")
    return {vars = {card.ability.extra.chips_gain * (lr and 3 or 1), card.ability.extra.chips}, key = (lr and "j_lobc_big_bad_wolf_alt" or nil)}
end

if JokerDisplay then
    JokerDisplay.Definitions.j_lobc_big_bad_wolf = {
        text = {
            { text = "+", colour = G.C.CHIPS },
            { ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS },
        },
        style_function = function(card, text, reminder_text, extra)
            if text then 
                text.states.visible = card:check_rounds(6) >= 6
            end
            if reminder_text then
            end
            if extra then
            end
            return false
        end
    }
end

return joker

-- baby im preying on you tonight
-- hunt you down eat you alive