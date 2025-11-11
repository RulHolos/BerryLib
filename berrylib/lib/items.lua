---@class berry.item : lstg.object
item = Class(Object)

function item:init(x, y, t, v, angle)
    x = min(max(x, -(Screen.playfield.width / 2) + 8), (Screen.playfield.width / 2) - 8)
    self.x, self.y = x, y
    angle = angle or 90
    v = v or 1.5
    SetV(self, v, angle)
    self.v = v
    self.group = GROUP_ITEM
    self.layer = LAYER_ITEMS
    self.bound = false
    self.img = t
    self.imgup = t .. "_up"
    self.attract = 0
end

function item:frame()
    local player = lstg.var.player
    if self.timer < 24 then
        self.rot = self.rot + 45
        self.hscale = (self.timer + 25) / 48
        self.vscale = self.hscale
        if self.timer == 22 then
            self.vy = min(self.v, 2)
            self.vx = 0
        end
    elseif self.attract > 0 then
        local a = Angle(self, player)
        self.vx = self.attract * cos(a) + player.dx * 0.5
        self.vy = self.attract * sin(a) + player.dy * 0.5
    elseif self.attract == 0 then
        self.vy = max(self.dy - 0.03, -1.7)
        if lstg.var.IsOnGraze then
            self.vy = max(self.vy, -0.5)
        end
    else
        self.vy = max(self.dy - 0.03, -0.05)
    end
    if self.y < -(Screen.playfield.height / 2) + Screen.playfield.boundOffset then
        Del(self)
    end
    if self.attract >= 8 then
        self.collected = true
    end
end

function item:render()
    if self.y > (Screen.playfield.height / 2) then
        if CheckRes("img", self.imgup) then
            Render(self.imgup, self.x, (Screen.playfield.height / 2) - 8)
        end
    else
        Render(self.img, self.x, self.y, self.rot, 0.28)
    end
end

---@param other lstg.object
function item:colli(other)
    if other == lstg.var.player then
        if self.class.collect then
            self.class.collect(self, other)
        end
        Kill(self)
        PlaySound("item00", 0.3, self.x / (Screen.playfield.width / 2))
    end
end

---@param x number
---@param y number
---@param dropTable table<any, integer>
function item.dropItem(x, y, dropTable)
    local count = 0
    for _, v in pairs(dropTable) do
        count = count + v
    end

    local r = sqrt(count - 1) * 5
    for k, v in pairs(dropTable) do
        for _ = 1, v do
            local r2 = sqrt(ran:Float(1, 4)) * r
            local a = ran:Float(0, 360)
            New(k, x + r2 * cos(a), y + r2 * sin(a))
        end
    end
end

-------------------- Actual items

---@class berry.item_extend : berry.item
item_extend = Class(item)
function item_extend:init(x, y)
    item.init(self, x, y, 7)
end
function item_extend:collect()
    lstg.var.lifeleft = lstg.var.lifeleft + 1
    PlaySound("extend", 0.5)
    --New(hinter, "hint.extend", 0.6, 0, 112, 15, 120)
end

---@param scene Scene
lstg.Signals:register("scene:start", "items:reset_scene", function(scene)
    if not scene.is_menu then
        lstg.var.score = 0
    end
end)