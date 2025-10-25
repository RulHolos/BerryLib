local imgui_exists, imgui = pcall(require, "imgui")

local ImGui = imgui.ImGui
local ImVec2 = imgui.ImVec2
local ImWindowFlags = imgui.ImGuiWindowFlags
local ImStyleVar = imgui.ImGuiStyleVar

---@class lstg.debug.SceneDebugger : lstg.debug.View
local SceneDebugger = {}

function SceneDebugger:getWindowName() return "Scene Debugger" end
function SceneDebugger:getMenuGroup() return "Tools" end
function SceneDebugger:getViewId() return "view.SceneDebugger" end
function SceneDebugger:getEnabled() return self.enabled end
---@param v boolean
function SceneDebugger:setState(v) self.enabled = v end

function SceneDebugger:frame() end
function SceneDebugger:layout()
    if ImGui.BeginTabBar("SceneDebuggerTab") then
        if ImGui.BeginTabItem("Groups") then
            self:groups()
            ImGui.EndTabItem()
        end
        ImGui.EndTabBar()
    end
end

function SceneDebugger:groups()
    local i = 1
    for k, v in pairs(SceneManager.groups) do
        ImGui.PushID(i)

        if ImGui.CollapsingHeader(v.name) then
            for a, b in pairs(SceneManager.scenes) do
                
            end
        end

        ImGui.PopID()
    end
end

return SceneDebugger
