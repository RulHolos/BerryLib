local bullet_data = require("assets.bullets").data.bullet_data

local last_cg = SceneManager.newGroup("Normal", 1, false, {}, true)

local test_scene = last_cg:newScene("test_entry")
function test_scene:init()
    New(BG_Temple)

    New(ReimuPlayer)

    Task.New(self, function()
        for col = 1, 16 do
            local i = 210
            for k, v in pairs(bullet_data) do
                Bullet.fire(k, col, -185 + (col * 15), i, 0, 0)
                i = i - 13
            end
        end
    end)
end