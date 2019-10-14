--====================================================================================
-- #Author: Olle Strand | Cünter#1634
-- #Version 0.1
--====================================================================================
RegisterServerEvent('serverlog')
AddEventHandler('serverlog', function(text)
	local gt = os.date('*t')
	local f,err = io.open("serverlog.log","a")
	if not f then return print(err) end
	local h = gt['hour'] if h < 10 then h = "0"..h end
	local m = gt['min'] if m < 10 then m = "0"..m end
	local s = gt['sec'] if s < 10 then s = "0"..s end
	local formattedlog = string.format("[%s:%s:%s] %s \n",h,m,s,text)
	f:write(formattedlog)
	f:close()
	-- uncomment line below, if you need (to show all logs in console also)
	print(formattedlog)
end)

function GetUserJobLevel(identifier)
    local result = MySQL.Sync.fetchAll("SELECT users.job_grade FROM users WHERE users.identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].job_grade
    end
    return nil
end

function GetUser(username, password, cb)
  MySQL.Async.fetchAll("SELECT * FROM mdt_accounts WHERE mdt_accounts.username = @username AND mdt_accounts.password = @password", {
    ['@username'] = username,
    ['@password'] = password
  }, function (data)
    cb(data[1])
  end)
end

function GetCitizen(name, surname, cb)
  MySQL.Async.fetchAll("SELECT dateofbirth, sex, height, identifier FROM users WHERE users.firstname = @name AND users.lastname = @surname", {
    ['@name'] = name,
    ['@surname'] = surname
  }, function (data)
    cb(data[1])
  end)
end

function GetVehicle(plate, cb)
	MySQL.Async.fetchAll("SELECT identifier, vehicle, job FROM owned_vehicles WHRE owned_vehicles.plate = @plate", {
		['@plate'] = plate
	}, function (data)
			local vehicle = json.decode(data[1].vehicle)
			table.insert(car, {vehicle = vehicle, plate = v.plate, identifier = data[1].identifier})
		cb(car)
	end)
end

function GetVehicleOwner(identifier, cb)
	MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE users.identifier = @identifier", {
		['@identifier'] = identifier
	}, function (data)
		cb(data[1])
	end)
end


-- ====================================================================================
-- Events that JS can access
-- ====================================================================================

RegisterServerEvent('gcPhone:mdt_getUserJobLevel')
AddEventHandler('gcPhone:mdt_getUserJobLevel', function(identifier)
  GetUserJobLevel(identifier)
end)

RegisterServerEvent('gcPhone:mdt_loginRequest')
AddEventHandler('gcPhone:mdt_loginRequest', function(username, password)
  local sourcePlayer = tonumber(source)

  GetUser(username, password, function (user)
    if user ~= nil then
			TriggerEvent("serverlog", "Admin:" .. user.adminlevel .. " | ID:" .. user.id)
      TriggerClientEvent('gcPhone:mdt_login', sourcePlayer, username, password, user.work, user.id, tonumber(user.adminlevel))
		end
  end)
end)

RegisterServerEvent('gcPhone:mdt_citizenRequest')
AddEventHandler('gcPhone:mdt_citizenRequest', function(firstname, lastname)
  local sourcePlayer = tonumber(source)

  GetCitizen(firstname, lastname, function (citizen)
    if user ~= nil then
      TriggerClientEvent('gcPhone:mdt_updateCitizen', sourcePlayer, firstname, lastname, citizen.dateofbirth, citizen.sex, citizen.height, citizen.identifier)
		end
  end)
end)

RegisterServerEvent('gcPhone:mdt_vehicleRequest')
AddEventHandler('gcPhone:mdt_vehicleRequest', function(plate)
	local sourceplayer = tonumber(source)

	GetVehicle(plate, function (veh)
		if vehicle ~= nil then
			GetVehicleOwner(vehicle.identifier, function(owner)
				local hashVehicle = veh.vehicle.model
				local vehicleModel = GetDisplayNameFromVehicleModel(hashVehicle)
				TriggerClientEvent('gcPhone:mdt_updateVehicle', sourcePlayer, owner.firstname, owner.lastname, plate, vehicleModel)
			end)
		end
	end)
end)
