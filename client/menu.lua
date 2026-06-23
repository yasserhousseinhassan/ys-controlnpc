--[[
    ╔══════════════════════════════════════════════════════════╗
    ║              YS-CONTROLNPC | OX Lib Menu                 ║
    ║          Developed by Yasser Storm Development           ║
    ╚══════════════════════════════════════════════════════════╝
    
    Full OX Lib context menu interface with clean design.
    All menus use ox_lib context menus exclusively.
]]

-- ┌──────────────────────────────────────┐
-- │         HELPER FUNCTIONS             │
-- └──────────────────────────────────────┘

local function statusBadge(enabled)
    if enabled then
        return '~g~ACTIVE~s~'
    else
        return '~r~INACTIVE~s~'
    end
end

local function percentLabel(value)
    return math.floor(value * 100) .. '%'
end

local function densityOptions(current)
    local options = {}
    for i = 0, 10 do
        local val = i / 10
        local label = math.floor(val * 100) .. '%'
        if val == current then
            label = label .. ' (Current)'
        end
        options[#options + 1] = { label = label, value = val }
    end
    return options
end

-- ┌──────────────────────────────────────┐
-- │          MAIN MENU                   │
-- └──────────────────────────────────────┘

function OpenMainMenu()
    local options = {}

    -- Header / Branding
    options[#options + 1] = {
        title = Config.UI.title,
        description = Config.UI.brand .. ' — v1.0.0',
        readOnly = true,
    }

    -- Active Preset indicator
    local presetLabel = 'None'
    if YS.State.activePreset and Config.Presets[YS.State.activePreset] then
        presetLabel = Config.Presets[YS.State.activePreset].label
    elseif YS.State.activePreset == 'custom' then
        presetLabel = 'Custom'
    end
    options[#options + 1] = {
        title = 'Active Profile: ' .. presetLabel,
        description = 'NPC: ' .. percentLabel(YS.State.pedDensity) .. ' | Traffic: ' .. percentLabel(YS.State.vehicleDensity),
        readOnly = true,
    }

    -- 1. NPC Management
    if Config.Modules.peds then
        options[#options + 1] = {
            title = 'NPC Management',
            description = 'Density: ' .. percentLabel(YS.State.pedDensity) .. ' | ' .. statusBadge(YS.State.pedDensity > 0),
            menu = 'ys_peds_menu',
        }
    end

    -- 2. Traffic Management
    if Config.Modules.traffic then
        options[#options + 1] = {
            title = 'Traffic Management',
            description = 'Density: ' .. percentLabel(YS.State.vehicleDensity) .. ' | ' .. statusBadge(YS.State.vehicleDensity > 0),
            menu = 'ys_traffic_menu',
        }
    end

    -- 3. Scenario Management
    if Config.Modules.scenarios then
        options[#options + 1] = {
            title = 'Scenario Management',
            description = statusBadge(YS.State.scenariosEnabled),
            menu = 'ys_scenarios_menu',
        }
    end

    -- 4. Event Management
    if Config.Modules.events then
        options[#options + 1] = {
            title = 'Event Management',
            description = statusBadge(YS.State.randomEventsEnabled),
            menu = 'ys_events_menu',
        }
    end

    -- 5. Density Control
    if Config.Modules.density then
        options[#options + 1] = {
            title = 'Density Control',
            description = 'Fine-tune population settings',
            menu = 'ys_density_menu',
        }
    end

    -- 6. Quick Presets
    if Config.Modules.presets then
        options[#options + 1] = {
            title = 'Quick Presets',
            description = 'Predefined configuration profiles',
            menu = 'ys_presets_menu',
        }
    end

    -- 7. Live Statistics
    if Config.Modules.stats then
        options[#options + 1] = {
            title = 'Live Statistics',
            description = 'Counters and performance',
            menu = 'ys_stats_menu',
        }
    end

    -- 8. Advanced Settings
    if Config.Modules.advanced then
        options[#options + 1] = {
            title = 'Advanced Settings',
            description = 'Configuration and saving',
            menu = 'ys_advanced_menu',
        }
    end

    lib.registerContext({
        id = 'ys_main_menu',
        title = 'YS Control NPC',
        options = options,
    })

    -- Register all sub-menus
    RegisterPedsMenu()
    RegisterTrafficMenu()
    RegisterScenariosMenu()
    RegisterEventsMenu()
    RegisterDensityMenu()
    RegisterPresetsMenu()
    RegisterStatsMenu()
    RegisterAdvancedMenu()

    lib.showContext('ys_main_menu')
end

-- ┌──────────────────────────────────────┐
-- │          PEDS MENU                   │
-- └──────────────────────────────────────┘

function RegisterPedsMenu()
    local isActive = YS.State.pedDensity > 0

    lib.registerContext({
        id = 'ys_peds_menu',
        title = 'NPC Management',
        menu = 'ys_main_menu',
        options = {
            {
                title = 'Current Status',
                description = 'Density: ' .. percentLabel(YS.State.pedDensity) .. ' | Loaded NPCs: ~b~' .. YS.Stats.pedCount .. '~s~',
                readOnly = true,
            },
            {
                title = 'Enable NPCs',
                description = 'Restore default NPC population',
                onSelect = function()
                    SetPedDensityValue(Config.Defaults.pedDensity > 0 and Config.Defaults.pedDensity or 0.5)
                    YS.Notify('NPCs enabled — Density: ' .. percentLabel(YS.State.pedDensity), 'success')
                    OpenMainMenu()
                end,
            },
            {
                title = 'Disable NPCs',
                description = 'Remove all ambient NPCs',
                onSelect = function()
                    SetPedDensityValue(0.0)
                    YS.Notify('NPCs disabled', 'info')
                    OpenMainMenu()
                end,
            },
            {
                title = 'NPC Counter',
                description = 'NPCs currently loaded: ~b~' .. YS.Stats.pedCount .. '~s~',
                readOnly = true,
            },
        },
    })
end

-- ┌──────────────────────────────────────┐
-- │          TRAFFIC MENU                │
-- └──────────────────────────────────────┘

function RegisterTrafficMenu()
    local isActive = YS.State.vehicleDensity > 0

    lib.registerContext({
        id = 'ys_traffic_menu',
        title = 'Traffic Management',
        menu = 'ys_main_menu',
        options = {
            {
                title = 'Current Status',
                description = 'Density: ' .. percentLabel(YS.State.vehicleDensity) .. ' | Loaded Vehicles: ~b~' .. YS.Stats.vehicleCount .. '~s~',
                readOnly = true,
            },
            {
                title = 'Enable Traffic',
                description = 'Restore default traffic density',
                onSelect = function()
                    SetVehicleDensityValue(Config.Defaults.vehicleDensity > 0 and Config.Defaults.vehicleDensity or 0.5)
                    YS.Notify('Traffic enabled — Density: ' .. percentLabel(YS.State.vehicleDensity), 'success')
                    OpenMainMenu()
                end,
            },
            {
                title = 'Disable Traffic',
                description = 'Remove all road traffic',
                onSelect = function()
                    SetVehicleDensityValue(0.0)
                    YS.Notify('Traffic disabled', 'info')
                    OpenMainMenu()
                end,
            },
            {
                title = 'Vehicle Counter',
                description = 'Vehicles currently loaded: ~b~' .. YS.Stats.vehicleCount .. '~s~',
                readOnly = true,
            },
        },
    })
end

-- ┌──────────────────────────────────────┐
-- │          SCENARIOS MENU              │
-- └──────────────────────────────────────┘

function RegisterScenariosMenu()
    local options = {
        {
            title = 'Global Status',
            description = 'Scenarios: ' .. statusBadge(YS.State.scenariosEnabled),
            readOnly = true,
        },
        {
            title = 'Enable All Scenarios',
            description = 'Restore all GTA V scenario types',
            onSelect = function()
                ToggleAllScenarios(true)
                OpenMainMenu()
            end,
        },
        {
            title = 'Disable All Scenarios',
            description = 'Stop all GTA V scenario types',
            onSelect = function()
                ToggleAllScenarios(false)
                OpenMainMenu()
            end,
        },
    }

    -- Per-category toggles
    for categoryKey, category in pairs(Config.Scenarios) do
        local enabled = GetScenarioCategoryState(categoryKey)
        options[#options + 1] = {
            title = category.label,
            description = statusBadge(enabled) .. ' — ' .. #category.scenarios .. ' scenario(s)',
            onSelect = function()
                ToggleScenarioCategory(categoryKey, not enabled)
                OpenMainMenu()
            end,
        }
    end

    lib.registerContext({
        id = 'ys_scenarios_menu',
        title = 'Scenario Management',
        menu = 'ys_main_menu',
        options = options,
    })
end

-- ┌──────────────────────────────────────┐
-- │          EVENTS MENU                 │
-- └──────────────────────────────────────┘

function RegisterEventsMenu()
    local isActive = YS.State.randomEventsEnabled

    lib.registerContext({
        id = 'ys_events_menu',
        title = 'Event Management',
        menu = 'ys_main_menu',
        options = {
            {
                title = 'Current Status',
                description = 'Random events: ' .. statusBadge(isActive),
                readOnly = true,
            },
            {
                title = 'Enable Events',
                description = 'Re-enable GTA V random ambient events',
                onSelect = function()
                    ToggleRandomEvents(true)
                    OpenMainMenu()
                end,
            },
            {
                title = 'Disable Events',
                description = 'Stop all random ambient events',
                onSelect = function()
                    ToggleRandomEvents(false)
                    OpenMainMenu()
                end,
            },
        },
    })
end

-- ┌──────────────────────────────────────┐
-- │          DENSITY MENU                │
-- └──────────────────────────────────────┘

function RegisterDensityMenu()
    local pedOptions = {}
    local vehOptions = {}

    -- Build ped density slider options
    for i = 0, 10 do
        local val = i / 10
        local label = math.floor(val * 100) .. '%'
        local isCurrent = (math.floor(YS.State.pedDensity * 10) == i)
        pedOptions[#pedOptions + 1] = {
            title = isCurrent and (label .. ' (Current)') or label,
            onSelect = function()
                SetPedDensityValue(val)
                YS.Notify('NPC Density: ' .. label, 'success')
                OpenMainMenu()
            end,
        }
    end

    -- Build vehicle density slider options
    for i = 0, 10 do
        local val = i / 10
        local label = math.floor(val * 100) .. '%'
        local isCurrent = (math.floor(YS.State.vehicleDensity * 10) == i)
        vehOptions[#vehOptions + 1] = {
            title = isCurrent and (label .. ' (Current)') or label,
            onSelect = function()
                SetVehicleDensityValue(val)
                YS.Notify('Vehicle Density: ' .. label, 'success')
                OpenMainMenu()
            end,
        }
    end

    -- Ped density sub-menu
    lib.registerContext({
        id = 'ys_density_ped_menu',
        title = 'NPC Density — Currently: ' .. percentLabel(YS.State.pedDensity),
        menu = 'ys_density_menu',
        options = pedOptions,
    })

    -- Vehicle density sub-menu
    lib.registerContext({
        id = 'ys_density_veh_menu',
        title = 'Vehicle Density — Currently: ' .. percentLabel(YS.State.vehicleDensity),
        menu = 'ys_density_menu',
        options = vehOptions,
    })

    -- Main density menu
    lib.registerContext({
        id = 'ys_density_menu',
        title = 'Density Control',
        menu = 'ys_main_menu',
        options = {
            {
                title = 'Overview',
                description = 'NPC: ~b~' .. percentLabel(YS.State.pedDensity) .. '~s~ | Vehicle: ~b~' .. percentLabel(YS.State.vehicleDensity) .. '~s~ | Parked: ~b~' .. percentLabel(YS.State.parkedVehicleDensity) .. '~s~',
                readOnly = true,
            },
            {
                title = 'NPC Density',
                description = 'Currently: ' .. percentLabel(YS.State.pedDensity),
                menu = 'ys_density_ped_menu',
            },
            {
                title = 'Vehicle Density',
                description = 'Currently: ' .. percentLabel(YS.State.vehicleDensity),
                menu = 'ys_density_veh_menu',
            },
        },
    })
end

-- ┌──────────────────────────────────────┐
-- │          PRESETS MENU                │
-- └──────────────────────────────────────┘

function RegisterPresetsMenu()
    local presetOrder = { 'performance', 'roleplay', 'semirp', 'vanilla' }
    local options = {}

    for _, key in ipairs(presetOrder) do
        local preset = Config.Presets[key]
        local isCurrent = (YS.State.activePreset == key)
        options[#options + 1] = {
            title = preset.label .. (isCurrent and ' (Current)' or ''),
            description = preset.description,
            onSelect = function()
                YS.ApplyPreset(key)
                OpenMainMenu()
            end,
        }
    end

    -- Custom preset info
    if YS.State.activePreset == 'custom' then
        options[#options + 1] = {
            title = 'Custom Mode (Current)',
            description = 'Custom settings configuration active',
            readOnly = true,
        }
    end

    lib.registerContext({
        id = 'ys_presets_menu',
        title = 'Quick Presets',
        menu = 'ys_main_menu',
        options = options,
    })
end

-- ┌──────────────────────────────────────┐
-- │          STATS MENU                  │
-- └──────────────────────────────────────┘

function RegisterStatsMenu()
    -- Estimate FPS gain based on reduction
    local basePedReduction = math.floor((1.0 - YS.State.pedDensity) * 100)
    local baseVehReduction = math.floor((1.0 - YS.State.vehicleDensity) * 100)
    local estimatedGain = math.floor((basePedReduction * 0.15) + (baseVehReduction * 0.12))
    if not YS.State.scenariosEnabled then
        estimatedGain = estimatedGain + 3
    end
    if not YS.State.randomEventsEnabled then
        estimatedGain = estimatedGain + 1
    end

    lib.registerContext({
        id = 'ys_stats_menu',
        title = 'Live Statistics',
        menu = 'ys_main_menu',
        options = {
            {
                title = 'Loaded NPCs',
                description = '~b~' .. YS.Stats.pedCount .. '~s~ NPCs in the zone',
                readOnly = true,
            },
            {
                title = 'Loaded Vehicles',
                description = '~b~' .. YS.Stats.vehicleCount .. '~s~ vehicles in the zone',
                readOnly = true,
            },
            {
                title = 'NPC Density',
                description = percentLabel(YS.State.pedDensity),
                readOnly = true,
            },
            {
                title = 'Traffic Density',
                description = percentLabel(YS.State.vehicleDensity),
                readOnly = true,
            },
            {
                title = 'Scenarios',
                description = statusBadge(YS.State.scenariosEnabled),
                readOnly = true,
            },
            {
                title = 'Events',
                description = statusBadge(YS.State.randomEventsEnabled),
                readOnly = true,
            },
            {
                title = 'Estimated FPS Gained',
                description = '~g~+' .. estimatedGain .. ' FPS~s~ (estimation)',
                readOnly = true,
            },
        },
    })
end

-- ┌──────────────────────────────────────┐
-- │          ADVANCED MENU               │
-- └──────────────────────────────────────┘

function RegisterAdvancedMenu()
    lib.registerContext({
        id = 'ys_advanced_menu',
        title = 'Advanced Settings',
        menu = 'ys_main_menu',
        options = {
            {
                title = 'Save Settings',
                description = 'Save current modifications to settings.json permanently',
                icon = 'floppy-disk',
                onSelect = function()
                    SyncToServer()
                    TriggerServerEvent('ys-controlnpc:server:persistSettings')
                    YS.Notify('Settings saved permanently', 'success')
                end,
            },
            {
                title = 'Reset to Defaults',
                description = 'Restore all original configurations',
                onSelect = function()
                    lib.registerContext({
                        id = 'ys_confirm_reset',
                        title = 'Confirm Reset',
                        menu = 'ys_advanced_menu',
                        options = {
                            {
                                title = 'Yes, reset settings',
                                description = 'Restore default config.lua values',
                                onSelect = function()
                                    YS.State.pedDensity = Config.Defaults.pedDensity
                                    YS.State.vehicleDensity = Config.Defaults.vehicleDensity
                                    YS.State.parkedVehicleDensity = Config.Defaults.parkedVehicleDensity
                                    YS.State.scenariosEnabled = Config.Defaults.scenariosEnabled
                                    YS.State.randomEventsEnabled = Config.Defaults.randomEventsEnabled
                                    YS.State.distantLights = Config.Defaults.distantLights
                                    YS.State.scenarioOverrides = {}
                                    YS.State.activePreset = nil
                                    ApplyScenarioStates()
                                    SyncToServer()
                                    YS.Notify('Settings reset to defaults', 'success')
                                    YS.Log('Settings reset to defaults')
                                    OpenMainMenu()
                                end,
                            },
                            {
                                title = 'Cancel',
                                description = 'Return to advanced settings',
                                menu = 'ys_advanced_menu',
                            },
                        },
                    })
                    lib.showContext('ys_confirm_reset')
                end,
            },
            {
                title = 'Distant Lights',
                description = statusBadge(YS.State.distantLights),
                onSelect = function()
                    YS.State.distantLights = not YS.State.distantLights
                    SyncToServer()
                    local stateText = YS.State.distantLights and 'enabled' or 'disabled'
                    YS.Notify('Distant lights ' .. stateText, 'info')
                    OpenMainMenu()
                end,
            },
            {
                title = 'Parked Vehicles',
                description = 'Density: ' .. percentLabel(YS.State.parkedVehicleDensity),
                menu = 'ys_parked_menu',
            },
            {
                title = 'Information',
                description = Config.UI.brand .. ' — v1.0.0\nStandalone • ESX • QBCore',
                readOnly = true,
            },
        },
    })

    -- Parked vehicle sub-menu
    local parkedOptions = {}
    for i = 0, 10 do
        local val = i / 10
        local label = math.floor(val * 100) .. '%'
        local isCurrent = (math.floor(YS.State.parkedVehicleDensity * 10) == i)
        parkedOptions[#parkedOptions + 1] = {
            title = isCurrent and (label .. ' (Current)') or label,
            onSelect = function()
                SetParkedDensityValue(val)
                YS.Notify('Parked vehicle density: ' .. label, 'success')
                OpenMainMenu()
            end,
        }
    end

    lib.registerContext({
        id = 'ys_parked_menu',
        title = 'Parked Vehicle Density — ' .. percentLabel(YS.State.parkedVehicleDensity),
        menu = 'ys_advanced_menu',
        options = parkedOptions,
    })
end
