local start_game = require("lib.menu.launcher.start_game")

---@param text string
---@param callback fun()
---@return launcher.widget
local function widget(text, callback)
    ---@class launcher.widget
    local w = {
        sizeX = 160,
        sizeY = 80,
        text = text,
        callback = callback,
        hovered = false,
        clicked = false,
    }
    return w
end

local launcher = SceneManager.new("launcher", false, true)
function launcher:init()
    self.menu_manager:addView("start", MenuView.create(start_game), true)

    ---@type launcher.widget[]
    self.widgets = {
        widget("Start Game", function()
            self.menu_manager:switchTo("start", 0)
        end),
        widget("Options", function()
            self.menu_manager:switchTo("options", 0)
        end),
        widget("Quit", function()
            QuitGame()
        end)
    }
end

function launcher:frame()
    local spacing = 20
    local offsetY = Screen.height - 20

    for i = 1, #self.widgets do
        local w = self.widgets[i]
        local yTop = offsetY - w.sizeY
        local yBottom = offsetY

        if IsMouseInRect(20, w.sizeX + 20, yTop, yBottom) then
            if GetMouseState(0) == true then
                w.clicked = true
                w.callback()
            else
                w.clicked = false
            end
            w.hovered = true
        else
            w.hovered = false
        end

        offsetY = yTop - spacing
    end
end

function launcher:render()
    SetViewMode("ui")

    SetImageState("white", "", Color(255, 64, 64, 64))
    RenderRect("white", 0, 200, 0, Screen.height)

    local spacing = 20
    local offsetY = Screen.height - 20

    for i = 1, #self.widgets do
        local w = self.widgets[i]
        local yTop = offsetY - w.sizeY
        local yBottom = offsetY

        if w.clicked then
            SetImageState("white", "", Color(255, 200, 200, 200))
        elseif w.hovered then
            SetImageState("white", "", Color(255, 128, 128, 128))
        else
            SetImageState("white", "", Color(255, 80, 80, 80))
        end
        RenderRect("white", 20, w.sizeX + 20, yTop, yBottom)

        SetFontState("menu", "", Color(255, 255, 255, 255))
        RenderText("menu", w.text, 30, yTop + w.sizeY/2, 0.7, "vcenter")

        offsetY = yTop - spacing
    end

    RenderText("menu", "Tip: use your mouse", 5, 10, 0.2, "top")
end