local test_obj = Class(Object)
function test_obj:init(text)
    self.text = text
    LoadImageFromFile("white", "general/white.png", false)
    LoadImageFromFile("ui_bg", "ui/ui_bg.png", false)

    --lstg.MsgBoxWarn(self.text)
end
function test_obj:render()
    SetViewMode("world")
    RenderRect("white", -192, 192, -224, 224)

    SetViewMode("ui")
    Render("ui_bg", 0, 0)
end

local test_scene = SceneManager.new("test_entry", true, true)
function test_scene:init()
    New(test_obj, "YAY THAT WORKS")
end