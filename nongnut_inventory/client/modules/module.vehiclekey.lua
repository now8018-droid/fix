local function resolveVehiclePlate(vehicleKey, vehicleData)
    if type(vehicleKey) == 'string' and vehicleKey ~= '' then
        return vehicleKey
    end

    if type(vehicleData) == 'table' then
        local plate = vehicleData.plate or vehicleData.vehicle_plate or vehicleData.license_plate
        if type(plate) == 'string' and plate ~= '' then
            return plate
        end
    end

    return nil
end

local syncedVehicleKeys = {}

local function syncVehicleKeys()
    local ok, vehicles = pcall(function()
        return exports['nongnut_garage']:getVehicles()
    end)
    if not ok or type(vehicles) ~= 'table' then
        return false
    end

    local hasVehicle = false
    for vehicleKey, vehicleData in pairs(vehicles) do
        local plate = resolveVehiclePlate(vehicleKey, vehicleData)
        if plate then
            hasVehicle = true
            if not syncedVehicleKeys[plate] then
                syncedVehicleKeys[plate] = true
                exports[GetCurrentResourceName()]:addAddonItem('item_vehiclekey', plate)
            end
        end
    end

    return hasVehicle
end

RegisterNetEvent('nongnut_inventory:initialized', function()
    CreateThread(function()
        for _ = 1, 30 do
            if syncVehicleKeys() then
                break
            end
            Wait(1000)
        end

        while true do
            Wait(60000)
            syncVehicleKeys()
        end
    end)
end)
