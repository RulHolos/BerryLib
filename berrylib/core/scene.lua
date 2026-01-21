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
last_scene = last_scene_group:newScene("1")
last_scene.init = function()
    -- Do something
end
last_scene.del = function()
    -- oh no I'm dead
end
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

local stage5 = easy:newScene("5")
easy:addScene(stage5)

local stage6a = easy:newScene("6a")
local stage6b = easy:newScene("6b")

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

Include("lib/menu/manager.lua")

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
    ---@type Menu.Manager?
    menu_manager = nil,
    ---@type Background
    bg = BG_Temple
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

---@param name string
---@param bg Background? background object of this stage.
---@return Scene
function SG:newScene(name, bg)
    ---@type Scene
    local scene = {
        type = "scene",
        init = S.init,
        frame = S.frame,
        render = S.render,
        del = S.del,
        name = name,
        is_menu = false,
        timer = 0,
        menu_manager = nil,
        bg = bg or BG_Temple,
    }

    scene = self:addScene(scene)
    SceneManager.scenes[scene.name] = scene
    return scene
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
    next_scene = nil,
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
        menu_manager = nil,
    }

    if is_menu then
        scene.menu_manager = MenuManager.create()
    end

    M.scenes[name] = scene
    if is_entry_point then
        M.next_scene = scene
    end
    return scene
end

---@param name string Name of the group.
---@param difficulty_index integer Difficulty index of this group. Used for score calculation.
---@param is_entry_point boolean
---@param item_init table?
---@param allow_pr boolean?
---@return Scene.Group @The created group. Used to add stage and stage definitions.
function M.newGroup(name, difficulty_index, is_entry_point, item_init, allow_pr)
    local group = makeInstance(SG)
    group.name = name
    group.diff_index = difficulty_index
    group.item_init = item_init or {}
    group.allow_pr = allow_pr or true

    M.groups[name] = group
    if is_entry_point then
        M.next_scene = group
    end

    return group
end

---@param name string Name of the group to go to.
function M.goToGroup(name)
    local group = M.groups[name]
    if not group then
        error(("Scene group '%s' doesn't exist."):format(name))
    end

    print(("Going to scene \"%s\""):format(name))

    M.next_scene = group
    M.next()
end

function M.next()
    M.stopCurrentScene()
    M.createNextScene()
end

---@param name string The name of the next scene to load.
function M.setNextScene(name)
    for _, v in pairs(M.scenes) do
        if v.name == name then
            M.next_scene = M.scenes[name]
            break
        end
    end
end

function M.stopCurrentScene()
    local destroying_scene = M.current_scene
    if M.current_scene == nil then return end

    M.current_scene:del()
    lstg.ResetPool()
    if not M.keep_resources then
        lstg.RemoveResource("stage")
    end

    lstg.Signals:emit("scene:end", M.current_scene)

    return destroying_scene
end

---@param scene Scene
function M.setupStageScene(scene)
    if M.current_scene.bg then
        New(M.current_scene.bg)
    end
    -- TODO: Player choosing system
    --if PlayerSystem.chosen_player then
    --    New(PlayerSystem.chosen_player)
    --end
    New(ReimuPlayer)
end

function M.createNextScene()
    local got_loaded = false
    lstg.SetResourceStatus("stage")

    if not M.next_scene then
        error("Next scene is undefined. Did you forget to explicitely tell the scene manager what scene or scene group you wanted to load next?")
    end

    if M.next_scene.type == "scene" then
        local next_scene = M.next_scene
        M.next_scene = nil
---@diagnostic disable-next-line : assign-type-mismatch
        M.current_scene = next_scene
        M.current_scene.timer = 0
        M.current_scene:init()
        if not M.current_scene.is_menu then
            M.setupStageScene(M.current_scene)
        end
        got_loaded = true
    elseif M.next_scene.type == "group" then -- M.next_scene is the same object during the entire lifetime of the group.
---@diagnostic disable-next-line : assign-type-mismatch
        M.current_group = M.groups[M.next_scene.name] -- Get the current group or one to get ctx of.

        local next_scene
        if M.current_group.path_choice ~= nil then
            next_scene = M.current_group.path_choice
            M.current_group.path_choice = nil
        else
            next_scene = M.current_group.scenes[M.current_group.current_scene_index]
        end

        if next_scene ~= nil then
            ---@type Scene
            local scene = M.scenes[next_scene]
            if scene == nil then return end

            M.current_scene = scene
            M.current_scene.timer = 0
            M.current_scene:init()
            if not M.current_scene.is_menu then
                M.setupStageScene(M.current_scene)
            end

            -- For next time it's used.
            M.current_group.current_scene_index = M.current_group.current_scene_index + 1
            got_loaded = true
        else
            error("There is no next scene in the current group. Did you forget to set a new scene or group to switch to?")
        end
    else
        error("Undefined group type.")
    end

    if got_loaded then
        lstg.Signals:emit("scene:start", M.current_scene)
    end
end

---@private
function M.frame()
    if M.current_scene == nil then return end

    Task.Do(M.current_scene)
    M.current_scene:frame()
    M.current_scene.timer = M.current_scene.timer + 1

    if M.current_scene.is_menu then
        M.current_scene.menu_manager:frame()
    end
end

---@private
function M.render()
    if M.current_scene == nil then return end

    SetViewMode("world")
    M.current_scene:render()

    if M.current_scene.is_menu then
        SetViewMode("ui")
        M.current_scene.menu_manager:render()
    end
end

---TODO:
---
---This function adds a scene on top of the current one as a temporary scene.
---It is used as a way to add a menu over the screen (only used by the pause screen in base BerryLib.)
function M.addStack()

end

--------------------------------------
--- Initialization

lstg.Signals:register("GameInit", "SceneManager:init", function()
    if SceneManager.next_scene == nil then
        error("No entry point scene defined.")
    end
end)
lstg.Signals:register("frame", "SceneManager:frame", M.frame, 999)
lstg.Signals:register("render", "SceneManager:render", M.render, 999)

SceneManager = M
return M