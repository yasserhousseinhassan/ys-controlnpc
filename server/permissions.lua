--[[
    ╔══════════════════════════════════════════════════════════╗
    ║              YS-CONTROLNPC | Permissions                 ║
    ║          Developed by Yasser Storm Development           ║
    ╚══════════════════════════════════════════════════════════╝
    
    Ace permissions & Framework group checking.
    Supports Standalone, ESX, and QBCore out of the box.
]]

local ESX = nil
local QBCore = nil

-- Automatically detect active frameworks and register default ACE permissions
CreateThread(function()
    -- Register default ACE permissions for admin groups automatically
    ExecuteCommand('add_ace group.admin ys.controlnpc allow')
    ExecuteCommand('add_ace group.superadmin ys.controlnpc allow')
    ExecuteCommand('add_ace group.god ys.controlnpc allow')

    if GetResourceState('es_extended') == 'started' then
        ESX = exports['es_extended']:getSharedObject()
    end
    
    if GetResourceState('qb-core') == 'started' then
        QBCore = exports['qb-core']:GetCoreObject()
    end
end)

--- Check if a player has permission to access the menu
---@param source number Player server ID
---@return boolean
function HasPermission(source)
    -- If restriction is disabled, everyone has access
    if not Config.Permission.restrict then
        return true
    end

    -- 1. Check ACE Permission
    if Config.Permission.checkAce then
        if IsPlayerAceAllowed(source, Config.Permission.acePermission) then
            return true
        end
    end

    -- 2. Check Framework Admin Groups
    if Config.Permission.checkFramework then
        -- Check ESX Group
        if ESX then
            local xPlayer = ESX.GetPlayerFromId(source)
            if xPlayer then
                local group = xPlayer.getGroup()
                for _, allowedGroup in ipairs(Config.Permission.allowedGroups) do
                    if group == allowedGroup then
                        return true
                    end
                end
            end
        end

        -- Check QBCore Group & Permissions
        if QBCore then
            local xPlayer = QBCore.Functions.GetPlayer(source)
            if xPlayer then
                -- Check Player Data Group
                local group = xPlayer.PlayerData.group
                for _, allowedGroup in ipairs(Config.Permission.allowedGroups) do
                    if group == allowedGroup then
                        return true
                    end
                end
                
                -- Check QBCore Helper Function
                for _, allowedGroup in ipairs(Config.Permission.allowedGroups) do
                    if QBCore.Functions.HasPermission(source, allowedGroup) then
                        return true
                    end
                end
            end
        end
    end

    return false
end
