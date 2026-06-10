--[[
    ╔══════════════════════════════════════════════════════════╗
    ║              YS-CONTROLNPC | Scenario Controller         ║
    ║          Developed by Yasser Storm Development           ║
    ╚══════════════════════════════════════════════════════════╝
    
    Manages GTA V world scenarios per category.
    Scenarios are applied once on change, not every frame.
]]

-- ┌──────────────────────────────────────┐
-- │    SCENARIO TOGGLE FUNCTIONS         │
-- └──────────────────────────────────────┘

--- Toggle all scenarios globally
---@param enabled boolean
function ToggleAllScenarios(enabled)
    YS.State.scenariosEnabled = enabled
    YS.State.scenarioOverrides = {}  -- Clear per-category overrides
    YS.State.activePreset = 'custom'

    for _, category in pairs(Config.Scenarios) do
        for _, scenario in ipairs(category.scenarios) do
            SetScenarioTypeEnabled(scenario, enabled)
        end
    end

    SyncToServer()

    local stateText = enabled and 'activés' or 'désactivés'
    YS.Notify('Tous les scénarios ' .. stateText, enabled and 'success' or 'info')

    if Config.Logs.logActions then
        YS.Log('All scenarios ' .. (enabled and 'enabled' or 'disabled'))
    end
end

--- Toggle a specific scenario category
---@param categoryKey string Key from Config.Scenarios
---@param enabled boolean
function ToggleScenarioCategory(categoryKey, enabled)
    local category = Config.Scenarios[categoryKey]
    if not category then return end

    YS.State.scenarioOverrides[categoryKey] = enabled
    YS.State.activePreset = 'custom'

    for _, scenario in ipairs(category.scenarios) do
        SetScenarioTypeEnabled(scenario, enabled)
    end

    SyncToServer()

    local stateText = enabled and 'activé' or 'désactivé'
    YS.Notify(category.label .. ' ' .. stateText, enabled and 'success' or 'info')

    if Config.Logs.logActions then
        YS.Log('Scenario category "' .. categoryKey .. '" ' .. (enabled and 'enabled' or 'disabled'))
    end
end

--- Get the effective enabled state of a scenario category
---@param categoryKey string
---@return boolean
function GetScenarioCategoryState(categoryKey)
    if YS.State.scenarioOverrides[categoryKey] ~= nil then
        return YS.State.scenarioOverrides[categoryKey]
    end
    return YS.State.scenariosEnabled
end

--- Toggle random events
---@param enabled boolean
function ToggleRandomEvents(enabled)
    YS.State.randomEventsEnabled = enabled
    YS.State.activePreset = 'custom'
    SetRandomEventFlag(enabled)
    SyncToServer()

    local stateText = enabled and 'activés' or 'désactivés'
    YS.Notify('Événements aléatoires ' .. stateText, enabled and 'success' or 'info')

    if Config.Logs.logActions then
        YS.Log('Random events ' .. (enabled and 'enabled' or 'disabled'))
    end
end
