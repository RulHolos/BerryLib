---@diagnostic disable: missing-fields
-- ================================= --
-- Base Object Classes and functions --
-- ================================= --

--- Groups
GROUP_GHOST = 0
GROUP_ENEMY_BULLET = 1
GROUP_ENEMY = 2
GROUP_PLAYER_BULLET = 3
GROUP_PLAYER = 4
GROUP_INDES = 5
GROUP_ITEM = 6
GROUP_NONTJT = 7
GROUP_SPELL = 8
GROUP_BOSS = 9

--- Layers
LAYER_BG = -700
LAYER_ENEMIES = -600
LAYER_PLAYER_BULLETS = -500
LAYER_PLAYER = -400
LAYER_ITEMS = -300
LAYER_ENEMY_BULLETS = -200
LAYER_ENEMY_BULLETS_EF = -100
LAYER_TOP = 0

--- Classes

---@type lstg.object[]
All_Classes = {}
---@type string[]
Class_Names = {}

Object = {
    0, 0, 0, 0, 0, 0;
    is_class = true,
    init = function() end,
    frame = function() end,
    render = DefaultRenderFunc,
    colli = function(other) end,
    kill = function() end,
    del = function() end,
}
table.insert(All_Classes, Object)

---Define new class type.
---@param base lstg.object
---@return lstg.object
function Class(base)
    assert(base, "Cannot create an object from an empty class.")

    if type(base) ~= "table" or not base.is_class then
        error("Base class invalid.")
    end

    ---@type lstg.object
    local result = { 0, 0, 0, 0, 0, 0 }
    result.is_class = true
    result.init = base.init
    result.frame = base.frame
    result.render = base.render
    result.colli = base.colli
    result.kill = base.kill
    result.del = base.del
    result.base = base

    table.insert(All_Classes, result)
    return result
end

function InitAllClasses()
    for _, v in pairs(All_Classes) do
        v[1] = v.init
        v[2] = v.frame
        v[3] = v.render
        v[4] = v.colli
        v[5] = v.kill
        v[6] = v.del
    end
end