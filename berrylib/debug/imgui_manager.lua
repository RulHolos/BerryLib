local imgui_exists, imgui = pcall(require, "imgui")
if not imgui_exists then
    Print("!! ImGui was invoked but doesn't exist !!")
end
ImGui = imgui.ImGui

---@param vkey number
---@return fun() : boolean
local function KeyDownTrigger(vkey)
    local last_state = false
    local state = false
    return function()
        state = lstg.GetKeyState(vkey)
        if not last_state and state then
            last_state = state
            return true
        else
            last_state = state
            return false
        end
    end
end

---@diagnostic disable-next-line: undefined-field
local Keyboard = lstg.Input.Keyboard
local F3_Trigger = KeyDownTrigger(Keyboard.F3)

---@param view lstg.debug.View
local function layoutViewMenuItem(view)
    local enabled = view:getEnabled()
    if ImGui.MenuItem(view:getWindowName(), nil, enabled) then
        enabled = not enabled
    end
    view:setState(enabled)
end

---@param view lstg.debug.View
local function layoutView(view)
    local enabled = view:getEnabled()
    if not enabled then return end

    local show = false
    show, enabled = ImGui.Begin(view:getWindowName(), enabled)
    view:setState(enabled)
    if show then
        view:layout()
    end
    ImGui.End()
end

---@class lstg.debug.manager
local M = {
    ---@type table<string, lstg.debug.View>
    view_collection = {},
    ---@type boolean
    show_menu = false,
    ---@type string[]
    view_categories = {}
}
ImGuiManager = M

---@param view lstg.debug.View
function M:addView(view)
    table.insert(self.view_collection, { view:getViewId(), view })
end

---@param view_id string Id of the view to remove.
function M:removeView(view_id)
    for i, v in ipairs(self.view_collection) do
        if v[1] == view_id then
            table.remove(self.view_collection, i)
            break
        end
    end
end

function M:initializeCategories()
    for _, v in ipairs(self.view_collection) do
        if not table.has_ivalue(self.view_categories, v[2].getMenuGroup()) then
            table.insert(self.view_categories, v[2].getMenuGroup())
        end
    end
end

function M:frame()
    if not imgui_exists then return end

    imgui.backend.NewFrame(self.show_menu)
    for _, v in ipairs(self.view_collection) do
        v[2]:frame()
    end
end

function M:layout()
    if F3_Trigger() then
        self.show_menu = not self.show_menu
    end

    if not imgui_exists then return end

    ImGui.NewFrame()
    if self.show_menu then
        if ImGui.BeginMainMenuBar() then
            for _, v in ipairs(self.view_categories) do
                if ImGui.BeginMenu(v) then
                    table.foreach_ipairs(self.view_collection,
                        function(view, i)
                            return view[2].getMenuGroup() == v
                        end,
                        function(view, i)
                            layoutViewMenuItem(view[2])
                        end)
                    ImGui.EndMenu()
                end
            end

            ImGui.EndMainMenuBar()
        end

        for _, v in ipairs(self.view_collection) do
            layoutView(v[2])
        end
    end
    ImGui.EndFrame()
end

function M:render()
    if not imgui_exists then return end

    ImGui.Render()
    imgui.backend.RenderDrawData()
end

return M