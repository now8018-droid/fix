local ESX = exports['es_extended']:getSharedObject()
local ESX_UseItem = ESX.UseItem or (function(item) return false end) -- Safe fallback

local CloseOnUse = Config.CloseOnUse.type == 'blacklist'
local CloseOnUseList = (function()
    local list = {}
    for _, name in pairs(Config.CloseOnUse.items) do
        list[name] = true
    end
    return list
end)()

local Delay = {
    ItemUse = false,
    SwitchWeapon = false
}

local AccessoryData = {}

function Function.UseItem(item)
    if CloseOnUse ~= (CloseOnUseList[item?.name] ~= nil) then
        exports['nongnut_inventory']:closeInventory()
    end
    local itemName = item?.name
    local itemType = item?.type
    
    -- Dynamically check if ESX has a client-side UseItem handler (patched in module.useitem.lua)
    local itemCallback = false
    if ESX.UseItem then
        itemCallback = ESX.UseItem(itemName)
    end
    
    if itemCallback then return end
    if itemType == 'item_weapon' then
        if not Delay.SwitchWeapon and playerLoadout[itemName] then
            Delay.SwitchWeapon = true
            Function.EquipWeapon(itemName)
            Delay.SwitchWeapon = false
        end
    elseif itemType == 'item_standard' then
        local currentItemCount = itemCount[itemName] or 0
        local currentItemLimit = itemLimit[itemName] or 0
        if currentItemLimit > 0 and currentItemCount > currentItemLimit then
            ESX.ShowNotification('ไอเทมเกินจำกัด', 'error')
            return
        end
        if currentItemCount > 0 then
            TriggerServerEvent('esx:useItem', itemName)
        end
    else
        local itemData = AccessoryData[itemName]
        if itemData then
            -- print(json.encode(itemData))
            Function.UseAccessory(itemType, itemName, itemData)
        end
    end
end

function Function.BeforeOpen()
    if GlobalState.restarting then return false end
    if IsPedDeadOrDying(PlayerPedId(), true) then return false end
    return true
end

function Function.BeforeUseFastSlot(slot, item)
    if type(item) ~= 'table' or Delay.ItemUse then return false end
    Delay.ItemUse = true
    SetTimeout(Config.Delay.ItemUse, function()
        Delay.ItemUse = false
    end)
    return true
end

function Function.EquipWeapon(name)
    local playerPed = PlayerPedId()
    local playerId = PlayerId()
    local weaponHash = joaat(name)
    local _, currentWeapon = GetCurrentPedWeapon(playerPed, true)
    local finishEquip = false
    CreateThread(function()
        repeat
            DisablePlayerFiring(playerId, true)
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 25, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 141, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 263, true)
			DisableControlAction(0, 264, true)
            Wait(0)
        until finishEquip
        DisablePlayerFiring(playerId, false)
    end)
    if HasPedGotWeapon(playerPed, weaponHash, false) then
        local weaponAnimationDict = 'reaction@intimidation@1h'
        ESX.Streaming.RequestAnimDict(weaponAnimationDict, function()
            if currentWeapon == weaponHash then
                TaskPlayAnim(playerPed, weaponAnimationDict, 'outro', 8.0, 3.0, -1, 50, 0.0, false, false, false)
                RemoveAnimDict(weaponAnimationDict)
                Wait(1800)
                SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
                Wait(100)
                ClearPedTasks(playerPed)
            else
                TaskPlayAnim(playerPed, weaponAnimationDict, 'intro', 8.0, 3.0, -1, 50, 0.0, false, false, false)
                RemoveAnimDict(weaponAnimationDict)
                Wait(800)
                SetCurrentPedWeapon(playerPed, weaponHash, true)
                Wait(1800)
                ClearPedTasks(playerPed)
            end
        end)
    end
    Delay.SwitchWeapon = false
    finishEquip = true
end

RegisterNetEvent('nongnut_inventory:playAnim', function(anim)
    local playerPed = PlayerPedId()
    if anim == 'drop' then
        local dict = 'random@domestic'
        local anim = 'pickup_low'
        ESX.Streaming.RequestAnimDict(dict, function()
            TaskPlayAnim(playerPed, dict, anim, 8.0, 2.0, 1000, 50, 0, false, false, false)
            RemoveAnimDict(dict)
        end)
    elseif anim == 'give' then
        local dict = 'mp_common'
        local anim = 'givetake1_a'
        ESX.Streaming.RequestAnimDict(dict, function()
            TaskPlayAnim(playerPed, dict, anim, 8.0, 8.0, 1400, 50, 0, false, false, false)
            RemoveAnimDict(dict)
        end)
    elseif anim == 'trunk' then
        local dict = 'mp_am_hold_up'
        local anim = 'purchase_beerbox_shopkeeper'
        ESX.Streaming.RequestAnimDict(dict, function()
            TaskPlayAnim(playerPed, dict, anim, 8.0, 8.0, -1, 48, 0.45, false, false, false)
            RemoveAnimDict(dict)
        end)
    end
end)

exports('setAccessoryData', function(name, data)
    AccessoryData[name] = data
end)

AddStateBagChangeHandler('restarting', 'global', function(_,_,value)
    Wait(0)
    if value then
        TriggerEvent('nongnut_inventory:closeInventory')
    end
end)