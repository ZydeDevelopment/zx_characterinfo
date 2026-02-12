# 🆔 Identity Script for FiveM

Modern character info script for FiveM with ESX & QB-Core support. Displays player data in a clean ox_lib context menu including name, job, money, phone number, date of birth, and more.

## ✨ Features

- **Multi-Framework Support** - Automatic detection for ESX & QB-Core
- **Multi-Language Support** - 5 languages available (CS, DE, FR, EN, ES)
- **ox_lib Context Menu** - Clean UI with FontAwesome icons and progress bars
- **Discord Webhook Logging** - Track command usage with detailed embeds
- **Full Customization** - Toggle any info field in config.lua
- **Database Integration** - Fetches phone numbers and date of birth via oxmysql
- **Status Display** - Shows hunger, thirst, and stress levels with color indicators
- **Gang Information** - Display gang and rank (QB-Core only)
- **Money Formatting** - Automatic comma separators for better readability
- **Lightweight & Optimized** - Minimal performance impact

## 📋 What It Displays

- Character name
- Date of birth
- Player ID
- Current job & grade
- Bank & cash money
- Phone number
- Citizen ID (QB-Core)
- Gang & rank (QB-Core)
- Stress level (QB-Core)
- Hunger & thirst levels
- Progress bars with color indicators

## 📦 Dependencies

- [ox_lib](https://github.com/overextended/ox_lib)
- [oxmysql](https://github.com/overextended/oxmysql)
- ESX or QB-Core framework
- esx_status (optional, for hunger/thirst on ESX)

## 🔧 Installation

1. Download and place in your `resources` folder
2. Add `ensure identity_zx` to your `server.cfg`
3. Configure `config.lua` to your preferences
4. Restart your server

## ⚙️ Configuration

```lua
-- Framework Settings
Config.Framework = 'esx' -- 'esx' or 'qb'

-- Language Settings
Config.Locale = 'en' -- Available: cs, de, fr, en, es

-- Display Settings
Config.ShowInfo = {
    name = true,           -- Show character name
    dateOfBirth = true,    -- Show date of birth
    playerId = true,       -- Show player ID
    job = true,            -- Show current job
    bankMoney = true,      -- Show bank money
    cashMoney = true,      -- Show cash money
    phoneNumber = true,    -- Show phone number
    citizenId = true,      -- Show citizen ID (QB only)
    gang = true,           -- Show gang (QB only)
    stress = true,         -- Show stress level (QB only)
    hunger = true,         -- Show hunger level
    thirst = true          -- Show thirst level
}

-- Webhook Settings
Config.Webhook = {
    enabled = true,
    url = '', -- Your Discord webhook URL
    botName = 'Identity Script',
    color = 3447003,
    title = 'Player ID Command Used'
}

-- Command Settings
Config.Command = 'id' -- Change the command name
```

## 🎮 Usage

Simply type `/id` in-game to display your character information in a clean context menu.

## PREVIEW

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/5c7c87f5-1bc6-4056-8399-8efde213d51b" />


## 🌍 Available Languages

- 🇨🇿 Czech (cs)
- 🇬🇧 English (en)
- 🇩🇪 German (de)
- 🇫🇷 French (fr)
- 🇪🇸 Spanish (es)

## 📝 License

This project is open-source and freely available for use on FiveM servers.

## 👨‍💻 Developer

**Zyrox** - ZyxdeDevelopment

## 💬 Support

Need help or have suggestions for improvements?

🔗 **Discord Server**: [Join Here](https://discord.gg/eUJEAyYX)

---

⭐ **If you like this resource, give it a star on GitHub!**

