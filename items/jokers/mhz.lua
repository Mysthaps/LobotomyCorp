local joker = {
    name = "1.76 MHz",
    config = {extra = {minc = 24, maxc = 85, minm = 4, maxm = 23}}, rarity = 2, cost = 7,
    pos = {x = 1, y = 1}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "teth",
    discover_rounds = {3, 6},
}

joker.calculate = function(self, card, context)
    if context.individual and context.cardarea == G.play then
        return {
            chips = math.floor(card.ability.extra.minc + (card.ability.extra.maxc - card.ability.extra.minc) * math.pow(pseudorandom("mhz_chips"), 2)),
            mult = math.floor(card.ability.extra.minm + (card.ability.extra.maxm - card.ability.extra.minm) * math.pow(pseudorandom("mhz_chips"), 2)),
            card = context.blueprint_card or card,
        }
    end
end

-- Remove card fronts
local front_funcref = SMODS.DrawSteps.front.func
function SMODS.DrawSteps.front.func(self, layer)
    if next(SMODS.find_card("j_lobc_mhz")) then return end
    return front_funcref(self, layer)
end

local greyed_funcref = SMODS.DrawSteps.greyed.func
function SMODS.DrawSteps.greyed.func(self, layer)
    if next(SMODS.find_card("j_lobc_mhz")) then 
        if self.greyed then
            self.children.center:draw_shader('played', nil, self.ARGS.send_to_shader)
        end
        return
    end
    return greyed_funcref(self, layer)
end

-- Override playing card suit colors
local generate_card_uiref = generate_card_ui
function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
    if next(SMODS.find_card("j_lobc_mhz")) then
        _c.replace_base_card = true
    end
    local t = generate_card_uiref(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
    if next(SMODS.find_card("j_lobc_mhz")) then
        _c.replace_base_card = false
    end
    return t
end

return joker

-- shoutouts to the sts card where it just kills your ears