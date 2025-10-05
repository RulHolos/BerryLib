local test_obj = Class(Object)
function test_obj:init(text)
    self.text = text

    lstg.MsgBoxWarn(self.text)
end

local test_scene = SceneManager.new("test_entry", true, true)
function test_scene:init()
    New(test_obj, "YAY THAT WORKS")
end