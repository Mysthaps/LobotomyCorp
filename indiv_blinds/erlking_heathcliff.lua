local blind = {
    name = "Erlking Heathcliff",
    pos = {x = 0, y = 0},
    dollars = 8, 
    mult = 100, 
    vars = {}, 
    debuff = {},
    boss = {min = 1, max = 10},
    boss_colour = HEX('800080'),
    atlas = "Erlking_Heathcliff",
    passives = {
        "psv_lobc_erlking_1",
        "psv_lobc_erlking_2",
        "psv_lobc_erlking_3",
        "psv_lobc_erlking_4",
        "psv_lobc_erlking_5",
        "psv_lobc_erlking_6",
        "psv_lobc_erlking_7",
        "psv_lobc_erlking_8",
        "psv_lobc_erlking_9",
    },
    no_collection = true,
}

blind.set_blind = function(self)
    G.GAME.blind.children.animatedSprite.scale = {x = 1435, y = 1042}
    G.GAME.blind.children.animatedSprite.scale_mag = 1042/1.5
    G.GAME.blind.children.animatedSprite:reset()
end

blind.defeat = function(self)
    G.GAME.blind.children.animatedSprite.scale = {x = 34, y = 34}
    G.GAME.blind.children.animatedSprite.scale_mag = 34/1.5
    G.GAME.blind.children.animatedSprite:reset()
end

return blind