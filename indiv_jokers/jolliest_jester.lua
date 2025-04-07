local joker = {
    name = "The Jolliest Jester",
    config = {extra = 50}, rarity = 3, cost = 6,
    pos = {x = 6, y = 8}, 
    blueprint_compat = false, 
    eternal_compat = false,
    perishable_compat = false,
    abno = true,
    risk = "he",
    discover_rounds = 7,
    dependencies = {
        "Cryptid"
    }
}

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { 
        G.GAME.probabilities["jolliest_jester"], card.ability.extra, G.GAME.probabilities["jolliest_jester_inc"],
        card:check_rounds(2), card:check_rounds(5), card:check_rounds(7)
    }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(5) < 5 then
        desc_key = 'dis_'..desc_key..'_2'
    elseif card:check_rounds(7) < 7 then
        desc_key = 'dis_'..desc_key..'_3'
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

local create_card_for_shopref = create_card_for_shop
function create_card_for_shop(area)
    local m = SMODS.find_card("j_lobc_jolliest_jester")
    if next(m) then
        if not (area == G.shop_jokers and G.SETTINGS.tutorial_progress and G.SETTINGS.tutorial_progress.forced_shop and G.SETTINGS.tutorial_progress.forced_shop[#G.SETTINGS.tutorial_progress.forced_shop]) then
            -- Make tags run normally first
            local forced_tag = nil
            for k, v in ipairs(G.GAME.tags) do
                if not forced_tag then
                    forced_tag = v:apply_to_run({type = 'store_joker_create', area = area})
                    if forced_tag then
                    for kk, vv in ipairs(G.GAME.tags) do
                        if vv:apply_to_run({type = 'store_joker_modify', card = forced_tag}) then break end
                    end
                    return forced_tag end
                end
            end

            if area == G.shop_jokers then
                -- Roll for Jolly Jonklers
                for _, v in ipairs(m) do
                    if not v.debuff then
                        if pseudorandom("jolliest_jester") < G.GAME.probabilities["jolliest_jester"] / v.ability.extra then
                            G.GAME.probabilities["jolliest_jester"] = math.floor(G.GAME.probabilities["jolliest_jester"] / 2 + 0.5)
                            local card = SMODS.create_card({key = "j_jolly", set = "Joker", area = area, key_append = "sho"})
                            create_shop_card_ui(card, "Joker", area)
                            G.E_MANAGER:add_event(Event({
                                func = (function()
                                    for k, v in ipairs(G.GAME.tags) do
                                    if v:apply_to_run({type = 'store_joker_modify', card = card}) then break end
                                    end
                                    return true
                                end)
                            }))
                            return card
                        else
                            G.GAME.probabilities["jolliest_jester"] = math.min(G.GAME.probabilities["jolliest_jester"] + G.GAME.probabilities["jolliest_jester_inc"], v.ability.extra)
                        end
                    end
                end
            end
        end
    end
    return create_card_for_shopref(area)
end

local check_for_buy_spaceref = G.FUNCS.check_for_buy_space
function G.FUNCS.check_for_buy_space(card)
    if next(SMODS.find_card("j_lobc_jolliest_jester")) and ((card.is_jolly and card:is_jolly()) or card.config.center.key == "j_jolly") then
        return true
    end
    return check_for_buy_spaceref(card)
end

return joker