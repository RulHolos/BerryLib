local config = require("lib.menu.MenuConfig")

---@class Scene.LoadingScene : Scene
local M = SceneManager.new("Loading", true, true)
function M:init()
    self.showing = false

    print("Loaded Loading Scene.")

    if config.disable_loading_screen then
        --SceneManager.setNextScene("test_entry")
        --SceneManager.next()
        SceneManager.goToGroup("Normal")
    end

    self.showing = true
end

function M:render()
    if not self.showing then
        return
    end

    SetViewMode("ui")
    -- TODO
    SetViewMode("world")
end