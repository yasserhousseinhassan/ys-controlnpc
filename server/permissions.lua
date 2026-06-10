--[[
    ╔══════════════════════════════════════════════════════════╗
    ║              YS-CONTROLNPC | Permissions                 ║
    ║          Developed by Yasser Storm Development           ║
    ╚══════════════════════════════════════════════════════════╝
    
    ACE permission system.
    
    To grant permissions, add to your server.cfg:
    
        add_ace group.admin ys.controlnpc allow
    
    Or for a specific player:
    
        add_ace identifier.license:XXXXX ys.controlnpc allow
]]

--- Check if a player has the required ACE permission
---@param source number Player server ID
---@return boolean
function HasPermission(source)
    if not Config.Permission.restrictToAce then
        return true
    end
    return IsPlayerAceAllowed(source, Config.Permission.acePermission)
end
