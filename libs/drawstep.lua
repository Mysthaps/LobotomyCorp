local current_mod = SMODS.current_mod
local config = SMODS.current_mod.config

-- "Sticker" modifiers
SMODS.DrawStep({
    key = "modifiers",
    order = 45, -- Above stickers
    func = function(self)
        if self.sprite_facing ~= 'front' then return end
        for _, v in ipairs(G.lobc_global_modifiers or {}) do
            if self.ability[v] then
                G.lobc_shared_modifiers[v].role.draw_major = self
                G.lobc_shared_modifiers[v]:draw_shader('dissolve', nil, nil, nil, self.children.center)
                G.lobc_shared_modifiers[v]:draw_shader('voucher', nil, self.ARGS.send_to_shader, nil, self.children.center)
            end
        end
    end
})
-- "Mood" modifiers (Shy Look, Wellcheers, Express Train)
SMODS.DrawStep({
    key = "mood",
    order = 50, -- Same order as The Soul/floating sprite
    func = function(self)
        if self.children.mood then
            self.children.mood.role.draw_major = self
            self.children.mood:draw_shader('dissolve', 0, nil, nil, self.children.center, nil, nil, nil, 0.1 + 0.03*math.sin(1.8*G.TIMERS.REAL), nil, 0.6)
            self.children.mood:draw_shader('dissolve', nil, nil, nil, self.children.center, nil, nil)
        end
    end
})
-- "Hover" modifiers
SMODS.DrawStep({
    key = "prey",
    order = 51,
    func = function(self)
        if self.sprite_facing ~= "front" then return end
        local h_mod = (self.config.center.abno and -0.15 or 0)
        for _, v in ipairs({"lantern", "prey", "prey_mark", "villain"}) do
            if self.children["lobc_"..v] then
                self.children["lobc_"..v]:draw_shader('dissolve', 0, nil, nil, self.children.center, 0.1, nil, nil, 0.1 + 0.03*math.sin(1.8*G.TIMERS.REAL) + self.T.h*-0.2-h_mod, nil, 0.6)
                self.children["lobc_"..v]:draw_shader('dissolve', nil, nil, nil, self.children.center, 0.1, nil, nil, self.T.h*-0.2-h_mod)
                h_mod = h_mod + 0.5
            end
        end
    end
})

-- Do not call Sprite:draw()
for _, v in ipairs({"mood", "lobc_lantern", "lobc_prey", "lobc_prey_mark", "lobc_villain"}) do
    SMODS.draw_ignore_keys[v] = true
end