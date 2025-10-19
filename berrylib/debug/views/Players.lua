local imgui_exists, imgui = pcall(require, "imgui")

local ImGui = imgui.ImGui
local ImVec2 = imgui.ImVec2
local ImWindowFlags = imgui.ImGuiWindowFlags
local ImStyleVar = imgui.ImGuiStyleVar

---@class lstg.debug.Players : lstg.debug.View
local Players = {}

function Players:getWindowName() return "Players Debugger" end
function Players:getMenuGroup() return "Tools" end
function Players:getViewId() return "view.Players" end
function Players:getEnabled() return self.enabled end
---@param v boolean
function Players:setState(v) self.enabled = v end

function Players:frame() end
function Players:layout()
    if ImGui.BeginTabBar("PlayersTab") then
        for _, v in ipairs(PlayersList) do
            if ImGui.BeginTabItem(v.name) then
                self:DisplayPlayer(v)
                ImGui.EndTabItem()
            end
        end
        ImGui.EndTabBar()
    end
end

---@param player lstg.Player
function Players:DisplayPlayer(player)
    ImGui.Text("Player Debugger for " .. player.name)

    local success, value = ImGui.InputInt("Protect Time", player.protect, 1, 15)
    if success then
        player.protect = clamp(value, 0, 10000000)
    end

    _, player.in_dialog = ImGui.Checkbox("In dialog?", player.in_dialog)

    ImGui.Separator()

    if ImGui.CollapsingHeader("Behavior Debuggers") then
        for k, v in ipairs(player.behaviors) do
            ImGui.PushID(v.name)

            ImGui.SeparatorText(v.name)
            if v.debug then
                v:debug()
            else
                ImGui.Text("No debugger for this behavior.")
            end

            ImGui.PopID()
        end
    end
end

return Players
