-- ============ --
-- Scene System --
-- ============ --

--[[
Scene system manager:

Scene types:
- Orphan scenes: Not bound to a group. They can be entry points and menu scenes (respectively main menu and/or pause menu)
- Group scenes: They're considered the actual "stages" of the game, where the players will move, the UI will appear and everything.

Scene groups only keep a reference to the name of the scene in the following format: index@group-name.
In this format, "index" is the scenes order, it goes from 1 to whatever you want.
"group-name" is usually "Easy", "Normal", ...

Flow:
1. You call SceneManager:next() to get to the next scene. SceneManager.next_scene must be defined or it will crash.
2. next_scene can be either an orphan scene or a group. If it's a group, it will initiate the group behaviour and load scenes in order.
    2.1. If you're in a scene group context, calling SceneManager:next() doesn't need next_scene to be defined.
3. Repeat as many times as you want.


To create new scenes groups, you first define a scene object, with an init, frame, render and del functions.
Then, you call SG:new(), it will automatically register scenes of this group.

The process looks like this:
```lua
last_scene_group = SceneManager:newGroup("Easy", 1, { life = 4, bombs = 3 }, false)
last_scene = SceneManager:new("1", false, false)
last_scene.init = function()
    -- Do something
end
last_scene.del = function()
    -- oh no I'm dead
end
last_scene_group:addScene(last_scene)
```

In this example, last_scene will have necessary values populated when added to last_scene_group.

!! Warning !!
Scene order is determined by which one got added first.
So, if you add the scene "2" before the scene "1", the scene "2" will play first.
The scene group doesn't sort anything and leaves full control to you, by choice.

Branching paths:
Branch paths are only supported in scene groups.

They act like IN's stage 6a and 6b, where there's two possible stages to go to after finishing stage 5.
In this scene manager, the player can chose if the developer allows them to.
Or, the developer can specify themselves what path the stage will advance to with certain conditions.

Branching scenes can be used that way:
```lua
local easy = SceneManager:newGroup("Easy", 1, { life = 4, bombs = 3 }, false)

local stage5 = SceneManager.new("5", false, false)
easy:addScene(stage5)

local stage6a = SceneManager.new("6a", false, false)
local stage6b = SceneManager.new("6b", false, false)
easy:addScene(stage6a)
easy:addScene(stage6b)

-- Add branching: Stage 5 can go to 6A or 6B
easy:addBranch("5", { "6a", "6b" })
```

And when you need to change the path:
```lua
SceneManager.current_group:setPath("6a")
SceneManager:next()
```
Will make the stage 5 advance to 6a.
--]]

---@alias SceneType "group"|"scene"

---@class Scene
local S = {
    ---@type SceneType
    type = "scene",
    name = "default",
    is_menu = false,
    init = function() end,
    frame = function() end,
    render = function() end,
    del = function() end,
    timer = 0,
}

--------------------------------------
--- Scene Group

---@class Scene.Group
local SG = {
    ---@type SceneType
    type = "group",
    ---@type string[] References to the scenes denominations
    scenes = {},

    name = "",
    diff_index = 1,
    item_init = {},
    allow_pr = false,

    current_scene_index = 1,

    ---@type table<string, string[]> -- Eg: { ["stage5"] = { "stage6a", "stage6b" } }
    branches = {},
    ---@type string|nil -- Chosen path name for current context. Will be cleared after calling :next()
    path_choice = nil
}

---Registers an already defined scene in the group.
---
---!!!ONLY KEEPS A NAME REFERENCE, NOT THE ACTUAL OBJECT!!!
---@param scene Scene
---@return Scene @The passed scene, just in case.
function SG:addScene(scene)
    local new_name = ("%s@%s"):format(scene.name, self.name)
    scene.name = new_name

    table.insert(self.scenes, new_name)

    return scene
end

