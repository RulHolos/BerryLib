local last_cg = SceneManager.newGroup("Normal", 1, false, {}, true)

local test_scene = last_cg:newScene("test_entry")
function test_scene:init()
    New(BG_Temple)

    New(ReimuPlayer)
end

------------------
--- Menu

local menu = SceneManager.new("menu", false, true)
function menu:init()

end