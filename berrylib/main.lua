-- ================= --
-- Load Base Scripts --
-- ================= --

---@class lstg
lstg = lstg or {}

lstg.DoFile("core/math.lua")
lstg.DoFile("core/random.lua")
lstg.DoFile("core/log.lua")
lstg.DoFile("core/signals.lua")
lstg.DoFile("core/objects.lua")
lstg.DoFile("core/resources.lua")
lstg.DoFile("core/plugin.lua")
lstg.DoFile("core/graphics.lua")
lstg.DoFile("core/input.lua")
lstg.DoFile("core/scene.lua")
lstg.DoFile("core/global.lua")

lstg.DoFile("lib/lib.lua")
---@type lstg.debug.manager
Include("debug/view.lua")

local quitFlag = false
function QuitGame()
    quitFlag = true
end

-- ======================== --
-- Engine defined functions --
-- ======================== --

function GameInit()
    Include("root.lua")
    lstg.plugin.DispatchEvent("afterGame")

    InitAllClasses()

    lstg.SetResourceStatus("global")
end

function FrameFunc()
    ImGuiManager:frame()
    lstg.SetTitle(("%s | %.2f FPS | %d OBJs"):format(Settings.Game, lstg.GetFPS(), lstg.GetnObj()))
    GetInput()

    -- Only call this to initiate the entry_point scene.
    -- SceneManager:next() will need to be called manually each time after that.
    if SceneManager.next_scene ~= nil and SceneManager.current_scene == nil then
        SceneManager.next()
    end

    lstg.Signals:emit("frame")

    lstg.ObjFrame()
    lstg.BoundCheck()
    CollisionCheck(GROUP_PLAYER, GROUP_ENEMY_BULLET)
    CollisionCheck(GROUP_PLAYER, GROUP_ENEMY)
    CollisionCheck(GROUP_PLAYER, GROUP_BOSS)
    CollisionCheck(GROUP_PLAYER, GROUP_INDES)
    CollisionCheck(GROUP_ENEMY, GROUP_PLAYER_BULLET)
    CollisionCheck(GROUP_BOSS, GROUP_PLAYER_BULLET)
    CollisionCheck(GROUP_NONTJT, GROUP_PLAYER_BULLET)
    CollisionCheck(GROUP_ITEM, GROUP_PLAYER)
    lstg.UpdateXY()

    ImGuiManager:layout()

    return quitFlag
end

function RenderFunc()
    lstg.BeginScene()

    lstg.Signals:emit("render")

    if SceneManager.current_scene then
       SceneManager.current_scene:render()
    end
    lstg.ObjRender()

    ImGuiManager:render()
    lstg.EndScene()
end

function FocusLoseFunc()
    lstg.Signals:emit("LoseFocus")
end

function FocusGainFunc()
    lstg.Signals:emit("GainFocus")
end