---@class launcher.Main : Menu.View
local M = {}

function M:init()
    MenuView.init(self)
end

function M:frame()

end

function M:render()
    SetImageState("white", "", Color(255, 64, 64, 64))
    RenderRect("white", 0, 100, 0, Screen.height)
end

return M