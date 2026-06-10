--[[
    ╔══════════════════════════════════════════════════════════╗
    ║              YS-CONTROLNPC | Configuration               ║
    ║          Developed by Yasser Storm Development           ║
    ╚══════════════════════════════════════════════════════════╝
]]

Config = {}

-- ┌──────────────────────────────────────┐
-- │          GENERAL SETTINGS            │
-- └──────────────────────────────────────┘

Config.Debug = false                          -- Enable debug prints in console
Config.CommandMenu = 'npcmenu'                -- Primary command to open menu
Config.CommandMenuAlt = 'controlnpc'          -- Alternative command

-- ┌──────────────────────────────────────┐
-- │          DEFAULT DENSITIES           │
-- └──────────────────────────────────────┘

Config.Defaults = {
    pedDensity = 0.4,                         -- Default ped density (0.0 to 1.0)
    vehicleDensity = 0.4,                     -- Default vehicle density (0.0 to 1.0)
    parkedVehicleDensity = 0.4,               -- Default parked vehicle density (0.0 to 1.0)
    scenariosEnabled = false,                 -- Default scenario state
    randomEventsEnabled = false,              -- Default random events state
    distantLights = false,                    -- Distant vehicle lights
}

-- ┌──────────────────────────────────────┐
-- │            PERMISSIONS               │
-- └──────────────────────────────────────┘

Config.Permission = {
    acePermission = 'ys.controlnpc',          -- ACE permission required
    restrictToAce = true,                     -- If false, all players can use it
}

-- ┌──────────────────────────────────────┐
-- │          MODULE TOGGLES              │
-- └──────────────────────────────────────┘

Config.Modules = {
    peds = true,                              -- Enable PNJ management module
    traffic = true,                           -- Enable traffic management module
    scenarios = true,                         -- Enable scenarios management module
    events = true,                            -- Enable events management module
    density = true,                           -- Enable density slider module
    presets = true,                           -- Enable presets module
    stats = true,                             -- Enable live statistics module
    advanced = true,                          -- Enable advanced settings module
}

-- ┌──────────────────────────────────────┐
-- │          PRESET PROFILES             │
-- └──────────────────────────────────────┘

Config.Presets = {
    performance = {
        label = 'Mode Performance',
        description = 'FPS maximum — Aucun PNJ ni trafic',
        pedDensity = 0.0,
        vehicleDensity = 0.0,
        parkedVehicleDensity = 0.0,
        scenariosEnabled = false,
        randomEventsEnabled = false,
    },
    roleplay = {
        label = 'Mode Roleplay',
        description = 'Population réduite — Immersion RP optimale',
        pedDensity = 0.25,
        vehicleDensity = 0.25,
        parkedVehicleDensity = 0.25,
        scenariosEnabled = true,
        randomEventsEnabled = false,
    },
    semirp = {
        label = 'Mode Semi-RP',
        description = 'Population modérée — Équilibre performances et immersion',
        pedDensity = 0.5,
        vehicleDensity = 0.5,
        parkedVehicleDensity = 0.5,
        scenariosEnabled = true,
        randomEventsEnabled = true,
    },
    vanilla = {
        label = 'Mode Vanilla GTA',
        description = 'Population native GTA V — Expérience originale',
        pedDensity = 1.0,
        vehicleDensity = 1.0,
        parkedVehicleDensity = 1.0,
        scenariosEnabled = true,
        randomEventsEnabled = true,
    },
}

-- ┌──────────────────────────────────────┐
-- │         SAVE SETTINGS                │
-- └──────────────────────────────────────┘

Config.Save = {
    enabled = true,                           -- Enable auto-save of settings
    file = 'data/settings.json',              -- Save file path (relative to resource)
    interval = 30,                            -- Auto-save interval in seconds (0 = save on change only)
}

-- ┌──────────────────────────────────────┐
-- │           LOG SETTINGS               │
-- └──────────────────────────────────────┘

Config.Logs = {
    enabled = true,                           -- Enable console logs
    prefix = '[YS-CONTROLNPC]',               -- Log prefix
    logActions = true,                        -- Log admin actions
    logPresets = true,                        -- Log preset changes
    logDensity = true,                        -- Log density changes
}

-- ┌──────────────────────────────────────┐
-- │        UI COLORS & BRANDING          │
-- └──────────────────────────────────────┘

Config.UI = {
    brand = 'Yasser Storm Development',
    title = 'YS Control NPC',
    accentColor = '#00E5FF',                  -- Cyan lumineux
    secondaryColor = '#2979FF',               -- Bleu électrique
    bgColor = '#0D1117',                      -- Fond sombre élégant
    successColor = '#00E676',                 -- Vert succès
    dangerColor = '#FF1744',                  -- Rouge danger
    warningColor = '#FFD600',                 -- Jaune warning
}

