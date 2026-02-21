--- G.GAME.blind.original_blind (string): Key of the first Blind if Blinds are summoned
--- G.GAME.current_round.phases_beaten (number): Amount of times Blind was beaten if Blind has phases
--- 
--- NOTES
--- 
--- Localization for Passives are taken from G.localization.descriptions.Passive
--- Passive key should be "psv_[mod prefix]_[key]" for consistency
--- SMODS.Blind.defeat(self) is called on the current blind if it has a summon
--- If passive description is too long, changing how it is formatted instead of changing UIBox width is preferred

to_big = to_big or function(x) return x end
local BLINDEXPANDER_VERSION = 102040

local function startup()
    if blindexpander.started_up then return end
    blindexpander.started_up = true

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

    local set_blindref = Blind.set_blind
    function Blind.set_blind(self, blind, reset, silent)
        if not reset then
            self.passives = blind and lobc_deep_copy(blind.passives)
            if self.passives then
                self.passives_data = {}
                for _, key in ipairs(self.passives) do
                    local obj = blindexpander.Passives[key]
                    local cfg = {}
                    if obj then
                        cfg = copy_table(obj.config)
                        obj:apply(false)
                    end
                    self.passives_data[#self.passives_data + 1] = {
                        disabled = false,
                        key = key,
                        config = cfg
                    }
                end
                self.children.alert = UIBox{
                    definition = create_UIBox_card_alert(),
                    config = {
                        align = "tri",
                        offset = {
                            x = 0.1, y = 0
                        },
                        parent = self
                    }
                }
            else
                self.children.alert = nil
            end
        end
        set_blindref(self, blind, reset, silent)
    end

    local blind_saveref = Blind.save
    function Blind.save(self)
        local blindTable = blind_saveref(self)
        blindTable.passives = self.passives
        blindTable.passives_data = self.passives_data
        blindTable.original_blind = self.original_blind
        return blindTable
    end

    local blind_loadref = Blind.load
    function Blind.load(self, blindTable)
        self.passives = blindTable.passives
        self.passives_data = blindTable.passives_data
        self.original_blind = blindTable.original_blind
        blind_loadref(self, blindTable)
    end
    function info_from_passive(passive_data)
        local width = 6
        for _, v in ipairs(SMODS.Mods) do
            if v.passive_ui_size and type(v.passive_ui_size) == "function" then
                width = math.max(width, v.passive_ui_size())
            end
        end
        local obj = blindexpander.Passives[passive_data.key]
        local disabled = (G.GAME.blind or {}).disabled or passive_data.disabled
        local loc_res = {}
        if obj then
            loc_res = obj:loc_vars(G.GAME.blind, passive_data) or {}
        end
        local no_name = loc_res.no_name
        local loc_key = loc_res.key or passive_data.key
        local loc_set = loc_res.set or "Passive"
        local desc_nodes = {}
        localize{type = 'descriptions', key = loc_key, set = loc_set, nodes = desc_nodes, vars = loc_res.vars or {}}
        local desc = {}
        for _, v in ipairs(desc_nodes) do
            desc[#desc+1] = {n=G.UIT.R, config={align = "cl"}, nodes=v}
        end
        local name_nodes = localize{type = 'name', key = loc_key, set = loc_set, name_nodes = {}, vars = loc_res.vars or {}}
        if disabled then
            name_nodes[1].nodes[1].nodes[1].config.strikethrough = G.C.RED
        end
        return 
        {n=G.UIT.R, config={align = "cl", colour = lighten(G.C.GREY, 0.4), r = 0.1, padding = 0.05}, nodes={
            (not no_name) and {n=G.UIT.R, config={align = "cl", padding = 0.05, r = 0.1}, nodes = name_nodes} or nil,
            {n=G.UIT.R, config={align = "cl", minw = width, minh = 0.4, r = 0.1, padding = 0.05, colour = desc_nodes.background_colour or G.C.WHITE}, nodes={{n=G.UIT.R, config={align = "cm", padding = 0.03}, nodes=desc}}}
        }}
    end

    function Blind:disable_passive(key, no_update, silent)
        if find_passive(key) then
            for _, data in ipairs(self.passives_data) do
                if data.key == key and not data.disabled then
                    data.disabled = true
                    local obj = blindexpander.Passives[key]
                    if obj then
                        obj:remove(self, data, true)
                    end
                    if not no_update then
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            func = function()
                            if self.boss and G.GAME.chips - G.GAME.blind.chips >= 0 then
                                G.STATE = G.STATES.NEW_ROUND
                                G.STATE_COMPLETE = false
                            end
                            return true
                        end
                        }))
                        for _, v in ipairs(G.playing_cards) do
                            self:debuff_card(v)
                        end
                        for _, v in ipairs(G.jokers.cards) do
                            self:debuff_card(v)
                        end
                    end
                    if not self.children.alert then
                        self.children.alert = UIBox{
                            definition = create_UIBox_card_alert(),
                            config = {
                                align = "tri",
                                offset = {
                                    x = 0.1, y = 0
                                },
                                parent = self
                            }
                        }
                    end
                    if not silent then self:wiggle() end
                    break
                end
            end
        end
    end

    function Blind:enable_passive(key, no_update, silent)
        if find_passive(key) then
            for _, data in ipairs(self.passives_data) do
                if data.key == key and data.disabled then
                    data.disabled = false
                    local obj = blindexpander.Passives[key]
                    if obj then
                        obj:apply(self, data, true)
                    end
                    if not no_update then
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            func = function()
                            if self.boss and G.GAME.chips - G.GAME.blind.chips >= 0 then
                                G.STATE = G.STATES.NEW_ROUND
                                G.STATE_COMPLETE = false
                            end
                            return true
                        end
                        }))
                        for _, v in ipairs(G.playing_cards) do
                            self:debuff_card(v)
                        end
                        for _, v in ipairs(G.jokers.cards) do
                            self:debuff_card(v)
                        end
                    end
                    if not self.children.alert and not self.disabled then
                       self.children.alert = UIBox{
                            definition = create_UIBox_card_alert(),
                            config = {
                                align = "tri",
                                offset = {
                                    x = 0.1, y = 0
                                },
                                parent = self
                            }
                        }
                    end
                    if not silent then self:wiggle() end
                    break
                end
            end
        end
    end

    function Blind:add_passive(key, no_update, silent)
        if not find_passive(key) then
            local obj = blindexpander.Passives[key]
            local cfg = {}
            if obj then
                cfg = copy_table(obj.config)
            end
            local data = {
                disabled = false,
                key = key,
                config = cfg
            }
            if obj then
                obj:apply(self, data, false)
            end
            self.passives_data = self.passives_data or {}
            self.passives_data[#self.passives_data + 1] = data
            if not no_update then
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                    if self.boss and G.GAME.chips - G.GAME.blind.chips >= 0 then
                        G.STATE = G.STATES.NEW_ROUND
                        G.STATE_COMPLETE = false
                    end
                    return true
                end
                }))
                for _, v in ipairs(G.playing_cards) do
                    self:debuff_card(v)
                end
                for _, v in ipairs(G.jokers.cards) do
                    self:debuff_card(v)
                end
            end
            if not self.children.alert then
                self.children.alert = UIBox{
                    definition = create_UIBox_card_alert(),
                    config = {
                        align = "tri",
                        offset = {
                            x = 0.1, y = 0
                        },
                        parent = self
                    }
                }
            end
            if not silent then self:wiggle() end
        end
    end

    function Blind:remove_passive(key, no_update, silent)
        if find_passive(key) then
            for i, data in ipairs(self.passives_data) do
                if data.key == key then
                    local obj = blindexpander.Passives[key]
                    if obj then
                        obj:remove(self, data, false)
                    end
                    table.remove(self.passives_data, i)
                    if not no_update then
                        G.E_MANAGER:add_event(Event({
                            trigger = 'immediate',
                            func = function()
                            if self.boss and G.GAME.chips - G.GAME.blind.chips >= 0 then
                                G.STATE = G.STATES.NEW_ROUND
                                G.STATE_COMPLETE = false
                            end
                            return true
                        end
                        }))
                        for _, v in ipairs(G.playing_cards) do
                            self:debuff_card(v)
                        end
                        for _, v in ipairs(G.jokers.cards) do
                            self:debuff_card(v)
                        end
                    end
                    if #self.passives_data ~= 0 and not self.children.alert then
                        self.children.alert = UIBox{
                            definition = create_UIBox_card_alert(),
                            config = {
                                align = "tri",
                                offset = {
                                    x = 0.1, y = 0
                                },
                                parent = self
                            }
                        }
                    end
                    if not silent then self:wiggle() end
                    break
                end
            end
        end
    end

    function get_actual_original_blind(key)
        local obj = G.P_BLINDS[key]
        if obj.precedes_original and not obj.summon then
            print("WARNING: precedes_original was set, but Blind does not have a summon")
        end
        if obj.precedes_original and obj.summon then
            return get_actual_original_blind(obj.summon)
        end
        return key
    end
    ---@param blind Blind
    function create_UIBox_blind_passive(blind)
        local passive_lines = {}
        for _, v in ipairs(blind.passives_data) do
            passive_lines[#passive_lines+1] = info_from_passive(v)
        end
        return
        {n=G.UIT.ROOT, config = {align = 'cm', colour = lighten(G.C.JOKER_GREY, 0.5), r = 0.1, emboss = 0.05, padding = 0.05}, nodes={
            {n=G.UIT.R, config={align = "cm", emboss = 0.05, r = 0.1, minw = 2.5, padding = 0.05, colour = G.C.GREY}, nodes={
                {n=G.UIT.C, config = {align = "lm", padding = 0.1}, nodes = passive_lines}
            }}
        }}
    end

    local blind_hoverref = Blind.hover
    function Blind.hover(self)
        if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then 
            if not self.hovering and self.states.visible and self.children.animatedSprite.states.visible then
                if self.passives_data and #self.passives_data > 0 then
                    G.blind_passive = UIBox{
                        definition = create_UIBox_blind_passive(self),
                        config = {
                            major = self,
                            parent = nil,
                            offset = {
                                x = 0.15,
                                y = 0.2 + 0.38*#self.passives_data,
                            },  
                            type = "cr",
                        }
                    }
                    G.blind_passive.attention_text = true
                    G.blind_passive.states.collide.can = false
                    G.blind_passive.states.drag.can = false
                    if self.children.alert then
                        self.children.alert:remove()
                        self.children.alert = nil
                    end
                end
            end
        end
        blind_hoverref(self)
    end

    local blind_stop_hoverref = Blind.stop_hover
    function Blind.stop_hover(self)
        if G.blind_passive then
            G.blind_passive:remove()
            G.blind_passive = nil
        end
        blind_stop_hoverref(self)
    end

    function find_passive(key)
        if G.GAME.blind and G.GAME.blind.passives_data then
            for _, v in ipairs(G.GAME.blind.passives_data) do
                if v.key == key then return true end
            end
        end
        return false
    end

    local update_new_roundref = Game.update_new_round
    function Game.update_new_round(self, dt)
        if self.buttons then self.buttons:remove(); self.buttons = nil end
        if self.shop then self.shop:remove(); self.shop = nil end

        if not G.STATE_COMPLETE and (not G.GAME.blind.disabled or (G.GAME.blind.config.blind.summon and G.GAME.blind.config.blind.summon_while_disabled)) and (G.GAME.blind.config.blind.summon or G.GAME.blind.config.blind.phases or G.GAME.blind.original_blind) then
            if G.GAME.blind.original_blind and not G.GAME.blind.config.blind.summon then -- Triggers if blind is not the original blind
                -- Reset to the original blind's values
                if G.GAME.blind.original_blind ~= G.GAME.blind.config.blind.key then
                    G.GAME.blind:set_blind(G.P_BLINDS[G.GAME.blind.original_blind])
                    G.GAME.blind.chips = -1 -- force win blind
                    G.GAME.blind.children.alert = nil
                end

                local valueToPutInIf = (Talisman and to_big and to_big(G.GAME.chips):gte(to_big(G.GAME.blind.chips))) or to_big(G.GAME.chips) >= to_big(G.GAME.blind.chips)
                if valueToPutInIf then
                    local obj = G.GAME.blind.config.blind
                    if obj.pre_defeat and type(obj.pre_defeat) == "function" then
                        obj:pre_defeat()
                    end
                end
            else
                local valueToPutInIf = (Talisman and to_big and to_big(G.GAME.chips):lt(to_big(G.GAME.blind.chips))) or to_big(G.GAME.chips) < to_big(G.GAME.blind.chips)
                if G.GAME.current_round.hands_left <= 0 and valueToPutInIf then 
                    G.GAME.blind.original_blind = nil
                    G.STATE_COMPLETE = true
                    end_round()
                    return
                else
                    G.GAME.current_round.phases_beaten = G.GAME.current_round.phases_beaten + 1
                end
                
                if G.GAME.blind.config.blind.phases and G.GAME.current_round.phases_beaten >= G.GAME.blind.config.blind.phases then
                    return update_new_roundref(self, dt)
                end

                if G.GAME.blind.config.blind.phase_refresh then 
                    -- Refresh deck
                    G.FUNCS.draw_from_discard_to_deck()
                    G.FUNCS.draw_from_hand_to_deck()
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 1,
                        blockable = false,
                        func = function()
                            G.E_MANAGER:add_event(Event({
                                trigger = 'immediate',
                                func = function()
                                    G.deck:shuffle(G.GAME.blind.config.blind.key..'_refresh')
                                    G.deck:hard_set_T()
                                return true
                                end
                            }))
                        return true
                        end
                    }))
                end

                local obj = G.GAME.blind.config.blind
                if obj.phase_change and type(obj.phase_change) == "function" then
                    obj:phase_change()
                end

                if G.GAME.blind.config.blind.summon then
                    local obj = G.GAME.blind.config.blind
                    G.P_BLINDS[obj.key].discovered = true
                    if obj.defeat and type(obj.defeat) == 'function' then
                        obj:defeat()
                    end
                    G.GAME.blind.original_blind = G.GAME.blind.original_blind or get_actual_original_blind(G.GAME.blind.config.blind.key)
                    G.GAME.blind:set_blind(G.P_BLINDS[G.GAME.blind.config.blind.summon])
                    G.GAME.blind.dollars = G.P_BLINDS[G.GAME.blind.original_blind].dollars
                    G.GAME.blind.boss = G.P_BLINDS[G.GAME.blind.original_blind].boss
                    G.GAME.current_round.dollars_to_be_earned = G.GAME.blind.dollars > 0 and (string.rep(localize('$'), G.GAME.blind.dollars)..'') or ('')
                end

                G.STATE = G.STATES.DRAW_TO_HAND
                G.E_MANAGER:add_event(Event({
                    trigger = 'ease',
                    blocking = false,
                    ref_table = G.GAME,
                    ref_value = 'chips',
                    ease_to = 0,
                    delay = 0.3 * G.SETTINGS.GAMESPEED,
                    func = (function(t) return math.floor(t) end)
                }))
            end
        end

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

    local new_roundref = new_round
    function new_round()
        new_roundref()
        G.GAME.current_round.phases_beaten = 0
    end

    local calculate_round_scoreref = SMODS.calculate_round_score
    function SMODS.calculate_round_score(flames)
        local score = calculate_round_scoreref(flames)
        if G.GAME.blind then
            local obj = G.GAME.blind.config.blind
            if obj.mod_score and type(obj.mod_score) == "function" then
                return obj:mod_score(score)
            end
        end
        return score
    end

    local blind_calcref = Blind.calculate
    function Blind:calculate(context)
        local blind_eff = blind_calcref(self, context)
        local final_ret = { blind_eff }
        if self.passives_data and not self.disabled then
            for _, data in ipairs(self.passives_data) do
                local obj = blindexpander.Passives[data.key]
                if obj and not data.disabled then
                    final_ret[#final_ret+1] = obj:calculate(self, data, context)
                end
            end
        end
        if #final_ret == 0 then
            return nil
        elseif #final_ret == 1 then
            return final_ret[1]
        else
            return SMODS.merge_defaults(unpack(final_ret))
        end
    end

    G.FUNCS.show_blind_passives_infotip = function(e)
        if e.config.ref_table then
            local num_passives = #e.config.ref_table
            local y_offset = 0.3*math.max(num_passives - 2, 0)
            e.children.info = UIBox{
                definition = create_UIBox_blind_passive({passives_data = e.config.ref_table}),
                config = (not e.config.ref_table or not e.config.ref_table.card_pos or e.config.ref_table.card_pos.x > G.ROOM.T.w*0.4) and
                    {offset = {x=-0.13,y=y_offset}, align = 'cl', parent = e} or
                    {offset = {x=0.13,y=y_offset}, align = 'cr', parent = e}
            }
            e.children.info:align_to_major()
            e.config.ref_table = nil
        end
    end

    local blind_collection_UIBox_ref = create_UIBox_blind_popup
    function create_UIBox_blind_popup(blind, ...)
        local ret = blind_collection_UIBox_ref(blind, ...)
        if blind.passives then
            local fake_data = {}
            for _, key in ipairs(blind.passives) do
                local obj = blindexpander.Passives[key]
                local cfg = {}
                if obj then
                    cfg = copy_table(obj.config)
                    obj:apply(false)
                end
                fake_data[#fake_data + 1] = {
                    disabled = false,
                    key = key,
                    config = cfg
                }
            end
            ret.config.object = Moveable()
            ret.config.ref_table = next(fake_data) and fake_data or nil
            ret.config.func = "show_blind_passives_infotip"
        end
        return ret
    end
end

blindexpander = blindexpander or {}
if not blindexpander.ver or blindexpander.ver < BLINDEXPANDER_VERSION then
    blindexpander.ver = BLINDEXPANDER_VERSION
    blindexpander.startup = startup
end

function UIElement:draw_pixellated_strikethough(_type, _parallax, _emboss, _progress)
    if not self.pixellated_rect or
        #self.pixellated_rect[_type].vertices < 1 or
        _parallax ~= self.pixellated_rect.parallax or
        self.pixellated_rect.w ~= self.VT.w or
        self.pixellated_rect.h ~= self.VT.h or
        self.pixellated_rect.sw ~= self.shadow_parrallax.x or
        self.pixellated_rect.sh ~= self.shadow_parrallax.y or
        self.pixellated_rect.progress ~= (_progress or 1)
    then
        self.pixellated_rect = {
            w = self.VT.w,
            h = self.VT.h,
            sw = self.shadow_parrallax.x,
            sh = self.shadow_parrallax.y,
            progress = (_progress or 1),
            fill = {vertices = {}},
            shadow = {vertices = {}},
            line = {vertices = {}},
            emboss = {vertices = {}},
            line_emboss = {vertices = {}},
            parallax = _parallax
        }
        local ext_up = self.config.ext_up and self.config.ext_up*G.TILESIZE or 0
        local totw, toth = self.VT.w*G.TILESIZE, (self.VT.h + math.abs(ext_up)/G.TILESIZE)*G.TILESIZE

        local vertices = {
            totw,toth/2+ext_up,
            0, toth/2+ext_up,
            0, toth/2+ext_up+1,
            totw,toth/2+ext_up+1
        }
        for k, v in ipairs(vertices) do
            if k%2 == 1 and v > totw*self.pixellated_rect.progress then v = totw*self.pixellated_rect.progress end
            self.pixellated_rect.fill.vertices[k] = v
            if k > 4 then
                self.pixellated_rect.line.vertices[k-4] = v
                if _emboss then
                    self.pixellated_rect.line_emboss.vertices[k-4] = v + (k%2 == 0 and -_emboss*self.shadow_parrallax.y or -0.7*_emboss*self.shadow_parrallax.x)
                end
            end
            if k%2 == 0 then
                self.pixellated_rect.shadow.vertices[k] = v -self.shadow_parrallax.y*_parallax
                if _emboss then
                    self.pixellated_rect.emboss.vertices[k] = v + _emboss*G.TILESIZE
                end
            else
                self.pixellated_rect.shadow.vertices[k] = v -self.shadow_parrallax.x*_parallax
                if _emboss then
                    self.pixellated_rect.emboss.vertices[k] = v
                end
            end
        end
    end
    love.graphics.polygon("fill", self.pixellated_rect.fill.vertices)
end

local injectItemsref = SMODS.injectItems
function SMODS.injectItems()
    injectItemsref()
    blindexpander.startup()
end

SMODS.current_mod.calculate = function (self, context)
    if context.end_of_round and not context.game_over and context.main_eval and context.beat_boss then
        G.GAME.blindexpander_hovered_this_ante[G.GAME.blind.config.blind.key] = nil
    end
end