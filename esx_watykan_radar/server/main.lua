ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

-- BILLS WITHOUT ESX_BILLING (START)
RegisterServerEvent('esx_watykan_radar:PayBill60Zone')
AddEventHandler('esx_watykan_radar:PayBill60Zone', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	
	xPlayer.removeMoney(100)
end)

RegisterServerEvent('esx_watykan_radar:PayBill80Zone')
AddEventHandler('esx_watykan_radar:PayBill80Zone', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	
	xPlayer.removeMoney(300)	
end)

RegisterServerEvent('esx_watykan_radar:PayBill120Zone')
AddEventHandler('esx_watykan_radar:PayBill120Zone', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	
	xPlayer.removeMoney(500)
end)
-- BILLS WITHOUT ESX_BILLING (END)

-- FLASHING EFFECT (START)
RegisterServerEvent('esx_watykan_radar:openGUI')
AddEventHandler('esx_watykan_radar:openGUI', function()
	TriggerClientEvent('esx_watykan_radar:openGUI', source)
end)

RegisterServerEvent('esx_watykan_radar:closeGUI')
AddEventHandler('esx_watykan_radar:closeGUI', function()
	TriggerClientEvent('esx_watykan_radar:closeGUI', source)
end)
-- FLASHING EFFECT (END)

function notification(text)
	TriggerClientEvent('esx:showNotification', source, text)
end