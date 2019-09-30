--====================================================================================
-- #Author: Olle Strand | Cünter#1634
-- #Version 0.1
--====================================================================================

RegisterNetEvent("gcPhone:mdt_login")
AddEventHandler("gcPhone:mdt_login", function(username, password)
  print("Reached client Stuff")
  SendNUIMessage({event = 'mdt_login', username = username, password = password})
end)
