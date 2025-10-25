local config = require("lib.menu.menuConfig")

---@class Scene.LoadingScene : Scene
local M = SceneManager.new("Loading", true, true)
function M:init()
    self.showing = false

    print("Loaded Loading Scene.")

    if config.disable_loading_screen then
        if GameExists() then
            SceneManager.goToGroup("Normal")
        else
            SceneManager.setNextScene("launcher")
            SceneManager.next()
        end
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