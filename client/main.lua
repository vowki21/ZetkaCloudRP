local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local IsNuiActive = false
local IsDisplaying = nil
local Timer = 0
local Prop = nil
local Id = nil
local IsAdmin = nil
local CloudPlayers = {}
local antytroll = {}
local streamujetags = {}
local admintags = {}
local ukryteid = {}

local Ped = {
	Active = false,
	Id = 0,
	Exists = false,
	Spectate = nil,
	Coords = nil,
}

CreateThread(function()
	while true do
		Wait(250)
		if not NetworkIsInSpectatorMode() then
			Ped.Spectate = nil
		end

		Ped.Active = not IsPauseMenuActive()
		if Ped.Active then
			Ped.Id = PlayerPedId()
			Ped.Exists = DoesEntityExist(Ped.Id)
			Ped.Coords = GetEntityCoords(Ped.Id)
		end
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerData = playerData

	SendNUIMessage({
		action = "updateJob", 
		praca = ESX.PlayerData.job.label.." - "..ESX.PlayerData.job.grade_label
	});

	SendNUIMessage({
		action = "updateJob2", 
		praca2 = ESX.PlayerData.secondjob.label.." - "..ESX.PlayerData.secondjob.grade_label
	});
	SendNUIMessage({
		action = "updateJob3", 
		praca3 = ESX.PlayerData.thirdjob.label.." - "..ESX.PlayerData.thirdjob.grade_label
	});
	
	
	TriggerServerEvent('esx_scoreboard:players')

	ESX.TriggerServerCallback('esx_scoreboard:ZapodajStreamujeAll', function(stream)
		streamujetags = stream
	end)
	ESX.TriggerServerCallback('esx_scoreboard:ZapodajUkryteAll', function(xd)
		ukryteid = xd
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job, response)
	ESX.PlayerData.job = job
	
	SendNUIMessage({
		action = "updateJob", 
		praca = ESX.PlayerData.job.label.." - "..ESX.PlayerData.job.grade_label
	})
end)

RegisterNetEvent('esx:setSecondJob')
AddEventHandler('esx:setSecondJob', function(secondjob, response)
	ESX.PlayerData.secondjob = secondjob
	
	SendNUIMessage({
		action = "updateJob2", 
		praca2 = ESX.PlayerData.secondjob.label.." - "..ESX.PlayerData.secondjob.grade_label
	})
end)

RegisterNetEvent('esx:setThirdJob')
AddEventHandler('esx:setThirdJob', function(thirdjob, response)
	ESX.PlayerData.thirdjob = thirdjob
	
	SendNUIMessage({
		action = "updateJob3", 
		praca3 = ESX.PlayerData.thirdjob.label.." - "..ESX.PlayerData.thirdjob.grade_label
	})
end)



AddEventHandler('EasyAdmin:spectate', function(ped)
	Ped.Spectate = ped
end)

local cache = {}

function DrawText2D(id, int)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextScale(0.4, 0.4)
	SetTextColour(56, 197, 201, 255)
	SetTextDropShadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextJustification(2)

	SetTextEntry('STRING')
	AddTextComponentString(id)
	DrawText(table.unpack({ 0.0, 0.965 - int }))
end

CreateThread(function()
	while true do
		if #cache > 0 then
			Wait(5)
			for i=1, #cache, 1 do
				local int = i * 0.0185
				DrawText2D(cache[i].id, int)
			end
		else
			Wait(1000)
		end
	end
end)

