ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('nongnut_leasevehicle:lease', function(renterId, plate, days, hours, rentalPrice)
    local xPlayer = ESX.GetPlayerFromId(source)
    local renter = ESX.GetPlayerFromId(renterId)
    
    if xPlayer and renter then
         -- Logic for leasing
         -- Transfer money, register lease in DB
         renter.removeAccountMoney('money', rentalPrice)
         xPlayer.addAccountMoney('money', rentalPrice)
         
         -- Grant keys?
         TriggerClientEvent('nongnut_inventory:addAddonItem', renterId, 'item_vehiclekey', plate, plate)
    end
end)
