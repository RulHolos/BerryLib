---@class lstg.LocalUserData
local M = {}
lstg.LocalUserData = M

local dir_root        = "score"
local dir_screenshots = dir_root .. "/screenshots"
local dir_replays     = dir_root .. "/replays"
local dir_db          = dir_root .. "/db"

function M.CreateDirectories()
    lstg.FileManager.CreateDirectory(dir_root)
    lstg.FileManager.CreateDirectory(dir_screenshots)
    lstg.FileManager.CreateDirectory(dir_replays)
    lstg.FileManager.CreateDirectory(dir_db)
end

---@return string
function M.GetRootDirectory()
    return dir_root
end

---@return string
function M.GetSnapshotDirectory()
    return dir_screenshots
end

---@return string
function M.GetReplayDirectory()
    return dir_replays
end

---@return string
function M.GetDatabaseDirectory()
    return dir_db
end

---@return string
function M.GetNamedDatabaseDirectory()
    return M.GetDatabaseDirectory() .. "/" .. Settings.Game
end

function M.Snapshot()
    local file_name = string.format("%s/%s.jpg", dir_screenshots, os.date("%Y-%m-%d_%H-%M-%S"))
    lstg.Snapshot(file_name)
end

M.CreateDirectories()
