local ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('nongnut_inventory:initialized', function()
    TriggerServerEvent('nongnut_inventory:requestAccessories')
end)

RegisterNetEvent('nongnut_inventory:accessoriesData', function(data)
    if not data or not next(data) then
        return
    end
    for k, v in pairs(data) do
        local itemType = v.type:gsub('player_', 'item_')
        local itemName = v.label
        local itemSkin = v.skin
        exports['nongnut_inventory']:addAddonItem(itemType, itemName, itemName)
        exports['nongnut_inventory']:setAccessoryData(itemType..'_'..itemName, json.decode(itemSkin))
    end
end)

RegisterNetEvent('nongnut_inventory:addAccessory', function(itemType, itemName, skin)
    exports['nongnut_inventory']:addAddonItem(itemType, itemName, itemName)
    exports['nongnut_inventory']:setAccessoryData(itemType..'_'..itemName, json.decode(skin))
end)

RegisterNetEvent('nongnut_inventory:removeAccessory', function(itemType, itemName)
    exports['nongnut_inventory']:removeAddonItem(itemType, itemName)
    exports['nongnut_inventory']:setAccessoryData(itemType..'_'..itemName, nil)
end)

function Function.UseAccessory(itemType, itemName, itemData)
    if itemType == 'item_mask' then
        local playerPed = PlayerPedId()
        local animation = {
            dict_on = 'mp_masks@standard_car@ds@',
            lib_on = 'put_on_mask',
            dict_off = 'mp_masks@standard_car@ds@',
            lib_off = 'put_on_mask',
        }
        if GetPedDrawableVariation(playerPed, 1) <= 0 then
            ESX.Streaming.RequestAnimDict(animation.dict_on, function()
                TaskPlayAnim(playerPed, animation.dict_on, animation.lib_on, 3.0, 3.0, 800, 48, 0, false, false, false)
                RemoveAnimDict(animation.dict)
                SetTimeout(500, function()
                    SetPedComponentVariation(playerPed, 1, itemData['mask_1'], itemData['mask_2'], 2)
                end)
                TriggerEvent('skinchanger:changeCharacter', 'mask_1', itemData['mask_1'])
                TriggerEvent('skinchanger:changeCharacter', 'mask_2', itemData['mask_2'])
                TriggerServerEvent('esx_skin:change', 'mask', itemData['mask_1'], itemData['mask_2'])
            end)
        else
            ESX.Streaming.RequestAnimDict(animation.dict_off, function()
                TaskPlayAnim(playerPed, animation.dict_off, animation.lib_off, 3.0, 3.0, 800, 48, 0, false, false, false)
                RemoveAnimDict(animation.dict)
                SetTimeout(700, function()
                    SetPedComponentVariation(playerPed, 1, 0, 0, 2)
                end)
                TriggerEvent('skinchanger:changeCharacter', 'mask_1', -1)
                TriggerEvent('skinchanger:changeCharacter', 'mask_2', 0)
                TriggerServerEvent('esx_skin:change', 'mask', -1, 0)
            end)
        end
    elseif itemType == 'item_ears' then
        local playerPed = PlayerPedId()
        local animation = {
            dict_on = 'mini@ears_defenders',
            lib_on = 'takeoff_earsdefenders_idle',
            dict_off = 'mini@ears_defenders',
            lib_off = 'takeoff_earsdefenders_idle',
        }
        if GetPedPropIndex(playerPed, 2) < 0 then
            ESX.Streaming.RequestAnimDict(animation.dict_on, function()
                TaskPlayAnim(playerPed, animation.dict_on, animation.lib_on, 3.0, 3.0, 800, 48, 0, false, false, false)
                RemoveAnimDict(animation.dict)
                SetTimeout(300, function()
                    SetPedPropIndex(playerPed, 2, itemData['ears_1'], itemData['ears_2'], 2)
                end)
                TriggerEvent('skinchanger:changeCharacter', 'ears_1', itemData['ears_1'])
                TriggerEvent('skinchanger:changeCharacter', 'ears_2', itemData['ears_2'])
                TriggerServerEvent('esx_skin:change', 'ears', itemData['ears_1'], itemData['ears_2'])
            end)
        else
            ESX.Streaming.RequestAnimDict(animation.dict_off, function()
                TaskPlayAnim(playerPed, animation.dict_off, animation.lib_off, 3.0, 3.0, 800, 48, 0, false, false, false)
                RemoveAnimDict(animation.dict)
                SetTimeout(300, function()
                    ClearPedProp(playerPed, 2)
                end)
                TriggerEvent('skinchanger:changeCharacter', 'ears_1', -1)
                TriggerEvent('skinchanger:changeCharacter', 'ears_2', 0)
                TriggerServerEvent('esx_skin:change', 'ears', -1, 0)
            end)
        end
    elseif itemType == 'item_glasses' then
        local playerPed = PlayerPedId()
        local animation = {
            dict_on = 'clothingspecs',
            lib_on = 'take_off',
            dict_off = 'clothingspecs',
            lib_off = 'take_off',
        }
        if GetPedPropIndex(playerPed, 1) < 0 then
            ESX.Streaming.RequestAnimDict(animation.dict_on, function()
                TaskPlayAnim(playerPed, animation.dict_on, animation.lib_on, 3.0, 3.0, 1100, 48, 0, false, false, false)
                RemoveAnimDict(animation.dict)
                SetTimeout(1000, function()
                    SetPedPropIndex(playerPed, 1, itemData['glasses_1'], itemData['glasses_2'], 2)
                end)
                TriggerEvent('skinchanger:changeCharacter', 'glasses_1', itemData['glasses_1'])
                TriggerEvent('skinchanger:changeCharacter', 'glasses_2', itemData['glasses_2'])
                TriggerServerEvent('esx_skin:change', 'glasses', itemData['glasses_1'], itemData['glasses_2'])
            end)
        else
            ESX.Streaming.RequestAnimDict(animation.dict_off, function()
                TaskPlayAnim(playerPed, animation.dict_off, animation.lib_off, 3.0, 3.0, 1100, 48, 0, false, false, false)
                RemoveAnimDict(animation.dict)
                SetTimeout(1000, function()
                    ClearPedProp(playerPed, 1)
                end)
                TriggerEvent('skinchanger:changeCharacter', 'glasses_1', -1)
                TriggerEvent('skinchanger:changeCharacter', 'glasses_2', 0)
                TriggerServerEvent('esx_skin:change', 'glasses', -1, 0)
            end)
        end
    elseif itemType == 'item_helmet' then
        local playerPed = PlayerPedId()
        local animation = {
            dict_on = 'veh@bicycle@roadfront@base',
            lib_on = 'put_on_helmet',
            dict_off = 'veh@bike@common@front@base',
            lib_off = 'take_off_helmet_walk',
        }
        if GetPedPropIndex(playerPed, 0) < 0 then
            ESX.Streaming.RequestAnimDict(animation.dict_on, function()
                TaskPlayAnim(playerPed, animation.dict_on, animation.lib_on, 3.0, 3.0, 1400, 48, 0, false, false, false)
                RemoveAnimDict(animation.dict)
                SetTimeout(1100, function()
                    SetPedPropIndex(playerPed, 0, itemData['helmet_1'], itemData['helmet_2'], 2)
                end)
                TriggerEvent('skinchanger:changeCharacter', 'helmet_1', itemData['helmet_1'])
                TriggerEvent('skinchanger:changeCharacter', 'helmet_2', itemData['helmet_2'])
                TriggerServerEvent('esx_skin:change', 'helmet', itemData['helmet_1'], itemData['helmet_2'])
            end)
        else
            ESX.Streaming.RequestAnimDict(animation.dict_off, function()
                TaskPlayAnim(playerPed, animation.dict_off, animation.lib_off, 3.0, 3.0, 1200, 48, 0, false, false, false)
                RemoveAnimDict(animation.dict)
                SetTimeout(700, function()
                    ClearPedProp(playerPed, 0)
                end)
                TriggerEvent('skinchanger:changeCharacter', 'helmet_1', -1)
                TriggerEvent('skinchanger:changeCharacter', 'helmet_2', 0)
                TriggerServerEvent('esx_skin:change', 'helmet', -1, 0)
            end)
        end
    end
end