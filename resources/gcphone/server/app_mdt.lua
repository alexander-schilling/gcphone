--====================================================================================
-- #Author: Olle Strand | Cünter#1634
-- #Version 0.1
--====================================================================================

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
  MySQL.Async.fetchAll("SELECT id FROM mdt_accounts WHERE mdt_accounts.username = @username AND mdt_accounts.password = @password", {
    ['@username'] = username,
    ['@password'] = password
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
      TriggerClientEvent('gcPhone:mdt_login', sourcePlayer, username, password)
  end)
end)
