SES                              = nil
local HasAlreadyEnteredMarker   = false
local GUI                       = {}
local LastPart                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local SeS                        = {}
local DakheleEvent              = false
GUI.Time                        = 0

Citizen.CreateThread(function()
    while SES == nil do
        TriggerEvent('esx:getSharedObject', function(obj) SES = obj end)
        Citizen.Wait(0)
    end
end)


RegisterNetEvent('SeS_events:sync')
AddEventHandler('SeS_events:sync', function()
    SES.TriggerServerCallback('SeS_events:getData', function(data)
        if data ~= nil then
            SeS.tp            = json.decode(data.tp)
            SeS.status        = json.decode(data.status)
            SeS.vest          = data.vest
            SeS.car1          = data.car1
            SeS.car1_plate    = data.car1_plate
            SeS.car1_fuel     = data.car1_fuel
            SeS.car1_marker   = json.decode(data.car1_marker)
            SeS.car2          = data.car2
            SeS.car2_plate    = data.car2_plate
            SeS.car2_fuel     = data.car2_fuel
            SeS.car2_marker   = json.decode(data.car2_marker)
            SeS.car_spawn     = json.decode(data.car_spawn)
            SeS.gun1          = data.gun1
            SeS.gun1_ammo     = data.gun1_ammo
            SeS.gun1_marker   = json.decode(data.gun1_marker)
            SeS.gun2          = data.gun2
            SeS.gun2_ammo     = data.gun2_ammo
            SeS.gun2_marker   = json.decode(data.gun2_marker)
            SeS.skin1_male    = json.decode(data.skin1_male)
            SeS.skin1_female  = json.decode(data.skin1_female)
            SeS.skin1_marker  = json.decode(data.skin1_marker)
            SeS.skin2_male    = json.decode(data.skin2_male)
            SeS.skin2_female  = json.decode(data.skin2_female)
            SeS.skin2_marker  = json.decode(data.skin2_marker)
        end
    end)
end)

RegisterCommand('event', function(source, args)
    local playerPed = GetPlayerPed(-1)
    local coords   = GetEntityCoords(playerPed)
    local inParking  = GetDistanceBetweenCoords(coords, 225.55, -786.38, 30.73, true) < 50
    TriggerEvent('SeS_events:sync')
    if SeS.status == 1 then
        if inParking then
            DakheleEvent = true

            SetCanPedEquipAllWeapons(playerPed, false)
            if SeS.gun1 ~= nil then
                SetCanPedSelectWeapon(PlayerPedId(), GetHashKey(SeS.gun1), true)
            end
            if SeS.gun2 ~= nil then
                SetCanPedSelectWeapon(PlayerPedId(), GetHashKey(SeS.gun2), true)
            end
            SetCanPedSelectWeapon(playerPed, 0xA2719263, true)

            RequestCollisionAtCoord(SeS.tp.x, SeS.tp.y, SeS.tp.z)
            while not HasCollisionLoadedAroundEntity(playerPed) do
                RequestCollisionAtCoord(SeS.tp.x, SeS.tp.y, SeS.tp.z)
                Citizen.Wait(1)
            end
            SetEntityCoords(playerPed, SeS.tp.x, SeS.tp.y, SeS.tp.z)
                    
            TriggerEvent('esx_basicneeds:healPlayer', source)
            SetPedArmour(playerPed, SeS.vest)

            TriggerEvent("chatMessage", "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Vared Event Shodid, Heal Shoma Poor Va Armor Shoma Bar Asas Event Set Shod Ke Dar Makan Haye Moshakhash Shode Mitonid Mashin, Aslahe Va Lebas Khod Ra Taghir Dahid")
        else
            TriggerEvent("chatMessage", "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Baraye Voroud Be Event Bayad Dakhele Mohavate Parking Markazi Bashid")
        end
    else
        TriggerEvent("chatMessage", "[EVENT SYSTEM]", {255, 0, 0}, " ^0Event Baste Shode Ya Sakhte Nashode Ast")
    end
end, false)

