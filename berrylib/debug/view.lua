--[[

Debug view with ImGui.
This is NOT intended for editor use, and so is strictly setup to be more efficient in code than editor.
If you wish to add more views, please don't do so in the editor, you'll save time and sanity.

]]

---@type lstg.debug.manager
Include("debug/imgui_manager.lua")

---- Load all views here ----
local patch = "debug.views."

ImGuiManager:addView(require(patch .. "UpdateControllerView"))

---- View Definition ----
---@class lstg.debug.View
local V = {
    enabled = false,
}

function V:getWindowName() return "View" end
function V:getMenuGroup() return "Tool" end
function V:getViewId() return "view.default" end
function V:getEnabled() return self.enabled end
---@param enable boolean
function V:setState(enable) self.enabled = enable end
function V:frame() end
function V:layout() end

ImGuiManager:initializeCategories()