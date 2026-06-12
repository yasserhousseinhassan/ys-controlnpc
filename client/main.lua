--[[
    ╔══════════════════════════════════════════════════════════╗
    ║              YS-CONTROLNPC | Client Main                 ║
    ║          Developed by Yasser Storm Development           ║
    ╚══════════════════════════════════════════════════════════╝
    
    Core client-side logic: state management, keybind, commands,
    and synchronization with server-saved settings.
]]

-- ┌──────────────────────────────────────┐
-- │          LOCAL STATE                  │
-- └──────────────────────────────────────┘

YS = {}

YS.State = {
    pedDensity = Config.Defaults.pedDensity,
    vehicleDensity = Config.Defaults.vehicleDensity,
    parkedVehicleDensity = Config.Defaults.parkedVehicleDensity,
    scenariosEnabled = Config.Defaults.scenariosEnabled,
    randomEventsEnabled = Config.Defaults.randomEventsEnabled,
    distantLights = Config.Defaults.distantLights,
    scenarioOverrides = {},   -- Per-category overrides: { [categoryKey] = bool }
    activePreset = nil,
}

YS.Stats = {
    pedCount = 0,
    vehicleCount = 0,
    lastUpdate = 0,
}

local hasPermission = false
local isReady = false

-- ┌──────────────────────────────────────┐
-- │          UTILITY FUNCTIONS           │
-- └──────────────────────────────────────┘

function YS.Log(msg)
    if Config.Logs.enabled then
        print(Config.Logs.prefix .. ' ' .. msg)
    end
end

function YS.Debug(msg)
    if Config.Debug then
        print('^3[YS-DEBUG]^0 ' .. msg)
    end
end

function YS.Notify(msg, type)
    lib.notify({
        title = Config.UI.title,
        description = msg,
        type = type or 'info',
        position = 'top-right',
        duration = 3000,
    })
end

--- Count entities of a given type near the player
---@param entityType number 1=Ped, 2=Vehicle, 3=Object
---@return number
function YS.CountNearbyEntities(entityType)
    local coords = GetEntityCoords(PlayerPedId())
    local handle, entity = FindFirstPed()
    if entityType == 2 then
        handle, entity = FindFirstVehicle()
    end

    local count = 0
    local found = true
    while found do
        if DoesEntityExist(entity) then
            if entityType == 1 and not IsPedAPlayer(entity) then
                count = count + 1
            elseif entityType == 2 then
                count = count + 1
            end
        end
        if entityType == 1 then
            found, entity = FindNextPed(handle)
        else
            found, entity = FindNextVehicle(handle)
        end
    end
    if entityType == 1 then
        EndFindPed(handle)
    else
        EndFindVehicle(handle)
    end
    return count
end

--- Apply a preset profile to the current state
---@param presetKey string
function YS.ApplyPreset(presetKey)
    local preset = Config.Presets[presetKey]
    if not preset then return end

    YS.State.pedDensity = preset.pedDensity
    YS.State.vehicleDensity = preset.vehicleDensity
    YS.State.parkedVehicleDensity = preset.parkedVehicleDensity
    YS.State.scenariosEnabled = preset.scenariosEnabled
    YS.State.randomEventsEnabled = preset.randomEventsEnabled
    YS.State.activePreset = presetKey

    -- Reset per-category overrides to follow master toggle
    YS.State.scenarioOverrides = {}

    ApplyScenarioStates()
    SyncToServer()

    YS.Notify(preset.label .. ' activated', 'success')
    YS.Log(preset.label .. ' loaded')
end

--- Synchronize current state to the server for persistence
function SyncToServer()
    TriggerServerEvent('ys-controlnpc:server:saveState', YS.State)
end

--- Applies the current scenario enabled/disabled states using natives
function ApplyScenarioStates()
    for categoryKey, category in pairs(Config.Scenarios) do
        local enabled = YS.State.scenariosEnabled
        -- Per-category override takes priority
        if YS.State.scenarioOverrides[categoryKey] ~= nil then
            enabled = YS.State.scenarioOverrides[categoryKey]
        end
        for _, scenario in ipairs(category.scenarios) do
            SetScenarioTypeEnabled(scenario, enabled)
        end
    end
end

-- ┌──────────────────────────────────────┐
-- │       INITIALIZATION                 │
-- └──────────────────────────────────────┘

CreateThread(function()
    -- Request saved state from server
    TriggerServerEvent('ys-controlnpc:server:requestState')
    
    -- Wait for server response
    local timeout = 5000
    local waited = 0
    while not isReady and waited < timeout do
        Wait(100)
        waited = waited + 100
    end

    if not isReady then
        YS.Debug('No saved state received, using defaults')
        isReady = true
    end

    ApplyScenarioStates()
    YS.Log('Resource initialized successfully')
end)

-- ┌──────────────────────────────────────┐
-- │       SERVER CALLBACKS               │
-- └──────────────────────────────────────┘

RegisterNetEvent('ys-controlnpc:client:receiveState', function(savedState)
    if savedState then
        local oldPedDensity = YS.State.pedDensity
        local oldVehDensity = YS.State.vehicleDensity

        YS.State.pedDensity = savedState.pedDensity or Config.Defaults.pedDensity
        YS.State.vehicleDensity = savedState.vehicleDensity or Config.Defaults.vehicleDensity
        YS.State.parkedVehicleDensity = savedState.parkedVehicleDensity or Config.Defaults.parkedVehicleDensity
        YS.State.scenariosEnabled = savedState.scenariosEnabled
        YS.State.randomEventsEnabled = savedState.randomEventsEnabled
        YS.State.distantLights = savedState.distantLights
        YS.State.scenarioOverrides = savedState.scenarioOverrides or {}
        YS.State.activePreset = savedState.activePreset
        if YS.State.scenariosEnabled == nil then YS.State.scenariosEnabled = Config.Defaults.scenariosEnabled end
        if YS.State.randomEventsEnabled == nil then YS.State.randomEventsEnabled = Config.Defaults.randomEventsEnabled end
        if YS.State.distantLights == nil then YS.State.distantLights = Config.Defaults.distantLights end
        YS.Debug('State loaded from server')

        -- Apply scenario states dynamically
        ApplyScenarioStates()

        -- Clear existing entities immediately if density is reduced or set to 0
        local ped = PlayerPedId()
        if ped and ped > 0 then
            local coords = GetEntityCoords(ped)
            if YS.State.pedDensity < oldPedDensity or YS.State.pedDensity == 0.0 then
                ClearAreaOfPeds(coords.x, coords.y, coords.z, 250.0, 1)
            end
            if YS.State.vehicleDensity < oldVehDensity or YS.State.vehicleDensity == 0.0 then
                ClearAreaOfVehicles(coords.x, coords.y, coords.z, 250.0, false, false, false, false, false)
            end
        end
    end
    isReady = true
end)

RegisterNetEvent('ys-controlnpc:client:permissionResult', function(result)
    hasPermission = result
end)

-- ┌──────────────────────────────────────┐
-- │       COMMANDS & KEYBIND             │
-- └──────────────────────────────────────┘

local function openMenuHandler()
    if not Config.Permission.restrict then
        OpenMainMenu()
        return
    end

    -- Ask server to verify ACE permission
    local cb = lib.callback.await('ys-controlnpc:server:checkPermission', false)
    if cb then
        hasPermission = true
        OpenMainMenu()
    else
        hasPermission = false
        YS.Notify('Access denied — Missing permission', 'error')
    end
end

RegisterCommand(Config.CommandMenu, function()
    openMenuHandler()
end, false)





-- ┌──────────────────────────────────────┐
-- │       STATS UPDATE THREAD            │
-- └──────────────────────────────────────┘

if Config.Modules.stats then
    CreateThread(function()
        while true do
            YS.Stats.pedCount = YS.CountNearbyEntities(1)
            YS.Stats.vehicleCount = YS.CountNearbyEntities(2)
            YS.Stats.lastUpdate = GetGameTimer()
            Wait(1000)
        end
    end)
end
