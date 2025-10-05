--[[

Debug view with ImGui.
This is NOT intended for editor use, and so is strictly setup to be more efficient in code than editor.
If you wish to add more views, please don't do so in the editor, you'll save time and sanity.

]]

---@type lstg.debug.manager
Include("debug/imgui_manager.lua")

---- All views are automatically loaded here at startup only.               ----
---- If you wish to add more files at runtime, use `ImGuiManager:addView()` ----
local patch = "debug.views."
local path = "berrylib/debug/views/"

local patches = lstg.FileManager.EnumFiles(path, "lua");
for _, v in ipairs(patches) do
    local file = string.sub(v[1], string.len(path) + 1, string.len(v[1]) - 4)
    ImGuiManager:addView(require(patch .. file))
end

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