CreateThread(function()
	while not HasAnimDictLoaded("amb@world_human_clipboard@male@idle_a") do
		RequestAnimDict("amb@world_human_clipboard@male@idle_a")
		Wait(0)
	end
	while true do
		Wait(500)
		local found = false
		local ped = Ped.Id
		if Ped.Spectate then
			ped = Ped.Spectate
		end

		local pid = PlayerId()
		for _, player in ipairs(GetActivePlayers()) do
			if pid ~= player then
				local playerPed = GetPlayerPed(player)
				local can = true
				if not IsEntityVisible(playerPed) then
					if not IsAdmin then
						can = false
					end	
				end	
				if can then						
					local coords1 = GetPedBoneCoords(ped, 31086, -0.4, 0.0, 0.0)
					local coords2 = GetPedBoneCoords(playerPed, 31086, -0.4, 0.0, 0.0)
					
					local dystans = 20.00
					if #(coords1 - coords2) < dystans and NetworkIsPlayerTalking(player) then
						local found = false
						for i=1, #cache, 1 do
							if cache[i].id == GetPlayerServerId(player) then
								found = true
								break
							end
						end
						if not found then
							table.insert(cache, {id = GetPlayerServerId(player)})
						end
					else
						for i=1, #cache, 1 do
							if GetPlayerServerId(player) == cache[i].id then
								table.remove(cache, i)
								break
							end
						end
					end
				end
			end  
		end					
	end
end)

