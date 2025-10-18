---@class lstg.Player.Behavior.Render : lstg.Player.Behavior
local M = {}
M.name = "Render"
M.priority = -10

function M:init()
    self.blend = ""
    self.img = ""
    ---@type string[]
    self.imgs = {}
    self.a, self.r, self.g, self.b = 255, 255, 255, 255
    self.ani_intv = 8
    self.max_left = 6
    self.max_right = 6
    self.lean = 0

    ---@type lstg.Player.Behavior.Move
---@diagnostic disable-next-line: assign-type-mismatch
    self.move = self.player:getBehavior("Move")

    assert(self.move ~= nil, "Render cannot exist without a move behavior.")
end

function M:frame()
    local dx = self.move.dx
    local target =
        dx > 0.5 and 1 or
        dx < -0.5 and -1 or
        0

    self.lean = self.lean + target
    self.lean = math.max(-self.max_left, math.min(self.lean, self.max_right))

    if target == 0 then
        if self.lean > 0 then
            self.lean = math.max(0, self.lean - 1)
        elseif self.lean < 0 then
            self.lean = math.min(0, self.lean + 1)
        end
    end

    local imgs = self.imgs
    local ani = math.floor(self.player.timer / self.ani_intv)

    local img
    if self.lean == 0 then
        img = imgs[ani % 8 + 1]
    elseif self.lean < 0 then
        img = imgs[ani % 6 + 11]
    else
        img = imgs[ani % 6 + 19]
    end

    self.img = img
end

function M:render()
    local blend = self.blend or ""
    local a, r, g, b = self.a or 255, self.r or 255, self.g or 255, self.b or 255

    if self.player.protect % 3 == 1 then
        SetImageState(self.img, blend, Color(a, 0, 0, b))
    else
        SetImageState(self.img, blend, Color(a, r, g, b))
    end
    Render(self.img, self.player.x, self.player.y, self.player.rot, self.player.scale)
end

return M