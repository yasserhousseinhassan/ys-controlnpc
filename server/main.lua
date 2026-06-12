--[[
    ╔══════════════════════════════════════════════════════════╗
    ║              YS-CONTROLNPC | Server Main                 ║
    ║          Developed by Yasser Storm Development           ║
    ╚══════════════════════════════════════════════════════════╝
    
    Server-side core: handles state sync, logging, and
    distributes saved settings to connecting clients.
]]

local currentState = nil

-- ┌──────────────────────────────────────┐
-- │          INITIALIZATION              │
-- └──────────────────────────────────────┘

CreateThread(function()
    Wait(500)

    -- Load saved state from file
    currentState = LoadSettings()

    if currentState then
        Log('Saved settings loaded successfully')
    else
        Log('No saved settings found — using defaults')
        currentState = {
            pedDensity = Config.Defaults.pedDensity,
            vehicleDensity = Config.Defaults.vehicleDensity,
            parkedVehicleDensity = Config.Defaults.parkedVehicleDensity,
            scenariosEnabled = Config.Defaults.scenariosEnabled,
            randomEventsEnabled = Config.Defaults.randomEventsEnabled,
            distantLights = Config.Defaults.distantLights,
            scenarioOverrides = {},
            activePreset = nil,
        }
    end

    Log('Resource started — ' .. Config.UI.brand)
end)

-- ┌──────────────────────────────────────┐
-- │         UTILITY FUNCTIONS            │
-- └──────────────────────────────────────┘

function Log(msg)
    if Config.Logs.enabled then
        print('^6' .. Config.Logs.prefix .. '^0 ' .. msg)
    end
end

function LogAction(source, action)
    if not Config.Logs.logActions then return end

    local playerName = 'Console'
    if source and source > 0 then
        playerName = GetPlayerName(source) or ('Player ' .. source)
    end
    Log(action .. ' by ' .. playerName)
end

-- ┌──────────────────────────────────────┐
-- │         STATE MANAGEMENT             │
-- └──────────────────────────────────────┘

--- Client requests their saved state on join
RegisterNetEvent('ys-controlnpc:server:requestState', function()
    local src = source
    TriggerClientEvent('ys-controlnpc:client:receiveState', src, currentState)
end)

--- Client pushes a state update
RegisterNetEvent('ys-controlnpc:server:saveState', function(state)
    local src = source

    -- Validate permission
    if not HasPermission(src) then
        Log('^1Unauthorized state change attempt by ' .. (GetPlayerName(src) or src))
        return
    end

    -- Validate state structure
    if type(state) ~= 'table' then return end
    if type(state.pedDensity) ~= 'number' then return end
    if type(state.vehicleDensity) ~= 'number' then return end

    -- Clamp values
    state.pedDensity = math.max(0.0, math.min(1.0, state.pedDensity))
    state.vehicleDensity = math.max(0.0, math.min(1.0, state.vehicleDensity))
    state.parkedVehicleDensity = math.max(0.0, math.min(1.0, state.parkedVehicleDensity or state.vehicleDensity))

    -- Update server state
    currentState = state

    -- Log the change
    local playerName = GetPlayerName(src) or ('Player ' .. src)
    if Config.Logs.logDensity then
        Log('State updated — NPC: ' .. math.floor(state.pedDensity * 100) .. '% | Traffic: ' .. math.floor(state.vehicleDensity * 100) .. '% — by ' .. playerName)
    end

    -- Save to file
    if Config.Save.enabled then
        SaveSettings(currentState)
    end

    -- Broadcast updated state to all clients in real-time
    TriggerClientEvent('ys-controlnpc:client:receiveState', -1, currentState)
end)

-- ┌──────────────────────────────────────┐
-- │       PERMISSION CALLBACK            │
-- └──────────────────────────────────────┘

lib.callback.register('ys-controlnpc:server:checkPermission', function(source)
    return HasPermission(source)
end)

-- ┌──────────────────────────────────────┐
-- │       AUTO-SAVE INTERVAL             │
-- └──────────────────────────────────────┘

if Config.Save.enabled and Config.Save.interval > 0 then
    CreateThread(function()
        while true do
            Wait(Config.Save.interval * 1000)
            if currentState then
                SaveSettings(currentState)
            end
        end
    end)
end

-- ┌──────────────────────────────────────┐
-- │       RESOURCE STOP HANDLER          │
-- └──────────────────────────────────────┘

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    if currentState and Config.Save.enabled then
        SaveSettings(currentState)
        Log('Settings saved on resource stop')
    end
end)
