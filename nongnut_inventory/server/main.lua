ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('nongnut_inventory:player:giveItem', function(targetId, itemType, itemName, count)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(targetId)

    if not xPlayer or not targetXPlayer then return end
    if xPlayer.source == targetXPlayer.source then return end

    if itemType == 'item_standard' then
        local sourceItem = xPlayer.getInventoryItem(itemName)
        if sourceItem.count >= count then
            if targetXPlayer.canCarryItem(itemName, count) then
                xPlayer.removeInventoryItem(itemName, count)
                targetXPlayer.addInventoryItem(itemName, count)
            else
                xPlayer.showNotification('Inventory target full')
            end
        else
            xPlayer.showNotification('Not enough items')
        end
    elseif itemType == 'item_account' then
        if xPlayer.getAccount(itemName).money >= count then
            xPlayer.removeAccountMoney(itemName, count)
            targetXPlayer.addAccountMoney(itemName, count)
        else
            xPlayer.showNotification('Not enough money')
        end
    elseif itemType == 'item_weapon' then
        if xPlayer.hasWeapon(itemName) then
            xPlayer.removeWeapon(itemName)
            targetXPlayer.addWeapon(itemName, count)
        else
            xPlayer.showNotification('You do not have this weapon')
        end
    end
end)

RegisterNetEvent('nongnut_inventory:player:dropItem', function(itemType, itemName, count)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    if itemType == 'item_standard' then
        if xPlayer.getInventoryItem(itemName).count >= count then
            xPlayer.removeInventoryItem(itemName, count)
            -- TriggerEvent('esx:onPlayerDropItem', source, itemName, count) -- Optional: if you want a pickup on ground
        end
    elseif itemType == 'item_account' then
        if xPlayer.getAccount(itemName).money >= count then
            xPlayer.removeAccountMoney(itemName, count)
             -- TriggerEvent('esx:onPlayerDropItem', source, itemName, count)
        end
    elseif itemType == 'item_weapon' then
        if xPlayer.hasWeapon(itemName) then
            xPlayer.removeWeapon(itemName)
             -- TriggerEvent('esx:onPlayerDropItem', source, itemName, count)
        end
    end
end)

registerNetEvent = RegisterNetEvent -- fallback

RegisterNetEvent('nongnut_inventory:player:giveVehicleKey', function(targetId, plate)
    local source = source
    local targetXPlayer = ESX.GetPlayerFromId(targetId)
    if targetXPlayer then
        TriggerClientEvent('nongnut_inventory:addAddonItem', targetId, 'item_vehiclekey', plate, plate)
        TriggerClientEvent('nongnut_inventory:removeAddonItem', source, 'item_vehiclekey', plate)
        pcall(function()
            exports['xbb-vehiclekey']:addKey(targetId, plate)
            exports['xbb-vehiclekey']:removeKey(source, plate)
        end)
    end
end)

RegisterNetEvent('nongnut_inventory:player:removeAccessory', function(itemName, itemType)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or type(itemName) ~= 'string' or type(itemType) ~= 'string' then
        return
    end

    MySQL.update.await([[
        DELETE FROM user_accessories
        WHERE identifier = ? AND type = ? AND label = ?
        LIMIT 1
    ]], {
        xPlayer.identifier,
        itemType,
        itemName
    })

    TriggerClientEvent('nongnut_inventory:removeAccessory', source, itemType, itemName)
    TriggerClientEvent('esx_skin:change', source, itemType:gsub('item_', ''), -1)
end)

