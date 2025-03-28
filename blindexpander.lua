--- USAGES
--- 
--- SMODS.Blind.passives (table): Contains passives keys to attach to Blind
--- SMODS.Blind.summon (string): After Blind is defeated, immediately sets new Blind with key
--- G.GAME.blind.original_blind (string): Key of the first Blind if Blinds are summoned
--- SMODS.Blind.phases (number): Amount of times Blind needs to be defeated to end the round
--- G.GAME.current_round.phases_beaten (number): Amount of times Blind was beaten if Blind has phases
--- SMODS.Blind.phase_refresh (bool): Refreshes the deck when Blind is defeated (independent of SMODS.Blind.phases)
--- 
--- SMODS.Blind.cry_score_cap(self, score) -> number: Caps score, the same effect as Cryptid's The Tax blind
--- SMODS.Blind.phase_change(self) -> nil: Called when Blind is defeated and a new phase starts (either summon or phases)
--- SMODS.Blind.pre_defeat(self) -> nil: Called when the final Blind (requires summon or phases) is defeated, but before deck shuffle and round eval occurs
--- SMODS.current_mod.passive_ui_size() -> number: Allows changing width of passive UIBox, default 6
--- find_passive(string) -> bool: Check if current Blind has a specific passive key
--- 
--- NOTES
--- 
--- Localization for Passives are taken from G.localization.descriptions.Passives
--- Passive key should be "psv_[mod prefix]_[key]" for consistency
--- SMODS.Blind.defeat(self) is called on the current blind if it has a summon
--- If passive description is too long, changing how it is formatted instead of changing UIBox width is preferred

to_big = to_big or function(x) return x end

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
            if first_time_passive then first_time_passive() end -- lobc exclusive
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
    blindTable.original_blind = self.original_blind
    return blindTable
end

local blind_loadref = Blind.load
function Blind.load(self, blindTable)
    self.passives = blindTable.passives
    self.original_blind = blindTable.original_blind
    blind_loadref(self, blindTable)
end

function info_from_passive(passive)
    local width = 6
    for _, v in ipairs(SMODS.Mods) do
        if v.passive_ui_size and type(v.passive_ui_size) == "function" then
            width = math.max(width, v.passive_ui_size())
        end
    end
    local desc_nodes = {}
    localize{type = 'descriptions', key = passive, set = "Passive", nodes = desc_nodes, vars = {}}
    local desc = {}
    for _, v in ipairs(desc_nodes) do
        desc[#desc+1] = {n=G.UIT.R, config={align = "cl"}, nodes=v}
    end
    return 
    {n=G.UIT.R, config={align = "cl", colour = lighten(G.C.GREY, 0.4), r = 0.1, padding = 0.05}, nodes={
        {n=G.UIT.R, config={align = "cl", padding = 0.05, r = 0.1}, nodes = localize{type = 'name', key = passive, set = "Passive", name_nodes = {}, vars = {}}},
        {n=G.UIT.R, config={align = "cl", minw = width, minh = 0.4, r = 0.1, padding = 0.05, colour = desc_nodes.background_colour or G.C.WHITE}, nodes={{n=G.UIT.R, config={align = "cm", padding = 0.03}, nodes=desc}}}
    }}
end

function create_UIBox_blind_passive(blind)
    local passive_lines = {}
    for _, v in ipairs(blind.passives) do
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
            if self.passives then
                G.blind_passive = UIBox{
                    definition = create_UIBox_blind_passive(self),
                    config = {
                        major = self,
                        parent = nil,
                        offset = {
                            x = 0.15,
                            y = 0.2 + 0.38*#self.passives,
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
    if G.GAME.blind and G.GAME.blind.passives then
        for _, v in ipairs(G.GAME.blind.passives) do
            if v == key then return true end
        end
    end
    return false
end

local update_new_roundref = Game.update_new_round
function Game.update_new_round(self, dt)
    if self.buttons then self.buttons:remove(); self.buttons = nil end
    if self.shop then self.shop:remove(); self.shop = nil end

    if not G.STATE_COMPLETE and not G.GAME.blind.disabled and (G.GAME.blind.config.blind.summon or G.GAME.blind.config.blind.phases or G.GAME.blind.original_blind) then
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
                G.GAME.blind.original_blind = G.GAME.blind.original_blind or G.GAME.blind.config.blind.key
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