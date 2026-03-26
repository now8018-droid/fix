local function updateData(data)
    local tempData = {}
    for plate, timestamp in pairs(data) do
        local itemName = 'item_vehiclekey_' .. plate
        tempData[itemName] = timestamp
        exports[GetCurrentResourceName()]:addAddonItem('item_vehiclekey', plate)
    end
    exports[GetCurrentResourceName()]:postMessage('setLeasedData', {
        leasedData = tempData
    })
end

RegisterNetEvent('nongnut_leasevehicle:updateData', function(data)
    updateData(data)
end)

RegisterNetEvent('nongnut_inventory:initialized', function()
    while GetResourceState('nongnut_leasevehicle') ~= 'started' do
        Wait(1000)
    end
    Wait(1000)
    updateData(exports['nongnut_leasevehicle']:getData())
end)