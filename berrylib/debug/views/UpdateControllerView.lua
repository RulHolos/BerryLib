local imgui_exists, imgui = pcall(require, "imgui")
ImGui = imgui.ImGui

---@class lstg.debug.UpdateControllerView : lstg.debug.View
local UpdateControllerView = {}

function UpdateControllerView:getWindowName() return "Update Controller" end
function UpdateControllerView:getMenuGroup() return "Game" end
function UpdateControllerView:getViewId() return "view.UpdateControllerView" end
function UpdateControllerView:getEnabled() return self.enabled end
---@param v boolean
function UpdateControllerView:setState(v) self.enabled = v end

function UpdateControllerView:frame() end
function UpdateControllerView:layout()
    ImGui.Text("test")
end

return UpdateControllerView
