RegisterNetEvent('nongnut_inventory:initialized', function()
    pcall(function()
        local vehicles = exports['nongnut_garage']:getVehicles()
        for plate in pairs(vehicles) do
            exports['nongnut_inventory']:addAddonItem('item_vehiclekey', plate)
        end
    end)
end)