local ESX = exports['es_extended']:getSharedObject()

local vaultLocks = {}

local function getEmptyVault()
    return {
        item_standard = {},
        item_account = {},
        item_weapon = {}
    }
end

local function normalizeVaultName(vaultName)
    if type(vaultName) ~= 'string' then
        return nil
    end

    vaultName = vaultName:gsub('^%s*(.-)%s*$', '%1')
    if vaultName == '' then
        return nil
    end

    return vaultName
end

local function loadVault(vaultName)
    local row = MySQL.single.await('SELECT data FROM vault_inventory WHERE vault_name = ? LIMIT 1', { vaultName })
    if not row or not row.data then
        return getEmptyVault()
    end

    local ok, decoded = pcall(json.decode, row.data)
    if not ok or type(decoded) ~= 'table' then
        return getEmptyVault()
    end

    decoded.item_standard = decoded.item_standard or {}
    decoded.item_account = decoded.item_account or {}
    decoded.item_weapon = decoded.item_weapon or {}

    return decoded
end

local function saveVault(vaultName, data)
    MySQL.update.await([[
        INSERT INTO vault_inventory (vault_name, data)
        VALUES (?, ?)
        ON DUPLICATE KEY UPDATE data = VALUES(data)
    ]], {
        vaultName,
        json.encode(data)
    })
end

local function ensureVaultLock(vaultName, source)
    local lockOwner = vaultLocks[vaultName]
    if not lockOwner or lockOwner == source then
        vaultLocks[vaultName] = source
        return true
    end

    return false
end

local function generateWeaponKey(itemName)
    return ('%s_%s_%s'):format(itemName, os.time(), math.random(100000, 999999))
end

ESX.RegisterServerCallback('nongnut_inventory:vault:putItem', function(source, cb, vaultName, itemName, itemType, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local normalizedVaultName = normalizeVaultName(vaultName)
    count = tonumber(count) or 0

    if not xPlayer or not normalizedVaultName or type(itemName) ~= 'string' or count <= 0 then
        cb(false)
        return
    end

    if not ensureVaultLock(normalizedVaultName, source) then
        cb(false)
        return
    end

    local vaultData = loadVault(normalizedVaultName)

    if itemType == 'item_standard' then
        local invItem = xPlayer.getInventoryItem(itemName)
        if not invItem or invItem.count < count then
            cb(false)
            return
        end

        xPlayer.removeInventoryItem(itemName, count)
        vaultData.item_standard[itemName] = (vaultData.item_standard[itemName] or 0) + count
        saveVault(normalizedVaultName, vaultData)
        cb(true, vaultData.item_standard[itemName], nil)
    elseif itemType == 'item_account' then
        local account = xPlayer.getAccount(itemName)
        if not account or account.money < count then
            cb(false)
            return
        end

        xPlayer.removeAccountMoney(itemName, count)
        vaultData.item_account[itemName] = (vaultData.item_account[itemName] or 0) + count
        saveVault(normalizedVaultName, vaultData)
        cb(true, vaultData.item_account[itemName], nil)
    elseif itemType == 'item_weapon' then
        if not xPlayer.hasWeapon(itemName) then
            cb(false)
            return
        end

        local key = generateWeaponKey(itemName)
        vaultData.item_weapon[itemName] = vaultData.item_weapon[itemName] or {}
        vaultData.item_weapon[itemName][key] = count
        xPlayer.removeWeapon(itemName)
        saveVault(normalizedVaultName, vaultData)
        cb(true, count, key)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('nongnut_inventory:vault:takeItem', function(source, cb, vaultName, itemName, itemType, count, itemUniqueKey)
    local xPlayer = ESX.GetPlayerFromId(source)
    local normalizedVaultName = normalizeVaultName(vaultName)
    count = tonumber(count) or 0

    if not xPlayer or not normalizedVaultName or type(itemName) ~= 'string' or count <= 0 then
        cb(false)
        return
    end

    if not ensureVaultLock(normalizedVaultName, source) then
        cb(false)
        return
    end

    local vaultData = loadVault(normalizedVaultName)

    if itemType == 'item_standard' then
        local storageCount = vaultData.item_standard[itemName] or 0
        if storageCount < count or not xPlayer.canCarryItem(itemName, count) then
            cb(false)
            return
        end

        xPlayer.addInventoryItem(itemName, count)
        storageCount = storageCount - count
        vaultData.item_standard[itemName] = storageCount > 0 and storageCount or nil
        saveVault(normalizedVaultName, vaultData)
        cb(true, storageCount > 0 and storageCount or 0, nil)
    elseif itemType == 'item_account' then
        local storageCount = vaultData.item_account[itemName] or 0
        if storageCount < count then
            cb(false)
            return
        end

        xPlayer.addAccountMoney(itemName, count)
        storageCount = storageCount - count
        vaultData.item_account[itemName] = storageCount > 0 and storageCount or nil
        saveVault(normalizedVaultName, vaultData)
        cb(true, storageCount > 0 and storageCount or 0, nil)
    elseif itemType == 'item_weapon' then
        local weaponMap = vaultData.item_weapon[itemName]
        if not weaponMap then
            cb(false)
            return
        end

        local key = itemUniqueKey
        if not key or not weaponMap[key] then
            for candidateKey in pairs(weaponMap) do
                key = candidateKey
                break
            end
        end

        if not key then
            cb(false)
            return
        end

        local ammo = tonumber(weaponMap[key]) or 0
        weaponMap[key] = nil
        if not next(weaponMap) then
            vaultData.item_weapon[itemName] = nil
        end

        xPlayer.addWeapon(itemName, ammo)
        saveVault(normalizedVaultName, vaultData)
        cb(true, 0, key)
    else
        cb(false)
    end
end)

RegisterNetEvent('nongnut_inventory:closeVault', function(vaultName)
    local source = source
    local normalizedVaultName = normalizeVaultName(vaultName)
    if not normalizedVaultName then
        return
    end

    if vaultLocks[normalizedVaultName] == source then
        vaultLocks[normalizedVaultName] = nil
    end
end)

AddEventHandler('playerDropped', function()
    local source = source
    for vaultName, owner in pairs(vaultLocks) do
        if owner == source then
            vaultLocks[vaultName] = nil
        end
    end
end)
