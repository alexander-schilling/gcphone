--====================================================================================
-- #Author: Jonathan D @Gannon
-- #Version 2.0
--====================================================================================

math.randomseed(os.time())

--- Pour les numero du style XX-XXX
--[[function getPhoneRandomNumber()
    local numBase0 = math.random(10,99)
    local numBase1 = math.random(0,999)
    local num = string.format("%02d-%03d", numBase0, numBase1 )
	return num
end]]
function getPhoneRandomNumber()
	return math.random(900000000,999999999)
end

--- Exemple pour les numero du style 06XXXXXXXX
-- function getPhoneRandomNumber()
--     return '0' .. math.random(600000000,699999999)
-- end


--[[
  Ouverture du téphone lié a un item
  Un solution ESC basé sur la solution donnée par HalCroves
  https://forum.fivem.net/t/tutorial-for-gcphone-with-call-and-job-message-other/177904
--]]

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
    ESX.RegisterServerCallback('gcphone:getItemAmount', function(source, cb, item)
        --print('gcphone:getItemAmount call item : ' .. item)
        local xPlayer = ESX.GetPlayerFromId(source)
        local items = xPlayer.getInventoryItem(item)
        if items == nil then
            cb(0)
        else
            cb(items.count)
        end
    end)
end)


--====================================================================================
--  Utils
--====================================================================================

function getSourceFromCharacter(character, cb)
    if character ~= nil and character.identifier ~= nil and character.characterId ~= nil then
		local yPlayer = ESX.GetPlayerFromIdentifier(character.identifier)
        if yPlayer ~= nil and yPlayer.characterId == character.characterId then
			return yPlayer.source
		else
			return nil
		end
	else
		return nil
	end
end

function getNumberPhone(identifier, charid)
    local result = MySQL.Sync.fetchAll("SELECT characters.phone_number FROM characters WHERE characters.identifier = @identifier AND characters.charid = @charid", {
		['@identifier'] = identifier,
		['@charid']		= charid
	})
	if result[1] ~= nil then
		return result[1].phone_number
	end
	return nil
end

function getCharacterByPhoneNumber(phone_number)
    local result = MySQL.Sync.fetchAll("SELECT characters.identifier, characters.charid FROM characters WHERE characters.phone_number = @phone_number", {
		['@phone_number'] = phone_number
	})
	if result[1] ~= nil then
		local data = {
			identifier = result[1].identifier,
			characterId = result[1].charid
		}
		return data
	end
	return nil
end

function getOrGeneratePhoneNumber(identifier, characterId, cb)
	local myPhoneNumber = getNumberPhone(identifier, characterId)
	if myPhoneNumber == '0' or myPhoneNumber == nil then
		repeat
			myPhoneNumber = getPhoneRandomNumber()
			local id = getCharacterByPhoneNumber(myPhoneNumber)
		until id == nil
		MySQL.Async.execute("UPDATE characters SET phone_number = @myPhoneNumber WHERE identifier = @identifier AND charid = @charid", {
			['@myPhoneNumber'] = myPhoneNumber,
			['@identifier'] = identifier,
			['@charid'] = characterId
		}, function ()
			cb(myPhoneNumber)
		end)
	else
		cb(myPhoneNumber)
	end
end

function generatePhoneNumber(identifier, characterId, cb)
	local myPhoneNumber = getNumberPhone(identifier, characterId)
	local id = ''
	repeat
		myPhoneNumber = getPhoneRandomNumber()
		id = getCharacterByPhoneNumber(myPhoneNumber)
	until id == nil
	MySQL.Async.execute("UPDATE characters SET phone_number = @myPhoneNumber WHERE identifier = @identifier AND charid = @charid", {
		['@myPhoneNumber'] = myPhoneNumber,
		['@identifier'] = identifier,
		['@charid'] = characterId
	}, function ()
		cb(myPhoneNumber)
	end)
end

