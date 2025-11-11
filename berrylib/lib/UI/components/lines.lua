---@class berry.UI.Component.Lines : berry.UI.Component
local M = {}
M.name = "Lines"
M.priority = 0

function M:init()
    self.positions = {
        { 109 + Screen.playfield.screen_right, 419 },
        { 109 + Screen.playfield.screen_right, 397 },
        { 109 + Screen.playfield.screen_right, 349 },
        { 109 + Screen.playfield.screen_right, 311 },
        { 109 + Screen.playfield.screen_right, 267 },
        { 109 + Screen.playfield.screen_right, 224 },
        { 109 + Screen.playfield.screen_right, 202 },
    }
end

function M:frame()
end

function M:render()
    local y0 = 448 - self.ui.timer * 3
    for i = 1, #self.positions do
        local x, y = self.positions[i][1], self.positions[i][2]
        local dy = max(y - y0, 0)
        local alpha = min(dy * 4, 255)
        local dw = alpha / 255
        SetImageState("ui:line_" .. i, "", Color(alpha, 255, 255, 255))
        Render("ui:line_" .. i, x, y, 0, dw, 1)
    end
end

function M:debug()
end

GameUI.registerBaseComponent(M)