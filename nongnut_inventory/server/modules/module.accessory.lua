local ESX = exports['es_extended']:getSharedObject()

-- Simple accessories request if needed
RegisterNetEvent('nongnut_inventory:requestAccessories', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    
    -- In a real scenario, fetch from `datastore_data` or `user_accessories`
    -- Expected data format: { {type = "player_mask", label = "Mask 1", skin = "{...}"} }
    
    MySQL.Async.fetchAll('SELECT * FROM user_accessories WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        local accessories = {}
        if result then
            for i=1, #result do
                table.insert(accessories, {
                    type = result[i].type, -- e.g. 'player_mask'
                    label = result[i].label,
                    skin = result[i].skin -- JSON string
                })
            end
        end
        TriggerClientEvent('nongnut_inventory:accessoriesData', source, accessories)
    end)
end)
