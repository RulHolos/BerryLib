---@class lstg.Player.Behavior.CollectItem : lstg.Player.Behavior
local M = {}
M.name = "CollectItem"
M.priority = 95

function M:init()

end

function M:frame()
    ---@type lstg.Player.Behavior.Death
    ---@diagnostic disable-next-line: assign-type-mismatch
    self.death = self.player:getBehavior("Death")
    if not self.death.canAct(self.death) then
        return
    end

    ---@type lstg.Player.Behavior.Move
    ---@diagnostic disable-next-line: assign-type-mismatch
    self.move = self.player:getBehavior("Move")

    if self.player.y > self.player.collect_line then
        for _, o in ObjList(GROUP_ITEM) do
            local flag = false
            if o.attract < 8 then
                flag = true
            elseif o.attract == 8 and o.target ~= self.player then
                if (not o.target) or o.target.y < self.player.y then
                    flag = true
                end
            end
            if flag then
                o.attract = 8
                o.target = self.player
            end
        end
    else
        if self.move.focus == 1 then
            for _, o in ObjList(GROUP_ITEM) do
                if Dist(self.player, o) < item.GetCollectRingRadius() then
                    if o.attract < 8 then
                        o.attract = max(o.attract, 8)
                        o.target = self.player
                    end
                end
            end
        else
            for _, o in ObjList(GROUP_ITEM) do
                if Dist(self.player, o) < 24 then
                    if o.attract < 3 then
                        o.attract = max(o.attract, 3)
                        o.target = self.player
                    end
                end
            end
        end
    end
end

function M:debug()

end

BasePlayerBehaviors[M.name] = M