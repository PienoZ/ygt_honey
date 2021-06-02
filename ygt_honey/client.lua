ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function OpenOpium()
	ESX.UI.Menu.CloseAll()
	local elements = {}
	menuOpen = true

	for k, v in pairs(ESX.GetPlayerData().inventory) do
		local price = config.items[v.name]

		if price and v.count > 0 then
			table.insert(elements, {
				label = ('%s - <span style="color:green;">$%s</span>'):format(v.label, ESX.Math.GroupDigits(price)),
				name = v.name,
				price = price,

				type = 'slider',
				value = 1,
				min = 1,
				max = v.count
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'honey_shop', {
		title    = 'Honey',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('kp_honey:sell', data.current.name, data.current.value)
	end, function(data, menu)
		menu.close()
		menuOpen = false
	end)
end

Citizen.CreateThread(function()	
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local ped = GetPlayerPed(-1)
		local coords = GetEntityCoords(playerPed)
		if not IsPedInAnyVehicle(GetPlayerPed(-1)) then
			
			if GetDistanceBetweenCoords(coords, config.zones.dealer.coords, true) < 2 then
					
				ESX.ShowHelpNotification("~INPUT_CONTEXT~ ~g~Bal ~y~Sat")
					
				if IsControlJustReleased(0, 38) then
								OpenOpium()	
				end
			end
		end
	end
end)


function CreateBlipCircle(coords, text, radius, color, sprite) -- 501
	local blip 

	SetBlipHighDetail(blip, true)
	SetBlipColour(blip, 1)
	SetBlipAlpha (blip, 128)

	blip = AddBlipForCoord(coords)

	SetBlipHighDetail(blip, true)
	SetBlipSprite (blip, 501)
	SetBlipScale  (blip, 0.5)
	SetBlipColour (blip, color)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(text)
	EndTextCommandSetBlipName(blip)
end

Citizen.CreateThread(function()
	for k,zone in pairs(config.zones) do
		CreateBlipCircle(zone.coords, zone.name, zone.radius, zone.color, zone.sprite)
	end
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		
		local px,py,pz = table.unpack(config.zones.process.coords)
		if GetDistanceBetweenCoords(coords, config.zones.process.coords, true) < 10 then
				DrawMarker(2, px, py, pz, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 240,230,140, 165, 1,0, 0,1)	
		end
		
	end
end)