--====================================================================================
--  Contacts
--====================================================================================
function getContacts(identifier, characterId)
	local result = MySQL.Sync.fetchAll("SELECT * FROM phone_users_contacts WHERE phone_users_contacts.identifier = @identifier AND phone_users_contacts.charid = @charid", {
		['@identifier'] = identifier,
		['@charid'] = characterId
	})
	return result
end

function addContact(source, number, display)
	local sourcePlayer = tonumber(source)
	local xPlayer = ESX.GetPlayerFromId(sourcePlayer)
	MySQL.Async.insert("INSERT INTO phone_users_contacts (`identifier`, `charid`, `number`,`display`) VALUES(@identifier, @charid, @number, @display)", {
		['@identifier'] = xPlayer.identifier,
		['@charid'] = xPlayer.characterId,
		['@number'] = number,
		['@display'] = display,
	},function()
		notifyContactChange(sourcePlayer)
	end)
end

function updateContact(source, id, number, display)
	local sourcePlayer = tonumber(source)
	MySQL.Async.insert("UPDATE phone_users_contacts SET number = @number, display = @display WHERE id = @id", {
		['@number'] = number,
		['@display'] = display,
		['@id'] = id,
	},function()
		notifyContactChange(sourcePlayer)
	end)
end

function deleteContact(source, identifier, characterId, id)
	local sourcePlayer = tonumber(source)
	MySQL.Sync.execute("DELETE FROM phone_users_contacts WHERE `identifier` = @identifier AND `charid` = @charid AND `id` = @id", {
		['@identifier'] = identifier,
		['@charid'] = characterId,
		['@id'] = id
	})
	notifyContactChange(sourcePlayer)
end

