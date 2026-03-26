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

RegisterNetEvent('nongnut_inventory:initialized', function()
    pcall(function()
        local vehicles = exports['nongnut_garage']:getVehicles()
        for vehicleKey, vehicleData in pairs(vehicles or {}) do
            local plate = resolveVehiclePlate(vehicleKey, vehicleData)
            if plate then
                exports['nongnut_inventory']:addAddonItem('item_vehiclekey', plate)
            end
        end
    end)
end)
