-- Compass
function lobc_generate_screen_lyric(beat, str, duration, pop_in_rate)
    local rotation = math.random(-50, 50)/100
    local offset = {x = math.random(-100, 100)/100, y = math.random(-150, 150)/100}
    return {
        beat = beat, 
        func = function()
            if SMODS.previous_track ~= "lobc_music_compass" then return end
            lobc_screen_text({
                scale = 0.8, 
                text = str, 
                colour = lighten(G.C.IMPORTANT, 0.7), 
                hold = duration*(60/lobc_conductor.bpm), 
                pop_out = 0.5,
                pop_in_rate = pop_in_rate or 0.3,
                align = 'cm', 
                offset = offset, 
                text_rot = rotation,
                major = G.play, 
                noisy = false, 
                timer = 'REAL',
                pause_force = true,
            })
        end
    }
end

function lobc_generate_compass_lyrics()
    return {
        lobc_generate_screen_lyric(66, "Bon Voyage", 13),
        lobc_generate_screen_lyric(77, "Your mermaid's setting sail", 14),
        lobc_generate_screen_lyric(89, "At last", 6, 0.6),
        lobc_generate_screen_lyric(93, "Full speed towards your heart", 18),
        lobc_generate_screen_lyric(109, "Full speed towards your heart", 15),
        lobc_generate_screen_lyric(122, "I've had enough", 21),
        lobc_generate_screen_lyric(141, "I'm reclaiming myself", 14),
        lobc_generate_screen_lyric(153, "The aft", 6, 0.6),
        lobc_generate_screen_lyric(157, "Leaving behind the hurt", 18),
        lobc_generate_screen_lyric(173, "Leaving behind the hurt", 19),
        lobc_generate_screen_lyric(190, "When it snapped", 13),
        lobc_generate_screen_lyric(201, "My compass was swallowed by the sea", 18),
        lobc_generate_screen_lyric(217, "My compass was swallowed by the sea", 18),
        lobc_generate_screen_lyric(233, "I cursed this relationship between you and me", 23),
        lobc_generate_screen_lyric(254, "I wanted blood", 17),
        lobc_generate_screen_lyric(269, "I wanted black and white", 14),
        lobc_generate_screen_lyric(281, "Clear cut", 6, 0.6),
        lobc_generate_screen_lyric(285, "Your evils predefined", 18),
        lobc_generate_screen_lyric(301, "Your evils predefined", 18),
        lobc_generate_screen_lyric(318, "Hold on tight", 13),
        lobc_generate_screen_lyric(329, "My compass is curiosity", 18),
        lobc_generate_screen_lyric(345, "My compass is curiosity", 18),
        lobc_generate_screen_lyric(361, "I'm piercing through the rope that strangled you and me", 22),
        lobc_generate_screen_lyric(381, "Let us be free", 9, 0.6),
        lobc_generate_screen_lyric(388, "(High tide, low tide)", 18),
        lobc_generate_screen_lyric(404, "(High tide, low tide)", 18),
        lobc_generate_screen_lyric(420, "(High tide, low tide)", 18),
        lobc_generate_screen_lyric(436, "(High tide, low tide)", 18),
    }
end

-- Get Funky
function lobc_get_funky()
    G.get_funky = true
    lobc_restart_music()
end

local align_cardsref = CardArea.align_cards
function CardArea.align_cards(self)
    if G.get_funky and (self == G.jokers or self == G.consumeables or self == G.hand) then return end
    align_cardsref(self)
end

function lobc_add_funky_event(beat, func)
    local sev = SMODS.Sounds["lobc_music_funky"].sync_events
    local found = false
    local inc = 0
    for k, v in ipairs(sev) do
        if v.beat - beat <= 3 and v.beat - beat >= 0 then
            found = true
            sev[beat + inc] = {beat = beat + inc, func = func}
            inc = inc + 1
        end
    end
    if not found then
        table.insert(sev, {beat = beat, func = func})
        table.insert(sev, {beat = beat + 1, func = func})
        table.insert(sev, {beat = beat + 2, func = func})
        table.insert(sev, {beat = beat + 3, func = func})
    end
end

local last = 0
function lobc_move_cards(rounded_beat)
    --print("started at "..rounded_beat)
    local sev = SMODS.Sounds["lobc_music_funky"].sync_events
    local available_cards = {}
    for _, t in ipairs({G.hand, G.jokers, G.consumeables}) do
        for _, v in ipairs(t.cards) do
            table.insert(available_cards, v)
        end
    end
    pseudoshuffle(available_cards, pseudoseed("get_funky"))

    sel = 2
    --[[local sel = last
    while sel == last do sel = math.random(1, 4) end]]--

    -- Cards move in a wave fashion
    if sel == 1 then
        local x_thing = G.ROOM.T.w / (#available_cards + 1)
        for k, v in ipairs(available_cards) do
            local sin = math.sin(math.pi()*k*0.2)
            -- determine starting pos
            v.T.x = x_thing * k
            v.T.y = (G.ROOM.T.y/2) * sin + 1
            -- Move
            G.E_MANAGER:add_event(Event({trigger = 'ease', ease = 'inexpo', blocking = false, blockable = false, ref_table = G.ROOM_ORIG, ref_value = 'x', ease_to = G.original_orig_x, delay = 2.5, timer = "REAL", func = (function(t) return t end)}))
            G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function() 
                play_sound("lobc_apoc_birth", 1, 0.8)
            return true end }))
        end
    -- Cards teleport randomly
    elseif sel == 2 then
        local function move()
            for k, v in ipairs(available_cards) do
                v.T.x = G.ROOM.T.w * math.random()
                v.T.y = G.ROOM.T.y * math.random(-0.5, 7)
                v.VT.x = v.T.x
                v.VT.y = v.T.y
            end
        end
        lobc_add_funky_event(rounded_beat, move)
    end
end

--eval lobc_get_funky()