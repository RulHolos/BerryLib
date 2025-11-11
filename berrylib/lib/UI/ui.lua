-- ============== --
-- User Interface --
-- ============== --
--[[
This module contains the implementation for the gameplay interface (stg-frame), life display, score, etc...

The UI is implemented as a game object, which, compared to THlib, IS subject to pausing.
The UI object is created automatically when a non-menu scene is entered, and destroyed when leaving it.

Vertical UI is not supported in BerryLib by default, only horizontal UI is.

This UI framework is not fit for use with the editor and is code-only.
If you really wish to edit this UI in editor, may ZUN have mercy on you, and please reconsider your life and sanity (looking at you Ryann...)

This ui framework uses components to build the UI.
]]

---@class berry.UI
local M = {}
GameUI = M
---@type berry.UI|nil
CurrentGameUI = nil

---@type berry.UI.Component[]
local BaseUIComponents = {}

function M:init()
    self.timer = 0

    ---@type berry.UI.Component[]
    self.components = {}
    for _, v in pairs(BaseUIComponents) do
        self:attachComponent(v)
    end
end

function M:frame()
    Task.Do(self)

    for _, component in ipairs(self.components) do
        if component.frame then
            component:frame()
        end
    end

    self.timer = self.timer + 1
end

function M:render()
    SetViewMode("ui")
    for _, component in ipairs(self.components) do
        if component.render then
            component:render()
        end
    end
end

function M:kill()
    Del(self)
end

function M:del()
    for _, v in ipairs(self.components) do
        self:detachComponent(v.name)
    end

    CurrentGameUI = nil
end

---@param component berry.UI.Component
function M:attachComponent(component)
    component = makeInstance(component)
    component.ui = self
    if component.init then
        component:init()
    end
    if not component or not component.name then
        error("Component must have a name or object is invalid.")
    end
    if component.onAttach then
        component:onAttach(self)
    end

    table.insert(self.components, component)
    table.sort(self.components, function(a, b)
        return (a.priority or 0) > (b.priority or 0)
    end)
end

---@param name string name of the component
function M:detachComponent(name)
    local component = self.components[name]
    if component and component.onDetach then
        component:onDetach(self)
    end
    self.components[name] = nil
end

---@param name string name of the component
---@return berry.UI.Component
function M:getComponent(name)
    local b
    for _, v in ipairs(self.components) do
        if v.name == name then
            b = v
        end
    end
    if b == nil then
        error(("The component named %s doesn't exist"):format(name))
    end
    return b
end

function M.registerBaseComponent(component)
    BaseUIComponents[component.name] = component
end

function M.create()
    local obj = makeInstance(M)
    CurrentGameUI = obj
    obj:init()

    return obj
end

----------------------------------------------
--- Components

---@class berry.UI.Component
---@field name string
---@field enabled boolean Mostly for debugging purposes.
---@field priority integer Higher means being executed first
---@field ui berry.UI Defined when attached
---@field init fun(self: berry.UI.Component)?
---@field frame fun(self: berry.UI.Component)?
---@field render fun(self: berry.UI.Component)?
---@field onAttach fun(self: berry.UI.Component, ui: berry.UI)?
---@field onDetach fun(self: berry.UI.Component, ui: berry.UI)?
---@field debug fun(self: berry.UI.Component)? Optional callback for the Player Debugger in ImGui.

--- Include behaviors here
local patch = "lib/UI/components/"
Include(patch .. "lines.lua")
Include(patch .. "frame.lua")
Include(patch .. "score.lua")

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