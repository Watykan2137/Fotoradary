----													----
----	WATYKAN KOCÓR BAGNIAK HAZE ESSA SITO DO PAŁY  	----
----													----
----		SCRIPT CREATE BY OG_WATYKAN					----
local useBilling = true 
local useCameraSound = true 
local useFlashingScreen = true 
local useBlips = true 
local alertPolice = true 
local alertSpeed = 150 

local defaultPrice60 = 100 
local defaultPrice80 = 300 
local defaultPrice120 = 500 

local extraZonePrice10 = 100 
local extraZonePrice20 = 500 
local extraZonePrice30 = 1000 


ESX = nil
local hasBeenCaught = false
local finalBillingPrice = 0;

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local blips = {
	{title="Fotoradar (60KM/H)", colour=1, id=1, x = -524.2645, y = -1776.3569, z = 21.3384}, -- 60KM/H ZONE
	
	-- 80KM/H ZONES
	{title="Fotoradar (80KM/H)", colour=1, id=1, x = 2506.0671, y = 4145.2431, z = 38.1054}, -- 80KM/H ZONE
	{title="Fotoradar (80KM/H)", colour=1, id=1, x = 1258.2006, y = 789.4199, z = 104.2190}, -- 80KM/H ZONE
	{title="Fotoradar (80KM/H)", colour=1, id=1, x = 980.9982, y = 407.4164, z = 92.2374}, -- 80KM/H ZONE
	
	-- 120KM/H ZONES
	{title="Fotoradar (120KM/H)", colour=1, id=1, x = 1584.9281, y = -993.4557, z = 59.3923}, -- 120KM/H ZONE
	{title="Fotoradar (120KM/H)", colour=1, id=1, x = 2442.2006, y = -134.6004, z = 88.7765}, -- 120KM/H ZONE
	{title="Fotoradar (120KM/H)", colour=1, id=1, x = 2871.7951, y = 3540.5795, z = 53.0930} -- 120KM/H ZONE
}

