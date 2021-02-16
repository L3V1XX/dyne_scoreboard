ESX = nil
local playMinute, playHour = 0, 0
local scoreboardOpen = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
	
    ESX.TriggerServerCallback('dyne_scoreboard:GetConfig', function(config)
        Config.IllegalActions = config
    end)

    ESX.TriggerServerCallback('dyne_scoreboard:getPlayers', function(players)
        Config.TotalPlayers = players
    end)
end)

DrawText3D = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

RegisterCommand('ilegales', function()
    if not scoreboardOpen then
        ESX.TriggerServerCallback('dyne_scoreboard:GetInfoServer', function(data)
            Config.CurrentCops = data.police
            
            if data.ems >= 3 then
                Config.CurrentEms = "+3"
            else
                Config.CurrentEms = data.ems
            end

            if data.taxi >= 3 then
                Config.CurrentTaxi = "+3"
            else
                Config.CurrentTaxi = data.taxi
            end

            if data.mechanic >= 3 then
                Config.CurrentMechanic = "+3"
            else
                Config.CurrentMechanic = data.mechanic
            end

            SendNUIMessage({
                action = "open",
                players = Config.TotalPlayers,
                maxPlayers = Config.MaxPlayers,
                requiredCops = Config.IllegalActions,
                currentCops = Config.CurrentCops,
                playerName = data.name,
                ambulance = Config.CurrentEms,
                mechanic = Config.CurrentMechanic,
                taxi = Config.CurrentTaxi,
                playerId = GetPlayerServerId(PlayerId()),
                playTime = string.format("%02dh %02dm", playHour, playMinute)
            })
            scoreboardOpen = true
        end)
    else
        SendNUIMessage({
            action = "close",
        })
        scoreboardOpen = false
    end
end)

RegisterKeyMapping('ilegales', 'Abrir menú de actos delictivos', 'keyboard', 'f10')

RegisterNetEvent('dyne_scoreboard:SetActivityBusy')
AddEventHandler('dyne_scoreboard:SetActivityBusy', function(activity, busy)
    Config.IllegalActions[activity].busy = busy
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)
		playMinute = playMinute + 1

		if playMinute == 60 then
			playMinute = 0
			playHour = playHour + 1
		end

		SendNUIMessage({
			action = 'updatePlayTime',
			playTime = string.format("%02dh %02dm", playHour, playMinute)
		})

        ESX.TriggerServerCallback('dyne_scoreboard:getPlayers', function(players)
            Config.TotalPlayers = players
        end)
	end
end)