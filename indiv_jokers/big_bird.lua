local config = SMODS.current_mod.config
local joker = {
    name = "Big Bird",
    config = {extra = {x_mult = 2, cost = 4, has_played_enchanted = false}}, rarity = 2, cost = 7,
    pos = {x = 6, y = 1}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "waw",
    discover_rounds = 6,
    no_pool_flag = "apocalypse_bird_event",
}

joker.calculate = function(self, card, context)
    if context.setting_blind and not context.getting_sliced then
        local chosen_card, chosen_key = pseudorandom_element(G.deck.cards, pseudoseed("lobc_big_bird"))
        G.deck.cards[#G.deck.cards], G.deck.cards[chosen_key] = G.deck.cards[chosen_key], G.deck.cards[#G.deck.cards]
        chosen_card.ability.big_bird_enchanted = true
        chosen_card.children.lobc_big_bird_particles = Particles(0, 0, 0,0, {
            timer = 0.3,
            scale = 0.45,
            speed = 0.3,
            lifespan = 4,
            attach = chosen_card,
            colours = {darken(G.C.MONEY, 0.1), darken(G.C.MONEY, 0.3), darken(G.C.MONEY, 0.5)},
            fill = true
        })
        chosen_card:juice_up()
    end

    if context.cardarea == G.jokers and not context.blueprint then
        if context.before then
            for _, v in ipairs(context.scoring_hand) do
                if not v.ability.big_bird_counted then
                    v.ability.big_bird_counter = (v.ability.big_bird_counter or 0) + 1
                    v.ability.big_bird_counted = true
                end
                if v.ability.big_bird_counter and v.ability.big_bird_counter >= 3 then
                    check_for_unlock({type = "lobc_lamp"})
                end
            end
        end

        if context.after then
            for _, v in ipairs(context.scoring_hand) do
                v.ability.big_bird_counted = nil
            end
        end
    end

    if context.individual and context.cardarea == G.play and context.other_card.ability.big_bird_enchanted then
        card.ability.extra.has_played_enchanted = true
        return {
            x_mult = card.ability.extra.x_mult,
            card = context.blueprint_card or card,
        }
    end

    if context.end_of_round and context.main_eval and not context.blueprint then
        if not card.ability.extra.has_played_enchanted then
            local destroyed_cards = {}
            G.E_MANAGER:add_event(Event({
                func = function()
                    local first = true
                    for _, v in ipairs(G.playing_cards) do
                        if v.ability.big_bird_enchanted then
                            ease_dollars(-card.ability.extra.cost)
                            v.ability.big_bird_enchanted = nil
                            destroyed_cards[#destroyed_cards+1] = v
                            v:start_dissolve()
                            if first and not config.disable_unsettling_sfx then
                                play_sound("lobc_big_bird_destroy", 1, 0.5)
                            end
                            first = nil
                        end
                    end
                    delay(0.2)
                    SMODS.calculate_context({remove_playing_cards = true, removed = destroyed_cards})
                return true
                end
            }))
        end

        for _, v in ipairs(G.playing_cards) do
            if v.ability.big_bird_counter then v.ability.big_bird_counter = nil end
        end
    end
end

joker.add_to_deck = function(self, card, from_debuff)
    if not G.GAME.pool_flags["apocalypse_bird_event"] and not from_debuff and next(SMODS.find_card("j_lobc_punishing_bird")) and next(SMODS.find_card("j_lobc_judgement_bird")) then
        for _, v in ipairs(SMODS.find_card("j_lobc_punishing_bird")) do
            v.ability.extra.start_apoc = true
            v.children.alert = UIBox{
                definition = create_UIBox_card_alert(), 
                config = {
                    align = "tri",
                    offset = {
                        x = 0.1, y = 0
                    },
                    parent = v
                }
            }
        end
        check_for_unlock({type = "lobc_through_the_dark_twilight"})
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { 
        card.ability.extra.x_mult, card.ability.extra.cost,
        card:check_rounds(2), card:check_rounds(4), card:check_rounds(6),
        colours = {HEX("C8831B")}
    }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(4) < 4 then
        desc_key = 'dis_'..desc_key..'_2'
    elseif card:check_rounds(6) < 6 then
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

-- Big Bird draw Enchanted cards
local draw_cardref = draw_card
function draw_card(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
    if from == G.deck and to == G.hand and not card then
        local enchanted = {}
        for _, v in ipairs(G.discard.cards) do
            if v.ability.big_bird_enchanted and not v.ability.big_bird_enchanted_marked_for_draw then enchanted[#enchanted+1] = v end
        end
        for _, v in ipairs(G.deck.cards) do
            if v.ability.big_bird_enchanted and not v.ability.big_bird_enchanted_marked_for_draw then enchanted[#enchanted+1] = v end
        end
        if #enchanted > 0 then
            local e_card = pseudorandom_element(enchanted, pseudoseed("enchanted_draw"))
            e_card.ability.big_bird_enchanted_marked_for_draw = true
            play_sound("lobc_big_bird_attract", 1, 0.8)
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                func = function()
                    e_card.ability.big_bird_enchanted_marked_for_draw = nil
                return true
                end
            }))
            return draw_cardref(e_card.area, G.hand, percent, dir, sort, e_card, delay, mute, stay_flipped, vol, discarded_only)
        end
    end
    draw_cardref(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
end

-- Restore Enchanted particles on reload
local card_updateref = Card.update
function Card.update(self, dt)
    card_updateref(self, dt)
    if self.ability.big_bird_enchanted and not self.children.lobc_big_bird_particles and G.GAME.blind and G.GAME.blind.in_blind then
        self.children.lobc_big_bird_particles = Particles(0, 0, 0,0, {
            timer = self.ability.permanent_enchanted and 0.4 or 0.3,
            scale = self.ability.permanent_enchanted and 0.3 or 0.45,
            speed = 0.3,
            lifespan = self.ability.permanent_enchanted and 3 or 4,
            attach = self,
            colours = {darken(G.C.MONEY, 0.1), darken(G.C.MONEY, 0.3), darken(G.C.MONEY, 0.5)},
            fill = true
        })
    end
end

-- Remove Enchanted at end of round
local update_new_roundref = Game.update_new_round
function Game.update_new_round(self, dt)
    if G.STATE ~= G.STATES.DRAW_TO_HAND then
        update_new_roundref(self, dt)
        for _, v in ipairs(G.playing_cards) do
            if v.ability.big_bird_enchanted and v.children.lobc_big_bird_particles then
                v.children.lobc_big_bird_particles:remove()
                v.children.lobc_big_bird_particles = nil
            end
        end
    end
end

if JokerDisplay then
    JokerDisplay.Definitions.j_lobc_big_bird = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.joker_display_values", ref_value = "x_mult" }
                }
            }
        },
        calc_function = function(card)
            local x_mult = 1
            local hand = next(G.play.cards) and G.play.cards or G.hand.highlighted
            local _, _, scoring_hand = JokerDisplay.evaluate_hand(hand)

            for i = 1, #scoring_hand do
                if scoring_hand[i].ability.big_bird_enchanted and not scoring_hand[i].debuff then
                    x_mult = x_mult * card.ability.extra.x_mult
                end
            end

            card.joker_display_values.x_mult = x_mult
        end,
        style_function = function(card, text, reminder_text, extra)
            if text then 
                text.states.visible = card:check_rounds(4) >= 4
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

-- :eyes: