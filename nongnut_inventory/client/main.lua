local ESX = exports['es_extended']:getSharedObject()
local Await = Citizen.Await
local uiLoaded = promise.new()

local hideCountCache = {}
local hiddenItemCache = {}
local fastSlotTab = 1
local fastSlotData = {}
local hotbarTimer = nil
local secondaryType = nil
local secondaryName = nil
local isOpen = false

local itemProgressCallback = {}
local itemProgressCallbackIdx = 0

function registerInput(command_name, label, input_group, key, on_press, on_release)
	local command = on_release and '+' .. command_name or command_name
    RegisterCommand(command, on_press)
    if on_release then
        RegisterCommand('-' .. command_name, on_release)
    end
    RegisterKeyMapping(command, label or '', input_group or 'keyboard', key or '')
end

local function postMessage(action, data)
    Await(uiLoaded)
    data = data or {}
    data.action = action
    SendNUIMessage(data)
end

local function closeHotbar()
    hotbarTimer = nil
    postMessage('closeHotbar')
end

local function openInventory()
    if not Function.BeforeOpen() then return end
    closeHotbar()
    postMessage('open')
    SetNuiFocus(true, true)
    isOpen = true
    TriggerScreenblurFadeIn()
    TriggerEvent('nongnut_inventory:opened')
end

local function closeInventory()
    postMessage('close')
    SetNuiFocus(false, false)
    SetNuiZindex(1000)
    secondaryType = nil
    secondaryName = nil
    isOpen = false
    TriggerScreenblurFadeOut()
    TriggerEvent('nongnut_inventory:closed')
end

local function openHotbar(changeTab)
    if changeTab and hotbarTimer then
        fastSlotTab = fastSlotTab % Config.FastSlot.Tab + 1
        postMessage('setFastSlotTab', {
            tab = fastSlotTab
        })
    end
    postMessage('openHotbar')
    local currentTime = GetGameTimer()
    hotbarTimer = currentTime
    SetTimeout(Config.Delay.CloseHotbar, function()
        if hotbarTimer == currentTime then
            closeHotbar()
        end
    end)
end

local function addAddonItem(itemType, name, itemLabel)
    local addonConfig = Config.ItemAddons[itemType]
    if not addonConfig then return end
    postMessage('addItem', {
        name = itemType .. '_' .. name,
        item = {
            label = itemLabel or name,
            count = 1,
            usable = addonConfig.use,
            giveable = addonConfig.give,
            droppable = addonConfig.drop,
            type = itemType,
            addon = true
        }
    })
end

local function removeAddonItem(itemType, name)
    local addonConfig = Config.ItemAddons[itemType]
    if not addonConfig then return end
    local fullName = itemType .. '_' .. name
    postMessage('removeItem', {
        name = fullName
    })
end

local function setImageOverride(name, imageSource)
    local path = './images/items/' .. imageSource
    postMessage('setImageOverride', {
        name = name,
        image = path
    })
end

local function removeImageOverride(name)
    postMessage('removeImageOverride', {
        name = name
    })
end

local function setupSecondaryInventory(data, items, disable)
    secondaryType = data?.type or nil
    secondaryName = data?.name or nil
    postMessage('setSecondItems', {
        items = items or {}
    })
    postMessage('setDisabledItems', {
        type = disable?.type or 'blacklist',
        items = disable?.items or {}
    })
    postMessage('setInvData', {
        invData = data or {
            rightTitle = 'STORAGE',
            leftFooter = 'INVENTORY',
            rightFooter = 'STORAGE',
            rightWeight = nil,
            rightMaxWeight = nil
        }
    })
    openInventory()
end

local function changeSecondaryData(data)
    postMessage('changeInvData', data)
end

local function removeSecondaryItem(itemName, itemUniqueKey)
    if itemUniqueKey then
        itemName = itemName .. ':' .. itemUniqueKey
    end
    postMessage('removeSecondItem', {
        name = itemName
    })
