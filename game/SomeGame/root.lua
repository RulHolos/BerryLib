local last_cg = SceneManager.newGroup("Normal", 1, true, {}, true)

local test_scene = last_cg:newScene("test_entry")
function test_scene:init()
    New(BG_Temple)

    New(ReimuPlayer)
end