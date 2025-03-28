local current_mod = SMODS.current_mod
local config = SMODS.current_mod.config
local skill_deck_1 = {
    {"what_s1", "what_s2", "what_p1s1",},
    {"what_s1", "what_p1s3", "what_p1s1"},
    {"what_s2", "what_p1s3", "what_p1s1", "what_p1s2"},
}
local skill_deck_2 = {
    {"what_s2", "what_p2s1", "what_p2s2"},
    {"what_s1", "what_s2", "what_p2s1", "what_p2s2"},
    {"what_s2", "what_p2s3"},
    {"what_p2s1", "what_p2s2"},
}
local skill_deck_3 = {
    {"what_s1", "what_s2", "what_p3s1", "what_p3s3"},
    {"what_s1", "what_p3s1", "what_p3s2", "what_p3s3"},
    {"what_s1", "what_s2", "what_p3s1", "what_p3s3"},
}
local blind = {
    name = "GasHarpoon",
    pos = {x = 0, y = 0},
    atlas = "what_huh",
    dollars = 8, 
    mult = 4, 
    phases = 3,
    vars = {}, 
    debuff = {},
    boss = {showdown = true, min = 10, max = 10},
    boss_colour = HEX('C4C4C4'),
    passives = {
        "psv_lobc_sanity",
        "psv_lobc_what_1",
        "psv_lobc_what_2",
        "psv_lobc_what_3_pip",
        "psv_lobc_fixed_encounter",
        "psv_lobc_final_battle",
    },
    phase_refresh = true,
    no_collection = true,
}

blind.lobc_loc_txt = function(self)
    if G.lobc_what_txt then return {upd_name = true, key = G.lobc_what_txt} end
    if G.GAME.blind.skill_deck then 
        if G.GAME.current_round.phases_beaten == 0 then return {vars = {G.GAME.blind.ego}, key = "bl_lobc_what_pip"} end
        if G.GAME.current_round.phases_beaten == 1 then return {vars = {G.GAME.blind.ego}, key = "bl_lobc_what_starbuck"} end
        if G.GAME.current_round.phases_beaten == 2 then return {vars = {G.GAME.blind.ego}, key = "bl_lobc_what_queequeg"} end
        return {vars = {G.GAME.blind.ego}, key = "bl_lobc_what_pip"}
    end
end

blind.setup_sprites = function(self)
    G.original_orig_x = lobc_deep_copy(G.ROOM_ORIG).x
    G.original_orig_y = lobc_deep_copy(G.ROOM_ORIG).y
    G.GAME.blind.children.animatedSprite.atlas = G.ANIMATION_ATLAS["lobc_what"]
    G.GAME.blind.children.animatedSprite.scale = {x = 512, y = 512}
    G.GAME.blind.children.animatedSprite.scale_mag = 512/1.5
    G.GAME.blind.children.animatedSprite:reset()
end

blind.set_blind = function(self)
    self:setup_sprites()
    if os.date("%d%m") == "0104" then config.seen_what = true; SMODS.save_mod_config(current_mod) end
    G.E_MANAGER:add_event(Event({trigger = 'before', func = function() 
        lobc_restart_music()
        display_cutscene({x = 0, y = 0}, "what", 0.1)
    return true end }))
    G.E_MANAGER:add_event(Event({func = function() 
        -- Sanity
        G.GAME.blind.p_sp = 0
        G.GAME.blind.b_sp = 0
    return true end }))
    
    G.GAME.blind.prepped = true
    G.GAME.blind.hands_sub = -1
    -- Pip's Ego
    mod_ego("set", 20)
end