function deleteAllContact(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Sync.execute("DELETE FROM phone_users_contacts WHERE `identifier` = @identifier AND `charid` = @charid", {
		['@identifier'] = xPlayer.identifier,
		['@charid'] = xPlayer.characterId
	})
end

function notifyContactChange(source)
	local sourcePlayer = tonumber(source)
	if sourcePlayer ~= nil then
		local xPlayer = ESX.GetPlayerFromId(sourcePlayer)
		if xPlayer ~= nil then
			TriggerClientEvent("gcPhone:contactList", sourcePlayer, getContacts(xPlayer.identifier, xPlayer.characterId))
		end
	end
end

RegisterServerEvent('gcPhone:addContact')
AddEventHandler('gcPhone:addContact', function(display, phoneNumber)
	local sourcePlayer = tonumber(source)
	addContact(sourcePlayer, phoneNumber, display)
end)

RegisterServerEvent('gcPhone:updateContact')
AddEventHandler('gcPhone:updateContact', function(id, display, phoneNumber)
	local sourcePlayer = tonumber(source)
	updateContact(sourcePlayer, id, phoneNumber, display)
end)

RegisterServerEvent('gcPhone:deleteContact')
AddEventHandler('gcPhone:deleteContact', function(id)
	local sourcePlayer = tonumber(source)
	local xPlayer = ESX.GetPlayerFromId(sourcePlayer)
	deleteContact(sourcePlayer, xPlayer.identifier, xPlayer.characterId, id)
end)

--====================================================================================
--  Messages - Olle Strand CUSTOM
--====================================================================================

RegisterServerEvent('gcPhone:addJobToDB')
AddEventHandler('gcPhone:addJobToDB', function(message, department, coordX, coordY, coordZ)
  MySQL.Async.fetchAll("INSERT INTO mdt_jobs (`message`, `department`,`coordX`, `coordY`,`coordZ`) VALUES(@message, @department, @coordX, @coordY, @coordZ);", {
		['@message'] = message,
    ['@department'] = department,
    ['@coordX'] = coordX,
    ['@coordY'] = coordY,
    ['@coordZ'] = coordZ
	})
end)

RegisterServerEvent('gcPhone:mdt_requestJobs')
AddEventHandler('gcPhone:mdt_requestJobs', function(department)
  local sourcePlayer = tonumber(source)

  MySQL.Async.fetchAll("SELECT * FROM mdt_jobs WHERE mdt_jobs.department = @department", {
    ['@department'] = department
  }, function (data)
    for k,v in pairs(data) do
      TriggerClientEvent('gcPhone:mdt_requestJobs', sourcePlayer, data[k].message, data[k].department, data[k].is_assigned, data[k].coordX, data[k].coordY, data[k].coordZ, data[k].id)
    end
  end)
end)

RegisterServerEvent('gcPhone:mdt_updateJob')
AddEventHandler('gcPhone:mdt_updateJob', function(job, user)
  local sourcePlayer = tonumber(source)
  local identifier = getPlayerID(source)

  MySQL.Sync.execute("UPDATE mdt_jobs set is_assigned='1' WHERE id=@id", {
    ['@id'] = job.jobID
  }, function (data)
    autoRespond(source, identifier, job.department, "jobSelected")
  end)
end)

RegisterServerEvent('gcPhone:mdt_removeJob')
AddEventHandler('gcPhone:mdt_removeJob', function(job)
  local sourcePlayer = tonumber(source)

  MySQL.Sync.execute("DELETE FROM `mdt_jobs` WHERE `id` = @id;", {
    ['@id'] = job.jobID
  }, function (data)

  end)
end)

--====================================================================================
--  Messages
--====================================================================================
function autoRespond(source, phone_number, type)
    local message = ""
    if type == "approved" then
      message = "Tu mensaje ha sido recibido. ¡Te responderemos apenas contestemos el llamado!"
    elseif type == "shortMsg" then
      message = "Tu mensaje es muy corto. Por favor, explica más"
    elseif type == "jobSelected" then
      message = "Tu llamado ha sido atendido, ¡vamos en camino!"
    else
      message = "Actualmente hay un error en el sistema, inténtalo más tarde"
    end

    local xPlayer = ESX.GetPlayerFromId(source)
    local myPhone = getNumberPhone(xPlayer.identifier, xPlayer.characterId)

    local tomess = _internalAddMessage(phone_number, myPhone, message, 0)
    TriggerClientEvent("gcPhone:receiveMessage", xPlayer.source, tomess)
end

function getMessages(identifier, characterId)
	local result = MySQL.Sync.fetchAll("SELECT phone_messages.* FROM phone_messages LEFT JOIN characters ON characters.identifier = @identifier AND characters.charid = @charid WHERE phone_messages.receiver = characters.phone_number", {
		['@identifier'] = identifier,
		['@charid']		= characterId
	})
	return result
	--return MySQLQueryTimeStamp("SELECT phone_messages.* FROM phone_messages LEFT JOIN users ON users.identifier = @identifier WHERE phone_messages.receiver = users.phone_number", {['@identifier'] = identifier})
end

RegisterServerEvent('gcPhone:_internalAddMessage')
AddEventHandler('gcPhone:_internalAddMessage', function(transmitter, receiver, message, owner, cb)
    cb(_internalAddMessage(transmitter, receiver, message, owner))
end)

function _internalAddMessage(transmitter, receiver, message, owner)
    local Query = "INSERT INTO phone_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`) VALUES(@transmitter, @receiver, @message, @isRead, @owner);"
    local Query2 = 'SELECT * from phone_messages WHERE `id` = @id;'
	   local Parameters = {
        ['@transmitter'] = transmitter,
        ['@receiver'] = receiver,
        ['@message'] = message,
        ['@isRead'] = owner,
        ['@owner'] = owner
    }


    local id = MySQL.Sync.insert(Query, Parameters)
    return MySQL.Sync.fetchAll(Query2, {
        ['@id'] = id
    })[1]
end

function addMessage(source, phone_number, message)
	local sourcePlayer = ESX.GetPlayerFromId(source)
	local otherPlayer = getCharacterByPhoneNumber(phone_number)
	local myPhone = getNumberPhone(sourcePlayer.identifier, sourcePlayer.characterId)
	if otherPlayer ~= nil and otherPlayer.identifier ~= nil then
		local tomess = _internalAddMessage(myPhone, phone_number, message, 0)
		local target = ESX.GetPlayerFromIdentifier(otherPlayer.identifier)

		if target ~= nil and target.characterId == otherPlayer.characterId then
			TriggerClientEvent("gcPhone:receiveMessage", target.source, tomess)
		end
    end
    local memess = _internalAddMessage(phone_number, myPhone, message, 1)
	TriggerClientEvent("gcPhone:receiveMessage", sourcePlayer.source, memess)
end

function setReadMessageNumber(source, num)
	local xPlayer = ESX.GetPlayerFromId(source)
	local mePhoneNumber = getNumberPhone(xPlayer.identifier, xPlayer.characterId)
	MySQL.Sync.execute("UPDATE phone_messages SET phone_messages.isRead = 1 WHERE phone_messages.receiver = @receiver AND phone_messages.transmitter = @transmitter", {
		['@receiver'] = mePhoneNumber,
		['@transmitter'] = num
	})
end

function deleteMessage(msgId)
	MySQL.Sync.execute("DELETE FROM phone_messages WHERE `id` = @id", {
		['@id'] = msgId
	})
end

function deleteAllMessageFromPhoneNumber(source, phone_number)
	local xPlayer = ESX.GetPlayerFromId(source)
	local mePhoneNumber = getNumberPhone(xPlayer.identifier, xPlayer.characterId)
	MySQL.Sync.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber and `transmitter` = @phone_number", {['@mePhoneNumber'] = mePhoneNumber,['@phone_number'] = phone_number})
end

function deleteAllMessage(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local mePhoneNumber = getNumberPhone(xPlayer.identifier, xPlayer.characterId)
	MySQL.Sync.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber", {
		['@mePhoneNumber'] = mePhoneNumber
	})
end

function deleteAllMessageIdentifier(identifier, characterId)
	local mePhoneNumber = getNumberPhone(identifier, characterId)
	MySQL.Sync.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber", {
		['@mePhoneNumber'] = mePhoneNumber
	})
end

RegisterServerEvent('gcPhone:sendMessage')
AddEventHandler('gcPhone:sendMessage', function(phoneNumber, message)
    local sourcePlayer = tonumber(source)

    addMessage(sourcePlayer, phoneNumber, message)
    if phoneNumber == "police" or phoneNumber == "ambulance" or phoneNumber == "taxi" or phoneNumber == "mechanic" then
      if message:len() >= 10 then
        autoRespond(source, phoneNumber, "approved")
      else
        autoRespond(source, phoneNumber, "shortMsg")
      end
    end
end)

RegisterServerEvent('gcPhone:deleteMessage')
AddEventHandler('gcPhone:deleteMessage', function(msgId)
    deleteMessage(msgId)
end)

RegisterServerEvent('gcPhone:deleteMessageNumber')
AddEventHandler('gcPhone:deleteMessageNumber', function(number)
	local sourcePlayer = tonumber(source)
	deleteAllMessageFromPhoneNumber(sourcePlayer, number)
	-- TriggerClientEvent("gcphone:allMessage", sourcePlayer, getMessages(identifier))
end)

RegisterServerEvent('gcPhone:deleteAllMessage')
AddEventHandler('gcPhone:deleteAllMessage', function()
	local sourcePlayer = tonumber(source)
	deleteAllMessage(sourcePlayer)
end)

RegisterServerEvent('gcPhone:setReadMessageNumber')
AddEventHandler('gcPhone:setReadMessageNumber', function(num)
	local sourcePlayer = tonumber(source)
	setReadMessageNumber(sourcePlayer, num)
end)

