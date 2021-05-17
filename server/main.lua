SES = nil
TriggerEvent('esx:getSharedObject', function(obj) SES = obj end)

TriggerEvent('es:addAdminCommand', 'eventdata', 13, function(source, args, user)
    local _source = source
    local xPlayer = SES.GetPlayerFromId(_source)
    local playerpos = xPlayer.coords



    if args[1] then
        if args[1] == 'create' then
            local Pos = {x = playerpos.x, y = playerpos.y, z = playerpos.z +0.5} 
            TriggerEvent('SeS_events:create', Pos, _source)
        elseif args[1] == 'delete' then
            TriggerEvent('SeS_events:delete', _source)
        elseif args[1] == 'status' then
            if args[2] == 'true' or args[2] == 'false' then
                TriggerEvent('SeS_events:changestatus', args[2], _source)
            else
                TriggerClientEvent('chatMessage', source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Dar Ghesmat Status Bayad true Ya false Vared")
            end
        elseif args[1] == 'remove' then
            if args[2] == 'car1' or args[2] == 'car2' then
                TriggerEvent('SeS_events:removecar', args[2], _source)
            elseif args[2] == 'gun1' or args[2] == 'gun2'then
                TriggerEvent('SeS_events:removegun', args[2], _source)
            elseif args[2] == 'skin1' or args[2] == 'skin2' then
                TriggerEvent('SeS_events:removeskin', args[2], _source)
            else
                TriggerClientEvent('chatMessage', source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Dar Ghesmat Akhar Remove Bayad Yeki Az Option Haye car1, car2, gun1, gun2, skin1, skin2 Vared Konid")
            end
        elseif args[1] == 'sync' then
            local aPlayers = SES.GetPlayers()
            for i=1, #aPlayers, 1 do
                TriggerClientEvent('SeS_events:sync', aPlayers[i])
            end
            TriggerClientEvent('chatMessage', source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Option Haye Event Baraye Tamami Player Ha Sync Shod")
        elseif args[1] == 'vest' then
            if tonumber(args[2]) then
				local armor = tonumber(args[2])
                if armor <= 100 then
                    TriggerEvent('SeS_events:changevest', args[2], _source)
                else
                    TriggerClientEvent('chatMessage', source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Nemitavanid Meghdar Armor Ra Bishtar Az 100 Set Konid")
                end
            else
                TriggerClientEvent('chatMessage', source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Dar Ghesmat Armor Faghat Mitavanid Adad Vared Konid")
            end
        elseif args[1] == 'car1' or args[1] == 'car2' then
            if args[2] then
                if args[3] then
                    if tonumber(args[4]) then 
                        local ben = tonumber(args[4])
                        if ben <= 100 then
                            local Pos = {x = playerpos.x, y = playerpos.y, z = playerpos.z}
                            TriggerEvent('SeS_events:changecar', args[1], args[2], args[3], args[4], Pos, _source)
                        else
                            TriggerClientEvent('chatMessage', source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Nemitavanid Meghdar Benzin Ra Bishtar Az 100 Set Konid")
                        end
                    else
                        TriggerClientEvent('chatMessage', source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Dar Ghesmat Benzin Faghat Mitavanid Adad Vared Konid")
                    end
                else
                    TriggerClientEvent('chatMessage', source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Dar Ghesmat Pelak Mashin Chizi Vared Nakardid")
                end
            else
                TriggerClientEvent('chatMessage', source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Dar Ghesmat VasileNaghlie Chizi Vared Nakardid")
            end
        elseif args[1] == 'carspawn' then
            local Pos = {x = playerpos.x, y = playerpos.y, z = playerpos.z , h = xPlayer.angel }
            TriggerEvent('SeS_events:changecarspawn', Pos, _source)
        elseif args[1] == 'gun1' or args[1] == 'gun2' then
            if args[2]:find('weapon_') or args[2]:find('WEAPON_')then
                if tonumber(args[3]) then
                    local Pos = {x = playerpos.x, y = playerpos.y, z = playerpos.z}
                    TriggerEvent('SeS_events:changegun', args[1], args[2], args[3], Pos, _source)
                else
                    TriggerClientEvent('chatMessage', source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Dar Ghesmat Tedad Tir Faghat Mitavanid Adad Vared Konid")
                end
            else
                TriggerClientEvent('chatMessage', source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Dar Ghesmat Model Aslahe Bayad Az WEAPON_(Esm Aslahe) Estefade Konid")
            end
       elseif args[1] == 'skin1' or args[1] == 'skin2' then
            if tonumber(args[2]) then
                if GetPlayerName(args[2]) then
                    local Pos = {x = playerpos.x, y = playerpos.y, z = playerpos.z}
                    TriggerEvent('SeS_events:changeskin', args[1], args[2], Pos, _source)
                else
                    TriggerClientEvent('chatMessage', source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Player Vared Shode Vojod Nadarad")
                end
            else
                TriggerClientEvent('chatMessage', source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Dar Ghesmat ID Player Faghat Mitavanid Adad Vared Konid")
            end
        else
            TriggerClientEvent('chatMessage', source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Shoma Dar Ghesmat Option Faghat Bayad Yeki Az Option Haye create, delete, remove, sync, status, vest, car1, car2, carspawn, gun1, gun2, skin1, skin2 Ra Vared Konid")
        end
    else
        TriggerClientEvent('chatMessage', source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Syntax Vared Shode Eshtebah Ast")
    end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Shoma Ejaze Estefade Az In Dastor Ra Nadarid!' } })
end, {help = "Taghir Option Haye Event", params = {{name = "Noe Taghir", help = "create, delete, remove, sync, status, vest, car1, car2, carspawn, gun1, gun2, skin1, skin2"}}})


SES.RegisterServerCallback('SeS_events:getData', function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM events_data', {}, function(data)
		cb(data[1])
    end)
end)

RegisterNetEvent('SeS_events:create')
AddEventHandler('SeS_events:create', function(pos, source)
    MySQL.Async.fetchAll('SELECT * FROM events_data', {}, function(data)
		if data[1] == nil then
			MySQL.Async.execute('INSERT INTO `events_data` (`status`, `tp`, `vest`) VALUES (1, @pos, 0)', {
				['@pos'] = json.encode(pos)
			}, function(rowsChanged)
				if rowsChanged > 0 then
					TriggerClientEvent('esx:ShowNotification', source, 'Shoma Ba Movafaghiyat Event Ra Sakhtid')
					TriggerClientEvent('SeS_events:sync', source)
				end
			end)
		else
			TriggerClientEvent('chatMessage', source, "[EVENT SYSTEM]", {255, 0, 0}, " ^0Dar Hal Hazer Yek Event Vojod Darad, Ebteda Ba Estefade Az ^2/eventdata delete ^0Event Ra Hazf Karde Va Sepas Besazid")
		end
    end)
end)

RegisterNetEvent('SeS_events:delete')
AddEventHandler('SeS_events:delete', function(source)
	MySQL.Async.fetchAll('SELECT * FROM events_data', {}, function(data)
		if data[1] ~= nil then
			MySQL.Async.execute('UPDATE events_data SET status = 0', {})
			TriggerClientEvent('SeS_events:sync', source)
			Wait(4000)
			MySQL.Async.execute('DELETE FROM events_data', {}, function(rowsChanged)
				if rowsChanged > 0 then
					TriggerClientEvent('esx:ShowNotification', source, 'Shoma Ba Movafaghiyat Event Ra Hazf Kardid')
				end
			end)
		else
			TriggerClientEvent('esx:ShowNotification', source, 'Eventi Baraye Pak Kardan Vojod Nadarad!')
		end
	end)
end)

RegisterNetEvent('SeS_events:changestatus')
AddEventHandler('SeS_events:changestatus', function(tf, source)
    local st
    local nt
    if tf == 'true' then
        st = 1
        nt = ' Baz Kardid'
    elseif tf == 'false' then
        st = 0
        nt = ' Bastid'
    end

    MySQL.Async.execute('UPDATE events_data SET status = @tf', {
        ['@tf'] = st
    }, function(rowsChanged)
        if rowsChanged > 0 then
            TriggerClientEvent('esx:ShowNotification', source, 'Shoma Ba Movafaghiyat Event Ra' .. nt)
            TriggerClientEvent('SeS_events:sync', source)
        end
    end)
end)

RegisterNetEvent('SeS_events:changecar')
AddEventHandler('SeS_events:changecar', function(type, model, plate, benzin, pos, source)
    if type == 'car1' then
        MySQL.Async.execute('UPDATE events_data SET car1 = @model, car1_plate = @plate, car1_fuel = @benzin, car1_marker = @pos', {
            ['@model'] = model,
            ['@plate'] = string.upper(plate),
            ['@benzin'] = benzin,
            ['@pos'] = json.encode(pos),
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('esx:ShowNotification', source, 'Shoma Ba Movafaghiyat Vasile Naghlie Aval Ba Model '..model..' Ba Pelak '..plate..' Ba ' ..benzin.. ' Benzin Baraye Event Gharar Dadid')
                TriggerClientEvent('SeS_events:sync', source)
            end
        end)
    elseif type == 'car2' then
        MySQL.Async.execute('UPDATE events_data SET car2 = @model, car2_plate = @plate, car2_fuel = @benzin, car2_marker = @pos', {
            ['@model'] = model,
            ['@plate'] = string.upper(plate),
            ['@benzin'] = benzin,
            ['@pos'] = json.encode(pos),
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('esx:ShowNotification', source, 'Shoma Ba Movafaghiyat Vasile Naghlie Dovom Ba Model'..model..' Ba Pelak '..plate..' Ba ' ..benzin.. ' Benzin Baraye Event Gharar Dadid')
                TriggerClientEvent('SeS_events:sync', source)
            end
        end)
    end
end)

RegisterNetEvent('SeS_events:changecarspawn')
AddEventHandler('SeS_events:changecarspawn', function(pos, source)
    MySQL.Async.execute('UPDATE events_data SET car_spawn = @pos', {
        ['@pos'] = json.encode(pos)
    }, function(rowsChanged)
        if rowsChanged > 0 then
            TriggerClientEvent('esx:ShowNotification', source, 'Shoma Ba Movafaghiyat Mahale Spawn Vasile Naghlie Baraye Event Gharar Dadid')
            TriggerClientEvent('SeS_events:sync', source)
        end
    end)
end)

RegisterNetEvent('SeS_events:changegun')
AddEventHandler('SeS_events:changegun', function(type, name, tir, pos, source)
    if type == 'gun1' then
        MySQL.Async.execute('UPDATE events_data SET gun1 = @name, gun1_ammo = @tir, gun1_marker = @pos', {
            ['@name'] = string.upper(name),
            ['@tir'] = tir,
            ['@pos'] = json.encode(pos)
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('esx:ShowNotification', source, 'Shoma Ba Movafaghiyat Gun Aval '..SES.GetWeaponLabel(name)..' Ba '..tir..' Tir Baraye Event Gharar Dadid')
                TriggerClientEvent('SeS_events:sync', source)
            end
        end)
    elseif type == 'gun2' then
        MySQL.Async.execute('UPDATE events_data SET gun2 = @name, gun2_ammo = @tir, gun2_marker = @pos', {
            ['@name'] = string.upper(name),
            ['@tir'] = tir,
            ['@pos'] = json.encode(pos)
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('esx:ShowNotification', source, 'Shoma Ba Movafaghiyat Gun Dovom '..SES.GetWeaponLabel(name)..' Ba '..tir..' Tir Baraye Event Gharar Dadid')
                TriggerClientEvent('SeS_events:sync', source)
            end
        end)
    end
end)

RegisterNetEvent('SeS_events:changevest')
AddEventHandler('SeS_events:changevest', function(meghdar, source)
    MySQL.Async.execute('UPDATE events_data SET vest = @meghdar', {
        ['@meghdar'] = meghdar,
    }, function(rowsChanged)
        if rowsChanged > 0 then
            TriggerClientEvent('esx:ShowNotification', source, 'Shoma Ba Movafaghiyat Meghdar %' .. meghdar .. ' Vest Voroudi Baraye Event Gharar Dadid')
            TriggerClientEvent('SeS_events:sync', source)
        end
    end)
end)

RegisterNetEvent('SeS_events:changeskin')
AddEventHandler('SeS_events:changeskin', function(type, player, pos, source)
    local xPlayer = SES.GetPlayerFromId(player)

    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(users)

        local user = users[1]
        local skin = nil

        if user.skin ~= nil then
            skin = json.decode(user.skin)
        end

        if skin.sex == 0 then
            if type == 'skin1' then
                MySQL.Async.execute('UPDATE events_data SET skin1_male = @skin, skin1_marker = @pos', {
                    ['@skin'] = json.encode(skin),
                    ['@pos'] = json.encode(pos)
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        TriggerClientEvent('esx:ShowNotification', source, 'Shoma Ba Movafaghiyat Lebas Khod Ra Baraye Lebas Mard Team Aval Event Gharar Dadid')
                        TriggerClientEvent('SeS_events:sync', source)
                    end
                end)
            elseif type == 'skin2' then
                MySQL.Async.execute('UPDATE events_data SET skin2_male = @skin, skin2_marker = @pos', {
                    ['@skin'] = json.encode(skin),
                    ['@pos'] = json.encode(pos)
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        TriggerClientEvent('esx:ShowNotification', source, 'Shoma Ba Movafaghiyat Lebas Khod Ra Baraye Lebas Mard Team Dovom Event Gharar Dadid')
                        TriggerClientEvent('SeS_events:sync', source)
                    end
                end)
            end
        else
            if type == 'skin1' then
                MySQL.Async.execute('UPDATE events_data SET skin1_female = @skin, skin1_marker = @pos', {
                    ['@skin'] = json.encode(skin),
                    ['@pos'] = json.encode(pos)
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        TriggerClientEvent('esx:ShowNotification', source, 'Shoma Ba Movafaghiyat Lebas Khod Ra Baraye Lebas Zan Team Aval Event Shomare Gharar Dadid')
                        TriggerClientEvent('SeS_events:sync', source)
                    end
                end)
            elseif type == 'skin2' then
                MySQL.Async.execute('UPDATE events_data SET skin2_female = @skin, skin2_marker = @pos', {
                    ['@skin'] = json.encode(skin),
                    ['@pos'] = json.encode(pos)
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        TriggerClientEvent('esx:ShowNotification', source, 'Shoma Ba Movafaghiyat Lebas Khod Ra Baraye Lebas Zan Team Dovom Event Shomare Gharar Dadid')
                        TriggerClientEvent('SeS_events:sync', source)
                    end
                end)
            end
        end
    end)
end)

RegisterNetEvent('SeS_events:removecar')
AddEventHandler('SeS_events:removecar', function(type, source)
    if type == 'car1' then
        MySQL.Async.execute('UPDATE events_data SET car1 = NULL, car1_plate = NULL, car1_fuel = NULL, car1_marker = NULL', {}, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('esx:ShowNotification', source, 'Shoma Ba Movafaghiyat Option VasileNaghlie Aval Event Ra Reset Kardid')
                TriggerClientEvent('SeS_events:sync', source)
            end
        end)
    elseif type == 'car2' then
        MySQL.Async.execute('UPDATE events_data SET car2 = NULL, car2_plate = NULL, car2_fuel = NULL, car2_marker = NULL', {}, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('esx:ShowNotification', source, 'Shoma Ba Movafaghiyat Option VasileNaghlie Dovom Event Ra Reset Kardid')
                TriggerClientEvent('SeS_events:sync', source)
            end
        end)
    end
end)

RegisterNetEvent('SeS_events:removegun')
AddEventHandler('SeS_events:removegun', function(type, source)
    if type == 'gun1' then
        MySQL.Async.execute('UPDATE events_data SET gun1 = NULL, gun1_ammo = NULL, gun1_marker = NULL', {}, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('esx:ShowNotification', source, 'Shoma Ba Movafaghiyat Option Aslahe Aval Event Ra Reset Kardid')
                TriggerClientEvent('SeS_events:sync', source)
            end
        end)
    elseif type == 'gun2' then
        MySQL.Async.execute('UPDATE events_data SET gun2 = NULL, gun2_ammo = NULL, gun2_marker = NULL', {}, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('esx:ShowNotification', source, 'Shoma Ba Movafaghiyat Option Aslahe Dovom Event Ra Reset Kardid')
                TriggerClientEvent('SeS_events:sync', source)
            end
        end)
    end
end)

RegisterNetEvent('SeS_events:removeskin')
AddEventHandler('SeS_events:removeskin', function(type, source)
    if type == 'skin1' then
        MySQL.Async.execute('UPDATE events_data SET skin1_male = NULL, skin1_female = NULL, skin1_marker = NULL', {}, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('esx:ShowNotification', source, 'Shoma Ba Movafaghiyat Option Lebas Aval Event Ra Reset Kardid')
                TriggerClientEvent('SeS_events:sync', source)
            end
        end)
    elseif type == 'skin2' then
        MySQL.Async.execute('UPDATE events_data SET skin2_male = NULL, skin2_female = NULL, skin2_marker = NULL', {}, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('esx:ShowNotification', source, 'Shoma Ba Movafaghiyat Option Lebas Dovom Event Ra Reset Kardid')
                TriggerClientEvent('SeS_events:sync', source)
            end
        end)
    end
end)