local current_mod = SMODS.current_mod
local config = SMODS.current_mod.config

-- copied from cryptid's cry_deep_copy
function lobc_deep_copy(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[lobc_deep_copy(k, s)] = lobc_deep_copy(v, s) end
    return res
end

-- Talisman compat
to_big = to_big or function(num)
    return num
end

-- copied from attention_text
function lobc_screen_text(args)
    if config.disable_all_text then return end
    args = args or {}
    args.text = args.text or 'test'
    args.scale = args.scale or 1
    args.colour = copy_table(args.colour or G.C.WHITE)
    args.hold = (args.hold or 0) + 0.1*(G.SPEEDFACTOR)
    args.pos = args.pos or {x = 0, y = 0}
    args.align = args.align or 'cm'
    args.emboss = args.emboss or nil
    args.timer = args.timer or nil
    args.quiver = args.quiver or nil
    args.spacing = args.spacing or 0
    if args.float == nil then args.float = true end

    args.fade = 1
    args.cover_colour = copy_table(G.C.CLEAR)

    args.uibox_config = {
        align = args.align or 'cm',
        offset = args.offset or { x = 0, y = 0}, 
        major = args.cover or args.major or nil,
    }

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0,
        blockable = false,
        blocking = false,
        func = function()
            args.AT = UIBox{
                T = {args.pos.x,args.pos.y,0,0},
                definition = 
                    {n=G.UIT.ROOT, config = {align = args.cover_align or 'cm', minw = (args.cover and args.cover.T.w or 0.001) + (args.cover_padding or 0), minh = (args.cover and args.cover.T.h or 0.001) + (args.cover_padding or 0), padding = 0.03, r = 0.1, emboss = args.emboss, colour = args.cover_colour}, nodes={
                        {n=G.UIT.O, config = { draw_layer = 1, object = DynaText({scale = args.scale, string = args.text, maxw = args.maxw, spacing = args.spacing, colours = {args.colour}, float = args.float, quiver = args.quiver, shadow = true, silent = not args.noisy, pop_in = args.pop_in or 0, pop_in_rate = args.pop_in_rate or 3, rotate = args.rotate or nil, text_rot = args.text_rot or 0, font = G.LANGUAGES[G.SETTINGS.language].font })}},
                    }}, 
                config = args.uibox_config
            }
            args.AT.states.hover.can = false
            args.AT.states.click.can = false
            args.AT.attention_text = true

            args.text = args.AT.UIRoot.children[1].config.object
            args.text.yesod_immune = true
            --args.text:pulse(0.5)
        return true
        end
    }))

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = args.hold,
        blockable = false,
        blocking = false,
        timer = args.timer,
        pause_force = args.pause_force,
        func = function()
            if not args.start_time then
                args.start_time = G.TIMERS.TOTAL
                args.text:pop_out(args.pop_out or 3)
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 1,
                    blockable = false,
                    blocking = false,
                    timer = "REAL",
                    func = function()
                        if args.AT then args.AT:remove() end
                    return true
                    end
                }))
            end
        return true
        end
    }))
end

