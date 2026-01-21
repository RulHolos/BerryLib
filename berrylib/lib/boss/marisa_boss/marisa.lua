local M = {}
---@type berry.boss.card[]
local spells = {}
local spell_count = 1

for i = 1, spell_count do
    table.insert(spells, require("lib.boss.marisa_boss.marisa_spell_" .. i))
end

function M.boss()
    local manager = BossManager.create()

    manager:addBoss("Marisa Kirisame", "leaf", -300, 384, nil)
    manager.boss_ui:set_state(true)

    manager.card_system:addCardRange(spells)

    manager:scope(function()
        manager:foreachBoss(true, false, function(b)
            b:move(0, 120, 30, MOVE_DECEL) -- Not blocking
        end)

        Task.wait(60)

        for _ = 1, spell_count do
            manager.card_system:goToNext()
        end

        manager:explode()
    end)
end

return M