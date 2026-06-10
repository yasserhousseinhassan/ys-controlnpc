--[[
    ╔══════════════════════════════════════════════════════════╗
    ║              YS-CONTROLNPC | FiveM Resource             ║
    ║          Developed by Yasser Storm Development          ║
    ║                                                          ║
    ║   Premium NPC & Traffic Control System                   ║
    ║   Version: 1.0.0                                         ║
    ╚══════════════════════════════════════════════════════════╝
]]

fx_version 'cerulean'
game 'gta5'

name 'ys-controlnpc'
author 'Yasser Storm Development'
description 'Premium NPC & Traffic Control System — Dynamic population management with OX Lib interface'
version '1.0.0'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client/main.lua',
    'client/density.lua',
    'client/scenarios.lua',
    'client/menu.lua',
}

server_scripts {
    'server/main.lua',
    'server/permissions.lua',
    'server/save.lua',
}

dependencies {
    'ox_lib',
}
