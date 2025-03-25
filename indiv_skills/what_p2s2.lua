local skill = {
    name = "Punctured Weakness",
    atlas = "what_skills",
    pos = {x = 2, y = 1},
}

skill.loc_vars = function(self, info_queue, skill)
    info_queue[#info_queue+1] = {key = 'lobc_prey_mark', set = 'Other'}
end

skill.calculate = function(self, skill, context)
    if context.before then
        prey_mark_card(context)
    end

    if context.individual and context.cardarea == G.play then
        if not context.other_card.ability.prey_marked then
            skill.triggered = true
            return {
                x_mult = 0.8,
                card = context.other_card,
            }
        end
    end

    if context.after then return {} end
end

return skill