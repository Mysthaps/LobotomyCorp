local current_mod = SMODS.current_mod
local config = SMODS.current_mod.config

-- Global mod calculation
function current_mod.calculate(self, context)
    -- Enchanted cards, thank you Eremel for the help!!
    if context.drawing_cards then
        local moved = 0
        for i=#G.deck.cards, 1, -1 do
            if G.deck.cards[i].ability.big_bird_enchanted then
                play_sound("lobc_big_bird_attract", 1, 0.8)
                moved = moved + 1
                local _c = G.deck.cards[i]
                table.remove(G.deck.cards, i)
                table.insert(G.deck.cards, _c)
            end
            if moved == context.amount then return end
        end
    end

    if context.stay_flipped and context.to_area == G.discard then
        if context.other_card.ability.big_bird_enchanted then
            return {
                modify = {to_area = G.deck}
            }
        end
    end

    if context.starting_shop then
        -- Open a Base Extraction Pack (Elite) after each Ante
        if G.GAME.modifiers.lobc_production then
            if G.GAME.round_resets.ante <= G.GAME.production_last_pack then return end
            G.GAME.production_last_pack = G.GAME.round_resets.ante
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                func = function()
                    if G.STATE_COMPLETE then
                        local card = Card(G.play.T.x + G.play.T.w/2 - G.CARD_W*1.27/2,
                        G.play.T.y + G.play.T.h/2-G.CARD_H*1.27/2, G.CARD_W*1.27, G.CARD_H*1.27, G.P_CARDS.empty, G.P_CENTERS["p_lobc_extraction_base_elite"], {bypass_discovery_center = true, bypass_discovery_ui = true})
                        card.cost = 0
                        G.FUNCS.use_card({config = {ref_table = card}})
                        card:start_materialize()
                        return true
                    end
                end
            }))
        -- Create an Extraction Pack that lasts an Ante
        else
            --G.GAME.current_round.lobc_extraction = G.GAME.current_round.lobc_extraction or get_pack("pack_extraction", "Abnormality").key
            --if G.GAME.current_round.lobc_extraction ~= "USED" then
            --    SMODS.add_booster_to_shop(G.GAME.current_round.lobc_extraction)
            --end
            SMODS.add_booster_to_shop(get_pack("pack_extraction", "Abnormality").key)
        end
    end
end

-- E.G.O Gift sell costs / Fairy Festival
local set_costref = Card.set_cost
function Card.set_cost(self)
    set_costref(self)
    if self.ability.set == "EGO_Gift" then self.sell_cost = 0 end
    if self.ability.lobc_fairy_festival and self.cost > 0 then self.cost = 0 end
end

-- Front sprites thing (Today's Shy Look / You Must Be Happy / Express Train to Hell / Opened Can of WellCheers)
local alignref = Card.align
function Card.align(self)  
    if self.children.mood then 
        self.children.mood.T.y = self.T.y
        self.children.mood.T.x = self.T.x
        self.children.mood.T.r = self.T.r
    end

    for _, v in ipairs({"lantern", "prey", "prey_mark", "villain"}) do
        if self.children["lobc_"..v] then
            self.children["lobc_"..v].T.y = self.T.y
            self.children["lobc_"..v].T.x = self.T.x
            self.children["lobc_"..v].T.r = self.T.r
        end
    end

    alignref(self)
end

-- Remove sell button
local can_sell_cardref = Card.can_sell_card
function Card.can_sell_card(self, context)
    -- The Queen of Hatred
    if self.ability and self.ability.extra and type(self.ability.extra) == 'table' and self.ability.extra.hysteria then
        return false
    end
    if self.config.center.key == "j_lobc_skin_prophecy" and G.GAME.current_round.skin_prophecy_uses then
        return false
    end
    return can_sell_cardref(self, context)
end

-- Remove Enchanted on new round
local update_new_roundref = Game.update_new_round
function Game.update_new_round(self, dt)
    if G.STATE ~= G.STATES.DRAW_TO_HAND then
        for _, v in ipairs(G.playing_cards) do
			if v.ability.big_bird_enchanted and v.children.lobc_big_bird_particles then
				v.children.lobc_big_bird_particles:remove()
				v.children.lobc_big_bird_particles = nil
			end
		end
    end
    update_new_roundref(self, dt)
end

-- Debuffing effects
local should_debuff_ability = {
    "scorched_girl_debuff",
    "theresia_debuff",
    "tt2_debuff",
}
function SMODS.current_mod.set_debuff(card, should_debuff)
    if card.ability then
        if card.ability.knight_of_despair_blessing then return false end
        for _, v in ipairs(should_debuff_ability) do
            if card.ability[v] then 
                --card:set_debuff(true)
                return true
            end
        end
    end
end

-- Make cards keep ability when transformed
local set_abilityref = Card.set_ability
function Card.set_ability(self, center, initial, delay_sprites)
    local lobc_abilities = {}

    if self.ability and self.playing_card then
        for _, v in ipairs(G.lobc_global_modifiers) do
            if self.ability[v] then
                lobc_abilities[v] = true
            end
        end
    end

    set_abilityref(self, center, initial, delay_sprites)

    if self.ability and self.playing_card then
        for k, v in pairs(lobc_abilities) do
            if v then
                self.ability[k] = true
            end
        end
    end
    
    --[[if self.ability and self.playing_card and self.ability.set == "Enhanced" then
        self:lobc_check_amplified()
    end]]--
end

-- JokerDisplay text replacements
if JokerDisplay then
    JokerDisplay.Global_Definitions.Replace["lobc_censored"] = {
        priority = 1,
        replace_text = "lobc_other_censored",
        replace_reminder = {},
        replace_extra = {},
        replace_modifiers = {},
        replace_debuff_text = { { text = "CENSORED", colour = G.C.UI.TEXT_INACTIVE } },
        stop_calc = true,
        is_replaced_func = function (card, custom_parent)
            return next(SMODS.find_card("j_lobc_censored")) and card.config.center.key ~= "j_lobc_censored"
        end
    }
    JokerDisplay.Global_Definitions.Replace["lobc_yesod"] = {
        priority = 10,
        replace_text = {},
        replace_reminder = {},
        replace_extra = {},
        replace_modifiers = {},
        replace_debuff_text = {},
        replace_debuff_reminder = {},
        replace_debuff_extra = {},
        stop_calc = true,
        is_replaced_func = function (card, custom_parent)
            return G.GAME and G.GAME.modifiers.lobc_yesod and G.GAME.round_resets.ante > 3
        end
    }
end

--=============== ACTIVES ===============--

-- Implements the following functions:
-- center.lobc_can_use_active(center, card): If true, the USE button will become active
-- center.lobc_active(center, card): The USE button is only present when the center has this function. Called when the USE button is pressed

local use_and_sell_buttonsref = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
    local t = use_and_sell_buttonsref(card)
    if t and t.nodes[1] and t.nodes[1].nodes[2] and card.config.center.lobc_active and type(card.config.center.lobc_active) == "function" then
        table.insert(t.nodes[1].nodes[2].nodes, 
            {n=G.UIT.C, config={align = "cr"}, nodes={
                {n=G.UIT.C, config={ref_table = card, align = "cr", maxw = 1.25, padding = 0.1, r=0.08, minw = 1.25, minh = 1, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'lobc_active_ability', func = 'lobc_can_use_active'}, nodes={
                    {n=G.UIT.B, config = {w=0.1,h=0.6}},
                    {n=G.UIT.T, config={text = localize('b_use'),colour = G.C.UI.TEXT_LIGHT, scale = 0.55, shadow = true}}
                }}
            }}
        )
    end
    return t
end

G.FUNCS.lobc_can_use_active = function(e)
    local card = e.config.ref_table
    local can_use = 
    not (not skip_check and ((G.play and #G.play.cards > 0) or
    (G.CONTROLLER.locked) or
    (G.GAME.STOP_USE and G.GAME.STOP_USE > 0))) and
    G.STATE ~= G.STATES.HAND_PLAYED and G.STATE ~= G.STATES.DRAW_TO_HAND and G.STATE ~= G.STATES.PLAY_TAROT and
    card.area == G.jokers and not card.debuff and
    (not card.config.center.lobc_can_use_active or card.config.center:lobc_can_use_active(card))
    if can_use then 
        e.config.colour = G.C.RED
        e.config.button = 'lobc_active_ability'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

G.FUNCS.lobc_active_ability = function(e, mute, nosave)
    local card = e.config.ref_table

    G.E_MANAGER:add_event(Event({func = function()
        e.disable_button = nil
        e.config.button = 'lobc_active_ability'
    return true end }))

    if card.children.use_button then card.children.use_button:remove(); card.children.use_button = nil end
    if card.children.sell_button then card.children.sell_button:remove(); card.children.sell_button = nil end

    card.config.center:lobc_active(card)
    card.area:remove_from_highlighted(card)
end
