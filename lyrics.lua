function lobc_generate_screen_lyric(beat, str, duration, pop_in_rate)
    local rotation = math.random(-50, 50)/100
    local offset = {x = math.random(-100, 100)/100, y = math.random(-150, 150)/100}
    return {
        beat = beat, 
        func = function()
            lobc_screen_text({
                scale = 0.8, 
                text = str, 
                colour = lighten(G.C.IMPORTANT, 0.7), 
                hold = duration*(60/lobc_conductor.bpm)*G.SETTINGS.GAMESPEED, 
                pop_out = 0.1*G.SETTINGS.GAMESPEED,
                pop_in_rate = pop_in_rate or 0.3,
                align = 'cm', 
                offset = offset, 
                text_rot = rotation,
                major = G.play, 
                noisy = false, 
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
        lobc_generate_screen_lyric(361, "I'm piercing the rope that strangled you and me", 22),
        lobc_generate_screen_lyric(381, "Let us be free", 9, 0.6),
        lobc_generate_screen_lyric(388, "(High tide, low tide)", 18),
        lobc_generate_screen_lyric(404, "(High tide, low tide)", 18),
        lobc_generate_screen_lyric(420, "(High tide, low tide)", 18),
        lobc_generate_screen_lyric(436, "(High tide, low tide)", 18),
    }
end