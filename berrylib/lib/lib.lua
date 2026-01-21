lstg.plugin.LoadPlugins()
lstg.plugin.DispatchEvent("beforeLib")
--- Here you can include files from util/ and lib/

Include("lib/UI/ui.lua")
Include("lib/players/player_system.lua")
Include("lib/menu/LoadingScene.lua")
Include("lib/bullets/bullet.lua")
Include("lib/enemies/enemy_base.lua")
Include("lib/items.lua")
Include("lib/boss/boss_manager.lua")

---
lstg.plugin.DispatchEvent("afterLib")