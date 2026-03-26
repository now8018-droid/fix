local ESX = exports['es_extended']:getSharedObject()
local STCNAME = GetCurrentResourceName() .. '.'

local playerKeys = {}

local function normalizePlate(plate)
    if type(plate) ~= 'string' then
        return nil
    end

    plate = plate:match('^%s*(.-)%s*$')
    if plate == '' then
        return nil
    end

    return plate
end

local function getPlayerIdentifier(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then
        return nil
    end

    return xPlayer.identifier
end

local function queryOwnedVehiclePlates(identifier)
    if not identifier then
        return {}
    end

    local rows = MySQL.query.await('SELECT plate FROM owned_vehicles WHERE owner = ?', { identifier }) or {}
    local keyMap = {}

    for _, row in ipairs(rows) do
        local plate = normalizePlate(row.plate)
        if plate then
            keyMap[plate] = true
        end
    end

    return keyMap
end

local function getPlayerKeys(source)
    if playerKeys[source] then
        return playerKeys[source]
    end

    local identifier = getPlayerIdentifier(source)
    local keyMap = queryOwnedVehiclePlates(identifier)

    playerKeys[source] = keyMap
    return keyMap
end

local function playerHasKey(source, plate)
    local keyMap = getPlayerKeys(source)
    return keyMap[plate] == true
end

local function addKeyToPlayer(source, plate)
    local keyMap = getPlayerKeys(source)
    keyMap[plate] = true
    TriggerClientEvent(STCNAME .. 'cl.addupdateKey', source, plate)
    TriggerClientEvent('nongnut_inventory:addAddonItem', source, 'item_vehiclekey', plate, plate)
end

local function removeKeyFromPlayer(source, plate)
    local keyMap = getPlayerKeys(source)
    keyMap[plate] = nil
    TriggerClientEvent(STCNAME .. 'cl.removeKey', source, plate)
    TriggerClientEvent('nongnut_inventory:removeAddonItem', source, 'item_vehiclekey', plate)
end

RegisterNetEvent(STCNAME .. 'sv.requestDataNEW', function()
    local source = source
    TriggerClientEvent(STCNAME .. 'cl.requestDataNEW', source, getPlayerKeys(source))
end)

RegisterNetEvent(STCNAME .. 'sv.getVehicleData', function(plate)
    local source = source
    plate = normalizePlate(plate)
    if not plate then
        return
    end

    if playerHasKey(source, plate) then
        TriggerClientEvent(STCNAME .. 'cl.addupdateKey', source, plate)
        return
    end

    local identifier = getPlayerIdentifier(source)
    if not identifier then
        return
    end

    local row = MySQL.single.await('SELECT plate FROM owned_vehicles WHERE owner = ? AND plate = ? LIMIT 1', {
        identifier,
        plate,
    })

    if row then
        addKeyToPlayer(source, plate)
    end
end)

RegisterNetEvent(STCNAME .. 'sv.setVehicle', function(targetId, plate)
    local source = source
    targetId = tonumber(targetId)
    plate = normalizePlate(plate)

    if not targetId or not plate then
        return
    end

    if not GetPlayerName(source) or not GetPlayerName(targetId) then
        return
    end

    TriggerClientEvent(STCNAME .. 'cl.setVehicle', targetId, plate)
end)

RegisterNetEvent(STCNAME .. 'sv.Returndata', function(name, callbackId, ...)
    local source = source
    local response = nil

    if name == 'hasKey' then
        local plate = normalizePlate((...))
        response = plate and playerHasKey(source, plate) or false
    elseif name == 'addKey' then
        local plate = normalizePlate((...))
        if plate then
            addKeyToPlayer(source, plate)
            response = true
        else
            response = false
        end
    elseif name == 'removeKey' then
        local plate = normalizePlate((...))
        if plate then
            removeKeyFromPlayer(source, plate)
            response = true
        else
            response = false
        end
    end

    TriggerClientEvent(STCNAME .. 'cl.Returndata', source, callbackId, response)
end)

AddEventHandler('playerDropped', function()
    playerKeys[source] = nil
end)

AddEventHandler('esx:playerLoaded', function(playerId)
    playerKeys[playerId] = nil
end)

exports('hasKey', function(source, plate)
    plate = normalizePlate(plate)
    if not plate then
        return false
    end

    return playerHasKey(source, plate)
end)

exports('addKey', function(source, plate)
    plate = normalizePlate(plate)
    if not plate then
        return false
    end

    addKeyToPlayer(source, plate)
    return true
end)

exports('removeKey', function(source, plate)
    plate = normalizePlate(plate)
    if not plate then
        return false
    end

    removeKeyFromPlayer(source, plate)
    return true
end)
