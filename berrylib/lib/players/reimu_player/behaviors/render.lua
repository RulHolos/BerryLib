local base_render = require("lib.players.base_behaviors.render")

---@class lstg.Player.Reimu.Behavior.Render : lstg.Player.Behavior
local M = {}
M.name = "Render"

function M:init()
    base_render.init(self)
    ----------------
    LoadImageGroup("reimu_player", "reimu_player", 0, 0, 32, 48, 8, 3, 0.5, 0.5, false)

    ---@type string[]
    self.imgs = {}

    if self.player.index == 2 then

    else
        for i = 1, 24 do
            self.imgs[i] = "reimu_player" .. i
        end
    end
end

function M:frame()
    base_render.frame(self)
end

function M:render()
    base_render.render(self)
end

return M