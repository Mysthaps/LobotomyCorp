local current_mod = SMODS.current_mod
local config = SMODS.current_mod.config

local lobc_conductor = {
    track = '',
    bpm = 0,
    offset = 0, 
    sec_per_beat = 0, 
    beat = 0, 
    pitch = 0,
}

-- Updates the conductor when sound changes
local modulate_soundref = modulate_sound
function modulate_sound(dt)
    local prev_track = SMODS.previous_track
    modulate_soundref(dt)
    local cur_track = SMODS.previous_track
    if prev_track ~= cur_track then
        local sound = SMODS.Sounds[cur_track]
        if sound and sound.sync_events then
            lobc_conductor.track = cur_track
            lobc_conductor.bpm = sound.bpm
            lobc_conductor.pitch = sound.pitch
            lobc_conductor.offset = sound.offset / sound.pitch
            lobc_conductor.sec_per_beat = 60/(sound.bpm / sound.pitch)
            lobc_conductor.beat = 0
        end
    end
end

local inc = 1
local last_beat = 0
function lobc_condupd(dt)
    local sound = SMODS.Sounds[lobc_conductor.track]
    -- Only activate for SMODS sounds, with bpm funcs
    if sound and sound.sync_events then
        local beat = lobc_conductor.beat
        G.SOUND_MANAGER.channel:push({type = "get_conductor"})
        while G.SOUND_MANAGER.conductor:getCount() > 0 do
            req = G.SOUND_MANAGER.conductor:pop()
        end
        if not req then return end

        -- Get Funky
        if G.get_funky then
            if beat - last_beat > (beat / 2) then
                inc = 1
            end
            if last_beat < inc and inc <= beat then
                --print(inc)
                if inc % 4 == 1 then lobc_move_cards(inc) end
                inc = inc + 1
            end
        end

        if beat ~= last_beat and beat - last_beat < (beat / 2) then -- bandage fix for looping
            for _, v in ipairs(SMODS.Sounds[lobc_conductor.track].sync_events) do
                if v.beat > last_beat and v.beat <= beat then
                    v.func()
                end
            end
        end

        local pos = req.pos - lobc_conductor.offset
        last_beat = lobc_conductor.beat
        lobc_conductor.beat = pos / lobc_conductor.sec_per_beat
    end
end

return lobc_conductor