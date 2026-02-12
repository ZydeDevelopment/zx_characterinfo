local ESX = nil
local QBCore = nil

-- Initialize framework
Citizen.CreateThread(function()
    if Config.Framework == 'esx' then
        ESX = exports['es_extended']:getSharedObject()
    elseif Config.Framework == 'qb' then
        QBCore = exports['qb-core']:GetCoreObject()
    end
end)

-- Function to send Discord webhook
local function sendWebhook(playerData, playerName, playerId)
    if not Config.Webhook.enabled or not Config.Webhook.url or Config.Webhook.url == '' then
        return
    end
    
    local embed = {
        {
            ["color"] = Config.Webhook.color,
            ["title"] = Config.Webhook.title,
            ["description"] = "Player **" .. playerName .. "** (ID: " .. playerId .. ") used the /" .. Config.Command .. " command",
            ["fields"] = {
                {
                    ["name"] = "Character Name",
                    ["value"] = playerData.name or "Unknown",
                    ["inline"] = true
                },
                {
                    ["name"] = "Player ID",
                    ["value"] = tostring(playerId),
                    ["inline"] = true
                },
                {
                    ["name"] = "Date of Birth",
                    ["value"] = playerData.dateOfBirth or "Unknown",
                    ["inline"] = true
                },
                {
                    ["name"] = "Job",
                    ["value"] = (playerData.job and (playerData.job.label or playerData.job.name)) or "Unemployed",
                    ["inline"] = true
                },
                {
                    ["name"] = "Bank Money",
                    ["value"] = "$" .. (playerData.bankMoney or 0),
                    ["inline"] = true
                },
                {
                    ["name"] = "Cash Money",
                    ["value"] = "$" .. (playerData.cashMoney or 0),
                    ["inline"] = true
                }
            },
            ["footer"] = {
                ["text"] = "Identity Script • " .. os.date("%Y-%m-%d %H:%M:%S")
            }
        }
    }
    
    PerformHttpRequest(Config.Webhook.url, function(err, text, headers) end, 'POST', json.encode({
        username = Config.Webhook.botName,
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

-- Function to get ESX player data
local function getESXPlayerData(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then 
        return nil 
    end
    
    local playerData = {
        name = xPlayer.getName(),
        playerId = source,
        job = {
            name = xPlayer.job.name,
            label = xPlayer.job.label,
            grade = xPlayer.job.grade,
            grade_label = xPlayer.job.grade_label
        },
        bankMoney = xPlayer.getAccount('bank').money,
        cashMoney = xPlayer.getMoney(),
        dateOfBirth = nil,
        phoneNumber = nil,
        hunger = nil,
        thirst = nil
    }
    
    -- Get additional data from database using oxmysql
    local result = exports.oxmysql:executeSync('SELECT dateofbirth, phone_number FROM users WHERE identifier = ?', {xPlayer.identifier})
    
    if result and result[1] then
        playerData.dateOfBirth = result[1].dateofbirth
        playerData.phoneNumber = result[1].phone_number
        print('[Identity Script] Loaded from DB - DOB: ' .. tostring(playerData.dateOfBirth) .. ', Phone: ' .. tostring(playerData.phoneNumber))
    else
        print('[Identity Script] No data found in users table for identifier: ' .. xPlayer.identifier)
    end
    
    -- Get status data if esx_status exists
    if GetResourceState('esx_status') == 'started' then
        TriggerEvent('esx_status:getStatus', source, 'hunger', function(status)
            if status then
                playerData.hunger = math.floor((status.getPercent and status.getPercent() or (status.val / 1000000 * 100)))
            end
        end)
        
        TriggerEvent('esx_status:getStatus', source, 'thirst', function(status)
            if status then
                playerData.thirst = math.floor((status.getPercent and status.getPercent() or (status.val / 1000000 * 100)))
            end
        end)
        
        -- Wait a bit for callbacks to complete
        Wait(100)
    end
    
    TriggerClientEvent('identity:showPlayerInfo', source, playerData)
    sendWebhook(playerData, GetPlayerName(source), source)
end

-- Function to get QB-Core player data
local function getQBPlayerData(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then 
        return nil 
    end
    
    local playerData = {
        name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
        dateOfBirth = Player.PlayerData.charinfo.birthdate,
        playerId = source,
        citizenId = Player.PlayerData.citizenid,
        phoneNumber = Player.PlayerData.charinfo.phone,
        job = {
            name = Player.PlayerData.job.name,
            label = Player.PlayerData.job.label,
            grade = Player.PlayerData.job.grade.level,
            grade_label = Player.PlayerData.job.grade.name
        },
        gang = {
            name = Player.PlayerData.gang.name,
            label = Player.PlayerData.gang.label,
            grade = Player.PlayerData.gang.grade
        },
        bankMoney = Player.PlayerData.money.bank,
        cashMoney = Player.PlayerData.money.cash,
        stress = Player.PlayerData.metadata.stress or 0,
        hunger = Player.PlayerData.metadata.hunger or 0,
        thirst = Player.PlayerData.metadata.thirst or 0
    }
    
    TriggerClientEvent('identity:showPlayerInfo', source, playerData)
    sendWebhook(playerData, GetPlayerName(source), source)
end

-- Handle player info request
RegisterNetEvent('identity:getPlayerInfo', function()
    local source = source
    
    if Config.Framework == 'esx' then
        getESXPlayerData(source)
    elseif Config.Framework == 'qb' then
        getQBPlayerData(source)
    else
        print('[Identity Script] Error: Invalid framework specified in config!')
    end
end)
