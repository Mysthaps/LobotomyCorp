local blind = {
    name = "Big Eyes",
    pos = {x = 0, y = 1},
    atlas = "LobotomyCorp_ApocBird",
    dollars = 8, 
    mult = 1, 
    vars = {}, 
    debuff = {},
    boss = {showdown = true, min = 10, max = 10},
    boss_colour = HEX('C8831B'),
    passives = {
        "psv_lobc_fixed_encounter",
        "psv_lobc_the_three_birds",
        "psv_lobc_cracking_eggs",
        "psv_lobc_lamp"
    },
    summon = "bl_lobc_ab_beak",
    phase_refresh = true,
    no_collection = true
}

blind.set_blind = function(self, reset, silent)
    local eval_func = function()
        return G.GAME.blind and G.GAME.blind.config.blind.key == 'bl_lobc_ab_eyes'
    end
    lobc_abno_text("big_eyes", eval_func, 2, 6)
end

blind.defeat = function(self)
    G.GAME.apoc_music = 2
    play_sound("lobc_dice_roll", 1, 0.8)
    G.ARGS.push = G.ARGS.push or {}
    G.ARGS.push.type = 'restart_music'
    if G.F_SOUND_THREAD then
        G.SOUND_MANAGER.channel:push(G.ARGS.push)
    else
        RESTART_MUSIC(G.ARGS.push)
    end
    G.E_MANAGER:add_event(Event({
        trigger = 'before',
        func = function()
            display_cutscene({x = 1, y = 0})
        return true 
        end 
    }))
end

local lamped = false
blind.debuff_hand = function(self, cards, hand, handname, check)
    local count = 0
    for _, v in ipairs(cards) do
        if v.ability.big_bird_enchanted then count = count + 1 end
    end
    if count >= 2 then lamped = true; return true 
    else lamped = false end
    if not check then
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            func = function()
                for _, v in ipairs(cards) do
                    if not v.ability.big_bird_enchanted then
                        v.ability.big_bird_enchanted = true
                        v.children.lobc_big_bird_particles = Particles(0, 0, 0,0, {
                            timer = 0.3,
                            scale = 0.45,
                            speed = 0.3,
                            lifespan = 4,
                            attach = v,
                            colours = {darken(G.C.MONEY, 0.1), darken(G.C.MONEY, 0.3), darken(G.C.MONEY, 0.5)},
                            fill = true
                        })
                        v:juice_up()
                        break
                    end
                end
            return true 
            end 
        })) 
    end
end

blind.get_loc_debuff_text = function(self)
    if lamped then return localize("k_lobc_lamp") end
end

return blind