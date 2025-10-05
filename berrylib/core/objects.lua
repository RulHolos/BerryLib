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
    del = function() end, -- I have to put the del callback here because lstg is stupid.
    frame = function() end,
    render = DefaultRenderFunc,
    colli = function(other) end,
    kill = function() end,
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
    result.del = base.del
    result.frame = base.frame
    result.render = base.render
    result.colli = base.colli
    result.kill = base.kill
    result.base = base

    table.insert(All_Classes, result)
    return result
end

function InitAllClasses()
    for _, v in pairs(All_Classes) do
        v[1] = v.init
        v[2] = v.del
        v[3] = v.frame
        v[4] = v.render
        v[5] = v.colli
        v[6] = v.kill
    end
end

---@generic C
---@param class_type C
---@return C
function makeInstance(class_type)
    local instance = {}
    local metatable = { __index = class_type }
    setmetatable(instance, metatable)
    return instance
end

---@generic T1, T2, T3, T4, T5, T6, T7, T8, T9, T10
---@param try function
---@param catch function?
---@param finally function?
---@return T1, T2, T3, T4, T5, T6, T7, T8, T9, T10
function TryCatch(try, catch, finally)
    assert(try ~= nil, "Try function cannot be nil.")

    local ret = {
        xpcall(try, function(err)
            return err .. "\n<=== inner traceback ===>\n" .. debug.traceback() .. "\n<=======================>"
        end)
    }

    if ret[1] == true then
        if finally then
            finally()
        end
        return unpack(ret, 2)
    else
        local cret = {}

        if catch then
            cret = {
                xpcall(catch, function(err)
                    return "error in catch block: " .. err .. "\n<=== inner traceback ===>\n" .. debug.traceback() .. "\n<=======================>"
                end, ret[2])
            }
        end

        if finally then
            finally()
        end

        if cret == nil then
            error("Unhandled error: " .. ret[2])
        else
            if cret[1] == true then
                return unpack(cret, 2)
            else
                error(cret[2])
            end
        end
    end
end