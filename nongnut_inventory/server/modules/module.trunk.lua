local ESX = exports['es_extended']:getSharedObject()

local DEFAULT_TRUNK_MAX_WEIGHT = 100000

local function getEmptyTrunk()
    return {
        item_standard = {},
        item_account = {},
        item_weapon = {}
    }
end

local function loadTrunk(plate)
    local row = MySQL.single.await('SELECT data FROM trunk_inventory WHERE plate = ? LIMIT 1', { plate })
    if not row or not row.data then
        return getEmptyTrunk()
    end

    local ok, decoded = pcall(json.decode, row.data)
    if not ok or type(decoded) ~= 'table' then
        return getEmptyTrunk()
    end

    decoded.item_standard = decoded.item_standard or {}
    decoded.item_account = decoded.item_account or {}
    decoded.item_weapon = decoded.item_weapon or {}

    return decoded
end

local function saveTrunk(plate, data)
    MySQL.update.await([[
        INSERT INTO trunk_inventory (plate, data)
        VALUES (?, ?)
        ON DUPLICATE KEY UPDATE data = VALUES(data)
    ]], {
        plate,
        json.encode(data)
    })
end

local function getTrunkWeight(_data)
    -- Integrate with a dedicated weight resource if needed.
    -- For now keep compatibility with current client display.
    return 0, DEFAULT_TRUNK_MAX_WEIGHT
end

local function generateWeaponKey(itemName)
    return ('%s_%s_%s'):format(itemName, os.time(), math.random(100000, 999999))
end

ESX.RegisterServerCallback('nongnut_inventory:getTrunk', function(_source, cb, plate)
    if type(plate) ~= 'string' or plate == '' then
        cb(getEmptyTrunk(), 0, DEFAULT_TRUNK_MAX_WEIGHT)
        return
    end

    local trunkData = loadTrunk(plate)
    local weight, maxWeight = getTrunkWeight(trunkData)
    cb(trunkData, weight, maxWeight)
end)

ESX.RegisterServerCallback('nongnut_inventory:trunk:putItem', function(source, cb, plate, itemName, itemType, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    count = tonumber(count) or 0
    if not xPlayer or type(plate) ~= 'string' or plate == '' or type(itemName) ~= 'string' or count <= 0 then
        cb(false)
        return
    end

    local trunkData = loadTrunk(plate)

    if itemType == 'item_standard' then
        local invItem = xPlayer.getInventoryItem(itemName)
        if not invItem or invItem.count < count then
            cb(false)
            return
        end

        xPlayer.removeInventoryItem(itemName, count)
        trunkData.item_standard[itemName] = (trunkData.item_standard[itemName] or 0) + count
    elseif itemType == 'item_account' then
        local account = xPlayer.getAccount(itemName)
        if not account or account.money < count then
            cb(false)
            return
        end

        xPlayer.removeAccountMoney(itemName, count)
        trunkData.item_account[itemName] = (trunkData.item_account[itemName] or 0) + count
    elseif itemType == 'item_weapon' then
        if not xPlayer.hasWeapon(itemName) then
            cb(false)
            return
        end

        local ammo = count
        local key = generateWeaponKey(itemName)
        trunkData.item_weapon[itemName] = trunkData.item_weapon[itemName] or {}
        trunkData.item_weapon[itemName][key] = ammo
        xPlayer.removeWeapon(itemName)
    else
        cb(false)
        return
    end

    saveTrunk(plate, trunkData)
    local weight, _ = getTrunkWeight(trunkData)

    if itemType == 'item_weapon' then
        cb(true, (trunkData.item_weapon[itemName] and next(trunkData.item_weapon[itemName]) and 1) or 0, weight)
        return
    end

    local newCount = (itemType == 'item_standard' and trunkData.item_standard[itemName]) or trunkData.item_account[itemName]
    cb(true, newCount or 0, weight)
end)

ESX.RegisterServerCallback('nongnut_inventory:trunk:takeItem', function(source, cb, plate, itemName, itemType, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    count = tonumber(count) or 0
    if not xPlayer or type(plate) ~= 'string' or plate == '' or type(itemName) ~= 'string' or count <= 0 then
        cb(false)
        return
    end

    local trunkData = loadTrunk(plate)

    if itemType == 'item_standard' then
        local storageCount = trunkData.item_standard[itemName] or 0
        if storageCount < count or not xPlayer.canCarryItem(itemName, count) then
            cb(false)
            return
        end

        xPlayer.addInventoryItem(itemName, count)
        storageCount = storageCount - count
        trunkData.item_standard[itemName] = storageCount > 0 and storageCount or nil
    elseif itemType == 'item_account' then
        local storageCount = trunkData.item_account[itemName] or 0
        if storageCount < count then
            cb(false)
            return
        end

        xPlayer.addAccountMoney(itemName, count)
        storageCount = storageCount - count
        trunkData.item_account[itemName] = storageCount > 0 and storageCount or nil
    elseif itemType == 'item_weapon' then
        local weaponMap = trunkData.item_weapon[itemName]
        if not weaponMap then
            cb(false)
            return
        end

        local pickedKey
        local ammo = 0
        for key, weaponAmmo in pairs(weaponMap) do
            pickedKey = key
            ammo = tonumber(weaponAmmo) or 0
            break
        end

        if not pickedKey then
            cb(false)
            return
        end

        weaponMap[pickedKey] = nil
        if not next(weaponMap) then
            trunkData.item_weapon[itemName] = nil
        end

        xPlayer.addWeapon(itemName, ammo)
    else
        cb(false)
        return
    end

    saveTrunk(plate, trunkData)
    local weight, _ = getTrunkWeight(trunkData)

    local newCount
    if itemType == 'item_standard' then
        newCount = trunkData.item_standard[itemName] or 0
    elseif itemType == 'item_account' then
        newCount = trunkData.item_account[itemName] or 0
    else
        local weaponMap = trunkData.item_weapon[itemName]
        newCount = weaponMap and 1 or 0
    end

    cb(true, newCount, weight)
end)
