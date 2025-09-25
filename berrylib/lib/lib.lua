lstg.plugin.LoadPlugins()
lstg.plugin.DispatchEvent("beforeLib")
--- Here you can include files from util/ and lib/

Include("util/signals.lua")
Include("util/tween/manager.lua")
Include("util/task.lua")

---
lstg.plugin.DispatchEvent("afterLib")