lstg.plugin.LoadPlugins()
lstg.plugin.DispatchEvent("beforeLib")
--- Here you can include files from util/ and lib/

Include("util/util.lua")
Include("lib/UI/ui.lua")
Include("lib/players/player_system.lua")
Include("lib/menu/loadingScene.lua")

---
lstg.plugin.DispatchEvent("afterLib")