blind.phase_change = function(self)
    ease_discard(math.max(0, G.GAME.round_resets.discards + G.GAME.round_bonus.discards) - G.GAME.current_round.discards_left)
    G.E_MANAGER:add_event(Event({func = function() 
        G.GAME.blind.skill_deck = nil
        if G.skill_deck then
            G.skill_deck:remove()
            G.skill_deck = nil
        end
        G.GAME.blind.discards_sub = 0

        -- Phase change cutscene
        if G.GAME.current_round.phases_beaten == 1 then
            display_cutscene(nil, "what_2", 0.1)
        elseif G.GAME.current_round.phases_beaten == 2 then
            display_cutscene(nil, "what_3", 0.1)
        end

        G.E_MANAGER:add_event(Event({func = function() 
            -- Change passive when phase changes
            if G.GAME.current_round.phases_beaten == 1 then
                -- Passive: [Starbuck's Fears]
                G.GAME.blind.passives[4] = "psv_lobc_what_3_starbuck"
                mod_ego("set", 20)
                G.GAME.blind.children.alert = UIBox{
                    definition = create_UIBox_card_alert(), 
                    config = {
                        align = "tri",
                        offset = {
                            x = 0.1, y = 0
                        },
                        parent = G.GAME.blind
                    }
                }
            elseif G.GAME.current_round.phases_beaten == 2 then
                -- Passive: [Queequeg's Atonement]
                G.GAME.blind.passives[4] = "psv_lobc_what_3_queequeg"
                mod_ego("set", 30)
                G.GAME.blind.children.alert = UIBox{
                    definition = create_UIBox_card_alert(), 
                    config = {
                        align = "tri",
                        offset = {
                            x = 0.1, y = 0
                        },
                        parent = G.GAME.blind
                    }
                }
                ease_discard(3)
            end
            G.GAME.blind.hands_sub = -1
            G.GAME.blind.prepped = true
            if G.GAME.blind.b_sp < 0 then
                G.E_MANAGER:add_event(Event({trigger = 'after', func = function() 
                    mod_sp("b", "set", 0)
                    SMODS.calculate_effect({
                        message = "Reset SP",
                        colour = G.C.BLUE,
                        no_juice = true
                    }, G.GAME.blind)
                return true end }))
            end
        return true end }))
    return true end }))
end

blind.defeat = function(self)
    G.GAME.blind.children.animatedSprite.scale = {x = 34, y = 34}
    G.GAME.blind.children.animatedSprite.scale_mag = 34/1.5
    G.GAME.blind.children.animatedSprite:reset()

    G.GAME.blind.skill_deck = nil
    if G.skill_deck then
        G.skill_deck:remove()
        G.skill_deck = nil
    end
    G.GAME.blind.p_sp = nil
    G.GAME.blind.b_sp = nil
    G.GAME.blind.shield_value = nil
end

blind.drawn_to_hand = function(self)
    if G.GAME.blind.prepped then
        local chips_this_round = to_big(G.GAME.chips) - to_big(G.GAME.blind.hands_sub)
        -- Only change effect if the hand scored
        if chips_this_round > to_big(0) then
            -- Increment hands this phase for specific skill decks
            G.GAME.blind.discards_sub = (G.GAME.blind.discards_sub or 0) + 1
            -- Roll skills
            G.GAME.blind:roll_skill()
            -- Remove shield
            G.GAME.blind.shield_value = nil
            -- Passive: [Ahab] - Heal SP to self each turn/Resets SP at -45 SP
            if G.GAME.blind.b_sp > -45 then
                G.E_MANAGER:add_event(Event({trigger = 'after', func = function() 
                    mod_sp("b", "add", 15)
                    SMODS.calculate_effect({
                        message = "+15 SP",
                        colour = G.C.BLUE,
                        no_juice = true
                    }, G.GAME.blind)
                return true end }))
            else
                if not G.GAME.blind.in_panic then
                    G.E_MANAGER:add_event(Event({trigger = 'after', func = function() 
                        SMODS.calculate_effect({
                            message = "Panic!",
                            colour = G.C.PURPLE,
                            no_juice = true
                        }, G.GAME.blind)
                    return true end }))
                    G.GAME.blind.in_panic = true
                else
                    G.GAME.blind.in_panic = nil
                    G.E_MANAGER:add_event(Event({trigger = 'after', func = function() 
                        mod_sp("b", "set", 0)
                        SMODS.calculate_effect({
                            message = "Reset SP",
                            colour = G.C.BLUE,
                            no_juice = true
                        }, G.GAME.blind)
                    return true end }))
                end
            end
        end

        -- Reset used status for specific skills
        for _, v in ipairs(G.playing_cards) do
            v.ability.p1s1_activated = nil
            v.ability.p3s1_activated = nil
            v.ability.what_activated = nil
        end
    end
end

blind.press_play = function(self)
    G.GAME.blind.prepped = true
    ease_hands_played(1)
end

blind.calculate = function(self, blind, context)
    -- Passive: [Sanity]
    if G.STATE == G.STATES.HAND_PLAYED and context.modify_scoring_hand then 
        for _, card in pairs(context.scoring_hand) do
            -- Activate effect on scoring cards only
            if card == context.other_card or SMODS.always_scores(context.other_card) or next(find_joker('Splash')) then 
                if not context.other_card.ability.what_activated then
                    if pseudorandom("what_panic") < (G.GAME.blind.b_sp - G.GAME.blind.p_sp)/100 then
                        SMODS.calculate_effect({
                            message = "Panic!",
                            colour = G.C.PURPLE,
                        }, context.other_card)
                        delay(0.2)
                        context.other_card.ability.what_activated = true
                        return {
                            remove_from_hand = true,
                        }
                    else
                        context.other_card.ability.what_activated = true
                    end
                end
            end
        end
    end

    -- Activate Skills
    -- Passive: [Price of Nobility] - SP on Clash Win/Lose
    if G.skill_deck then
        for i = 1, #G.skill_deck.cards do
            local skill = G.skill_deck.cards[i]
            local res = skill.config.center:calculate(skill, context)
            if res then
                G.E_MANAGER:add_event(Event({trigger = 'after', func = function() 
                    if not skill.triggered then
                        G.E_MANAGER:add_event(Event({trigger = 'after', func = function() 
                            mod_sp("p", "add", 10)
                            SMODS.calculate_effect({
                                message = "+10 SP",
                                colour = G.C.BLUE,
                                no_juice = true
                            }, G.deck)
                        return true end }))
                        G.E_MANAGER:add_event(Event({trigger = 'after', func = function() 
                            mod_sp("b", "add", -10)
                            SMODS.calculate_effect({
                                message = "-10 SP",
                                colour = G.C.RED,
                            }, blind)
                        return true end }))
                        -- Skill: [Murky Innocence] - [Failed Use]
                        if skill.config.center.key == "sk_lobc_what_p1s3" then
                            G.E_MANAGER:add_event(Event({trigger = 'after', func = function() 
                                mod_sp("b", "add", -5)
                                SMODS.calculate_effect({
                                    message = "-5 SP",
                                    colour = G.C.RED,
                                }, blind)
                            return true end }))
                        end
                        sendDebugMessage("Lost a clash: "..skill.config.center.key, "LobotomyCorp")
                    end
                return true end }))
                if (context.modify_scoring_hand and res.remove_from_hand) or ((context.destroying_card or context.destroy_card) and res.remove) then
                    return res
                end
                SMODS.calculate_effect(res, res.card or skill)
            end
        end
    end

    -- Passive: [Price of Nobility] - SP on scoring
    if context.individual and context.cardarea == G.play then
        if find_passive("psv_lobc_sanity") then
            G.E_MANAGER:add_event(Event({trigger = 'after', func = function() 
                mod_sp("p", "add", 1)
            return true end }))
            return {
                card = context.other_card,
                message = "+1 SP",
                colour = G.C.BLUE,
                no_juice = true
            }
        end
    end

    if context.after then
        -- Passive: [Pip's Sin and Innocence]
        if G.GAME.current_round.phases_beaten == 0 then
            G.E_MANAGER:add_event(Event({trigger = 'after', func = function() 
                mod_sp("b", "add", math.floor(blind.ego/2))
                SMODS.calculate_effect({
                    message = "+"..math.floor(blind.ego/2).." SP",
                    colour = G.C.BLUE,
                }, blind)
            return true end }))
        end

        -- Passive: [Queequeg's Atonement]
        if G.GAME.current_round.phases_beaten == 2 and G.GAME.blind.shield_value then
            G.E_MANAGER:add_event(Event({trigger = 'after', func = function() 
                if G.GAME.blind.shield_value > 0 then
                    mod_ego("add", 5)
                else
                    mod_ego("add", -10)
                end
            return true end }))
        end

        -- Once an Ahab...
        if G.GAME.current_round.phases_beaten == 2 then
            G.E_MANAGER:add_event(Event({trigger = 'after', func = function() 
                if to_big(G.GAME.chips) >= to_big(G.GAME.blind.chips) then
                    play_sound("lobc_what_death", 1, 0.8)
                end
            return true end }))
        end
    end

    -- Destroy Prey Marked cards on discard
    if context.pre_discard and context.other_card and context.other_card.ability.prey_marked then
        return {
            remove = true, 
            no_juice = true
        }
    end
end

local messaged = false
blind.cry_cap_score = function(self, score)
    local score_modifier = 1
    -- Passive: [Ahab] - Score increases by 20% at -45 SP
    if G.GAME.blind.b_sp <= -45 then
        score_modifier = score_modifier + 0.2
    end
    -- Passive: Score increases by 50% at 0 Ego
    if G.GAME.blind.ego <= 0 then
        score_modifier = score_modifier + 0.5
    end
    -- Passive: [Starbuck's Fears]
    if G.GAME.current_round.phases_beaten == 1 and G.GAME.blind.ego > 0 then
        score_modifier = score_modifier - math.floor(G.GAME.blind.ego/6) * 0.2
    end
    -- Go through all the skills
    if G.skill_deck then
        for i = 1, #G.skill_deck.cards do
            local skill = G.skill_deck.cards[i]
            -- Skill: [Murky Innocence] - Score decreases by 50% if triggered
            if skill.config.center.key == "sk_lobc_what_p1s3" and skill.triggered then
                score_modifier = score_modifier - 0.5
            end
            -- Skill: [Clouded Path] - Score decreases by 20% if Prey Marked card in hand
            if skill.config.center.key == "sk_lobc_what_p3s1" then
                local proc = false
                for _, v in ipairs(G.hand.cards) do
                    if v.ability.prey_marked then proc = true; break end
                end
                if proc then
                    skill.triggered = true
                    score_modifier = score_modifier - 0.2
                end
            end
        end
    end

    local final_score = score * score_modifier
    if G.GAME.blind.shield_value then final_score = math.max(final_score - G.GAME.blind.shield_value, 0) end
    if not messaged then
        if score_modifier ~= 1 then
            G.E_MANAGER:add_event(Event({trigger = 'after', func = function() 
                SMODS.calculate_effect({
                    message = (score_modifier * 100).."% Score",
                    colour = score_modifier > 1 and G.C.BLUE or G.C.RED,
                    no_juice = true
                }, G.GAME.blind)
            return true end }))
        end
        messaged = true
    else
        messaged = false
    end

    -- Passive: [Ahab] - Score is capped at 30% Blind Size
    return math.floor(math.min(0.3*G.GAME.blind.chips, final_score)+0.5)
    --return math.floor(final_score) -- No capped score
end

-- Function to quick apply Prey Mark
function prey_mark_card(context)
    for _, v in ipairs(context.scoring_hand) do
        if not v.ability.prey_marked then
            v.ability.prey_marked = true
            return
        end
    end
end

-- Adds/Sets SP
function mod_sp(var, _type, val)
    if var == "p" and G.GAME.blind.p_sp then
        if _type == "set" then G.GAME.blind.p_sp = val end
        if _type == "add" then G.GAME.blind.p_sp = G.GAME.blind.p_sp + val end
        if G.GAME.blind.p_sp > 45 then G.GAME.blind.p_sp = 45 end
        if G.GAME.blind.p_sp < -45 then G.GAME.blind.p_sp = -45 end
    end
    if var == "b" and G.GAME.blind.b_sp then
        if _type == "set" then G.GAME.blind.b_sp = val end
        if _type == "add" then G.GAME.blind.b_sp = G.GAME.blind.b_sp + val end
        if G.GAME.blind.b_sp > 45 then G.GAME.blind.b_sp = 45 end
        if G.GAME.blind.b_sp < -45 then G.GAME.blind.b_sp = -45 end
    end
end

-- Adds/Sets Ego
function mod_ego(_type, val)
    if _type == "set" then G.GAME.blind.ego = val end
    if _type == "add" then G.GAME.blind.ego = G.GAME.blind.ego + val end
    if G.GAME.blind.ego < 0 then G.GAME.blind.ego = 0 end
    if G.GAME.blind.ego > 30 then G.GAME.blind.ego = 30 end
    G.GAME.blind:set_text()
end

-- Restore Prey Mark on reload
local card_updateref = Card.update
function Card.update(self, dt)
    card_updateref(self, dt)
    if self.ability.prey_marked and not self.children.lobc_prey_mark then
        self.children.lobc_prey_mark = Sprite(self.T.x, self.T.y, self.T.w, self.T.h, G.ASSET_ATLAS["lobc_LobotomyCorp_modifiers"], {x = 5, y = 0})
        self.children.lobc_prey_mark.role.major = self
        self.children.lobc_prey_mark.states.hover.can = false
        self.children.lobc_prey_mark.states.click.can = false
    end
end

-- Draw Prey Marked cards to hand / Destroy Prey Marked cards on discard
local draw_cardref = draw_card
function draw_card(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
    if from == G.play and to == G.discard and card then
        if card.ability.prey_marked and not card.marked_destroy then
            return draw_cardref(G.play, G.hand, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
        end
    end
    draw_cardref(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only)
end

-- Function to roll a new skill deck
function Blind:roll_skill()
    if G.skill_deck then
        G.skill_deck:remove()
        G.skill_deck = nil
    end
    if force_skills then 
        self.skill_deck = force_skills
        G.GAME.blind:set_text() 
        return 
    end
    if self.config.blind.key == "bl_lobc_what_blind" then
        -- Pip's Ego
        if G.GAME.current_round.phases_beaten == 0 then 
            if G.GAME.blind.discards_sub == 1 or G.GAME.blind.ego == 0 then self.skill_deck = skill_deck_1[1]
            elseif G.GAME.blind.discards_sub == 2 then self.skill_deck = skill_deck_1[2]
            else self.skill_deck = skill_deck_1[3] end
        end
        -- Starbuck's Ego
        if G.GAME.current_round.phases_beaten == 1 then 
            if G.GAME.blind.ego == 0 then self.skill_deck = skill_deck_2[4]
            elseif G.GAME.blind.discards_sub == 1 then self.skill_deck = skill_deck_2[1]
            else
                local has_prey = false
                for _, v in ipairs(G.hand.cards) do
                    if v.ability.prey_marked then has_prey = true end
                end
                if has_prey then self.skill_deck = skill_deck_2[3]
                else self.skill_deck = skill_deck_2[2] end
            end
        end
        -- Queequeg's Ego
        if G.GAME.current_round.phases_beaten == 2 then 
            if G.GAME.blind.ego == 0 then self.skill_deck = skill_deck_3[3]
            elseif G.GAME.blind.discards_sub == 1 then self.skill_deck = skill_deck_3[1]
            else self.skill_deck = skill_deck_3[2] end
        end
        G.GAME.blind:set_text()
    end
end
-- eval _G.force_skills = {"what_p3s3"}; G.GAME.blind:roll_skill()

return blind