---Adds a branching path for a specific scene in this group.
---
---Branching scenes can be used that way:
---
---```lua
---local easy = SceneManager:newGroup("Easy", 1, { life = 4, bombs = 3 }, false)
---
---local stage5 = SceneManager.new("5", false, false)
---easy:addScene(stage5)
---
---local stage6a = SceneManager.new("6a", false, false)
---local stage6b = SceneManager.new("6b", false, false)
---easy:addScene(stage6a)
---easy:addScene(stage6b)
---
----- Add branching: Stage 5 can go to 6A or 6B
---easy:addBranch("5", { "6a", "6b" })
---```
---
---And when you need to change the path:
---```lua
---SceneManager.current_group:setPath("6a")
---SceneManager:next()
---```
---
---Will make the stage 5 advance to 6a.
---@param from_scene string Branching scene name (without @group suffix)
---@param to_scenes string[] Array of possible paths for this scene
function SG:addBranch(from_scene, to_scenes)
    local key = ("%s@%s"):format(from_scene, self.name)
    self.branches[key] = to_scenes
end

---Sets which path to take next
---@param to_scene string Scene name (without @group suffix)
function SG:setPath(to_scene)
    self.path_choice = ("%s@%s"):format(to_scene, self.name)
end

---Gets all the available branches/paths for the current scene in a group.
---@return string[] @Possible paths from the current scene
function SG:getAvailableBranches()
    if not SceneManager.current_scene then return {} end
    local key = SceneManager.current_scene.name
    return self.branches[key] or {}
end

function SG:reset()
    self.current_scene_index = 1
end

--------------------------------------
--- Scene Manager

---@class SceneManager
local M = {
    ---@type table<string, Scene> Collection of scenes with their identifier and scene object.
    scenes = {},
    ---@type table<string, Scene.Group> Collection of scene groups with their identifier and scene group object.
    groups = {},
    ---@type Scene|nil
    current_scene = nil,
    ---@type Scene.Group|nil
    current_group = nil,
    ---@type Scene|Scene.Group Can be either a scene or a scene group.
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
        type = "scene",
        init = S.init,
        frame = S.frame,
        render = S.render,
        del = S.del,
        name = name,
        is_menu = is_menu,
        timer = 0,
    }

    M.scenes[name] = scene
    if is_entry_point then
        M.next_scene = scene
    end
    return scene
end

---@return Scene.Group @The created group. Used to add stage and stage definitions.
function M.newGroup(name, difficulty_index, item_init, allow_pr)
    local group = makeInstance(SG)
    group.name = name
    group.diff_index = difficulty_index
    group.item_init = item_init
    group.allow_pr = allow_pr

    M.groups[name] = group

    return group
end

---@param group Scene.Group?
function M.next(group)
    M.stopCurrentScene()
    M.createNextScene(group)
end

function M.stopCurrentScene()
    if M.current_scene == nil then return end

    M.current_scene:del()
    lstg.ResetPool()
    if not M.keep_resources then
        lstg.RemoveResource("stage")
    end
end

---@param group Scene.Group?
function M.createNextScene(group)
    if not M.next_scene and group == nil then
        error("Next scene is undefined. Did you forget to explicitely tell the scene manager what scene you wanted to load next?")
    end

    if M.next_scene.type == "scene" then
        local next_scene = M.next_scene
        M.next_scene = nil
---@diagnostic disable-next-line : assign-type-mismatch
        M.current_scene = next_scene
        M.current_scene.timer = 0
        M.current_scene:init()
    elseif group ~= nil then
---@diagnostic disable-next-line : assign-type-mismatch
        M.current_group = M.groups[group] -- Get the current group or one to get ctx of.

        local next_scene
        if group.path_choice then
            next_scene = group.path_choice
            group.path_choice = nil
        else
            next_scene = group.scenes[group.current_scene_index]
        end

        if next_scene ~= nil then
            local scene = M.scenes[next_scene]
            if scene == nil then return end

            M.current_scene = scene
            M.current_scene.timer = 0
            M.current_scene:init()
        end

        -- For next time it's used.
        M.current_group.current_scene_index = M.current_group.current_scene_index + 1
    else
        error("Undefined group type.")
    end
end

---@private
function M.frame()
    if M.current_scene == nil then return end

    Task.Do(M.current_scene)
    M.current_scene:frame()
    M.current_scene.timer = M.current_scene.timer + 1
end

function M.render()
    if M.current_scene == nil then return end

    SetViewMode("world")
    M.current_scene:render()
    SetViewMode("ui") -- Maybe remove this
end

--------------------------------------
--- Initialization

lstg.Signals:register("frame", "SceneManager:frame", M.frame, 999)

SceneManager = M
return M