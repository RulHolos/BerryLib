local card = require("lib.boss.card")

---@type berry.boss.card
local M = card.create("", 2, 5, 60, 1800, { item_power = 50, item_point = 50 })

function M:before()
end

function M:init()
    local b = self.manager:getBossFromIndex(1)

    Task.new(self, function()
        for _ = 1, INF do
            b:wander(ran:Int(60, 120), MOVE_DECEL)
            Task.wait(ran:Int(15, 120))
        end
    end)

    Task.new(self, function()
        for _ = 1, INF do
            Bullet.fire("square", Bullet.COLOR.BLUE, 0, 0, 1.8, 180, false, false, 0)
            Task.wait(15)
        end
    end)
end

function M:frame()
end

function M:render()
end

function M:beforedel()
    card.delete_all_danger()
end
function M:del() end
function M:afterdel()
end

return M