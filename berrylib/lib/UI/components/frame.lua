---@class berry.UI.Component.Frame : berry.UI.Component
local M = {}
M.name = "Frame"
M.priority = 100

function M:init()
end

function M:frame()
end

function M:render()
    RenderRect("ui:bg", 0, Screen.width, 0, Screen.height)
end

function M:debug()
end

GameUI.registerBaseComponent(M)