-- ================= --
-- Load Base Scripts --
-- ================= --

---@class lstg
lstg = lstg or {}

lstg.DoFile("core/_core.lua")

Include("backgrounds/bgs.lua")

Include("util/util.lua")
Include("lib/lib.lua")

---@type lstg.debug.manager
Include("debug/view.lua")

Include("se/se.lua")
Include("font/font.lua")

Include("editor.lua")

local quitFlag = false
function QuitGame()
    quitFlag = true
end

---@return boolean @True if the game is set, otherwise; false.
function GameExists()
    return Settings.Game ~= nil
end

lstg.Signals:register("frame", "gameplayFrame", function()
    ObjFrame()
    BoundCheck()
    CollisionCheck(GROUP_PLAYER, GROUP_ENEMY_BULLET)
    CollisionCheck(GROUP_PLAYER, GROUP_ENEMY)
    CollisionCheck(GROUP_PLAYER, GROUP_BOSS)
    CollisionCheck(GROUP_PLAYER, GROUP_INDES)
    CollisionCheck(GROUP_ENEMY, GROUP_PLAYER_BULLET)
    CollisionCheck(GROUP_BOSS, GROUP_PLAYER_BULLET)
    CollisionCheck(GROUP_NONTJT, GROUP_PLAYER_BULLET)
    CollisionCheck(GROUP_ITEM, GROUP_PLAYER)

    UpdateXY()
    AfterFrame()
end, -1)

lstg.Signals:register("render", "gameplayRender", function()
    ObjRender()
end, 999)

-- ======================== --
-- Engine defined functions --
-- ======================== --

function GameInit()
    InitAllClasses()

    lstg.SetResourceStatus("stage")

    if not GameExists() then
        Include("lib/menu/launcher/launcher.lua")
    else
        Include("root.lua")
    end

    lstg.plugin.DispatchEvent("afterGame")
    lstg.Signals:emit("GameInit")
end

function FrameFunc()
    lstg.SetTitle(("%s | %.2f FPS | %d OBJs"):format(Settings.Game, lstg.GetFPS(), lstg.GetnObj()))
    GetInput()

    ImGuiManager:frame()

    -- Only call this to initiate the entry_point scene.
    -- SceneManager:next() will need to be called manually each time after that.
    if SceneManager.next_scene ~= nil and SceneManager.current_scene == nil then
        SceneManager.next()
    end

    lstg.Signals:emit("frame")

    ImGuiManager:layout()

    return quitFlag
end

function GameExit()
end

function RenderFunc()
    BeginScene()

    lstg.Signals:emit("render")

    ImGuiManager:render()
    EndScene()

    if KeyIsPressed("Snapshot") then
        lstg.LocalUserData.Snapshot()
    end
end

function FocusLoseFunc()
    lstg.Signals:emit("LoseFocus")
end

function FocusGainFunc()
    lstg.Signals:emit("GainFocus")
end