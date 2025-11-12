local config = require("lib.menu.menuConfig")

local assets = {
    bullet = require("assets.bullets"),
    player = require("assets.player"),
    misc = require("assets.misc"),
    ui = require("assets.ui"),
    items = require("assets.items"),
}

local resdesc = {}

for _, tbl in pairs(assets) do
    for _, v in ipairs(tbl.resdesc) do
        table.insert(resdesc, v)
    end
end

local resmgr = Loader.newMgr(resdesc, function(_)
    for _, tbl in pairs(assets) do
        if tbl.postLoad then
            tbl.postLoad()
        end
    end
end)

local function switch()
    if GameExists() then
        SceneManager.goToGroup("Normal")
    else
        SceneManager.setNextScene("launcher")
        SceneManager.next()
    end
    Loader.setCurrentMgr()
end

---@class Scene.LoadingScene : Scene
local M = SceneManager.new("Loading", true, true)
function M:init()
    self.showing = false

    if config.disable_loading_screen then
        switch()
        return
    end

    Loader.setCurrentMgr(resmgr)

    self.showing = true
end

function M:frame()
    if not self.showing then
        return
    end

    if not Loader.getCurrentMgr():isDone() then
        SetResourceStatus("global")
        Loader.loadFrame()
    else
        switch()
    end
end

function M:render()
    if not self.showing then
        return
    end

    SetViewMode("ui")
    -- TODO
    SetViewMode("world")
end