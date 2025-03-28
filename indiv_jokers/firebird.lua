local joker = {
    name = "The Firebird",
    config = {extra = {x_mult = 1, incr = 0.15}}, rarity = 3, cost = 7,
    pos = {x = 3, y = 7}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "waw",
    discover_rounds = 6,
}

joker.calculate = function(self, card, context)
    if context.joker_main and card.ability.extra.x_mult > 1 then
        return {
            x_mult = card.ability.extra.x_mult,
            card = context.blueprint_card or card,
        }
    end

    if context.end_of_round and not context.blueprint and context.main_eval and card.ability.extra.x_mult > 1 then
        card.ability.extra.x_mult = 1
        return {
            message = localize('k_reset'),
            colour = G.C.RED
        }
    end
end

local ease_dollarsref = ease_dollars
function ease_dollars(mod, instant)
    local firebirds = SMODS.find_card("j_lobc_firebird")
    if firebirds[1] and mod > 5 then
        for _, v in ipairs(firebirds) do
            v.ability.extra.x_mult = v.ability.extra.x_mult + v.ability.extra.incr * (mod - 5)
            SMODS.calculate_effect({
                message = localize{type = 'variable', key = 'a_xmult', vars = {v.ability.extra.x_mult}},
                colour = G.C.RED,
            }, v)
        end
        return ease_dollarsref(5, instant)
    end
    return ease_dollarsref(mod, instant)
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { 
        card.ability.extra.cap, card.ability.extra.incr, card.ability.extra.x_mult, 
        card:check_rounds(3), card:check_rounds(6)
    }
    local desc_key = self.key
    if card:check_rounds(3) < 3 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(6) < 6 then
        desc_key = 'dis_'..desc_key..'_2'
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if not self.discovered and card.area ~= G.jokers then
        localize{type = 'descriptions', key = 'und_'..self.key, set = "Other", nodes = desc_nodes, vars = vars}
    elseif specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
    end
end

if JokerDisplay then
    JokerDisplay.Definitions.j_lobc_firebird = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "x_mult" }
                }
            }
        },
        style_function = function(card, text, reminder_text, extra)
            if text then 
                text.states.visible = card:check_rounds(6) >= 6
            end
            if reminder_text then
            end
            if extra then
            end
            return false
        end
    }
end

return joker

-- I AM FIREEEEEEEEEE
-- BURN THOSE WHO DARE TO CARE FOR MEEEEEEEEEEEEE