end

local function changeSecondaryItem(itemName, itemType, itemCount, itemUniqueKey)
    local itemData = {
        count = itemCount,
        label = itemLabel[itemName] or itemName,
        type = itemType
    }
    if itemUniqueKey then
        itemData.key = itemUniqueKey
        itemData.image = itemName .. '.png'
        if itemType == 'item_weapon' then
            itemData.hideCount = GetWeaponDamageType(joaat(itemName)) == 2 and true or (hideCountCache[itemName] and true or nil)
        end
        itemName = itemName .. ':' .. itemUniqueKey
    end
    postMessage('addSecondItem', {
        name = itemName,
        item = itemData
    })
end

local function itemProgress(name, duration, callback)
    itemProgressCallbackIdx = itemProgressCallbackIdx + 1
    itemProgressCallback[itemProgressCallbackIdx] = callback
    postMessage('addItemProgress', {
        name = name,
        duration = duration,
        callbackIdx = itemProgressCallbackIdx
    })
    return itemProgressCallbackIdx
end

local function cancelItemProgress(_callbackIdx)
    local callbackIdx = tonumber(_callbackIdx)
    if not itemProgressCallback[callbackIdx] then return end
    itemProgressCallback[callbackIdx] = nil
    postMessage('removeItemProgress', {
        callbackIdx = callbackIdx
    })
end

