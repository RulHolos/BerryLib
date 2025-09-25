-- ================= --
-- Load Base Scripts --
-- ================= --

lstg.DoFile("core/objects.lua")
lstg.DoFile("core/resources.lua")
lstg.DoFile("core/plugin.lua")
lstg.DoFile("core/graphics.lua")
lstg.DoFile("core/log.lua")
lstg.DoFile("core/input.lua")
lstg.DoFile("core/scene.lua")

lstg.DoFile("lib/lib.lua")

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

    if SceneManager.next_scene == nil then
        error("No entry point scene defined.")
    end
    lstg.SetResourceStatus("stage")
end

function FrameFunc()
    lstg.SetTitle(("%s | %.2f FPS | %d OBJ"):format(Settings.Game, lstg.GetFPS(), lstg.GetnObj()))
    GetInput()

    if SceneManager.next_scene ~= nil then
        SceneManager.next()
    end
    SceneManager.frame()

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

    Signals:emit("frame")

    return quitFlag
end

function RenderFunc()
    lstg.BeginScene()

    SceneManager.current_scene:render()
    lstg.ObjRender()

    lstg.EndScene()
end

function FocusLoseFunc()

end

function FocusGainFunc()

end