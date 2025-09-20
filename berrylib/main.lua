-- ================= --
-- Load Base Scripts --
-- ================= --

lstg.DoFile("core/resources.lua")
lstg.DoFile("core/plugin.lua")

lstg.DoFile("lib/lib.lua")

-- ======================== --
-- Engine defined functions --
-- ======================== --

function GameInit()

end

function FrameFunc()
    lstg.SetTitle(("%s | %.2f FPS | %d OBJ"):format(Settings.Game, lstg.GetFPS(), lstg.GetnObj()))

    lstg.ObjFrame()
    lstg.BoundCheck()

    lstg.UpdateXY()

    return false
end

function RenderFunc()
    lstg.BeginScene()
    
    lstg.ObjRender()

    lstg.EndScene()
end

function FocusLoseFunc()

end

function FocusGainFunc()

end