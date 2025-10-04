Include("util/tween/tween.lua")

TweenManager = {
    ---@type lstg.Tween[]
    list = {}
}

---@param tween lstg.Tween
function TweenManager:add(tween)
    table.insert(self.list, tween)
    return tween
end

function TweenManager:frame()
    for i = #self.list, 1, -1 do
        local tw = self.list[i]
        if IsValid(tw.target) then
            tw:frame()
        end
        if tw.finished or not IsValid(tw.target) then
            table.remove(self.list, i)
        end
    end
end

--- Signals Setup

lstg.Signals:register("frame", "TweenManager:frame", function()
    TweenManager:frame()
end)