RegisterCommand('exitevent', function(source, args, user)
    local playerPed = GetPlayerPed(-1)
    local coords   = GetEntityCoords(playerPed)
    
    DakheleEvent = false

    if HasPedGotWeapon(playerPed, GetHashKey(SeS.gun1), false) then
        RemoveWeaponFromPed(playerPed, GetHashKey(SeS.gun1))
    end
    if HasPedGotWeapon(playerPed, GetHashKey(SeS.gun2), false) then
        RemoveWeaponFromPed(playerPed, GetHashKey(SeS.gun2))
    end

    TriggerEvent("esx_ambulancejob:reviveJLkiramdahansoheil", source)

    Wait(2000)
    RequestCollisionAtCoord(225.55, -786.38, 30.73)
    while not HasCollisionLoadedAroundEntity(playerPed) do
        RequestCollisionAtCoord(225.55, -786.38, 30.73)
        Citizen.Wait(1)
    end
    SetEntityCoords(playerPed, 225.55, -786.38, 30.73)
	SES.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin)
        TriggerEvent("skinchanger:loadSkin", skin)
    end)
end, false)

TriggerEvent('chat:addSuggestion', '/event', 'Vared Shodan Be Event', {})
TriggerEvent('chat:addSuggestion', '/exitevent', 'Khoroj Az Event', {})

function OpenCarMenu(station)
    local elements = {}

    if SeS.car1 ~= nil then
        local aheadVehName1 = GetDisplayNameFromVehicleModel(SeS.car1)
        local vehicleName1  = GetLabelText(aheadVehName1) 
		table.insert(elements, {label = 'Daryaft ' .. vehicleName1 , value = 'get_veh1'})
	end
    if SeS.car2 ~= nil then
        local aheadVehName2 = GetDisplayNameFromVehicleModel(SeS.car2)
        local vehicleName2  = GetLabelText(aheadVehName2) 
		table.insert(elements, {label = 'Daryaft ' .. vehicleName2 , value = 'get_veh2'})
	end
  
    SES.UI.Menu.CloseAll()

    SES.UI.Menu.Open('default', GetCurrentResourceName(), 'veh', {
        title    = _U('get_car'),
        align    = 'top-right',
        elements = elements,
    }, function(data, menu)

    if data.current.value == "get_veh1" then
        menu.close()
        if SeS.car1 ~= nil then
            if SeS.car_spawn ~= nil then
                SpawnVasileNaghlie(SeS.car1, SeS.car1_plate, SeS.car1_fuel)
            else
                SES.ShowNotification('Mahali Baraye Spawn VasileNaghlie Taeen Nashode, Lotfan Be Admin Etela Dahid')
            end
        else
            SES.ShowNotification('VasileNaghlie Baraye Event Taeen Nashode, Lotfan Be Admin Etela Dahid')
        end
	elseif data.current.value == "get_veh2" then
        menu.close()
        if SeS.car2 ~= nil then
            if SeS.car_spawn ~= nil then
                SpawnVasileNaghlie(SeS.car2, SeS.car2_plate, SeS.car2_fuel)
            else
                SES.ShowNotification('Mahali Baraye Spawn VasileNaghlie Taeen Nashode, Lotfan Be Admin Etela Dahid')
            end
        else
            SES.ShowNotification('VasileNaghlie Baraye Event Taeen Nashode, Lotfan Be Admin Etela Dahid')
        end
	end

    end, function(data, menu)

    menu.close()

    CurrentAction     = 'menu_car'
    CurrentActionMsg  = _U('open_car')
    end)
end

function SetVehicleMaxMods(vehicle, plate, window, colors)
    local plate = string.gsub(plate, "-", "")
    local props

    if colors then
        props = {
            modEngine = 3,
            modSeSakes = 2,
            windowTint = window,
            modArmor = 4,
            modTransmission = 2,
            modSuspension = -1,
            modTurbo = true,
            plate = plate,
            color1 = colors.a,
            color2 = colors.b
        }
    else
        props = {
            modEngine = 3,
            modSeSakes = 2,
            windowTint = window,
            modArmor = 4,
            modTransmission = 2,
            modSuspension = -1,
            modTurbo = true,
            plate = plate
        }
    end

    SES.Game.SetVehicleProperties(vehicle, props)
    SetVehicleDirtLevel(vehicle, 0.0)
end