function DrawText3DD(x, y, z, text, color)
    local onScreen, _x, _y = World3dToScreen2d(x,y,z)
	
	local scale = (1 / #(GetGameplayCamCoords() - vec3(x, y, z))) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    
    if onScreen then
        SetTextScale(0.8 * scale, 1.55 * scale)
        SetTextFont(0)
        SetTextColour(color[1], color[2], color[3], 255)
        SetTextDropshadow(0, 0, 5, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
		SetTextCentre(1)

        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function DrawText3D(x, y, z, text, color)
    local onScreen, _x, _y = World3dToScreen2d(x,y,z)
	
	local scale = (1 / #(GetGameplayCamCoords() - vec3(x, y, z))) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    
    if onScreen then
        SetTextScale(1.0 * scale, 1.55 * scale)
        SetTextFont(0)
        SetTextColour(color[1], color[2], color[3], 255)
        SetTextDropshadow(0, 0, 5, 0, 255)
        SetTextDropShadow()
        SetTextOutline()
		SetTextCentre(1)

        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function DrawText3DOpis(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)

    if onScreen then
        SetTextScale(0.30, 0.30)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

RegisterCommand('+zetka', function()
	local found = false
	if Ped.Active and Ped.Exists then
		found = true
		IsDisplaying = false
		if IsEntityVisible(Ped.Id) then
			if not IsAdmin then
				TriggerServerEvent('esx_scoreboard:Show', "rozgląda się uważnie")
				if not IsPedInAnyVehicle(Ped.Id, false) and not exports["esx_ambulancejob"]:isDead() and not IsEntityDead(Ped.Id) and not IsPedFalling(Ped.Id) and not IsPedCuffed(Ped.Id) and not IsPedDiving(Ped.Id) and not IsPedInCover(Ped.Id, false) and not IsPedInParachuteFreeFall(Ped.Id) and GetPedParachuteState(Ped.Id) < 1 and not exports['cloud_trunk']:checkInTrunk() and not exports['esx_policejob']:IsCuffed() then
					TaskPlayAnim(Ped.Id, "amb@world_human_clipboard@male@idle_a", "idle_a", 8.0, -8.0, -1, 1, 0.0, false, false, false)
					IsDisplaying = true

					ESX.Game.SpawnObject('p_cs_clipboard', {
						x = Ped.Coords.x,
						y = Ped.Coords.y,
						z = Ped.Coords.z + 2
					}, function(object)
						AttachEntityToEntity(object, Ped.Id, GetPedBoneIndex(Ped.Id, 36029), 0.1, 0.015, 0.12, 45.0, -130.0, 180.0, true, false, false, false, 0, true)
						Prop = object
					end)					
				end
			end
		end
	end
end, false)

RegisterCommand('-zetka', function()
	SendNUIMessage({
		action = 'toggle',
		state = false
	})

	if IsDisplaying == true then
		StopAnimTask(Ped.Id, "amb@world_human_clipboard@male@idle_a", "idle_a", 1.0)
		DeleteObject(Prop)
		Prop = nil
	end
	IsDisplaying = nil
	IsNuiActive = false
end, false)

RegisterKeyMapping('+zetka', 'Obejrzyj liste graczy', 'keyboard', 'Z')

RegisterNetEvent('esx_scoreboard:UstawStream', function(player, text, admintaggg)
	local ajdi = player
	local info = text
	
	streamujetags[ajdi] = info
	admintags[ajdi] = admintaggg
end)

RegisterNetEvent('esx_scoreboard:ukryteid', function(player, tajp)
	ukryteid[player] = tajp
end)

CreateThread(function()
	
	while true do
		Wait(0)
		local sleep = true
		if Ped.Active and Ped.Exists then
			if IsDisplaying ~= nil then
				if IsDisplaying == false or IsEntityPlayingAnim(Ped.Id, "amb@world_human_clipboard@male@idle_a", "idle_a", 3) or exports["esx_ambulancejob"]:isDead() then
					PlayerList()

					local ped = Ped.Id
					if Ped.Spectate then
						ped = Ped.Spectate
					end

					local pid = PlayerId()
					for _, player in ipairs(GetActivePlayers()) do
						if id ~= player then
							local playerPed = GetPlayerPed(player)
							local can = true
							if not IsEntityVisible(playerPed) then
								if not IsAdmin then
									can = false
								end	
							end	
							if can then	
								local coords1 = GetPedBoneCoords(ped, 31086, -0.4, 0.0, 0.0)
								local coords2 = GetPedBoneCoords(playerPed, 31086, -0.4, 0.0, 0.0)
								
								local dystans = IsAdmin and 150.00 or 40.00
								if #(coords1 - coords2) < dystans then
									local ajdi = GetPlayerServerId(player)
									sleep = false
									if ukryteid[ajdi] == false or ukryteid[ajdi] == nil then
										--drawText3D('❗', coords2.y, false, 0.7)
										DrawText3D(coords2.x, coords2.y, coords2.z + 1.0, GetPlayerServerId(player), (NetworkIsPlayerTalking(player) and {0, 0, 255} or {255, 255, 255}))
										
										if (streamujetags[ajdi] ~= nil and tostring(streamujetags[ajdi]) ~= '') then
											DrawText3DD(coords2.x, coords2.y, coords2.z + 1.6, streamujetags[ajdi], {128, 0, 255})
										end
										if (admintags[ajdi] ~= nil and tostring(admintags[ajdi]) ~= '') then
											DrawText3DD(coords2.x, coords2.y, coords2.z + 1.2, admintags[ajdi], {255, 255, 255})
										end
									end
								end
							end
						end  
					end					
				end		
			end
		end
		if sleep then
			Wait(300)
		end
	end
end)

function PlayerList()

	if IsNuiActive then
		return
	end

	local timer = GetGameTimer()
	if timer - Timer > 10000 then
		Timer, Id, CloudPlayers = timer, nil, nil, {}
		TriggerServerEvent('esx_scoreboard:players')
	end
	
	if Id and ESX.PlayerData.job then
		SendNUIMessage({
			action = 'updatePlayerJobs',
			jobs   = {ems = CloudPlayers['ambulance'], police = CloudPlayers['police'], sheriff = CloudPlayers['sheriff'], mechanik = CloudPlayers['mechanik'], gheneraugarage = CloudPlayers['gheneraugarage'], doj = CloudPlayers['doj'], cardealer = CloudPlayers['cardealer'], player_count = CloudPlayers['players']}
		})

		
		SendNUIMessage({
			action = 'toggle',
			state = true
		})
		
		IsNuiActive = true
	end
end

RegisterNetEvent('esx_scoreboard:players')
AddEventHandler('esx_scoreboard:players', function(Counter, Admin)
	Id = GetPlayerServerId(PlayerId())
	
	SendNUIMessage({
		action = 'updateId',
		id = Id
	})	
	
	CloudPlayers = Counter
	IsAdmin = Admin
end)