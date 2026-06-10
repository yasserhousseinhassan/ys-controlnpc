--[[
    ╔══════════════════════════════════════════════════════════╗
    ║              YS-CONTROLNPC | OX Lib Menu                 ║
    ║          Developed by Yasser Storm Development           ║
    ╚══════════════════════════════════════════════════════════╝
    
    Full OX Lib context menu interface with premium design.
    All menus use ox_lib context menus exclusively.
]]

-- ┌──────────────────────────────────────┐
-- │         HELPER FUNCTIONS             │
-- └──────────────────────────────────────┘

local function statusBadge(enabled)
    if enabled then
        return '~g~ACTIF~s~'
    else
        return '~r~INACTIF~s~'
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
            label = label .. ' (Actuel)'
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
    local presetLabel = 'Aucun'
    if YS.State.activePreset and Config.Presets[YS.State.activePreset] then
        presetLabel = Config.Presets[YS.State.activePreset].label
    elseif YS.State.activePreset == 'custom' then
        presetLabel = 'Custom'
    end
    options[#options + 1] = {
        title = 'Profil Actif: ' .. presetLabel,
        description = 'PNJ: ' .. percentLabel(YS.State.pedDensity) .. ' | Trafic: ' .. percentLabel(YS.State.vehicleDensity),
        readOnly = true,
    }

    -- 1. Gestion des PNJ
    if Config.Modules.peds then
        options[#options + 1] = {
            title = 'Gestion des PNJ',
            description = 'Densité: ' .. percentLabel(YS.State.pedDensity) .. ' | ' .. statusBadge(YS.State.pedDensity > 0),
            menu = 'ys_peds_menu',
        }
    end

    -- 2. Gestion du trafic
    if Config.Modules.traffic then
        options[#options + 1] = {
            title = 'Gestion du Trafic',
            description = 'Densité: ' .. percentLabel(YS.State.vehicleDensity) .. ' | ' .. statusBadge(YS.State.vehicleDensity > 0),
            menu = 'ys_traffic_menu',
        }
    end

    -- 3. Gestion des scénarios
    if Config.Modules.scenarios then
        options[#options + 1] = {
            title = 'Gestion des Scénarios',
            description = statusBadge(YS.State.scenariosEnabled),
            menu = 'ys_scenarios_menu',
        }
    end

    -- 4. Gestion des événements
    if Config.Modules.events then
        options[#options + 1] = {
            title = 'Gestion des Événements',
            description = statusBadge(YS.State.randomEventsEnabled),
            menu = 'ys_events_menu',
        }
    end

    -- 5. Contrôle des densités
    if Config.Modules.density then
        options[#options + 1] = {
            title = 'Contrôle des Densités',
            description = 'Ajustement fin des populations',
            menu = 'ys_density_menu',
        }
    end

    -- 6. Presets rapides
    if Config.Modules.presets then
        options[#options + 1] = {
            title = 'Presets Rapides',
            description = 'Profils de configuration prédéfinis',
            menu = 'ys_presets_menu',
        }
    end

    -- 7. Statistiques en direct
    if Config.Modules.stats then
        options[#options + 1] = {
            title = 'Statistiques en Direct',
            description = 'Compteurs et performances',
            menu = 'ys_stats_menu',
        }
    end

    -- 8. Paramètres avancés
    if Config.Modules.advanced then
        options[#options + 1] = {
            title = 'Paramètres Avancés',
            description = 'Configuration et sauvegarde',
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
        title = 'Gestion des PNJ',
        menu = 'ys_main_menu',
        options = {
            {
                title = 'État Actuel',
                description = 'Densité: ' .. percentLabel(YS.State.pedDensity) .. ' | PNJ chargés: ~b~' .. YS.Stats.pedCount .. '~s~',
                readOnly = true,
            },
            {
                title = 'Activer les PNJ',
                description = 'Rétablir la population de PNJ par défaut',
                onSelect = function()
                    SetPedDensityValue(Config.Defaults.pedDensity > 0 and Config.Defaults.pedDensity or 0.5)
                    YS.Notify('PNJ activés — Densité: ' .. percentLabel(YS.State.pedDensity), 'success')
                    OpenMainMenu()
                end,
            },
            {
                title = 'Désactiver les PNJ',
                description = 'Supprimer tous les PNJ ambiants',
                onSelect = function()
                    SetPedDensityValue(0.0)
                    YS.Notify('PNJ désactivés', 'info')
                    OpenMainMenu()
                end,
            },
            {
                title = 'Compteur PNJ',
                description = 'PNJ actuellement chargés: ~b~' .. YS.Stats.pedCount .. '~s~',
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
        title = 'Gestion du Trafic',
        menu = 'ys_main_menu',
        options = {
            {
                title = 'État Actuel',
                description = 'Densité: ' .. percentLabel(YS.State.vehicleDensity) .. ' | Véhicules chargés: ~b~' .. YS.Stats.vehicleCount .. '~s~',
                readOnly = true,
            },
            {
                title = 'Activer le Trafic',
                description = 'Rétablir le trafic routier par défaut',
                onSelect = function()
                    SetVehicleDensityValue(Config.Defaults.vehicleDensity > 0 and Config.Defaults.vehicleDensity or 0.5)
                    YS.Notify('Trafic activé — Densité: ' .. percentLabel(YS.State.vehicleDensity), 'success')
                    OpenMainMenu()
                end,
            },
            {
                title = 'Désactiver le Trafic',
                description = 'Supprimer tout le trafic routier',
                onSelect = function()
                    SetVehicleDensityValue(0.0)
                    YS.Notify('Trafic désactivé', 'info')
                    OpenMainMenu()
                end,
            },
            {
                title = 'Compteur Véhicules',
                description = 'Véhicules actuellement chargés: ~b~' .. YS.Stats.vehicleCount .. '~s~',
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
            title = 'État Global',
            description = 'Scénarios: ' .. statusBadge(YS.State.scenariosEnabled),
            readOnly = true,
        },
        {
            title = 'Activer Tous les Scénarios',
            description = 'Rétablir tous les scénarios GTA V',
            onSelect = function()
                ToggleAllScenarios(true)
                OpenMainMenu()
            end,
        },
        {
            title = 'Désactiver Tous les Scénarios',
            description = 'Supprimer tous les scénarios GTA V',
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
            description = statusBadge(enabled) .. ' — ' .. #category.scenarios .. ' scénario(s)',
            onSelect = function()
                ToggleScenarioCategory(categoryKey, not enabled)
                OpenMainMenu()
            end,
        }
    end

    lib.registerContext({
        id = 'ys_scenarios_menu',
        title = 'Gestion des Scénarios',
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
        title = 'Gestion des Événements',
        menu = 'ys_main_menu',
        options = {
            {
                title = 'État Actuel',
                description = 'Événements aléatoires: ' .. statusBadge(isActive),
                readOnly = true,
            },
            {
                title = 'Activer les Événements',
                description = 'Réactiver les événements aléatoires GTA V',
                onSelect = function()
                    ToggleRandomEvents(true)
                    OpenMainMenu()
                end,
            },
            {
                title = 'Désactiver les Événements',
                description = 'Supprimer tous les événements aléatoires',
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
            title = isCurrent and (label .. ' (Actuel)') or label,
            onSelect = function()
                SetPedDensityValue(val)
                YS.Notify('Densité PNJ: ' .. label, 'success')
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
            title = isCurrent and (label .. ' (Actuel)') or label,
            onSelect = function()
                SetVehicleDensityValue(val)
                YS.Notify('Densité véhicules: ' .. label, 'success')
                OpenMainMenu()
            end,
        }
    end

    -- Ped density sub-menu
    lib.registerContext({
        id = 'ys_density_ped_menu',
        title = 'Densité PNJ — Actuellement: ' .. percentLabel(YS.State.pedDensity),
        menu = 'ys_density_menu',
        options = pedOptions,
    })

    -- Vehicle density sub-menu
    lib.registerContext({
        id = 'ys_density_veh_menu',
        title = 'Densité Véhicules — Actuellement: ' .. percentLabel(YS.State.vehicleDensity),
        menu = 'ys_density_menu',
        options = vehOptions,
    })

    -- Main density menu
    lib.registerContext({
        id = 'ys_density_menu',
        title = 'Contrôle des Densités',
        menu = 'ys_main_menu',
        options = {
            {
                title = 'Aperçu',
                description = 'PNJ: ~b~' .. percentLabel(YS.State.pedDensity) .. '~s~ | Véhicules: ~b~' .. percentLabel(YS.State.vehicleDensity) .. '~s~ | Garés: ~b~' .. percentLabel(YS.State.parkedVehicleDensity) .. '~s~',
                readOnly = true,
            },
            {
                title = 'Densité PNJ',
                description = 'Actuellement: ' .. percentLabel(YS.State.pedDensity),
                menu = 'ys_density_ped_menu',
            },
            {
                title = 'Densité Véhicules',
                description = 'Actuellement: ' .. percentLabel(YS.State.vehicleDensity),
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
            title = preset.label .. (isCurrent and ' (Actuel)' or ''),
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
            title = 'Mode Custom (Actuel)',
            description = 'Configuration personnalisée active',
            readOnly = true,
        }
    end

    lib.registerContext({
        id = 'ys_presets_menu',
        title = 'Presets Rapides',
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
        title = 'Statistiques en Direct',
        menu = 'ys_main_menu',
        options = {
            {
                title = 'PNJ Chargés',
                description = '~b~' .. YS.Stats.pedCount .. '~s~ PNJ dans la zone',
                readOnly = true,
            },
            {
                title = 'Véhicules Chargés',
                description = '~b~' .. YS.Stats.vehicleCount .. '~s~ véhicules dans la zone',
                readOnly = true,
            },
            {
                title = 'Densité PNJ',
                description = percentLabel(YS.State.pedDensity),
                readOnly = true,
            },
            {
                title = 'Densité Trafic',
                description = percentLabel(YS.State.vehicleDensity),
                readOnly = true,
            },
            {
                title = 'Scénarios',
                description = statusBadge(YS.State.scenariosEnabled),
                readOnly = true,
            },
            {
                title = 'Événements',
                description = statusBadge(YS.State.randomEventsEnabled),
                readOnly = true,
            },
            {
                title = 'FPS Estimés Gagnés',
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
        title = 'Paramètres Avancés',
        menu = 'ys_main_menu',
        options = {
            {
                title = 'Sauvegarder Maintenant',
                description = 'Forcer la sauvegarde des paramètres actuels',
                onSelect = function()
                    SyncToServer()
                    YS.Notify('Paramètres sauvegardés', 'success')
                end,
            },
            {
                title = 'Réinitialiser par Défaut',
                description = 'Restaurer tous les paramètres par défaut',
                onSelect = function()
                    lib.registerContext({
                        id = 'ys_confirm_reset',
                        title = 'Confirmer la Réinitialisation',
                        menu = 'ys_advanced_menu',
                        options = {
                            {
                                title = 'Oui, réinitialiser',
                                description = 'Restaurer les valeurs par défaut de config.lua',
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
                                    YS.Notify('Paramètres réinitialisés', 'success')
                                    YS.Log('Settings reset to defaults')
                                    OpenMainMenu()
                                end,
                            },
                            {
                                title = 'Annuler',
                                description = 'Retourner aux paramètres avancés',
                                menu = 'ys_advanced_menu',
                            },
                        },
                    })
                    lib.showContext('ys_confirm_reset')
                end,
            },
            {
                title = 'Phares Distants',
                description = statusBadge(YS.State.distantLights),
                onSelect = function()
                    YS.State.distantLights = not YS.State.distantLights
                    SyncToServer()
                    local stateText = YS.State.distantLights and 'activés' or 'désactivés'
                    YS.Notify('Phares distants ' .. stateText, 'info')
                    OpenMainMenu()
                end,
            },
            {
                title = 'Véhicules Garés',
                description = 'Densité: ' .. percentLabel(YS.State.parkedVehicleDensity),
                menu = 'ys_parked_menu',
            },
            {
                title = 'Informations',
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
            title = isCurrent and (label .. ' (Actuel)') or label,
            onSelect = function()
                SetParkedDensityValue(val)
                YS.Notify('Densité véhicules garés: ' .. label, 'success')
                OpenMainMenu()
            end,
        }
    end

    lib.registerContext({
        id = 'ys_parked_menu',
        title = 'Densité Véhicules Garés — ' .. percentLabel(YS.State.parkedVehicleDensity),
        menu = 'ys_advanced_menu',
        options = parkedOptions,
    })
end