function SpawnVasileNaghlie(vehicle, plate, fuel)
    local nazdik = GetClosestVehicle(SeS.car_spawn.x,  SeS.car_spawn.y,  SeS.car_spawn.z,  3.0,  0,  71)
    if not DoesEntityExist(nazdik) then
        SES.Game.SpawnVehicle(vehicle, {
            x = SeS.car_spawn.x+math.random(-10.0, 20.0),
            y = SeS.car_spawn.y+math.random(10.0, 20.0),
            z = SeS.car_spawn.z + 1
        }, SeS.car_spawn.h, function(callback_vehicle)
        SetVehicleMaxMods(callback_vehicle, plate, 1)
        SetVehRadioStation(callback_vehicle, "OFF")
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
        Wait(2800)
        SetVehicleFuelLevel(GetVehiclePedIsIn(PlayerPedId()), tonumber(fuel)+0.0)
        end)
    else
        SES.ShowNotification('Sabr Konid Ta Mahale Spawn Khali Shavad')
    end
end

function OpenGunMenu(type)
	local elements = {}

    if SeS.gun1 ~= nil then
		table.insert(elements, {label = 'Daryaft ' .. SES.GetWeaponLabel(SeS.gun1), value = 'get_gun1'})
	end
    if SeS.gun2 ~= nil then
		table.insert(elements, {label = 'Daryaft ' .. SES.GetWeaponLabel(SeS.gun2), value = 'get_gun2'})
	end

    SES.UI.Menu.CloseAll()

    SES.UI.Menu.Open('default', GetCurrentResourceName(), 'get_gun', {
        title    = _U('get_gun'),
        align    = 'top-right',
        elements = elements
    }, function(data, menu)
  
    if data.current.value == "get_gun1" then
        menu.close()
        if SeS.gun1 ~= nil then
            if SeS.gun1_ammo ~= nil then
                GiveWeaponToPed(PlayerPedId(), GetHashKey(SeS.gun1), SeS.gun1_ammo, false, true)
            else
                SES.ShowNotification('Tedad Tir Aslahe Baraye Event Taeen Nashode, Lotfan Be Admin Etela Dahid')
            end
        else
            SES.ShowNotification('Aslaheii Baraye Event Taeen Nashode, Lotfan Be Admin Etela Dahid')
        end
    elseif data.current.value == "get_gun2" then
        menu.close()
        if SeS.gun2 ~= nil then
            if SeS.gun2_ammo ~= nil then
                GiveWeaponToPed(PlayerPedId(), GetHashKey(SeS.gun2), SeS.gun2_ammo, false, true)
            else
                SES.ShowNotification('Tedad Tir Aslahe Baraye Event Taeen Nashode, Lotfan Be Admin Etela Dahid')
            end
        else
            SES.ShowNotification('Aslaheii Baraye Event Taeen Nashode, Lotfan Be Admin Etela Dahid')
        end
    end

    end, function(data, menu)

    menu.close()

    CurrentAction     = 'menu_gun'
    CurrentActionMsg  = _U('open_gun')
    end)
end


function OpenSkinMenu()

    local elements = {
        {label = _U('citizen_wear'), value = 'citizen_wear'},
    }

    if SeS.skin1_marker ~= nil then
		table.insert(elements, {label = 'Daryaft Lebas Team Aval' , value = 'get_skin1'})
	end
    if SeS.skin2_marker ~= nil then
		table.insert(elements, {label = 'Daryaft Lebas Team Dovom', value = 'get_skin2'})
	end
  
    SES.UI.Menu.CloseAll()
  
    SES.UI.Menu.Open('default', GetCurrentResourceName(), 'get_skin', {
        title    = _U('get_skin'),
        align    = 'top-right',
        elements = elements,
    }, function(data, menu)
    
        menu.close()

        if data.current.value == 'citizen_wear' then
            SES.TriggerServerCallback("esx_skin:getPlayerSkin", function(skin)
                TriggerEvent("skinchanger:loadSkin", skin)
            end)
        elseif data.current.value == 'get_skin1' then
            TriggerEvent("skinchanger:getSkin", function(skin)
                if skin.sex == 0 then
                    if SeS.skin1_male ~= nil then
                        TriggerEvent("skinchanger:loadClothes", skin, SeS.skin1_male)
                    else
                        SES.ShowNotification(_U("no_outfit"))
                    end
                else
                    if SeS.skin1_female ~= nil then
                        TriggerEvent("skinchanger:loadClothes", skin, SeS.skin1_female)
                    else
                        SES.ShowNotification(_U("no_outfit"))
                    end
                end
            end)
        elseif data.current.value == 'get_skin2' then
            TriggerEvent("skinchanger:getSkin", function(skin)
                if skin.sex == 0 then
                    if SeS.skin2_male ~= nil then
                        TriggerEvent("skinchanger:loadClothes", skin, SeS.skin2_male)
                    else
                        SES.ShowNotification(_U("no_outfit"))
                    end
                else
                    if SeS.skin2_female ~= nil then
                        TriggerEvent("skinchanger:loadClothes", skin, SeS.skin2_female)
                    else
                        SES.ShowNotification(_U("no_outfit"))
                    end
                end
            end)
        end
  
        end, function(data, menu)
  
        menu.close()
  
        CurrentAction     = 'menu_skin'
        CurrentActionMsg  = _U('open_skin')
    end)