-- Admin/AllItems logic Placeholders
RegisterNetEvent('nongnut_inventory:admin:putItem', function(itemName, itemType, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'user' then
        -- Admin logic to put item back to "infinite" source or delete it
        if itemType == 'item_standard' then
            xPlayer.removeInventoryItem(itemName, count)
        elseif itemType == 'item_weapon' then
            xPlayer.removeWeapon(itemName)
        elseif itemType == 'item_account' then
            xPlayer.removeAccountMoney(itemName, count)
        end
    end
end)

RegisterNetEvent('nongnut_inventory:admin:takeItem', function(itemName, itemType, count)
     local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'user' then
        if itemType == 'item_standard' then
            xPlayer.addInventoryItem(itemName, count)
        elseif itemType == 'item_weapon' then
            xPlayer.addWeapon(itemName, count)
        elseif itemType == 'item_account' then
            xPlayer.addAccountMoney(itemName, count)
        end
    end
end)

RegisterNetEvent('nongnut_inventory:player:putItem', function(targetSource, itemName, itemType, count, itemKey)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(tonumber(targetSource))
    
    if not targetXPlayer then return end

    -- Verify Distance (optional but recommended)
    local ped = GetPlayerPed(source)
    local targetPed = GetPlayerPed(targetXPlayer.source)
    if #(GetEntityCoords(ped) - GetEntityCoords(targetPed)) > 5.0 then
        return 
    end

    if itemType == 'item_standard' then
        if xPlayer.getInventoryItem(itemName).count >= count then
            if targetXPlayer.canCarryItem(itemName, count) then
                xPlayer.removeInventoryItem(itemName, count)
                targetXPlayer.addInventoryItem(itemName, count)
                
                -- Update UI for target
                TriggerClientEvent('nongnut_inventory:updateSecondInventory', source, itemType, itemName, targetXPlayer.getInventoryItem(itemName).count)
            end
        end
    elseif itemType == 'item_weapon' then
        if xPlayer.hasWeapon(itemName) then
            xPlayer.removeWeapon(itemName)
            targetXPlayer.addWeapon(itemName, count)
             TriggerClientEvent('nongnut_inventory:updateSecondInventory', source, itemType, itemName, count) 
        end
    elseif itemType == 'item_account' then
         if xPlayer.getAccount(itemName).money >= count then
            xPlayer.removeAccountMoney(itemName, count)
            targetXPlayer.addAccountMoney(itemName, count)
             TriggerClientEvent('nongnut_inventory:updateSecondInventory', source, itemType, itemName, targetXPlayer.getAccount(itemName).money)
        end
    end
end)


RegisterNetEvent('nongnut_inventory:player:takeItem', function(targetSource, itemName, itemType, count, itemUniqueKey)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(tonumber(targetSource))
    
    if not targetXPlayer then return end
    
      -- Verify Distance
    local ped = GetPlayerPed(source)
    local targetPed = GetPlayerPed(targetXPlayer.source)
    if #(GetEntityCoords(ped) - GetEntityCoords(targetPed)) > 5.0 then
        return 
    end

    if itemType == 'item_standard' then
        if targetXPlayer.getInventoryItem(itemName).count >= count then
            if xPlayer.canCarryItem(itemName, count) then
                targetXPlayer.removeInventoryItem(itemName, count)
                xPlayer.addInventoryItem(itemName, count)
                
                 -- Update UI for source (who is looking at the secondary inventory)
                 -- TriggerClientEvent('nongnut_inventory:updateSecondInventory', source, itemType, itemName, targetXPlayer.getInventoryItem(itemName).count)
                 -- Actually the client updates itself when receiving standard esx events, but we might need to force update secondary view
            end
        end
     elseif itemType == 'item_weapon' then
        if targetXPlayer.hasWeapon(itemName) then
            targetXPlayer.removeWeapon(itemName)
            xPlayer.addWeapon(itemName, count)
        end
    elseif itemType == 'item_account' then
         if targetXPlayer.getAccount(itemName).money >= count then
            targetXPlayer.removeAccountMoney(itemName, count)
            xPlayer.addAccountMoney(itemName, count)
        end
    end
end)

RegisterNetEvent('nongnut_inventory:changeWeapSkin', function(weaponName, skinName)
     local xPlayer = ESX.GetPlayerFromId(source)
     if not xPlayer or type(weaponName) ~= 'string' or type(skinName) ~= 'string' then
        return
     end

     local skinItem
     local removeOnUse = false
     local weaponSkins = Config.WeaponSkins and Config.WeaponSkins[weaponName]
     if weaponSkins then
        for i = 1, #weaponSkins do
            local skin = weaponSkins[i]
            if skin.name == skinName then
                skinItem = skin.item
                removeOnUse = skin.remove == true
                break
            end
        end
     end

     if skinItem then
        local invItem = xPlayer.getInventoryItem(skinItem)
        if not invItem or invItem.count <= 0 then
            return
        end
        if removeOnUse then
            xPlayer.removeInventoryItem(skinItem, 1)
        end
     end

     TriggerClientEvent('nongnut_inventory:setWeaponSkin', source, weaponName, skinName)
end)