RegisterServerEvent('gcPhone:deleteALL')
AddEventHandler('gcPhone:deleteALL', function()
	local sourcePlayer = tonumber(source)
	local xPlayer = ESX.GetPlayerFromId(sourcePlayer)
	deleteAllMessage(sourcePlayer)
	deleteAllContact(sourcePlayer)
	appelsDeleteAllHistorique(xPlayer.identifier, xPlayer.characterId)
	TriggerClientEvent("gcPhone:contactList", sourcePlayer, {})
	TriggerClientEvent("gcPhone:allMessage", sourcePlayer, {})
	TriggerClientEvent("appelsDeleteAllHistorique", sourcePlayer, {})
end)

RegisterServerEvent('gcPhone:changeChip')
AddEventHandler('gcPhone:changeChip', function(source, myPhoneNumber)
	local sourcePlayer = tonumber(source)
	local xPlayer = ESX.GetPlayerFromId(sourcePlayer)

	deleteAllMessage(sourcePlayer)
	appelsDeleteAllHistorique(xPlayer.identifier, xPlayer.characterId)
	TriggerClientEvent("gcPhone:allMessage", sourcePlayer, {})
	TriggerClientEvent("appelsDeleteAllHistorique", sourcePlayer, {})

	TriggerClientEvent("gcPhone:myPhoneNumber", sourcePlayer, myPhoneNumber)

	MySQL.Sync.execute("UPDATE characters SET phone_number = @myPhoneNumber WHERE identifier = @identifier AND charid = @charid", {
		['@myPhoneNumber'] = myPhoneNumber,
		['@identifier'] = xPlayer.identifier,
		['@charid'] = xPlayer.characterId
	}, function ()
		print(xPlayer.identifier .. ' changed his phone number to: ' .. myPhoneNumber)	
	end)
end)

RegisterServerEvent('gcPhone:characterKill')
AddEventHandler('gcPhone:characterKill', function(identifier, characterId)
	deleteAllMessageIdentifier(identifier, characterId)
	appelsDeleteAllHistorique(identifier, characterId)

	generatePhoneNumber(identifier, characterId, function (myPhoneNumber)
		print(identifier .. ' changed his phone number to: ' .. myPhoneNumber .. ' by character kill')	
	end)
end)

--====================================================================================
--  Gestion des appels
--====================================================================================
local AppelsEnCours = {}
local PhoneFixeInfo = {}
local lastIndexCall = 10

function getHistoriqueCall (num)
    local result = MySQL.Sync.fetchAll("SELECT * FROM phone_calls WHERE phone_calls.owner = @num ORDER BY time DESC LIMIT 120", {
        ['@num'] = num
    })
    return result
end

function sendHistoriqueCall (src, num)
    local histo = getHistoriqueCall(num)
    TriggerClientEvent('gcPhone:historiqueCall', src, histo)
end

function saveAppels (appelInfo)
    if appelInfo.extraData == nil or appelInfo.extraData.useNumber == nil then
        MySQL.Async.insert("INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)", {
            ['@owner'] = appelInfo.transmitter_num,
            ['@num'] = appelInfo.receiver_num,
            ['@incoming'] = 1,
            ['@accepts'] = appelInfo.is_accepts
        }, function()
            notifyNewAppelsHisto(appelInfo.transmitter_src, appelInfo.transmitter_num)
        end)
    end
    if appelInfo.is_valid == true then
        local num = appelInfo.transmitter_num
        if appelInfo.hidden == true then
            mun = "###-####"
        end
        MySQL.Async.insert("INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)", {
            ['@owner'] = appelInfo.receiver_num,
            ['@num'] = num,
            ['@incoming'] = 0,
            ['@accepts'] = appelInfo.is_accepts
        }, function()
            if appelInfo.receiver_src ~= nil then
                notifyNewAppelsHisto(appelInfo.receiver_src, appelInfo.receiver_num)
            end
        end)
    end