end

-- Sakht Marker
Citizen.CreateThread(function()
    while true do
        Wait(0)
        
        local playerPed = GetPlayerPed(-1)
        local coords    = GetEntityCoords(playerPed)
        if SeS.status == 1 then
            if SeS.car1_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  SeS.car1_marker.x,  SeS.car1_marker.y,  SeS.car1_marker.z,  true) < Config.DrawDistance then
                    DrawMarker(Config.CarMarkerType, SeS.car1_marker.x,  SeS.car1_marker.y,  SeS.car1_marker.z-0.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.CarMarkerSize.x, Config.CarMarkerSize.y, Config.CarMarkerSize.z, Config.CarMarkerColor.r, Config.CarMarkerColor.g, Config.CarMarkerColor.b, 100, false, true, 2, true, false, false, false)
                end
            end
            if SeS.car2_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  SeS.car2_marker.x,  SeS.car2_marker.y,  SeS.car2_marker.z,  true) < Config.DrawDistance then
                    DrawMarker(Config.CarMarkerType, SeS.car2_marker.x,  SeS.car2_marker.y,  SeS.car2_marker.z-0.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.CarMarkerSize.x, Config.CarMarkerSize.y, Config.CarMarkerSize.z, Config.CarMarkerColor.r, Config.CarMarkerColor.g, Config.CarMarkerColor.b, 100, false, true, 2, true, false, false, false)
                end
            end
            
            if SeS.gun1_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  SeS.gun1_marker.x,  SeS.gun1_marker.y,  SeS.gun1_marker.z,  true) < Config.DrawDistance then
                    DrawMarker(Config.GunMarkerType, SeS.gun1_marker.x,  SeS.gun1_marker.y,  SeS.gun1_marker.z-0.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.GunMarkerSize.x, Config.GunMarkerSize.y, Config.GunMarkerSize.z, Config.GunMarkerColor.r, Config.GunMarkerColor.g, Config.GunMarkerColor.b, 100, false, true, 2, true, false, false, false)
                end
            end
            if SeS.gun2_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  SeS.gun2_marker.x,  SeS.gun2_marker.y,  SeS.gun2_marker.z,  true) < Config.DrawDistance then
                    DrawMarker(Config.GunMarkerType, SeS.gun2_marker.x,  SeS.gun2_marker.y,  SeS.gun2_marker.z-0.1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.GunMarkerSize.x, Config.GunMarkerSize.y, Config.GunMarkerSize.z, Config.GunMarkerColor.r, Config.GunMarkerColor.g, Config.GunMarkerColor.b, 100, false, true, 2, true, false, false, false)
                end
            end
            
            if SeS.skin1_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  SeS.skin1_marker.x,  SeS.skin1_marker.y,  SeS.skin1_marker.z,  true) < Config.DrawDistance then
                    DrawMarker(Config.SkinMarkerType, SeS.skin1_marker.x,  SeS.skin1_marker.y,  SeS.skin1_marker.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.SkinMarkerSize.x, Config.SkinMarkerSize.y, Config.SkinMarkerSize.z, Config.SkinMarkerColor.r, Config.SkinMarkerColor.g, Config.SkinMarkerColor.b, 100, false, true, 2, true, false, false, false)
                end
            end
            if SeS.skin2_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  SeS.skin2_marker.x,  SeS.skin2_marker.y,  SeS.skin2_marker.z,  true) < Config.DrawDistance then
                    DrawMarker(Config.SkinMarkerType, SeS.skin2_marker.x,  SeS.skin2_marker.y,  SeS.skin2_marker.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.SkinMarkerSize.x, Config.SkinMarkerSize.y, Config.SkinMarkerSize.z, Config.SkinMarkerColor.r, Config.SkinMarkerColor.g, Config.SkinMarkerColor.b, 100, false, true, 2, true, false, false, false)
                end
            end
        end
    end
end)
    
