local last_cg = SceneManager.newGroup("Normal", 1, false, {}, true)

local test_scene = last_cg:newScene("test_entry")
function test_scene:init()
    New(BG_Temple)

    New(ReimuPlayer)

    Task.New(self, function()
        for i = 0, INF do
            Bullet.fire("square", Bullet.COLOR.DEEP_RED, 0, 40, 1.8, 0)
            Bullet.fire("arrow_big", Bullet.COLOR.DEEP_RED, 0, 20, 1.8, 0)
            Bullet.fire("gun_bullet", Bullet.COLOR.DEEP_RED, 0, 0, 1.8, 0)
            Bullet.fire("butterfly", Bullet.COLOR.DEEP_RED, 0, -20, 1.8, 0)
            Bullet.fire("kite", Bullet.COLOR.DEEP_RED, 0, -40, 1.8, 0)
            Task.Wait(60)
        end
    end)
end