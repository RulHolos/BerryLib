local bullet_data = require("assets.bullets").data.bullet_data

local last_cg = SceneManager.newGroup("Normal", 1, false, {}, true)

local test_scene = last_cg:newScene("test_entry")
function test_scene:init()
    New(BG_Temple)

    New(ReimuPlayer)

    --[[Task.new(self, function()
        for col = 1, 16 do
            local i = 210
            for k, v in pairs(bullet_data) do
                Bullet.fire(k, col, -185 + (col * 15), i, 0, 0)
                i = i - 13
            end
        end
    end)]]

    Task.new(self, function()
        local col = 1
        for _ = 0, INF do
            --Bullet.fire("arrow_big", col, 0, 0, 1.8, 0, true)
            New(item_power, -100, 200)
            New(item_power_large, -50, 200)
            New(item_power_full, 50, 200)
            New(item_point, 100, 200)

            Bullet.fire("arrow_big", Bullet.COLOR.RED, 0, 0, 1.8, 0, false, false, 0)
            Task.wait(30)

            col = wrap(col + 1, 1, 16)
        end
    end)

    New(EnemyBase, 0, 120, 1000, true, false, 14, {})
end