end

function notifyNewAppelsHisto (src, num)
    sendHistoriqueCall(src, num)
end

RegisterServerEvent('gcPhone:getHistoriqueCall')
AddEventHandler('gcPhone:getHistoriqueCall', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local srcPhone = getNumberPhone(xPlayer.identifier, xPlayer.characterId)
    sendHistoriqueCall(xPlayer.source, num)
end)


RegisterServerEvent('gcPhone:internal_startCall')
AddEventHandler('gcPhone:internal_startCall', function(source, phone_number, rtcOffer, extraData)
    if FixePhone[phone_number] ~= nil then
        onCallFixePhone(source, phone_number, rtcOffer, extraData)
        return
    end

    local rtcOffer = rtcOffer
    if phone_number == nil or phone_number == '' then
        print('BAD CALL NUMBER IS NIL')
        return
    end

    local hidden = string.sub(phone_number, 1, 1) == '#'
    if hidden == true then
        phone_number = string.sub(phone_number, 2)
    end

    local indexCall = lastIndexCall
    lastIndexCall = lastIndexCall + 1

    local sourcePlayer = tonumber(source)
    local xPlayer = ESX.GetPlayerFromId(sourcePlayer)

    local srcPhone = ''
    if extraData ~= nil and extraData.useNumber ~= nil then
        srcPhone = extraData.useNumber
    else
        srcPhone = getNumberPhone(xPlayer.identifier, xPlayer.characterId)
    end
    local destPlayer = getCharacterByPhoneNumber(phone_number)

    local is_valid = destPlayer ~= nil and destPlayer.identifier ~= xPlayer.identifier
    AppelsEnCours[indexCall] = {
        id = indexCall,
        transmitter_src = sourcePlayer,
        transmitter_num = srcPhone,
        receiver_src = nil,
        receiver_num = phone_number,
        is_valid = destPlayer ~= nil,
        is_accepts = false,
        hidden = hidden,
        rtcOffer = rtcOffer,
        extraData = extraData
    }

    if is_valid then
        srcTo = getSourceFromCharacter(destPlayer)
        if srcTo ~= nil then
            AppelsEnCours[indexCall].receiver_src = srcTo
            TriggerEvent('gcPhone:addCall', AppelsEnCours[indexCall])
            TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
            TriggerClientEvent('gcPhone:waitingCall', srcTo, AppelsEnCours[indexCall], false)
        else
            TriggerEvent('gcPhone:addCall', AppelsEnCours[indexCall])
            TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
        end
    else
        TriggerEvent('gcPhone:addCall', AppelsEnCours[indexCall])
        TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
    end

end)

RegisterServerEvent('gcPhone:startCall')
AddEventHandler('gcPhone:startCall', function(phone_number, rtcOffer, extraData)
    TriggerEvent('gcPhone:internal_startCall',source, phone_number, rtcOffer, extraData)
end)

RegisterServerEvent('gcPhone:candidates')
AddEventHandler('gcPhone:candidates', function (callId, candidates)
    -- print('send cadidate', callId, candidates)
    if AppelsEnCours[callId] ~= nil then
        local source = source
        local to = AppelsEnCours[callId].transmitter_src
        if source == to then
            to = AppelsEnCours[callId].receiver_src
        end
        -- print('TO', to)
        TriggerClientEvent('gcPhone:candidates', to, candidates)
    end
end)


RegisterServerEvent('gcPhone:acceptCall')
AddEventHandler('gcPhone:acceptCall', function(infoCall, rtcAnswer)
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        if PhoneFixeInfo[id] ~= nil then
            onAcceptFixePhone(source, infoCall, rtcAnswer)
            return
        end
        AppelsEnCours[id].receiver_src = infoCall.receiver_src or AppelsEnCours[id].receiver_src
        if AppelsEnCours[id].transmitter_src ~= nil and AppelsEnCours[id].receiver_src~= nil then
            AppelsEnCours[id].is_accepts = true
            AppelsEnCours[id].rtcAnswer = rtcAnswer
            TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)
	    SetTimeout(1000, function() -- change to +1000, if necessary.
       		TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
	    end)
            saveAppels(AppelsEnCours[id])
        end
    end