-- on-screen text that's present in like every project moon game
function lobc_abno_text(key, eval_func, delay, quips)
    if config.disable_abno_text then return end
    local chosen_quip = nil

    for _, v in pairs(G.lobc_global_meltdowns) do
        if G.GAME.modifiers["lobc_"..v] and key ~= v then return end
    end

    if type(quips) == "number" then chosen_quip = math.random(1, quips or 8)
    else
        --[[
            quips = {
                global = 2,
                { min_ante = 0, max_ante = 3, amount = 2 },
                { min_ante = 4, max_ante = 6, amount = 4 },
                { min_ante = 7, max_ante = G.GAME.win_ante, amount = 4 },
            }
        ]]--
        local all_quips = {}

        if quips["global"] and G.GAME.round_resets.ante <= G.GAME.win_ante then
            for i = 1, quips["global"] do
                all_quips[#all_quips+1] = "0_"..i
            end
        end

        for k, v in ipairs(quips) do
            if (v.phase and G.GAME.current_round.phases_beaten == v.phase) or 
               (v.min_ante and G.GAME.round_resets.ante >= v.min_ante and G.GAME.round_resets.ante <= v.max_ante) then
                for i = 1, v.amount do
                    all_quips[#all_quips+1] = k.."_"..i
                end
            end
        end

        chosen_quip = all_quips[math.random(#all_quips)]
    end
    local rotation = math.random(-75, 75)/100
    local offset = {x = math.random(-300, 300)/100, y = math.random(-300, 300)/100}
    local spacing = math.random(0, 8)

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = delay or 0, 
        blocking = false, 
        blockable = false, 
        timer = 'REAL',
        func = function() 
            if eval_func() and key and chosen_quip then 
                lobc_screen_text({scale = 0.65, text = localize("k_lobc_"..key.."_"..chosen_quip), colour = G.C.RED, hold = 5, align = 'cm', offset = offset, spacing = spacing, major = G.play, noisy = false, text_rot = rotation, pop_in_rate = 0.2, pop_out = 0.5, timer = "REAL", pause_force = true, quiver = {speed = 0.07, amount = 0.15, silent = true}})
                lobc_abno_text(key, eval_func, math.random(2, 10), quips) 
            end 
        return true 
        end
    }))
end

-- what it says
function lobc_get_usage_count(key)
    return G.PROFILES[G.SETTINGS.profile].joker_usage[key] and G.PROFILES[G.SETTINGS.profile].joker_usage[key].count or 0
end

-- Check rounds until observation unlock
function Card:check_rounds()
    --local val = lobc_get_usage_count(self.config.center_key)
    --return math.min(val, comp)
    return lobc_get_usage_count(self.config.center_key)
end

-- Make Abnos breach
function abno_breach(card, delay)
    G.E_MANAGER:add_event(Event({
        trigger = 'after', 
        delay = (delay or 1)*2,
        func = function()
            play_sound('tarot1')
            card.T.r = -0.2
            card:juice_up(0.3, 0.4)
            card.states.drag.is = true
            card.children.center.pinch.x = true
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_lobc_breached'), colour = G.C.FILTER, instant = true})
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                func = function()
                    card.getting_sliced = true
                    G.jokers:remove_card(card)
                    card:remove()
                    card = nil
                return true 
                end
            }))
            return true
        end
    }))
end

-- Restart music
function lobc_restart_music()
    if config.disable_music then return end
    G.ARGS.push = G.ARGS.push or {}
    G.ARGS.push.type = 'restart_music'
    if G.F_SOUND_THREAD then
        G.SOUND_MANAGER.channel:push(G.ARGS.push)
    else
        RESTART_MUSIC(G.ARGS.push)
    end
end

-- Shallow copy (deep copy is in blindexpander)
function shallow_copy(t)
    local t2 = {}
    for k,v in pairs(t) do
        t2[k] = v
    end
    return t2
end

-- Quickly rerolls a boss
function lobc_reroll_boss(card)
    local offset = 0
    if card.config.center.key == "j_lobc_plague_doctor" then offset = 0.8 end
    lobc_screen_text({text = localize('k_lobc_warning_1'), scale = 0.35, hold = 6*G.SETTINGS.GAMESPEED, major = G.play, align = 'cm', offset = {x = 0, y = -3.5 + offset}, noisy = false, float = false, colour = G.C.RED})
    lobc_screen_text({text = localize{type = 'name_text', key = card.config.center.key, set = card.ability.set}..localize('k_lobc_warning_2'), scale = 0.35, hold = 6*G.SETTINGS.GAMESPEED, major = G.play, align = 'cm', offset = {x = 0, y = -3.1 + offset}, noisy = false, float = false, colour = G.C.WHITE})
    G.from_boss_tag = true
    G.FUNCS.reroll_boss()
end

-- Updated play_sound
local play_soundref = play_sound
local played_enchanted = false
function play_sound(sound_code, per, vol)
    if sound_code and sound_code:find('lobc') then
        -- No SFX toggle
        if config.no_sfx then return end
        if sound_code == "lobc_big_bird_attract" then
            if played_enchanted then return end
            played_enchanted = true
            G.E_MANAGER:add_event(Event({trigger = 'after', blocking = false, func = function()
                played_enchanted = false
            return true end }))
        end
        return play_soundref(sound_code, per, vol * 0.8)
    end
    return play_soundref(sound_code, per, vol)
end