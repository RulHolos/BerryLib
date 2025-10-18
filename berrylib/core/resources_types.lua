---@class lstg.resource
local M = {}
M.__index = M

function M:new(name, path)
    local obj = setmetatable({}, self)
    self.name, self.path = name, path
    return obj
end

---=========================--

---@class lstg.resource.image : lstg.resource
Image = setmetatable({}, { __index = M })
Image.__index = Image

function Image:new(name, path)
    local obj = M.new(self, name, path)
    return obj
end

function Image:setScale(scale)
    self.scale = scale
    SetImageScale(self.name, scale)
end

---=========================--

---@class lstg.resource.ttf : lstg.resource
TTF = setmetatable({}, { __index = M })
TTF.__index = TTF

function TTF:new(name, path)
    local obj = M.new(self, name, path)
    return obj
end

function TTF:setState()

end

function TTF:render()

end