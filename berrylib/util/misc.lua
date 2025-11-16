misc = {}

--- Player Death effect
function render_circle(x, y, r, point)
    local ang = 360 / (2 * point)
    for angle = 360 / point, 360, 360 / point do
        local x1, y1 = x + r * cos(angle + ang), y + r * sin(angle + ang)
        local x2, y2 = x + r * cos(angle - ang), y + r * sin(angle - ang)
        Render4V('_rev_white',
            x, y, 0.5,
            x, y, 0.5,
            x1, y1, 0.5,
            x2, y2, 0.5)
    end
end

function misc.RenderRing(img, x, y, r1, r2, rot, n, nimg)
    local da = 360 / n
    local a = rot
    for i = 1, n do
        a = rot - da * i
        Render4V(img .. ((i - 1) % nimg + 1),
            r1 * cos(a + da) + x, r1 * sin(a + da) + y, 0.5,
            r2 * cos(a + da) + x, r2 * sin(a + da) + y, 0.5,
            r2 * cos(a) + x, r2 * sin(a) + y, 0.5,
            r1 * cos(a) + x, r1 * sin(a) + y, 0.5
        )
    end
end

Death_Eff = Class(Object)
function Death_Eff:init(x, y, _type)
    self.x, self.y = x, y
    self.type = _type
    self.size, self.size1 = 0, 0
    self.layer = LAYER_TOP - 1
    Task.new(self, function()
        local size, size1 = 0, 0
        if self.type == "second" then
            Task.wait(30)
        end
        for _ = 1, 360 do
            self.size = size
            self.size1 = size1
            size = size + 12
            size1 = size1 + 8
            Task.wait(1)
        end
    end)
end
function Death_Eff:frame()
    Task.Do(self)
    if self.timer > 180 then
        Del(self)
    end
end
function Death_Eff:render()
    if self.type == "first" then
        render_circle(self.x, self.y, self.size, 60)
        render_circle(self.x + 35, self.y + 35, self.size1, 60)
        render_circle(self.x + 35, self.y - 35, self.size1, 60)
        render_circle(self.x - 35, self.y + 35, self.size1, 60)
        render_circle(self.x - 35, self.y - 35, self.size1, 60)
    elseif self.type == "second" then
        render_circle(self.x, self.y, self.size, 60)
    end
end

---------------------- Screen Shaker
local Shaker = Class(Object)
function Shaker:init(time, size)
    lstg.tmpvar._G_shaker = self
    self.time = time
    self.size = size
end
function Shaker:frame()
    local a = int(self.timer / 3) * 360 / 5 * 2
    local x = self.size * cos(a)
    local y = self.size * sin(a)
    Screen.offset.x = x
    Screen.offset.y = y

    if self.timer >= self.time then
        Del(self)
    end
end
function Shaker:del()
    Screen.offset.x = 0
    Screen.offset.y = 0
    lstg.tmpvar._G_shaker = nil
end

---@param time integer time in frame
---@param scale integer Scale of the shaking in pixels.
function misc.ShakeScreen(time, scale)
    if lstg.tmpvar._G_shaker then
        lstg.tmpvar._G_shaker.time = time
        lstg.tmpvar._G_shaker.size = scale
        lstg.tmpvar._G_shaker.timer = 0
    else
        New(Shaker, time, scale)
    end
end

----------------------

LoadTexture("particles", "ui/particles.png")
LoadImageGroup("parimg", "particles", 0, 0, 32, 32, 4, 4)

CopyImage("_rev_white", "white")
SetImageState('_rev_white', 'add+sub',
        Color(255, 255, 255, 255),
        Color(255, 255, 255, 255),
        Color(255, 0, 0, 0),
        Color(255, 0, 0, 0)
)