ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('dyne_scoreboard:GetInfoServer', function(source, cb)
    local data = {}
    data.police, data.ems, data.mechanic, data.taxi = 0, 0, 0, 0
    local xPlayers = ESX.GetPlayers()
    local player = ESX.GetPlayerFromId(source)
    data.name = player.getName()
    
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        
        if xPlayer ~= nil then
            if xPlayer.job.name == "police" then
                data.police = data.police + 1
            elseif xPlayer.job.name == "mechanic" then
                data.mechanic = data.mechanic + 1
            elseif xPlayer.job.name == "ambulance" then
                data.ems = data.ems + 1
            elseif xPlayer.job.name == "taxi" then
                data.taxi = data.taxi + 1
            end
        end
    end

    cb(data)
end)

ESX.RegisterServerCallback('dyne_scoreboard:GetConfig', function(source, cb)
    cb(Config.IllegalActions)
end)

ESX.RegisterServerCallback('dyne_scoreboard:getPlayers', function(source, cb)
    local xPlayers = ESX.GetPlayers()
    local players = 0
    for i=1, #xPlayers, 1 do
        players = players + 1
    end

    cb(players)
end)

RegisterServerEvent('dyne_scoreboard:SetActivityBusy')
AddEventHandler('dyne_scoreboard:SetActivityBusy', function(activity, bool)
    Config.IllegalActions[activity].busy = bool
    TriggerClientEvent('dyne_scoreboard:SetActivityBusy', -1, activity, bool)
end)