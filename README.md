# YS-CONTROLNPC

> **Premium NPC & Traffic Control System for FiveM**
> Developed by **Yasser Storm Development**

---

## Description

**ys-controlnpc** is a premium FiveM resource that provides complete and dynamic control over the GTA V world population. Manage NPCs, traffic, scenarios, and events in real time through a sleek OX Lib interface — no server restart required.

---

## Features

| Module | Description |
|---|---|
| **NPC Management** | Toggle pedestrian activation, deactivation, and density |
| **Traffic Management** | Control road traffic and parked vehicles density |
| **GTA V Scenarios** | Grouped scenario controls by category (police, ambulance, etc.) |
| **Random Events** | Toggle GTA V singleplayer random ambient world events |
| **Density Control** | Fine-tune population densities from 0% to 100% in 10% steps |
| **Quick Presets** | Quick profiles: Performance, Roleplay, Semi-RP, Vanilla, Custom |
| **Live Statistics** | Live entity counters, active density values, and estimated FPS gained |
| **Advanced Settings** | Save state, settings reset, and distant headlights controls |

---

## Dependencies

- [ox_lib](https://github.com/overextended/ox_lib)

---

## Installation

1. Download and place `ys-controlnpc` in your server's `resources/` folder.
2. Add `ensure ox_lib` before `ensure ys-controlnpc` in your `server.cfg`.
3. Add `ensure ys-controlnpc` to your `server.cfg`.
4. Configure permissions (optional, see below).
5. Restart your server.

## Permissions

By default, the script dynamically restricts menu access to administrators, completely plug-and-play without editing your config files.

### 1. Automatic Admin Detection (Zero Configuration)
On startup, the resource automatically registers ACE permissions for standard admin groups (`group.admin`, `group.superadmin`, and `group.god`). If your administrators are defined in txAdmin or standard server configurations, **they will immediately have access without you needing to edit your `server.cfg`**.

### 2. Manual Custom Access (Optional)
If you want to grant access to a specific player manually via ACE, you can add this line to your `server.cfg`:

```cfg
add_ace identifier.license:XXXXXXXXXXXXXX ys.controlnpc allow
```

### 3. Framework Admin Groups (ESX & QBCore)
If `checkFramework = true` is enabled in `config.lua`, the script will automatically detect ESX or QBCore and verify if the player belongs to any of the groups listed in `allowedGroups` (default is `admin`, `superadmin`, and `god`).

> **Note:** You can completely disable authorization checks by setting `Config.Permission.restrict = false` in `config.lua`.

---

## Commands & Keybinds

| Command / Key | Action |
|---|---|
| `/npcmenu` | Opens the main menu |
| `/controlnpc` | Opens the main menu (alternative command) |
| `F5` | Keyboard keybind shortcut (configurable) |

---

## Presets

| Preset | NPCs | Traffic | Scenarios | Events |
|---|---|---|---|---|
| **Performance** | 0% | 0% | No | No |
| **Roleplay** | 25% | 25% | Yes | No |
| **Semi-RP** | 50% | 50% | Yes | Yes |
| **Vanilla GTA** | 100% | 100% | Yes | Yes |
| **Custom** | Configurable | Configurable | Configurable | Configurable |

---

## Project Structure

```
ys-controlnpc/
├── fxmanifest.lua          # FiveM resource manifest
├── config.lua              # Full configuration settings
├── client/
│   ├── main.lua            # Client-side core logic
│   ├── menu.lua            # OX Lib menu interface
│   ├── density.lua         # Density multiplier control thread
│   └── scenarios.lua       # Scenario control functions
├── server/
│   ├── main.lua            # Server-side core logic
│   ├── permissions.lua     # ACE permission validation
│   └── save.lua            # JSON settings persistence
├── data/
│   └── settings.json       # Persisted settings file
└── README.md
```

---

## Compatibility

- Standalone
- ESX
- QBCore
- OneSync Infinity
- 128+ players
- 256+ players

---

## Performance

- **Consumption:** ~0.00 ms when idle
- **Single thread** for density multiplier application (optimized)
- **Zero threads** for scenarios (applied once upon state changes)
- **No unnecessary polling**

---

## Console Logs

Administrative and density actions are logged with the prefix `[YS-CONTROLNPC]`:

```
[YS-CONTROLNPC] Resource started — Yasser Storm Development
[YS-CONTROLNPC] State updated — NPC: 25% | Traffic: 25% — by AdminName
[YS-CONTROLNPC] All scenarios disabled
[YS-CONTROLNPC] Performance Mode loaded
[YS-CONTROLNPC] Settings saved on resource stop
```

---

## Persistence / Auto-Save

Your current configuration is automatically saved to `data/settings.json` and restored:

- After a player reconnects
- After the resource is restarted
- After the server is restarted

---

## License

© 2024 **Yasser Storm Development** — All rights reserved.
This script is protected and cannot be redistributed without prior authorization.

---

<p align="center">
  <b>Yasser Storm Development</b><br>
  Premium FiveM Resources
</p>
