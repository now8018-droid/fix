
local function checkItemLimit(itemName, actionCount)
    local limit = itemLimit[itemName]
    local currentCount = itemCount[itemName] or 0
    if limit then
        if currentCount + actionCount > limit then
            actionCount = limit - currentCount
            if actionCount <= 0 then
                return nil
            end
        end
    else
        if actionCount > currentCount then
            actionCount = currentCount
            if actionCount <= 0 then
                return nil
            end
        end
    end
    return actionCount
end

function Function.GiveItem(targetId, itemName, itemType, actionCount)
    if not tonumber(targetId) then
        return
    end
    if itemType == 'item_vehiclekey' then
        TriggerServerEvent('nongnut_inventory:player:giveVehicleKey', targetId, itemName:gsub('item_vehiclekey_', ''))
        return
    end
    TriggerServerEvent('nongnut_inventory:player:giveItem', targetId, itemType, itemName, actionCount)
end

function Function.DropItem(itemName, itemType, actionCount)
    -- actionCount = checkItemLimit(itemName, actionCount)
    -- if not actionCount then
    --     return
    -- end
    if  itemType == 'item_mask' or
        itemType == 'item_ears' or
        itemType == 'item_glasses' or
        itemType == 'item_helmet' then
            TriggerServerEvent('nongnut_inventory:player:removeAccessory', itemName, itemType)
            TriggerEvent('nongnut_inventory:playAnim', 'drop')
            return
    end
    TriggerServerEvent('nongnut_inventory:player:dropItem', itemType, itemName, actionCount)
end

function Function.DragItem(action, secondaryType, secondaryName, itemName, itemType, actionCount, itemUniqueKey)
    if action == 'put' then
        if secondaryType == 'vault' then
            exports['nongnut_inventory']:putItemToVault(secondaryName, itemName, itemType, actionCount)
        elseif secondaryType == 'trunk' then
            exports['nongnut_inventory']:putItemToTrunk(secondaryName, itemName, itemType, actionCount)
        elseif secondaryType == 'player' then
            TriggerServerEvent('nongnut_inventory:player:putItem', secondaryName, itemName, itemType, actionCount, itemKey)
        elseif secondaryType == 'allitems' then
            print(itemName)
            TriggerServerEvent('nongnut_inventory:admin:putItem', itemName, itemType, actionCount)
        elseif secondaryType == 'playerall' then
            print(itemName)
            TriggerServerEvent('nongnut_inventory:allitems:putItem', secondaryName, itemName, itemType, actionCount)
        elseif secondaryType == "thief" then
            TriggerServerEvent("plus_thiefplayer:ThiefPlayer_SV", action, secondaryName, itemName, itemType, actionCount)
        end
    else
        local realCount = actionCount
        actionCount = itemType == 'item_standard' and checkItemLimit(itemName, actionCount) or actionCount
        if not actionCount then
            return
        end
        if secondaryType == 'vault' then
            exports['nongnut_inventory']:takeItemFromVault(secondaryName, itemName, itemType, actionCount, itemUniqueKey)
        elseif secondaryType == 'trunk' then
            exports['nongnut_inventory']:takeItemFromTrunk(secondaryName, itemName, itemType, actionCount, itemUniqueKey)
        elseif secondaryType == 'player' then
            TriggerServerEvent('nongnut_inventory:player:takeItem', secondaryName, itemName, itemType, actionCount, itemUniqueKey)
        elseif secondaryType == 'allitems' then
            print(itemName)
            TriggerServerEvent('nongnut_inventory:admin:takeItem', itemName, itemType, actionCount)
        elseif secondaryType == 'playerall' then
            print(itemName)
            TriggerServerEvent('nongnut_inventory:allitems:takeItem', secondaryName, itemName, itemType, realCount)
        elseif secondaryType == "thief" then
            TriggerServerEvent("plus_thiefplayer:ThiefPlayer_SV", action, secondaryName, itemName, itemType, actionCount)
        end
    end
end