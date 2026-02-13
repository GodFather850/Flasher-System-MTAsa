# Flasher System MTAsa

# 🚗 **Flasher System - Vehicle Light Controller**

> **A professional vehicle light flasher system for MTA:SA roleplay servers**

---

## ✨ **Features**

- ✅ Buy flasher system with **in-game currency**
- ✅ 5 unique **flashing modes**
- ✅ **30-day expiration** system with automatic removal
- ✅ **On/Off** commands to control flashers anytime
- ✅ Integrated with **account system**, **core**, and **notification**
- ✅ SQLite database for persistent storage
- ✅ Optimized performance with efficient timers

---

## 🎮 **Commands**

| Command | Description |
|---------|-------------|
| `/flashlist` | Show available flasher modes and prices |
| `/buyflasher [1-5]` | Purchase a flasher for 30 days |
| `/onflasher` | Activate your purchased flasher |
| `/offflasher` | Deactivate and turn off all lights |

---

## 💰 **Pricing**

| Flasher ID | Price (Cash) | Description |
|:----------:|:------------:|-------------|
| **1** | 1000💵 | Front lights only (0,1) |
| **2** | 2000💵 | Rear lights only (2,3) |
| **3** | 3000💵 | All lights (0,1,2,3) |
| **4** | 4000💵 | Left side (0,2) |
| **5** | 5000💵 | Right side (1,3) |

> 💡 Each purchase grants **30 days** of access – auto-deleted after expiry!

---

## 🔧 **Installation**

1. **Place** the resource folder in your server's `resources` directory
2. **Ensure** dependencies:
   - `[R]Accounts`
   - `[R]Core`
   - `[R]Notification`
   - `[R]DS`
3. **Start** the resource in your `mtaserver.conf` or via admin panel
4. **Database** (`shopdb.sql`) auto-creates on first run

---

## 🧠 **How It Works**

```lua
-- Timer rotates through 5 flashing patterns every 500ms
setTimer(function()
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh then
        light = not light  -- Toggle on/off state
        funcs[index](veh)  -- Apply current pattern
        index = index + 1
        if index > #funcs then index = 1 end
    end
end, 500, 0)
```
# Light Modes:

**Mode 1: Front lights flash**

**Mode 2: Rear lights flash**

**Mode 3: All lights flash**

**Mode 4: Left side lights**

**Mode 5: Right side lights**

---

🛠️ Dependencies

`[R]Accounts` – Account management

`[R]Core` – Core framework

`[R]Notification` – Notification system

`[R]DS` – Dealership integration

---
# 🎯 Perfect For
**Roleplay servers with police vehicles 🚔**

**Emergency services (ambulance, fire department) 🚑🚒**

**Car meets & night cruises 🌙**

**Adding realism with hazard lights ⚠️**

**Team Speak squads showing off! 🎤🔥**

---
# 📸 Preview

╔════════════════════════════╗
║   🔥 FLASHER MODE 3 🔥    ║
║  All Lights Flashing!      ║
║  █ █ █ █  █ █ █ █         ║
╚════════════════════════════╝

**[Flasher 3]: cheshmak 3 Left 3 Right 3000 Gold**

---
# 📜 License
This project is licensed under the MIT License – feel free to use, modify, and distribute!
---
███████╗██╗      █████╗ ███████╗██╗  ██╗███████╗██████╗
██╔════╝██║     ██╔══██╗██╔════╝██║  ██║██╔════╝██╔══██╗
███████╗██║     ███████║███████╗███████║█████╗  ██████╔╝
╚════██║██║     ██╔══██║╚════██║██╔══██║██╔══╝  ██╔══██╗
███████║███████╗██║  ██║███████║██║  ██║███████╗██║  ██║
╚══════╝╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
---
