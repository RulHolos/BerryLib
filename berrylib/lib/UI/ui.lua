-- ============== --
-- User Interface --
-- ============== --
--[[
This module contains the implementation for the gameplay interface (stg-frame), life display, score, etc...

The UI is implemented as a game object, which, compared to THlib, IS subject to pausing.
The UI object is created automatically when a non-menu scene is entered, and destroyed when leaving it.

Vertical UI is not supported in BerryLib, only horizontal UI is.

This UI framework is not fit for use with the editor and is code-only.
]]

---@class berry.UI
local M = {}
GameUI = M
---@type berry.UI|nil
CurrentGameUI = nil

function M:init()
    self.group = GROUP_GHOST
    self.layer = LAYER_TOP + 2 -- Above all. UI layers are between TOP+1 and TOP+3.
    self.bound = false
    self.colli = false

    LoadImageFromFile("ui_bg", "ui/ui_bg.png", false)
end

function M:frame()
    Task.Do(self)
end

function M:render()
    SetViewMode("ui")
    Render("ui_bg", 0, 0)
end

function M:del()
    CurrentGameUI = nil
end

function M:formatScore(score)
    local function formatnum(num)
        local sign = sign(num)
        num = abs(num)
        local tmp, var = {}, nil
        while num >= 1000 do
            var = num - int(num / 1000) * 1000
            table.insert(tmp, 1, ("%03d"):format(var))
            num = int(num / 1000)
        end
        table.insert(tmp, 1, tostring(num))
        var = table.concat(tmp, ".")
        if sign < 0 then
            var = ("-%s"):format(var)
        end
        return var, #tmp - 1
    end

    if score < 1000000000000 then
        return formatnum(score)
    else
        return string.format("999.999.999.999")
    end
end

function M.create()
    local obj = makeInstance(M)
    CurrentGameUI = obj
    obj:init()

    return obj
end

--=====================--
--- Signals Callbacks ---
--=====================--

lstg.Signals:register("frame", "GameUI:frame", function()
    if CurrentGameUI then
        CurrentGameUI:frame()
    end
end, 900)
lstg.Signals:register("render", "GameUI:render", function()
    if CurrentGameUI then
        CurrentGameUI:render()
    end
end, 900)

---@param scene Scene
lstg.Signals:register("scene:start", "GameUI.create", function(scene)
    if not scene.is_menu then
        GameUI.create()
    end
end)

---@param scene Scene
lstg.Signals:register("scene:end", "GameUI:del", function(scene)
    if CurrentGameUI and not scene.is_menu then
        CurrentGameUI:del()
    end
end)

return M