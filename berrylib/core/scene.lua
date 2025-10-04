-- ============ --
-- Scene System --
-- ============ --

local function make_instance(C)
    local I = {}
    setmetatable(I, { __index = C })
    return I
end

---@class Scene
local S = {
    name = "default",
    is_menu = false,
    init = function() end,
    frame = function() end,
    render = function() end,
    del = function() end,
}

---@class Scene.Group
local SG = {
    ---@type Scene[]
    scenes = {}
}

--------------------------------------
--- Scene Manager

---@class SceneManager
local M = {
    ---@type Scene[]
    scenes = {},
    current_scene = S,
    next_scene = S,
    ---If true, will transfer the resource pool.
    keep_resources = false,
}

---@param name string
---@param is_entry_point boolean If true, will be the first scene loaded.
---@param is_menu boolean
---@return Scene
function M.new(name, is_entry_point, is_menu)
    ---@type Scene
    local scene = {
        init = S.init,
        del = S.del,
        render = S.render,
        frame = S.frame,
        name = name,
        is_menu = is_menu,
    }

    M.scenes[name] = scene
    if is_entry_point then
        M.next_scene = scene
    end
    return scene
end

function M.next()
    M.stopCurrentScene()
    M.createNextScene()
end

function M.stopCurrentScene()
    M.current_scene:del()
    lstg.ResetPool()
    if not M.keep_resources then
        lstg.RemoveResource("stage")
    end
end

function M.createNextScene()
    local next_scene = M.next_scene
    M.next_scene = nil
    M.current_scene = make_instance(next_scene)
    M.current_scene.timer = 0
    M.current_scene:init()
end

function M.frame()
    Task.Do(M.current_scene)
    M.current_scene:frame()
    M.current_scene.timer = M.current_scene.timer + 1
end

--------------------------------------
--- Initialization

lstg.Signals:register("frame", "SceneManager:frame", M.frame, 100)

SceneManager = M
return M