Citizen.CreateThread(function()
	for _, info in pairs(blips) do
		if useBlips == true then
			info.blip = AddBlipForCoord(info.x, info.y, info.z)
			SetBlipSprite(info.blip, info.id)
			SetBlipDisplay(info.blip, 4)
			SetBlipScale(info.blip, 0.5)
			SetBlipColour(info.blip, info.colour)
			SetBlipAsShortRange(info.blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(info.title)
			EndTextCommandSetBlipName(info.blip)
		end
	end
end)

local Speedcamera60Zone = {
    {x = -524.2645,y = -1776.3569,z = 21.3384}
}

local Speedcamera80Zone = {
    {x = 2506.0671,y = 4145.2431,z = 38.1054},
    {x = 1258.2006,y = 789.4199,z = 103.2190},
    {x = 980.9982,y = 407.4164,z = 92.2374}
}

local Speedcamera120Zone = {
    {x = 1584.9281,y = -993.4557,z = 59.3923},
    {x = 2442.2006,y = -134.6004,z = 88.7765},
    {x = 2871.7951,y = 3540.5795,z = 53.0930}
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)

		-- 60 zone
        for k in pairs(Speedcamera60Zone) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Speedcamera60Zone[k].x, Speedcamera60Zone[k].y, Speedcamera60Zone[k].z)

            if dist <= 20.0 then
				local playerPed = GetPlayerPed(-1)
				local playerCar = GetVehiclePedIsIn(playerPed, false)
				local veh = GetVehiclePedIsIn(playerPed)
				local SpeedKM = GetEntitySpeed(playerPed)*3.6
				local maxSpeed = 60.0 -- THIS IS THE MAX SPEED IN KM/H
				
				if SpeedKM > maxSpeed then
					if IsPedInAnyVehicle(playerPed, false) then
						if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then
							if hasBeenCaught == false then
								if GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE2" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE3" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE4" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICEB" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICET" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "SHERIFF" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "FIRETRUK" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "AMBULAN" then -- BLACKLISTED VEHICLE
								-- VEHICLES ABOVE ARE BLACKLISTED
								else
									-- ALERT POLICE (START)
									if alertPolice == true then
										if SpeedKM > alertSpeed then
											local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
											TriggerServerEvent('esx_phone:send', 'police', ' Someone passed the speed camera, above ' .. alertSpeed.. ' KMH', true, {x =x, y =y, z =z})
										end
									end
									-- ALERT POLICE (END)								
								
									-- FLASHING EFFECT (START)
									if useFlashingScreen == true then
										TriggerServerEvent('esx_watykan_radar:openGUI')
									end
									
									if useCameraSound == true then
										TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
									end
									
									if useFlashingScreen == true then
										Citizen.Wait(200)
										TriggerServerEvent('esx_watykan_radar:closeGUI')
									end
									-- FLASHING EFFECT (END)								
								
									TriggerEvent("esx:SendNotification", {text = "Zostales zlapany przez fotoradar w strefie 60! Twoja szybkosc: " .. math.floor(SpeedKM) .. " KM/H", type = "error", timeout = 5000, layout = "centerLeft"})
									
									if useBilling == true then
										if SpeedKM >= maxSpeed + 30 then
											finalBillingPrice = defaultPrice60 + extraZonePrice30
										elseif SpeedKM >= maxSpeed + 20 then
											finalBillingPrice = defaultPrice60 + extraZonePrice20
										elseif SpeedKM >= maxSpeed + 10 then
											finalBillingPrice = defaultPrice60 + extraZonePrice10
										else
											finalBillingPrice = defaultPrice60
										end
										
										TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(PlayerId()), 'society_police', 'Fotoradar (60KM/H) - Your speed: ' .. math.floor(SpeedKM) .. ' KM/H - ', finalBillingPrice) -- Sends a bill from the police
									else
										TriggerServerEvent('esx_watykan_radar:PayBill60Zone')
									end
										
									hasBeenCaught = true
									Citizen.Wait(5000) -- This is here to make sure the player won't get fined over and over again by the same camera!
								end
							end
						end
					end
					
					hasBeenCaught = false
				end
            end
        end
		
		-- 80 zone
		for k in pairs(Speedcamera80Zone) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Speedcamera80Zone[k].x, Speedcamera80Zone[k].y, Speedcamera80Zone[k].z)

            if dist <= 20.0 then
				local playerPed = GetPlayerPed(-1)
				local playerCar = GetVehiclePedIsIn(playerPed, false)
				local veh = GetVehiclePedIsIn(playerPed)
				local SpeedKM = GetEntitySpeed(playerPed)*3.6
				local maxSpeed = 80.0 -- THIS IS THE MAX SPEED IN KM/H
				
				if SpeedKM > maxSpeed then
					if IsPedInAnyVehicle(playerPed, false) then
						if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then					
							if hasBeenCaught == false then
								if GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE2" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE3" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE4" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICEB" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICET" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "FIRETRUK" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "AMBULAN" then -- BLACKLISTED VEHICLE
								-- VEHICLES ABOVE ARE BLACKLISTED
								else
									-- ALERT POLICE (START)
									if alertPolice == true then
										if SpeedKM > alertSpeed then
											local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
											TriggerServerEvent('esx_phone:send', 'police', ' Someone passed the speed camera, above ' .. alertSpeed.. ' KMH', true, {x =x, y =y, z =z})
										end
									end
									-- ALERT POLICE (END)								
								
									-- FLASHING EFFECT (START)
									if useFlashingScreen == true then
										TriggerServerEvent('esx_watykan_radar:openGUI')
									end
									
									if useCameraSound == true then
										TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
									end
									
									if useFlashingScreen == true then
										Citizen.Wait(200)
										TriggerServerEvent('esx_watykan_radar:closeGUI')
									end
									-- FLASHING EFFECT (END)								
								
									TriggerEvent("esx:SendNotification", {text = "Zostales zlapany przez fotoradar w strefie 80! Twoja predkosc: " .. math.floor(SpeedKM) .. " KM/H", type = "error", timeout = 5000, layout = "centerLeft"})
									
									if useBilling == true then
										if SpeedKM >= maxSpeed + 30 then
											finalBillingPrice = defaultPrice80 + extraZonePrice30
										elseif SpeedKM >= maxSpeed + 20 then
											finalBillingPrice = defaultPrice80 + extraZonePrice20
										elseif SpeedKM >= maxSpeed + 10 then
											finalBillingPrice = defaultPrice80 + extraZonePrice10
										else
											finalBillingPrice = defaultPrice80
										end
									
										TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(PlayerId()), 'society_police', 'Speedcamera (80KM/H) - Your speed: ' .. math.floor(SpeedKM) .. ' KM/H - ', finalBillingPrice) -- Sends a bill from the police
									else
										TriggerServerEvent('esx_watykan_radar:PayBill80Zone')
									end
										
									hasBeenCaught = true
									Citizen.Wait(5000) -- This is here to make sure the player won't get fined over and over again by the same camera!
								end
							end
						end
					end
					
					hasBeenCaught = false
				end
            end
        end
		
		-- 120 zone
		for k in pairs(Speedcamera120Zone) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Speedcamera120Zone[k].x, Speedcamera120Zone[k].y, Speedcamera120Zone[k].z)

            if dist <= 20.0 then
				local playerPed = GetPlayerPed(-1)
				local playerCar = GetVehiclePedIsIn(playerPed, false)
				local veh = GetVehiclePedIsIn(playerPed)
				local SpeedKM = GetEntitySpeed(playerPed)*3.6
				local maxSpeed = 120.0 -- THIS IS THE MAX SPEED IN KM/H
				
				if SpeedKM > maxSpeed then
					if IsPedInAnyVehicle(playerPed, false) then
						if (GetPedInVehicleSeat(playerCar, -1) == playerPed) then 
							if hasBeenCaught == false then
								if GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE2" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE3" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICE4" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICEB" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "POLICET" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "FIRETRUK" then -- BLACKLISTED VEHICLE
								elseif GetDisplayNameFromVehicleModel(GetEntityModel(veh)) == "AMBULAN" then -- BLACKLISTED VEHICLE
								-- VEHICLES ABOVE ARE BLACKLISTED
								else
									-- ALERT POLICE (START)
									if alertPolice == true then
										if SpeedKM > alertSpeed then
											local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
											TriggerServerEvent('esx_phone:send', 'police', ' Someone passed the speed camera, above ' .. alertSpeed.. ' KMH', true, {x =x, y =y, z =z})
										end
									end
									-- ALERT POLICE (END)
								
									-- FLASHING EFFECT (START)
									if useFlashingScreen == true then
										TriggerServerEvent('esx_watykan_radar:openGUI')
									end
									
									if useCameraSound == true then
										TriggerServerEvent("InteractSound_SV:PlayOnSource", "speedcamera", 0.5)
									end
									
									if useFlashingScreen == true then
										Citizen.Wait(200)
										TriggerServerEvent('esx_watykan_radar:closeGUI')
									end
									-- FLASHING EFFECT (END)
								
									TriggerEvent("esx:SendNotification", {text = "Zostales zlapany przez fotoradar w strefie 120! Twoja predkosc: " .. math.floor(SpeedKM) .. " KM/H", type = "error", timeout = 5000, layout = "centerLeft"})
									
									
									if useBilling == true then
										if SpeedKM >= maxSpeed + 30 then
											finalBillingPrice = defaultPrice120 + extraZonePrice30
										elseif SpeedKM >= maxSpeed + 20 then
											finalBillingPrice = defaultPrice120 + extraZonePrice20
										elseif SpeedKM >= maxSpeed + 10 then
											finalBillingPrice = defaultPrice120 + extraZonePrice10
										else
											finalBillingPrice = defaultPrice120
										end
									
										TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(PlayerId()), 'society_police', 'Speedcamera (120KM/H) - Your speed: ' .. math.floor(SpeedKM) .. ' KM/H - ', finalBillingPrice) -- Sends a bill from the police
									else
										TriggerServerEvent('esx_watykan_radar:PayBill120Zone')
									end
										
									hasBeenCaught = true
									Citizen.Wait(5000) -- This is here to make sure the player won't get fined over and over again by the same camera!
								end
							end
						end
					end
					
					hasBeenCaught = false
				end
            end
        end
    end
end)

RegisterNetEvent('esx_watykan_radar:openGUI')
AddEventHandler('esx_watykan_radar:openGUI', function()
    SetNuiFocus(false,false)
    SendNUIMessage({type = 'openSpeedcamera'})
end)   

RegisterNetEvent('esx_watykan_radar:closeGUI')
AddEventHandler('esx_watykan_radar:closeGUI', function()
    SendNUIMessage({type = 'closeSpeedcamera'})
end)

----													----
----	WATYKAN KOCÓR BAGNIAK HAZE ESSA SITO DO PAŁY  	----
----													----
----		SCRIPT CREATE BY OG_WATYKAN					----