local config = SMODS.current_mod.config
local joker = {
    name = "Big Bird",
    config = {extra = {x_mult = 3, cost = 4, has_played_enchanted = false}}, rarity = 3, cost = 8,
    pos = {x = 6, y = 1}, 
    blueprint_compat = true, 
    eternal_compat = true,
    perishable_compat = true,
    abno = true,
    risk = "waw",
    discover_rounds = 6,
    loc_txt = {},
}

joker.calculate = function(self, card, context)
    if context.setting_blind and not context.getting_sliced then
        local available_cards = {}
        for _, v in ipairs(G.playing_cards) do
            if not v.ability.big_bird_enchanted then available_cards[#available_cards+1] = v end
        end
        if #available_cards <= 0 then return true end
        local chosen_card = pseudorandom_element(available_cards, pseudoseed("lobc_big_bird"))
        chosen_card.ability.big_bird_enchanted = true
        chosen_card.children.lobc_big_bird_particles = Particles(0, 0, 0,0, {
            timer = 0.3,
            scale = 0.45,
            speed = 0.3,
            lifespan = 4,
            attach = chosen_card,
            colours = {darken(G.C.MONEY, 0.1), darken(G.C.MONEY, 0.3), darken(G.C.MONEY, 0.5)},
            fill = true
        })
        chosen_card:juice_up()
    end

    if context.individual and context.cardarea == G.play and context.other_card.ability.big_bird_enchanted then
        card.ability.extra.has_played_enchanted = true
        return {
            x_mult = card.ability.extra.x_mult,
            card = card
        }
    end

    if context.end_of_round and not context.repetition and not context.individual then
        if not card.ability.extra.has_played_enchanted then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local first = true
                    for _, v in ipairs(G.playing_cards) do
                        if v.ability.big_bird_enchanted then
                            ease_dollars(-card.ability.extra.cost)
                            v.ability.big_bird_enchanted = nil
                            v:start_dissolve()
                            if first and not config.disable_unsettling_sfx then
                                play_sound("lobc_big_bird_destroy", 1, 0.5)
                            end
                            first = nil
                        end
                    end
                return true
                end
            }))
        end
    end
end

joker.generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    local vars = { 
        card.ability.extra.x_mult, card.ability.extra.cost,
        card:check_rounds(2), card:check_rounds(4), card:check_rounds(6),
        colours = {HEX("C8831B")}
    }
    local desc_key = self.key
    if card:check_rounds(2) < 2 then
        desc_key = 'dis_'..desc_key..'_1'
    elseif card:check_rounds(4) < 4 then
        desc_key = 'dis_'..desc_key..'_2'
    elseif card:check_rounds(6) < 6 then
        desc_key = 'dis_'..desc_key..'_3'
    end

    full_UI_table.name = localize{type = 'name', key = desc_key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
    if specific_vars and specific_vars.debuffed then
        localize{type = 'other', key = 'debuffed_default', nodes = desc_nodes}
    else
        localize{type = 'descriptions', key = desc_key, set = self.set, nodes = desc_nodes, vars = vars}
    end
end

if JokerDisplay then
    -- tba
end

return joker

-- :eyes: