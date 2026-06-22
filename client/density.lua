--[[
    ╔══════════════════════════════════════════════════════════╗
    ║              YS-CONTROLNPC | Density Controller          ║
    ║          Developed by Yasser Storm Development           ║
    ╚══════════════════════════════════════════════════════════╝
    
    Applies ped and vehicle density multipliers every frame.
    Optimized: single thread, combined natives, minimal overhead.
]]

-- ┌──────────────────────────────────────┐
-- │     DENSITY APPLICATION THREAD       │
-- └──────────────────────────────────────┘

CreateThread(function()
    while true do
        local pedDensity = YS.State.pedDensity
        local vehDensity = YS.State.vehicleDensity
        local parkedDensity = YS.State.parkedVehicleDensity

        -- Ped density natives (must be called every frame)
        SetPedDensityMultiplierThisFrame(pedDensity)
        SetScenarioPedDensityMultiplierThisFrame(pedDensity, pedDensity)
        SetAmbientPedRangeMultiplierThisFrame(pedDensity > 0.0 and 1.0 or 0.0)

        -- Vehicle density natives (must be called every frame)
        SetVehicleDensityMultiplierThisFrame(vehDensity)
        SetRandomVehicleDensityMultiplierThisFrame(vehDensity)
        SetParkedVehicleDensityMultiplierThisFrame(parkedDensity)
        SetScenarioVehicleDensityMultiplierThisFrame(vehDensity)
        SetAmbientVehicleRangeMultiplierThisFrame(vehDensity > 0.0 and 1.0 or 0.0)

        -- Random events
        SetRandomEventFlag(YS.State.randomEventsEnabled)

        -- Distant lights
        DisableVehicleDistantlights(not YS.State.distantLights)

        -- Dispatch services control
        if pedDensity == 0.0 then
            -- Disable all dispatch services and random cops when ped density is zero
            SetCreateRandomCops(false)
            SetCreateRandomCopsNotOnScenarios(false)
            SetCreateRandomCopsOnScenarios(false)
            for i = 1, 15 do
                EnableDispatchService(i, false)
            end
        end

        -- Garbage trucks
        SetGarbageTrucks(vehDensity > 0.0)

        -- Random boats / trains
        SetRandomBoats(vehDensity > 0.0)
        SetRandomTrains(vehDensity > 0.0)

        Wait(0)
    end
end)

-- Periodic cleanup of residual entities when density is set to 0.0
CreateThread(function()
    while true do
        if YS.State then
            local pedDensity = YS.State.pedDensity
            local vehDensity = YS.State.vehicleDensity

            if pedDensity == 0.0 or vehDensity == 0.0 then
                local ped = PlayerPedId()
                if ped and ped > 0 then
                    local coords = GetEntityCoords(ped)
                    if pedDensity == 0.0 then
                        ClearAreaOfPeds(coords.x, coords.y, coords.z, 1000.0, 1)
                    end
                    if vehDensity == 0.0 then
                        ClearAreaOfVehicles(coords.x, coords.y, coords.z, 1000.0, false, false, false, false, false)
                    end
                end
            end
        end
        Wait(100) -- Run 10 times a second to clear them before they become visible during fast driving
    end
end)

-- ┌──────────────────────────────────────┐
-- │   DENSITY CHANGE FUNCTIONS           │
-- └──────────────────────────────────────┘

--- Set ped density and sync to server
---@param value number 0.0 to 1.0
function SetPedDensityValue(value)
    YS.State.pedDensity = value
    YS.State.activePreset = 'custom'
    SyncToServer()

    if Config.Logs.logDensity then
        YS.Log('Ped density set to ' .. math.floor(value * 100) .. '%')
    end
end

--- Set vehicle density and sync to server
---@param value number 0.0 to 1.0
function SetVehicleDensityValue(value)
    YS.State.vehicleDensity = value
    YS.State.parkedVehicleDensity = value
    YS.State.activePreset = 'custom'
    SyncToServer()

    if Config.Logs.logDensity then
        YS.Log('Vehicle density set to ' .. math.floor(value * 100) .. '%')
    end
end

--- Set parked vehicle density separately
---@param value number 0.0 to 1.0
function SetParkedDensityValue(value)
    YS.State.parkedVehicleDensity = value
    YS.State.activePreset = 'custom'
    SyncToServer()

    if Config.Logs.logDensity then
        YS.Log('Parked vehicle density set to ' .. math.floor(value * 100) .. '%')
    end
end