end)




RegisterServerEvent('gcPhone:rejectCall')
AddEventHandler('gcPhone:rejectCall', function (infoCall)
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        if PhoneFixeInfo[id] ~= nil then
            onRejectFixePhone(source, infoCall)
            return
        end
        if AppelsEnCours[id].transmitter_src ~= nil then
            TriggerClientEvent('gcPhone:rejectCall', AppelsEnCours[id].transmitter_src)
        end
        if AppelsEnCours[id].receiver_src ~= nil then
            TriggerClientEvent('gcPhone:rejectCall', AppelsEnCours[id].receiver_src)
        end

        if AppelsEnCours[id].is_accepts == false then
            saveAppels(AppelsEnCours[id])
        end
        TriggerEvent('gcPhone:removeCall', AppelsEnCours)
        AppelsEnCours[id] = nil
    end
end)

RegisterServerEvent('gcPhone:appelsDeleteHistorique')
AddEventHandler('gcPhone:appelsDeleteHistorique', function (numero)
    local xPlayer = ESX.GetPlayerFromId(source)
    local srcPhone = getNumberPhone(xPlayer.identifier, xPlayer.characterId)
    MySQL.Sync.execute("DELETE FROM phone_calls WHERE `owner` = @owner AND `num` = @num", {
        ['@owner'] = srcPhone,
        ['@num'] = numero
    })
end)

function appelsDeleteAllHistorique(identifier, characterId)
    local srcPhone = getNumberPhone(identifier, characterId)
    MySQL.Sync.execute("DELETE FROM phone_calls WHERE `owner` = @owner", {
        ['@owner'] = srcPhone
    })
end

RegisterServerEvent('gcPhone:appelsDeleteAllHistorique')
AddEventHandler('gcPhone:appelsDeleteAllHistorique', function ()
    local xPlayer = ESX.GetPlayerFromId(source)
    appelsDeleteAllHistorique(xPlayer.identifier, xPlayer.characterId)
end)

--====================================================================================
--  OnLoad
--====================================================================================
AddEventHandler('esx:playerLoaded',function(source, xPlayer)
	local sourcePlayer = tonumber(source)

	getOrGeneratePhoneNumber(xPlayer.identifier, xPlayer.characterId, function (myPhoneNumber)
		TriggerClientEvent("gcPhone:myPhoneNumber", sourcePlayer, myPhoneNumber)
		TriggerClientEvent("gcPhone:contactList", sourcePlayer, getContacts(xPlayer.identifier, xPlayer.characterId))
		TriggerClientEvent("gcPhone:allMessage", sourcePlayer, getMessages(xPlayer.identifier, xPlayer.characterId))
	end)
end)

-- Just For reload
RegisterServerEvent('gcPhone:allUpdate')
AddEventHandler('gcPhone:allUpdate', function()
	local sourcePlayer = tonumber(source)
	local xPlayer = ESX.GetPlayerFromId(sourcePlayer)

	if xPlayer ~= nil then
		local num = getNumberPhone(xPlayer.identifier, xPlayer.characterId)
		TriggerClientEvent("gcPhone:myPhoneNumber", sourcePlayer, num)
		TriggerClientEvent("gcPhone:contactList", sourcePlayer, getContacts(xPlayer.identifier, xPlayer.characterId))
		TriggerClientEvent("gcPhone:allMessage", sourcePlayer, getMessages(xPlayer.identifier, xPlayer.characterId))
		TriggerClientEvent('gcPhone:getBourse', sourcePlayer, getBourse())
		sendHistoriqueCall(sourcePlayer, num)
	end
end)


