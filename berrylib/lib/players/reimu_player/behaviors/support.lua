local base_support = require("lib.players.base_behaviors.support")

---@class lstg.Player.Reimu.Behavior.Support : lstg.Player.Behavior
local M = {}
M.name = "Support"

function M:init()
    base_support.init(self)

    self.unfocused_positions = {
        [0] = {},
        [1] = {
            { 0, 36 },
        },
        [2] = {
            { -32, 0 },
            { 32, 0 }
        },
        [3] = {
            { -32, -8 },
            { 0, -32 },
            { 32, -8 },
        },
        [4] = {
            { -36, -12 },
            { -16, -32 },
            { 16, -32 },
            { 36, -12 },
        },
    }
    self.focused_positions = {
        [0] = {},
        [1] = {
            { 0, 24 },
        },
        [2] = {
            { -12, 24 },
            { 12, 24 }
        },
        [3] = {
            { -16, 20 },
            { 0, 28 },
            { 16, 20 },
        },
        [4] = {
            { -16, 20 },
            { -6, 28 },
            { 6, 28 },
            { 16, 20 },
        },
    }

    self.move_speed = 0.3
    self.change_focus_speed = 0.2

    LoadImage("reimu_support", "reimu_player", 64, 144, 16, 16)
    self.img = "reimu_support"
end

function M:frame()
    base_support.frame(self)

    self.rot = self.player.timer * 3
end

function M:render()
    base_support.render(self)
end

return M