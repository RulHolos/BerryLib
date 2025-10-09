local imgui_exists, imgui = pcall(require, "imgui")

local ImGui = imgui.ImGui
local ImVec2 = imgui.ImVec2
local ImWindowFlags = imgui.ImGuiWindowFlags
local ImStyleVar = imgui.ImGuiStyleVar

---@class lstg.debug.Event_Viewer : lstg.debug.View
local Event_Viewer = {}

function Event_Viewer:getWindowName() return "Event Viewer" end
function Event_Viewer:getMenuGroup() return "Tools" end
function Event_Viewer:getViewId() return "view.Event_Viewer" end
function Event_Viewer:getEnabled() return self.enabled end
---@param v boolean
function Event_Viewer:setState(v) self.enabled = v end

function Event_Viewer:frame() end
function Event_Viewer:layout()
    if ImGui.BeginTabBar("EventViewerTabBar") then
        if ImGui.BeginTabItem("Dynamic Signals") then
            self:layoutDynamicSignals()
            ImGui.EndTabItem()
        end
        if ImGui.BeginTabItem("Static Signals") then
            self:layoutStaticSignals()
            ImGui.EndTabItem()
        end
        ImGui.EndTabBar()
    end
end

function Event_Viewer:layoutDynamicSignals()
    ImGui.Text('Registered Dynamic Signals:')

    ImGui.BeginChild('ScrollRegion', ImVec2(0, -ImGui.GetFrameHeightWithSpacing()), 0, ImWindowFlags.HorizontalScrollbar)
    do
        ImGui.PushStyleVar(ImStyleVar.ItemSpacing, ImVec2(4, 1))
        for k, v in pairs(lstg.Signals.entries) do
            if ImGui.TreeNode(k) then
                for i, entry in ipairs(v) do
                    ImGui.Text(("%d. %s (priority: %d%s)"):format(i, entry.id or "<no id>", entry.priority or 0, entry.once and ", once" or ""))
                end
                ImGui.TreePop()
            end
        end
        ImGui.PopStyleVar()
    end
    ImGui.EndChild()
end

function Event_Viewer:layoutStaticSignals()
    ImGui.Text('Registered Static Signals:')

    ImGui.BeginChild('ScrollRegionStatic', ImVec2(0, -ImGui.GetFrameHeightWithSpacing()), 0, ImWindowFlags.HorizontalScrollbar)
    do
        ImGui.PushStyleVar(ImStyleVar.ItemSpacing, ImVec2(4, 1))
        for k, v in pairs(lstg.Signals.static) do
            ImGui.Text(("%s: %s"):format(k, tostring(v)))
        end
        ImGui.PopStyleVar()
    end
    ImGui.EndChild()
end

return Event_Viewer