MySQL.ready(function()
    MySQL.Async.fetchAll("DELETE FROM phone_messages WHERE (DATEDIFF(CURRENT_DATE,time) > 10)")
end)

--====================================================================================
--  App bourse
--====================================================================================
function getBourse()
    --  Format
    --  Array
    --    Object
    --      -- libelle type String    | Nom
    --      -- price type number      | Prix actuelle
    --      -- difference type number | Evolution
    --
    -- local result = MySQL.Sync.fetchAll("SELECT * FROM `recolt` LEFT JOIN `items` ON items.`id` = recolt.`treated_id` WHERE fluctuation = 1 ORDER BY price DESC",{})
    local result = {
        {
            libelle = 'Google',
            price = 125.2,
            difference =  -12.1
        },
        {
            libelle = 'Microsoft',
            price = 132.2,
            difference = 3.1
        },
        {
            libelle = 'Amazon',
            price = 120,
            difference = 0
        }
    }
    return result
end

--====================================================================================
--  App ... WIP
--====================================================================================


-- SendNUIMessage('ongcPhoneRTC_receive_offer')
-- SendNUIMessage('ongcPhoneRTC_receive_answer')

-- RegisterNUICallback('gcPhoneRTC_send_offer', function (data)


-- end)


-- RegisterNUICallback('gcPhoneRTC_send_answer', function (data)


-- end)



function onCallFixePhone (source, phone_number, rtcOffer, extraData)
    local indexCall = lastIndexCall
    lastIndexCall = lastIndexCall + 1

    local hidden = string.sub(phone_number, 1, 1) == '#'
    if hidden == true then
        phone_number = string.sub(phone_number, 2)
    end
    local sourcePlayer = tonumber(source)
    local xPlayer = ESX.GetPlayerFromId(sourcePlayer)

    local srcPhone = ''
    if extraData ~= nil and extraData.useNumber ~= nil then
        srcPhone = extraData.useNumber
    else
        srcPhone = getNumberPhone(xPlayer.identifier, xPlayer.characterId)
    end

    AppelsEnCours[indexCall] = {
        id = indexCall,
        transmitter_src = sourcePlayer,
        transmitter_num = srcPhone,
        receiver_src = nil,
        receiver_num = phone_number,
        is_valid = false,
        is_accepts = false,
        hidden = hidden,
        rtcOffer = rtcOffer,
        extraData = extraData,
        coords = FixePhone[phone_number].coords
    }

    PhoneFixeInfo[indexCall] = AppelsEnCours[indexCall]

    TriggerClientEvent('gcPhone:notifyFixePhoneChange', -1, PhoneFixeInfo)
    TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
end



function onAcceptFixePhone(source, infoCall, rtcAnswer)
    local id = infoCall.id

    AppelsEnCours[id].receiver_src = source
    if AppelsEnCours[id].transmitter_src ~= nil and AppelsEnCours[id].receiver_src~= nil then
        AppelsEnCours[id].is_accepts = true
        AppelsEnCours[id].forceSaveAfter = true
        AppelsEnCours[id].rtcAnswer = rtcAnswer
        PhoneFixeInfo[id] = nil
        TriggerClientEvent('gcPhone:notifyFixePhoneChange', -1, PhoneFixeInfo)
        TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)
        SetTimeout(5000, function() -- change to +1000, if necessary.
            TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
        end)
        saveAppels(AppelsEnCours[id])
    end
end

function onRejectFixePhone(source, infoCall, rtcAnswer)
    local id = infoCall.id
    PhoneFixeInfo[id] = nil
    TriggerClientEvent('gcPhone:notifyFixePhoneChange', -1, PhoneFixeInfo)
    TriggerClientEvent('gcPhone:rejectCall', AppelsEnCours[id].transmitter_src)
    if AppelsEnCours[id].is_accepts == false then
        saveAppels(AppelsEnCours[id])
    end
    AppelsEnCours[id] = nil

end
