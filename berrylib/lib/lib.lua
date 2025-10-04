lstg.plugin.LoadPlugins()
lstg.plugin.DispatchEvent("beforeLib")
--- Here you can include files from util/ and lib/

Include("util/util.lua")

---
lstg.plugin.DispatchEvent("afterLib")