local function cancelAllItemProgress()
    local progress = {}
    for idx in pairs(itemProgressCallback) do
        progress[#progress + 1] = idx
    end
    for i = 1, #progress do
        cancelItemProgress(progress[i])
    end
end

local function initialized()
    RegisterNetEvent('esx:setAccountMoney', function(account)
        itemCount[account.name] = account.money > 0 and account.money or nil
        if not Config.Accounts[account.name] then return end
        postMessage('setItemCount', {
            name = account.name,
            count = account.money
        })
    end)

    RegisterNetEvent('esx:updateAccounts', function(updates)
        for i = 1, #updates do
            local account = updates[i]
            itemCount[account.name] = account.money > 0 and account.money or nil
            if Config.Accounts[account.name] then
                postMessage('setItemCount', {
                    name = account.name,
                    count = account.money
                })
            end
        end
    end)

    RegisterNetEvent('esx:updateInventory', function(updates)
        for i = 1, #updates do
            local update = updates[i]
            postMessage('setItemCount', {
                name = update.name,
                count = update.count
            })
            itemCount[update.name] = update.count > 0 and update.count or nil
        end
    end)

    RegisterNetEvent('esx:addInventoryItem', function(itemName, count, weapon)
        if weapon then return end
        postMessage('setItemCount', {
            name = itemName,
            count = count
        })
        itemCount[itemName] = count > 0 and count or nil
    end)

    RegisterNetEvent('esx:removeInventoryItem', function(itemName, count, weapon)
        if weapon then return end
        postMessage('setItemCount', {
            name = itemName,
            count = count
        })
        itemCount[itemName] = count > 0 and count or nil
    end)

    RegisterNetEvent('esx:addWeapon', function(weaponName, ammo)
        postMessage('setItemCount', {
            name = weaponName,
            count = ammo
        })
        Wait(0)
        playerLoadout[weaponName] = GetAmmoInPedWeapon(PlayerPedId(), joaat(weaponName))
    end)

    RegisterNetEvent('esx:removeWeapon', function(weaponName)
        postMessage('setItemCount', {
            name = weaponName,
            count = json.null
        })
        playerLoadout[weaponName] = nil
    end)

    RegisterNetEvent('nongnut_inventory:closeInventory', function()
        closeInventory()
    end)

    RegisterNetEvent('esx:onPlayerDeath', function()
        closeInventory()
    end)

    RegisterNetEvent('nongnut_inventory:openSecondaryInventory', function(data, isAdmin, allItems, secondType)
        local items = {}
        for name, count in pairs(data['items'] or {}) do
            items[name] = {
                count = count,
                label = itemLabel[name] or name,
                type = 'item_standard'
            }
        end
        for name, count in pairs(data['accounts'] or {}) do
            items[name] = {
                count = count,
                label = itemLabel[name] or name,
                type = 'item_account'
            }
        end
        for name, weap in pairs(data['weapons'] or {}) do
            items[name] = {
                count = weap.ammo,
                label = itemLabel[name] or name,
                type = 'item_weapon',
                hideCount = GetWeaponDamageType(joaat(name)) == 2 and true or (hideCountCache[name] and true or nil)
            }
        end
        local vehicleKeyCfg = Config.ItemAddons['item_vehiclekey']
        if vehicleKeyCfg then
            for name in pairs(data.vehicle_key) do
                items['item_vehiclekey_' .. name] = {
                    label = name,
                    count = 1,
                    usable = vehicleKeyCfg.use,
                    giveable = vehicleKeyCfg.give,
                    droppable = vehicleKeyCfg.drop,
                    type = 'item_vehiclekey',
                    addon = true
                }
            end
        end
        if not isAdmin then
            local accountCfg = Config.Accounts
            for name in pairs(accountCfg) do
                if not accountCfg[name] then
                    items[name] = nil
                end
            end
        end

        if allItems then
            local items = {}
            local playerData = ESX.GetPlayerData()
            local inventory = playerData.inventory or {}
            for i = 1, #inventory do
                local item = inventory[i]
                items[item.name] = {
                    count = item.limit ~= -1 and item.limit or 1,
                    label = item.label,
                    type = 'item_standard'
                }
            end
            local accounts = playerData.accounts or {}
            for i = 1, #accounts do
                local account = accounts[i]
                items[account.name] = {
                    count = 1,
                    label = account.label,
                    type = 'item_account'
                }
            end
            local weapons = ESX.GetWeaponList()
            for i = 1, #weapons do
                local weapon = weapons[i]
                items[weapon.name] = {
                    count = 250,
                    label = weapon.label,
                    type = 'item_weapon',
                    hideCount = GetWeaponDamageType(joaat(weapon.name)) == 2 and true or (hideCountCache[weapon.name] and true or nil)
                }
            end
            postMessage('setLeftItems', {
                items = items
            })
        end
        setupSecondaryInventory({
            type = secondType or (allItems and 'playerall' or 'player'),
            name = tonumber(data.source),
            rightTitle = 'PLAYER INVENTORY',
            leftFooter = allItems and 'ALL ITEMS' or 'INVENTORY',
            rightFooter = ('กระเป๋าของ %s(%s)'):format(data.name, data.source),
        }, items, {
            type = 'blacklist',
            items = {}
        })
    end)

    RegisterNetEvent('nongnut_inventory:updateSecondInventory', function(itemType, itemName, itemCount, itemUniqueKey, history)
        if not itemCount or itemCount < 1 then
            removeSecondaryItem(itemName, itemUniqueKey)
        else
            changeSecondaryItem(itemName, itemType, itemCount, itemUniqueKey)
        end
        if history then
            postMessage('addHistory', {
                method = history[2] and "remove" or "add",
                name = history[1],
                item = history[3],
                amount = history[4],
                label = itemLabel[history[3]] or history[3]
            })
        end
    end)

    RegisterNetEvent('nongnut_inventory:allItems', function()
        local items = {}
        local playerData = ESX.GetPlayerData()
        local inventory = playerData.inventory or {}
        for i = 1, #inventory do
            local item = inventory[i]
            items[item.name] = {
                count = item.limit ~= -1 and item.limit or 1,
                label = item.label,
                type = 'item_standard'
            }
        end
        local accounts = playerData.accounts or {}
        for i = 1, #accounts do
            local account = accounts[i]
            items[account.name] = {
                count = 1,
                label = account.label,
                type = 'item_account'
            }
        end
        local weapons = ESX.GetWeaponList()
        for i = 1, #weapons do
            local weapon = weapons[i]
            items[weapon.name] = {
                count = 250,
                label = weapon.label,
                type = 'item_weapon',
                hideCount = GetWeaponDamageType(joaat(weapon.name)) == 2 and true or (hideCountCache[weapon.name] and true or nil)
            }
        end
        setupSecondaryInventory({
            type = 'allitems',
            rightTitle = 'ALL ITEMS',
            leftFooter = 'INVENTORY',
            rightFooter = 'ALL ITEMS',
            rightWeight = nil,
            rightMaxWeight = nil
        }, items, {
            type = 'blacklist',
            items = {}
        })
    end)

    RegisterNetEvent('nongnut_inventory:addAddonItem', addAddonItem)
    RegisterNetEvent('nongnut_inventory:removeAddonItem', removeAddonItem)
    
    registerInput('openinv', 'Open Inventory', 'keyboard', Config.Button.Inventory, function()
        openInventory()
    end)

    registerInput('openhotbar', 'Open Hotbar', 'keyboard', Config.Button.Hotbar, function()
        openHotbar(true)
    end)

    for i = 1, Config.FastSlot.Slot do
        registerInput('usehotbar_' .. i, 'Inventory Hotbar ' .. i, 'keyboard', tostring(i), function()
            local slot = fastSlotData[fastSlotTab] and fastSlotData[fastSlotTab][i]
            if not Function.BeforeUseFastSlot(i, slot) then return end
            openHotbar(false)
            Function.UseItem(slot)
        end)
    end

    RegisterCommand('closeinv', function()
        closeInventory()
    end)
end

local function initializeInventory()
    local actionMap = {
        use = {},
        give = {},
        drop = {}
    }
    for i = 1, #Config.ItemActions.use do
        local name = Config.ItemActions.use[i]
        actionMap.use[name] = true
    end
    for i = 1, #Config.ItemActions.give do
        local name = Config.ItemActions.give[i]
        actionMap.give[name] = true
    end
    for i = 1, #Config.ItemActions.drop do
        local name = Config.ItemActions.drop[i]
        actionMap.drop[name] = true
    end
    for i = 1, #Config.ItemHideCount do
        local name = Config.ItemHideCount[i]
        hideCountCache[name] = true
    end
    for i = 1, #Config.ItemNoShow do
        local name = Config.ItemNoShow[i]
        hiddenItemCache[name] = true
    end

    local items = {}
    local playerData = ESX.GetPlayerData()
    local inventory = playerData.inventory or {}
    for i = 1, #inventory do
        local item = inventory[i]
        items[item.name] = {
            count = item.count,
            label = item.label,
            limit = item.limit > 0 and item.limit or nil,
            usable = item.usable or actionMap.use[item.name] or actionMap.use['item_standard'],
            giveable = actionMap.give[item.name] or actionMap.give['item_standard'],
            droppable = actionMap.drop[item.name] or actionMap.drop['item_standard'],
            type = 'item_standard',
            hideCount = hideCountCache[item.name] and true or nil
        }
        itemCount[item.name] = item.count > 0 and item.count or nil
        itemLimit[item.name] = item.limit > 0 and item.limit or nil
        itemLabel[item.name] = item.label
    end
    local accounts = playerData.accounts or {}
    for i = 1, #accounts do
        local account = accounts[i]
        if Config.Accounts[account.name] then
            items[account.name] = {
                count = account.money,
                label = account.label,
                usable = actionMap.use[account.name] or actionMap.use['item_account'],
                giveable = actionMap.give[account.name] or actionMap.give['item_account'],
                droppable = actionMap.drop[account.name] or actionMap.drop['item_account'],
                type = 'item_account'
            }
        end
        itemCount[account.name] = account.money > 0 and account.money or nil
        itemLabel[account.name] = account.label
    end
    local weapons = ESX.GetWeaponList()
    for i = 1, #weapons do
        local weapon = weapons[i]
        items[weapon.name] = {
            count = json.null,
            label = weapon.label,
            usable = actionMap.use[weapon.name] or actionMap.use['item_weapon'],
            giveable = actionMap.give[weapon.name] or actionMap.give['item_weapon'],
            droppable = actionMap.drop[weapon.name] or actionMap.drop['item_weapon'],
            type = 'item_weapon',
            hideCount = GetWeaponDamageType(joaat(weapon.name)) == 2 and true or (hideCountCache[weapon.name] and true or nil)
        }
        itemLabel[weapon.name] = weapon.label
    end
    local loadout = playerData.loadout or {}
    for i = 1, #loadout do
        local weapon = loadout[i]
        if items[weapon.name] then
            local ammo = GetAmmoInPedWeapon(PlayerPedId(), joaat(weapon.name))
            items[weapon.name].count = ammo
            playerLoadout[weapon.name] = ammo
        end
    end
    local fastSlots = {}
    local saveFastSlots = json.decode(GetResourceKvpString('inventory_fastslots') or '{}')
    for i = 1, Config.FastSlot.Tab do
        fastSlots[i] = {}
        for j = 1, Config.FastSlot.Slot do
            -- fastSlots[i][j] = json.null
            if saveFastSlots[i] and saveFastSlots[i][j] then
                fastSlots[i][j] = saveFastSlots[i][j]
            else
                fastSlots[i][j] = json.null
            end
        end
    end
    fastSlotData = fastSlots

    -- FASHION
    while GetResourceState('bt_attacher') ~= 'started' and GetResourceState('bt_attacher') ~= 'missing' do
        Wait(100)
    end
    while GetResourceState('jpx_mark_fashion') ~= 'started' and GetResourceState('jpx_mark_fashion') ~= 'missing' do
        Wait(100)
    end
    pcall(function()
        local ignoreList = {
            ['phone'] = true
        }
        local btCfg = GetResourceState('bt_attacher') ~= 'missing' and exports['bt_attacher']:getConfig().Attach_Config or {}
        local jpxCfg = GetResourceState('jpx_mark_fashion') ~= 'missing' and exports['jpx_mark_fashion']:getItemList() or {}
        for name in pairs(ignoreList) do
            btCfg[name] = nil
            for _, jpxFashionData in pairs(jpxCfg) do
                if jpxFashionData.itemname == name then
                    jpxCfg[_] = nil
                    break
                end
            end
        end
        for k, v in pairs(Config.Categories) do
            if v.name == 'fashion' or v.name == 'all' then
                for btFashionName in pairs(btCfg) do
                    v.items[btFashionName] = true
                end
                for _, jpxFashionData in pairs(jpxCfg) do
                    v.items[jpxFashionData.itemname] = true
                end
                -- break
            end
        end
    end)
    -- FASHION

    postMessage('setupInventory', {
        items = items,
        hiddenItems = hiddenItemCache,
        itemOrders = Config.ItemOrders,
        itemDescriptions = Config.ItemDescriptions,
        categories = Config.Categories,
        favorites = json.decode(GetResourceKvpString('inventory_favorites') or '{}'),
        fastSlots = fastSlots,
        playerId = GetPlayerServerId(PlayerId()),
        onlineRewards = {
            seconds = 0,
            rewards = {},
            currentRewardIndex = 0
        }
    })
    for itemName, itemData in pairs(Config.ItemDefaults) do
        postMessage('addItem', {
            name = itemName,
            item = {
                label = itemData.label,
                count = 1,
                usable = itemData.use,
                giveable = itemData.give,
                droppable = itemData.drop,
                type = 'item_default',
                image = itemData.image or (itemName .. '.png'),
                addon = true
            }
        })
        -- setImageOverride(itemName, itemData.image or (itemName .. '.png'))
        itemCount[itemName] = 1
        itemLabel[itemName] = itemData.label
    end
    print('Inventory initialized')
    TriggerEvent('nongnut_inventory:initialized')
    initialized()
    Function.Loop()
end

RegisterNUICallback('uiLoaded', function(data, cb)
    cb('ok')
    uiLoaded:resolve(true)
end)

RegisterNUICallback('close', function(data, cb)
    cb('ok')
    closeInventory()
end)

RegisterNUICallback('giveItem', function(data, cb)
    cb('ok')
    Function.GiveItem(tonumber(data.target), data.name, data.type, tonumber(data.amount))
end)

RegisterNUICallback('dragItem', function(data, cb)
    cb('ok')
    local amount = tonumber(data.amount) or 0
    if amount < 1 then return end
    local source = data.source
    if source == 'drop' then
        Function.DropItem(data.name, data.type, amount)
    elseif secondaryType then
        local action = source == 'left' and 'put' or (source == 'right' and 'take' or nil)
        if action then
            Function.DragItem(action, secondaryType, secondaryName, data.name, data.type, amount, data.key)
        end
    end
end)

RegisterNUICallback('useItem', function(data, cb)
    cb('ok')
    Function.UseItem(data)
end)

RegisterNUICallback('transferVehicle', function(data, cb)
    cb('ok')
    local name = data.name
    if name then
        Function.TransferKey(name:gsub('item_vehiclekey_', ''), function(...)
            postMessage('openTransferVehicle', ...)
        end)
    else
        Function.TransferKeySubmit(tonumber(data.renterId), data.plate, tonumber(data.days), tonumber(data.hours), tonumber(data.rentalPrice))
    end
end)

RegisterNUICallback('changeWeaponSkin', function(data, cb)
    cb('ok')
    local weapon = data.weapon
    if weapon then
        local skin = data.skin
        if skin then
            Function.ChangeWeaponSkinSubmit(weapon, skin)
        end
    else
        local weaponName = data.name
        local weaponSkinConfig = Config.WeaponSkins[weaponName]
        if weaponSkinConfig then
            Function.ChangeWeaponSkin(weaponName, weaponSkinConfig, function(...)
                postMessage('openWeaponSkin', ...)
            end)
        end
    end
end)

RegisterNUICallback('updateFavorites', function(data, cb)
    cb('ok')
    SetResourceKvp('inventory_favorites', json.encode(data.favorites))
end)

RegisterNUICallback('tabChanged', function(data, cb)
    cb('ok')
    fastSlotTab = data.tab
end)

RegisterNUICallback('updateFastSlots', function(data, cb)
    cb('ok')
    SetResourceKvp('inventory_fastslots', json.encode(data.fastSlots))
    fastSlotData = data.fastSlots
end)

RegisterNUICallback('onItemProgressComplete', function(data, cb)
    cb('ok')
    local callbackIdx = tonumber(data.callbackIdx)
    if not callbackIdx then return end
    local callback = itemProgressCallback[callbackIdx]
    if callback then
        callback()
        itemProgressCallback[callbackIdx] = nil
    end
end)

CreateThread(function()
    repeat
        Wait(1000)
    until ESX.IsPlayerLoaded()
    initializeInventory()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName and isOpen then closeInventory() end
end)

exports('postMessage', postMessage)
exports('closeInventory', closeInventory)
exports('isInventoryOpen', function()
    return isOpen
end)
exports('setupSecondaryInventory', setupSecondaryInventory)
exports('changeSecondaryData', changeSecondaryData)
exports('changeSecondaryItem', changeSecondaryItem)
exports('removeSecondaryItem', removeSecondaryItem)
exports('addAddonItem', addAddonItem)
exports('removeAddonItem', removeAddonItem)
exports('setImageOverride', setImageOverride)
exports('removeImageOverride', removeImageOverride)
exports('getNoShowItems', function()
    return hiddenItemCache
end)
exports('itemProgress', itemProgress)
exports('cancelItemProgress', cancelItemProgress)
exports('cancelAllItemProgress', cancelAllItemProgress)
