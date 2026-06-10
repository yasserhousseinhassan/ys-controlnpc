--[[
    ╔══════════════════════════════════════════════════════════╗
    ║              YS-CONTROLNPC | Save System                 ║
    ║          Developed by Yasser Storm Development           ║
    ╚══════════════════════════════════════════════════════════╝
    
    JSON-based persistent storage for settings.
    Settings survive resource restarts and server reboots.
]]

local json = json
local resourceName = GetCurrentResourceName()

-- ┌──────────────────────────────────────┐
-- │         SAVE / LOAD FUNCTIONS        │
-- └──────────────────────────────────────┘

--- Save settings to a JSON file
---@param state table The state object to save
function SaveSettings(state)
    if not Config.Save.enabled then return end
    if not state then return end

    local filePath = Config.Save.file
    local data = json.encode(state, { indent = true })

    if not data then
        Log('^1Failed to encode settings to JSON')
        return
    end

    SaveResourceFile(resourceName, filePath, data, -1)

    if Config.Debug then
        Log('^3Settings saved to ' .. filePath)
    end
end

--- Load settings from a JSON file
---@return table|nil The loaded state object, or nil if not found
function LoadSettings()
    if not Config.Save.enabled then return nil end

    local filePath = Config.Save.file
    local raw = LoadResourceFile(resourceName, filePath)

    if not raw or raw == '' then
        return nil
    end

    local success, data = pcall(json.decode, raw)
    if not success or type(data) ~= 'table' then
        Log('^1Failed to decode settings from ' .. filePath)
        return nil
    end

    return data
end