Citizen.CreateThread(function()
    while true do
        Wait(0)
        
        local playerPed      = GetPlayerPed(-1)
        local coords         = GetEntityCoords(playerPed)
        local isInMarker     = false
        local currentPart    = nil
        
        if SeS.status == 1 then
            if SeS.car1_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  SeS.car1_marker.x,  SeS.car1_marker.y,  SeS.car1_marker.z,  true) < Config.CarMarkerSize.x then
                isInMarker     = true
                currentPart    = 'Car'
                end
            end
            if SeS.car2_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  SeS.car2_marker.x,  SeS.car2_marker.y,  SeS.car2_marker.z,  true) < Config.CarMarkerSize.x then
                isInMarker     = true
                currentPart    = 'Car'
                end
            end
            
            if SeS.gun1_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  SeS.gun1_marker.x,  SeS.gun1_marker.y,  SeS.gun1_marker.z,  true) < Config.GunMarkerSize.x then
                isInMarker     = true
                currentPart    = 'Gun'
                end
            end
            if SeS.gun2_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  SeS.gun2_marker.x,  SeS.gun2_marker.y,  SeS.gun2_marker.z,  true) < Config.GunMarkerSize.x then
                isInMarker     = true
                currentPart    = 'Gun'
                end
            end
            
            if SeS.skin1_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  SeS.skin1_marker.x,  SeS.skin1_marker.y,  SeS.skin1_marker.z,  true) < Config.SkinMarkerSize.x then
                isInMarker     = true
                currentPart    = 'Skin'
                end
            end
            if SeS.skin2_marker ~= nil then
                if GetDistanceBetweenCoords(coords,  SeS.skin2_marker.x,  SeS.skin2_marker.y,  SeS.skin2_marker.z,  true) < Config.SkinMarkerSize.x then
                isInMarker     = true
                currentPart    = 'Skin'
                end
            end
            
            local hasExited = false
                
            if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastPart ~= currentPart)) then
                if (LastPart ~= nil) and (LastPart ~= currentPart) then
                    TriggerEvent('SeS_events:hasExitedMarker', LastPart)
                    hasExited = true
                end
                HasAlreadyEnteredMarker = true
                LastPart                = currentPart
            
                TriggerEvent('SeS_events:hasEnteredMarker', currentPart)
            end
            
            if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
            
                HasAlreadyEnteredMarker = false
            
                TriggerEvent('SeS_events:hasExitedMarker', LastPart)
            end
        end
    end
end)

AddEventHandler('SeS_events:hasEnteredMarker', function(part)
    if part == 'Car' then
        CurrentAction     = 'menu_car'
        CurrentActionMsg  = _U('open_car')
    end
        
    if part == 'Gun' then
        CurrentAction     = 'menu_gun'
        CurrentActionMsg  = _U('open_gun')
    end
        
    if part == 'Skin' then
        CurrentAction     = 'menu_skin'
        CurrentActionMsg  = _U('open_skin')
    end  
end)
        
AddEventHandler('SeS_events:hasExitedMarker', function(part)
    SES.UI.Menu.CloseAll()
    CurrentAction = nil
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if CurrentAction ~= nil then
            SetTextComponentFormat('STRING')
            AddTextComponentString(CurrentActionMsg)
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
        
            if IsControlPressed(0, 38) and (GetGameTimer() - GUI.Time) > 150 then
                if CurrentAction == 'menu_car' then
                    OpenCarMenu()
                elseif CurrentAction == 'menu_gun' then
                    OpenGunMenu()
                elseif CurrentAction == 'menu_skin' then
                    OpenSkinMenu()
                end
                CurrentAction = nil
                GUI.Time      = GetGameTimer()
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if DakheleEvent then
            SetCanPedEquipAllWeapons(PlayerPedId(), false)
            if SeS.gun1 ~= nil then
                SetCanPedSelectWeapon(PlayerPedId(), GetHashKey(SeS.gun1), true)
            end
            if SeS.gun2 ~= nil then
                SetCanPedSelectWeapon(PlayerPedId(), GetHashKey(SeS.gun2), true)
            end
            SetCanPedSelectWeapon(PlayerPedId(), 0xA2719263, true)
        else
            SetCanPedEquipAllWeapons(PlayerPedId(), true)
        end
        Citizen.Wait(5000)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if DakheleEvent then
            DisableControlAction(2, 166, true)
            DisableControlAction(2, 167, true)
        else
            Citizen.Wait(5000)
        end
    end
end)