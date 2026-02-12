local CurrentLocale = {}

-- Load localization
Citizen.CreateThread(function()
    Wait(100) -- Wait for locales to load
    if Locales and Locales[Config.Locale] then
        CurrentLocale = Locales[Config.Locale]
    elseif Locales and Locales['en'] then
        CurrentLocale = Locales['en'] -- Fallback to English
    else
        print('[Identity Script] Error: No localization found!')
    end
end)

-- Function to get localized text
function _U(str, ...)
    if CurrentLocale[str] then
        return string.format(CurrentLocale[str], ...)
    else
        return 'Translation [' .. str .. '] does not exist'
    end
end

-- Function to format money
local function formatMoney(amount)
    if not amount then return '0 $' end
    local formatted = tostring(amount):reverse():gsub("(%d%d%d)", "%1,"):reverse()
    if formatted:sub(1, 1) == "," then
        formatted = formatted:sub(2)
    end
    return formatted .. ' $'
end

-- Function to format percentage
local function formatPercentage(value)
    if not value then return '0%' end
    return math.floor(value) .. '%'
end

-- Register the /id command
RegisterCommand(Config.Command, function(source, args, rawCommand)
    TriggerServerEvent('identity:getPlayerInfo')
end, false)

-- Handle player info response
RegisterNetEvent('identity:showPlayerInfo', function(playerData)
    if not playerData then 
        print('[Identity Script] Error: No player data received')
        return 
    end
    
    local menuOptions = {}
    
    -- Build menu options based on config
    if Config.ShowInfo.name then
        local name = playerData.name or _U('unknown')
        table.insert(menuOptions, {
            title = _U('character_name'),
            description = name,
            icon = 'user'
        })
    end
    
    if Config.ShowInfo.dateOfBirth then
        local dob = playerData.dateOfBirth or _U('unknown')
        table.insert(menuOptions, {
            title = _U('date_of_birth'),
            description = dob,
            icon = 'calendar'
        })
    end
    
    if Config.ShowInfo.playerId then
        local pid = playerData.playerId or _U('unknown')
        table.insert(menuOptions, {
            title = _U('player_id'),
            description = tostring(pid),
            icon = 'hashtag'
        })
    end
    
    if Config.ShowInfo.job then
        if playerData.job then
            local jobText = playerData.job.label or playerData.job.name or _U('unemployed')
            if playerData.job.grade_label or playerData.job.grade then
                jobText = jobText .. ' - ' .. (playerData.job.grade_label or ('Grade ' .. playerData.job.grade))
            end
            table.insert(menuOptions, {
                title = _U('current_job'),
                description = jobText,
                icon = 'briefcase'
            })
        else
            table.insert(menuOptions, {
                title = _U('current_job'),
                description = _U('unemployed'),
                icon = 'briefcase'
            })
        end
    end
    
    if Config.ShowInfo.bankMoney then
        local bank = playerData.bankMoney or 0
        table.insert(menuOptions, {
            title = _U('bank_money'),
            description = formatMoney(bank),
            icon = 'building-columns'
        })
    end
    
    if Config.ShowInfo.cashMoney then
        local cash = playerData.cashMoney or 0
        table.insert(menuOptions, {
            title = _U('cash_money'),
            description = formatMoney(cash),
            icon = 'money-bill'
        })
    end
    
    if Config.ShowInfo.phoneNumber then
        local phone = playerData.phoneNumber or _U('unknown')
        table.insert(menuOptions, {
            title = _U('phone_number'),
            description = phone,
            icon = 'phone'
        })
    end
    
    if Config.ShowInfo.citizenId and playerData.citizenId then
        table.insert(menuOptions, {
            title = _U('citizen_id'),
            description = playerData.citizenId,
            icon = 'id-card'
        })
    end
    
    if Config.ShowInfo.gang and playerData.gang then
        local gangText = playerData.gang.label or playerData.gang.name or _U('no_gang')
        if playerData.gang.grade and playerData.gang.grade.name then
            gangText = gangText .. ' - ' .. playerData.gang.grade.name
        end
        table.insert(menuOptions, {
            title = _U('gang'),
            description = gangText,
            icon = 'users'
        })
    end
    
    -- Stress level (QB-Core only)
    if Config.ShowInfo.stress and playerData.stress then
        local stress = playerData.stress
        table.insert(menuOptions, {
            title = _U('stress_level'),
            description = formatPercentage(stress),
            icon = 'heart-pulse',
            progress = stress,
            colorScheme = stress > 50 and 'red' or 'green'
        })
    end
    
    -- Hunger level
    if Config.ShowInfo.hunger and playerData.hunger then
        local hunger = playerData.hunger
        table.insert(menuOptions, {
            title = _U('hunger_level'),
            description = formatPercentage(hunger),
            icon = 'utensils',
            progress = hunger,
            colorScheme = hunger < 30 and 'red' or 'green'
        })
    end
    
    -- Thirst level
    if Config.ShowInfo.thirst and playerData.thirst then
        local thirst = playerData.thirst
        table.insert(menuOptions, {
            title = _U('thirst_level'),
            description = formatPercentage(thirst),
            icon = 'droplet',
            progress = thirst,
            colorScheme = thirst < 30 and 'red' or 'green'
        })
    end
    
    -- Register and show context menu
    if #menuOptions > 0 then
        lib.registerContext({
            id = 'player_identity_menu',
            title = _U('player_information') or 'Player Information',
            options = menuOptions
        })
        
        lib.showContext('player_identity_menu')
    else
        print('[Identity Script] Error: No info to display')
    end
end)