-- ┌──────────────────────────────────────┐
-- │      SCENARIO DEFINITIONS            │
-- └──────────────────────────────────────┘

Config.Scenarios = {
    police = {
        label = 'Police',
        scenarios = {
            'WORLD_VEHICLE_POLICE',
            'WORLD_VEHICLE_POLICE_CAR',
            'WORLD_VEHICLE_POLICE_BIKE',
            'WORLD_VEHICLE_POLICE_NEXT_TO_CAR',
        },
    },
    ambulance = {
        label = 'Ambulance',
        scenarios = {
            'WORLD_VEHICLE_AMBULANCE',
        },
    },
    firetruck = {
        label = 'Pompiers',
        scenarios = {
            'WORLD_VEHICLE_FIRE_TRUCK',
        },
    },
    construction = {
        label = 'Construction',
        scenarios = {
            'WORLD_VEHICLE_CONSTRUCTION_SOLO',
            'WORLD_VEHICLE_CONSTRUCTION_PASSENGERS',
            'WORLD_VEHICLE_QUARRY',
        },
    },
    cyclists = {
        label = 'Cyclistes',
        scenarios = {
            'WORLD_VEHICLE_BICYCLE_BMX',
            'WORLD_VEHICLE_BICYCLE_BMX_BALLAS',
            'WORLD_VEHICLE_BICYCLE_BMX_FAMILY',
            'WORLD_VEHICLE_BICYCLE_BMX_HARMONY',
            'WORLD_VEHICLE_BICYCLE_BMX_VAGOS',
            'WORLD_VEHICLE_BICYCLE_MOUNTAIN',
            'WORLD_VEHICLE_BICYCLE_ROAD',
            'WORLD_VEHICLE_BIKE_OFF_ROAD_RACE',
            'WORLD_VEHICLE_BIKER',
        },
    },
    boats = {
        label = 'Bateaux',
        scenarios = {
            'WORLD_VEHICLE_BOAT_IDLE',
            'WORLD_VEHICLE_BOAT_IDLE_ALAMO',
            'WORLD_VEHICLE_BOAT_IDLE_MARQUIS',
        },
    },
    helicopters = {
        label = 'Hélicoptères',
        scenarios = {
            'WORLD_VEHICLE_HELI_LIFEGUARD',
        },
    },
    military = {
        label = 'Avions Militaires',
        scenarios = {
            'WORLD_VEHICLE_MILITARY_PLANES_BIG',
            'WORLD_VEHICLE_MILITARY_PLANES_SMALL',
        },
    },
    trucks = {
        label = 'Camions & Remorques',
        scenarios = {
            'WORLD_VEHICLE_TRUCK_LOGS',
            'WORLD_VEHICLE_TRUCKS_TRAILERS',
            'WORLD_VEHICLE_CLUCKIN_BELL_TRAILER',
        },
    },
    special = {
        label = 'Véhicules Spéciaux',
        scenarios = {
            'WORLD_VEHICLE_ATTRACTOR',
            'WORLD_VEHICLE_BROKEN_DOWN',
            'WORLD_VEHICLE_BUSINESSMEN',
            'WORLD_VEHICLE_DRIVE_PASSENGERS',
            'WORLD_VEHICLE_DRIVE_PASSENGERS_LIMITED',
            'WORLD_VEHICLE_DRIVE_SOLO',
            'WORLD_VEHICLE_EMPTY',
            'WORLD_VEHICLE_MARIACHI',
            'WORLD_VEHICLE_MECHANIC',
            'WORLD_VEHICLE_PARK_PARALLEL',
            'WORLD_VEHICLE_PARK_PERPENDICULAR_NOSE_IN',
            'WORLD_VEHICLE_PASSENGER_EXIT',
            'WORLD_VEHICLE_SALTON',
            'WORLD_VEHICLE_SALTON_DIRT_BIKE',
            'WORLD_VEHICLE_SECURITY_CAR',
            'WORLD_VEHICLE_STREETRACE',
            'WORLD_VEHICLE_TOURBUS',
            'WORLD_VEHICLE_TOURIST',
            'WORLD_VEHICLE_TANDL',
            'WORLD_VEHICLE_TRACTOR',
            'WORLD_VEHICLE_TRACTOR_BEACH',
            'WORLD_VEHICLE_DISTANT_EMPTY_GROUND',
        },
    },
}
