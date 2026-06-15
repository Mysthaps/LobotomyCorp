local current_mod = SMODS.current_mod
local config = SMODS.current_mod.config

-- Card updates
local card_updateref = Card.update
function Card.update(self, dt)
    -- Check if enough rounds have passed, should be saving
    if self.config.center.abno then
        local rounds = self.config.center.discover_rounds[#self.config.center.discover_rounds]
        local count = lobc_get_usage_count(self.config.center_key)
        if config.discover_all and count < rounds then
            G.PROFILES[G.SETTINGS.profile].joker_usage[self.config.center.key] = {count = rounds or 0}
            self.config.center.discovered = true
            self:set_sprites(self.config.center)
        end
        self.config.center.discovered = (count >= rounds)
        self.config.center.alerted = self.config.center.discovered
    end

    card_updateref(self, dt)
end

-- Update round count for abnos
local set_joker_usageref = set_joker_usage
function set_joker_usage()
    set_joker_usageref()
    for k, v in pairs(G.jokers.cards) do
        if v.config.center_key and v.ability.set == 'Joker' and v.config.center.abno then
            if lobc_get_usage_count(v.config.center_key) >= v.config.center.discover_rounds[#v.config.center.discover_rounds] then
                if not v.config.center.discovered then
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4*G.SETTINGS.GAMESPEED, func = function()
                        play_sound('card1')
                        v:flip()
                    return true end }))
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4*G.SETTINGS.GAMESPEED, func = function()
                        discover_card(v.config.center)
                        v:set_sprites(v.config.center, nil)
                        play_sound('card1')
                        v:flip()
                    return true end }))
                end
                check_for_unlock({type = "lobc_observe_abno", card = v})
            end
        end
    end
end

-- Override undiscovered description
local generate_card_uiref = generate_card_ui
function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
    local abno_hide_desc = (hide_desc and _c.set == "Joker" and _c.abno)
    if card_type == "Undiscovered" and _c.set == "Joker" and _c.abno then
        card_type = "Undiscovered Abnormality"
        hide_desc = false
    end
    local t = generate_card_uiref(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
    if abno_hide_desc and _c.set == "Joker" and _c.abno then
        t.main = {}
        if main_start then t.main[#t.main+1] = main_start end
        localize{type = 'other', key = 'und_'.._c.key, set = _c.set, nodes = t.main}
        if main_end then t.main[#t.main+1] = main_end end
    end
    if card_type == "Undiscovered Abnormality" then
        t.card_type = "Undiscovered"
    end
    return t
end