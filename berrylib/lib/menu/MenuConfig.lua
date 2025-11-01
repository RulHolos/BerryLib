---@class Menu.Config
local M = {}

---===============================
---This is the configuration file for the menu framework of BerryLib.
---===============================

---@type boolean Debugs some flags. Should be false for your game's release versions.
M.debug_mode = true

---If set to true, the loading screen will bypass entirely.
---
---However, be careful, no resources will be loaded at this stage if you skip it.
---@type boolean
M.disable_loading_screen = false

---Dictates the number of frames to take to switch between views.
---
---Note: This time is the total for fading out and in to the new scene.
---
---This value will be half of itself for a single scene.
M.frames_for_switching = 60

return M