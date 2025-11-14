local easing = require("berrylib.util.easing")

---@class lstg.Player.Behavior.Support : lstg.Player.Behavior
local M = {}
M.name = "Support"
M.priority = 0

function M:init()
    -- Those two tables have positions based on the number of supports the player has and its current power value.
    -- For an example on how to use them, see the reimu player's definition of them.
    self.unfocused_positions = {}
    self.focused_positions = {}

    self.number_of_supports = 0

    self.focused = false

    ---Current positions of each supports.
    self.positions = {}

    ---Interpolation speed in range [0, 1].
    self.move_speed = 0.2

    ---@type fun(t:integer)
    self.move_function = easing.linear
    ---@type fun(t:integer)
    self.change_focus_function = easing.linear

    self.change_focus_speed = 0.08
    self._focus_change_entries = {}
    self._focus_changing = false
    self._prev_focus = nil

    self.img = "white"
    self.rot = 0
    self.scale = 1.0

    self.beginFocusChange = M.beginFocusChange
    self.updateFocusChange = M.updateFocusChange
    self.doFor = M.doFor

    ---@type lstg.Player.Behavior.Power
    ---@diagnostic disable-next-line: assign-type-mismatch
    self.power = self.player:getBehavior("Power")

    ---@type lstg.Player.Behavior.Move
    ---@diagnostic disable-next-line: assign-type-mismatch
    self.move = self.player:getBehavior("Move")
end

local function getOffset(off)
    local ox, oy = 0, 0
    if type(off) == "table" then
        ox = off[1] or off.x or 0
        oy = off[2] or off.y or 0
    else
        ox = off or 0
    end
    return ox, oy
end

local function lerp(a, b, f)
    return a + (b - a) * f
end

function M:frame()
    local level = clamp(int(self.power.current_power / 100), 0, 4)

    local new_focused = self.move.focus == 1
    if self._prev_focus == nil then
        self._prev_focus = new_focused
        self.focused = new_focused
    elseif new_focused ~= self._prev_focus then
        self:beginFocusChange(new_focused)
        self._prev_focus = new_focused
        self.focused = new_focused
    end

    if self._focus_changing then
        self:updateFocusChange()
    end

    local src_table = (self.focused and self.focused_positions) or self.unfocused_positions
    local src = src_table[level] or {}
    self.number_of_supports = #src

    if not src or #src == 0 then
        self.number_of_supports = 0
        self.positions = {}
        return
    end

    local t = self.move_speed
    local ease_t = self.move_function(t) or t

    for i = 1, #src do
        if not (self._focus_changing and self._focus_change_entries[i]) then
            local offx, offy = getOffset(src[i])
            local target_x = self.player.x + offx
            local target_y = self.player.y + offy

            if not self.positions[i] then
                self.positions[i] = { x = target_x, y = target_y }
            else
                self.positions[i].x = lerp(self.positions[i].x, target_x, ease_t)
                self.positions[i].y = lerp(self.positions[i].y, target_y, ease_t)
            end
        end
    end

    for i = #src + 1, #self.positions do
        self.positions[i] = nil
    end
end

function M:beginFocusChange(targetFocused)
    local level = clamp(int(self.power.current_power / 100), 0, 4)
    local target_src_table = (targetFocused and self.focused_positions) or self.unfocused_positions
    local target_src = target_src_table[level] or {}
    if not target_src then
        target_src = {} --Shouldn't happen but just in case
    end

    local max_n = math.max(#target_src, #self.positions, 1)
    self._focus_change_entries = {}
    for i = 1, max_n do
        local start_x, start_y
        if self.positions[i] then
            start_x = self.positions[i].x
            start_y = self.positions[i].y
        else
            local curOff = (self.focused and self.focused_positions or self.unfocused_positions)
            curOff = curOff[level] or {}
            local ox, oy = getOffset(curOff[i] or {})
            start_x = self.player.x + ox
            start_y = self.player.y + oy
            self.positions[i] = { x = start_x, y = start_y }
        end

        local offx, offy = getOffset(target_src[i] or {})
        self._focus_change_entries[i] = {
            start_x = start_x,
            start_y = start_y,
            offx = offx,
            offy = offy,
            progress = 0
        }
    end

    self._focus_changing = true
end

function M:updateFocusChange()
    local level = clamp(int(self.power.current_power / 100), 0, 4)
    local all_done = true
    for i, entry in pairs(self._focus_change_entries) do
        entry.progress = math.min(1, entry.progress + self.change_focus_speed)
        local p = entry.progress
        local eased = self.change_focus_function(p) or p

        local target_x = self.player.x + entry.offx
        local target_y = self.player.y + entry.offy

        self.positions[i] = self.positions[i] or { x = entry.start_x, y = entry.start_y }
        self.positions[i].x = lerp(entry.start_x, target_x, eased)
        self.positions[i].y = lerp(entry.start_y, target_y, eased)

        if p < 1 then
            all_done = false
        end
    end

    if all_done then
        local final_src_table = (self.focused and self.focused_positions) or self.unfocused_positions
        local final_src = final_src_table[level] or {}
        for i = 1, #final_src do
            local offx, offy = getOffset(final_src[i])
            self.positions[i] = { x = self.player.x + offx, y = self.player.y + offy }
        end
        self._focus_change_entries = {}
        self._focus_changing = false
    end
end

---@param f fun(index:integer, posX:number, posY:number)
function M:doFor(f)
    for i = 1, #self.positions do
        local p = self.positions[i]
        f(i, p.x, p.y)
    end
end

function M:render()
    if not self.img then
        return
    end

    for i = 1, #self.positions do
        local p = self.positions[i]
        if p then
            Render(self.img, p.x, p.y, self.rot, self.scale, self.scale)
        end
    end
end

function M:debug()

end

return M