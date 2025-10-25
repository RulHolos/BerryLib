local main = require("lib.menu.launcher.main")

local launcher = SceneManager.new("launcher", false, true)
function launcher:init()
    self.menu_manager:addView("main", MenuView.create(main), true)
end