--====================================================================================
-- #Author: Olle Strand | Cünter#1634
-- #Version 0.1
--====================================================================================

function getUserJob(identifier)
    local result = MySQL.Sync.fetchAll("SELECT users.job FROM users WHERE users.identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].job
    end
    return nil
end

function getUserJobLevel(identifier)
    local result = MySQL.Sync.fetchAll("SELECT users.job_grade FROM users WHERE users.identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].job_grade
    end
    return nil
end
