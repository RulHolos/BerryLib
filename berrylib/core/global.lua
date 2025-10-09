---Global variables
lstg.var = {}

---Temporary global variables
lstg.tmpvar = {}

local old_res = GetResourceStatus()
SetResourceStatus("global")
LoadImageFromFile("white", "general/white.png", false)
SetResourceStatus(old_res)