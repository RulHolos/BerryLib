local imgui_exists, imgui = pcall(require, "imgui")

local groupMap = {
    [0] = "GROUP_GHOST",
    [1] = "GROUP_ENEMY_BULLET",
    [2] = "GROUP_ENEMY",
    [3] = "GROUP_PLAYER_BULLET",
    [4] = "GROUP_PLAYER",
    [5] = "GROUP_INDES",
    [6] = "GROUP_ITEM",
    [7] = "GROUP_NONTJT",
    [8] = "GROUP_SPELL",
    [9] = "GROUP_BOSS"
}

local ImGui = imgui.ImGui
local ImVec2 = imgui.ImVec2
local ImWindowFlags = imgui.ImGuiWindowFlags
local ImStyleVar = imgui.ImGuiStyleVar

---@class lstg.debug.ObjectInspector : lstg.debug.View
local ObjectInspector = {}

function ObjectInspector:getWindowName() return "Object Inspector" end
function ObjectInspector:getMenuGroup() return "Tools" end
function ObjectInspector:getViewId() return "view.ObjectInspector" end
function ObjectInspector:getEnabled() return self.enabled end
---@param v boolean
function ObjectInspector:setState(v) self.enabled = v end

function ObjectInspector:frame() end
function ObjectInspector:layout()
    for i = GROUP_GHOST, GROUP_BOSS do
        if ImGui.CollapsingHeader(groupMap[i]) then
            for k, v in ObjList(i) do
                ImGui.PushID("Group " .. i .. "obj " .. k)

                ImGui.Indent()
                self:objectInspector(k, v)
                ImGui.Unindent()
                ImGui.PopID()
            end
        end
    end
end

---@param id any
---@param obj lstg.object
function ObjectInspector:objectInspector(id, obj)
    local i = 0
    if ImGui.CollapsingHeader(id) then
        ImGui.Indent()
        i = self:displayTable(obj, nil, obj, i)
        ImGui.Unindent()
    end
end

---There's a lot of random code here, but trust.
function ObjectInspector:displayTable(obj, key, value, i)
    for k, v in pairs(value) do
        ImGui.PushID(i)

        if type(v) == "boolean" then
            self:editBool(obj, k, v)
        elseif type(v) == "number" and k ~= "2" then
            self:editNumber(obj, k, v)
        elseif type(v) == "function" then
            self:triggerFunction(obj, k, v)
        elseif type(v) == "table" then
            if k ~= "base" and k ~= "1" then
                if ImGui.TreeNode(k) then
                    i = self:displayTable(obj, k, v, i)
                    ImGui.TreePop()
                end
            end
        end

        ImGui.PopID()

        i = i + 1
    end

    return i
end

function ObjectInspector:editBool(obj, k, v)
    _, obj[k] = ImGui.Checkbox(k, obj[k])
end

function ObjectInspector:editNumber(obj, k, v)
    success, value = ImGui.InputFloat(k, obj[k] or 0, 0.1, 1)
    if success then
        obj[k] = value
    end
end

function ObjectInspector:triggerFunction(obj, k, v)
    ImGui.Text("Function: " .. k)
    ImGui.SameLine()
    if ImGui.Button("Call") then
        obj[k](obj)
    end
end

return ObjectInspector
