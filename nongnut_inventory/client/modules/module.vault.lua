local ESX = exports['es_extended']:getSharedObject()

ESX.ShowNotification = function(text, type, duration)
    TriggerEvent('pNotify:SendNotification', {
        text = text,
        type = type or 'info',
        timeout = duration or 3000,
        layout = 'bottomleft',
        queue = 'global'
    })
end

local vaultOpen = false
local triggerServer = false

function putItem(vaultType, itemName, itemType, itemCount)
    if itemType == 'item_weapon' then
        local PlayerPed = PlayerPedId()
        local weaponHash = joaat(itemName)
        if HasPedGotWeapon(PlayerPed, weaponHash, false) then
            itemCount = GetAmmoInPedWeapon(PlayerPed, weaponHash)
        else
            return
        end
    end
    
    ESX.TriggerServerCallback('nongnut_inventory:vault:putItem', function(success, count, ukey)
        local count = count or 0
        if success then
            exports[GetCurrentResourceName()]:changeSecondaryItem(itemName, itemType, count, ukey)
        end
    end, vaultType, itemName, itemType, itemCount)
end

function takeItem(vaultType, itemName, itemType, itemCount, itemUniqueKey)
    ESX.TriggerServerCallback('nongnut_inventory:vault:takeItem', function(success, count, ukey)
        local count = count or 0
        if success then
            if count > 0 then
                exports[GetCurrentResourceName()]:changeSecondaryItem(itemName, itemType, count, ukey)
            else
                exports[GetCurrentResourceName()]:removeSecondaryItem(itemName, ukey)
            end
        end
    end, vaultType, itemName, itemType, itemCount, itemUniqueKey)
end

RegisterFontFile('font4thai')
local fontId = RegisterFontId('font4thai')
RegisterFontFile('Kanit')
local fontIdKanit = RegisterFontId('Kanit')

local function Draw3DText(x, y, z, textInput, _, scaleX, scaleY)
    -- local px, py, pz = table.unpack(GetGameplayCamCoords())
    -- local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)  
    local camcoords = GetGameplayCamCoords() 
    local dist = GetDistanceBetweenCoords(camcoords.x, camcoords.y, camcoords.z, x, y, z, 1)    
    local scale = (1 / dist) * 15
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov 
    SetTextScale(scaleX * scale, scaleY * scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextColour(250, 250, 250, 255)		
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x, y , z + 2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

local vaultCoords = {
    {
        coords = vector3(930.0836, -3169.6430, 6.0909 + 0.5),
        radius = 2.0,
        vipRadius = 4.0,
        trunkIndex = 198,
        text = 'กด ~g~[E] ~w~เพื่อเปิดตู้เซฟ',
        -- item = {'vault_key', 'vault_key_pro'}
        item = {'vault_key', 'gangcard'}
    },
    {
        coords = vector3(1093.16, 3050.6, 43.24),
        radius = 2.0,
        text = 'กด ~g~[E] ~w~เพื่อเปิดตู้เซฟ',
        item = {'vault_key'}
    },

    {
        coords = vector3(-423.0636, 1085.606, 327.3994), --staff
        radius = 2.0,
        text = 'กด ~g~[E] ~w~เพื่อเปิดตู้เซฟ',
        item = {'vault_key', 'gangcard'}
    },
    {
        coords = vector3(1068.3165, 3045.6853, 48.4131 + 0.5),
        radius = 2.0,
        vipRadius = 4.0,
        trunkIndex = 199,
        text = 'กด ~g~[E] ~w~เพื่อเปิดตู้เซฟ',
        item = {'vault_key', 'gangcard'}
    },
    {
        coords = vector3(1148.44, -1575.28, 35.36),
        radius = 1.7,
        text = 'กด ~g~[E] ~w~เพื่อเปิดตู้เซฟ',
        item = {'vault_key'}
    },

    { -- police private
        coords = vector3(-338.8834, -581.443, 39.464),
        radius = 1.7,
        text = 'กด ~g~[E] ~w~เพื่อเปิดตู้เซฟ',
        item = {'vault_key'}
    },
    {
        coords = vector3(-322.0985, -581.4026, 39.464),
        radius = 2.0,
        text = 'กด ~g~[E] ~w~เพื่อเปิดตู้เซฟตำรวจ',
        job = 'police',
        item = 'vault_police'
    },

    {
        coords = vector3(1142.32, -1575.64, 35.36),
        radius = 2.0,
        text = 'กด ~g~[E] ~w~เพื่อเปิดตู้เซฟหมอ',
        job = 'ambulance',
        item = 'vault_medic'
    },
    {
        coords = vector3(-417.4415, 1085.6508, 327.3994), 
        radius = 2.0,
        text = 'กด ~g~[E] ~w~เพื่อเปิดตู้เซฟสภา',
        job = 'council',
        item = 'vault_council'
    },
    { -- PUB
        coords = vector3(94.3631, -1271.8608, 21.1111), 
        radius = 2.0,
        text = 'กด ~g~[E] ~w~เพื่อเปิดตู้เซฟ',
        job = 'vanilla',
    },
    -- {
    --     coords = vector3(-1718.2, -943.88, 12.32),
    --     radius = 2.0,
    --     text = 'กด ~g~[E] ~w~เพื่อเปิดตู้เซฟ N CLUB',
    --     job = 'nclub'
    -- },
    {
        coords = vector3(0.0, 0.0, 5000.0),
        radius = 0.0,
        text = 'กด ~g~[E] ~w~เพื่อเปิดตู้เซฟ',
        item = {'vault_key', 'gangcard'}
    },
}

local vaultGangMap = (function()
    for i = 1, #vaultCoords do
        local vault = vaultCoords[i]
        if vault.coords == vector3(0.0, 0.0, 5000.0) then
            return vault
        end
    end
end)()

local function checkCoords(coords, radius)
    repeat
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        if #(playerCoords - coords) > radius then
            exports[GetCurrentResourceName()]:closeInventory()
        end
        Wait(500)
    until not vaultOpen
end

local function checkItem(itemName)
    local playerData = ESX.GetPlayerData()
    if playerData.inventory then
        for _, item in pairs(playerData.inventory) do
            if item.name == itemName then
                return item.count, item.label
            end
        end
    end
    return 0, itemName
end

local bypassBlock = Config.BypassBlockVault

local function openVault(eventName, v, ...)
    local playerData = ESX.GetPlayerData()
    ESX.TriggerServerCallback(eventName, function(data, gang, history)
        if data then
            local items = {}
            for name, count in pairs(data['item_account'] or {}) do
                items[name] = {
                    count = count,
                    label = itemLabel[name] or name,
                    type = 'item_account'
                }
            end
            for name, count in pairs(data['item_standard'] or {}) do
                items[name] = {
                    count = count,
                    label = itemLabel[name] or name,
                    type = 'item_standard'
                }
            end
            for name, weapKey in pairs(data['item_weapon'] or {}) do
                for key, ammo in pairs(weapKey) do
                    items[name .. ':' .. key] = {
                        count = ammo,
                        label = itemLabel[name] or name,
                        key = key,
                        type = 'item_weapon',
                        hideCount = GetWeaponDamageType(joaat(name)) == 2 and true or (hideCountCache[name] and true or nil),
                        image = name .. '.png'
                    }
                end
            end
            -- SetSecondText('STORAGE')
            -- ShowElement('title-left')
            -- ShowElement('title-right')
            -- SetElementHTML('title-left', 'INVENTORY')
            -- SetElementHTML('title-right', 'STORAGE')
            -- SetupSecondInventory(items, 'vault', gang and 'gang' or v.job or '')
            local mergedTable = {}
            local blockType = 'blacklist'
            for key, value in pairs(Config.ItemAddons) do
                mergedTable[key] = value
            end
            for key, value in pairs(Config.ItemDefaults) do
                mergedTable[key] = value
            end
            for key, value in pairs(Config.BlockVault) do
                mergedTable[key] = value
            end
            if v.job and bypassBlock[playerData.job.name] then
                for item in pairs(bypassBlock[playerData.job.name]) do
                    mergedTable[item] = nil
                end
            end
            -- if v.admin then
            --     mergedTable = {}
            -- end
            if gang then
                blockType = 'whitelist'
                -- blockType = 'blacklist'
                mergedTable = Config.GangVaultItem
            end
            -- if gang or v.job then
            --     triggerServer = true
            --     local historyCount = history and #history or 0
            --     local tempHistory = {}
            --     for i = 1, historyCount do
            --         local entry = history[i]
            --         tempHistory[i] = {
            --             action = entry[2],
            --             name = entry[1],
            --             item = entry[3],
            --             count = entry[4],
            --         }
            --     end
            --     CallJSCustomFunction('showVaultHistory', tempHistory)
            -- end
            -- DisableItems(mergedTable, gang and true or false)
            -- OpenSecondInventory()
            exports[GetCurrentResourceName()]:setupSecondaryInventory({
                type = 'vault',
                name = gang and 'gang' or v.job or nil,
                rightTitle = 'VAULT',
                leftFooter = 'INVENTORY',
                rightFooter = 'VAULT',
            }, items, {
                type = blockType,
                items = mergedTable
            })
            vaultOpen = true
            CreateThread(function()
                checkCoords(v.coords, v.radius + 5.0)
            end)
            
            if gang or v.job then
                local historyCount = history and #history or 0
                local tempHistory = {}
                local itemLabel = _G.itemLabel or {}
                for i = 1, historyCount do
                    local entry = history[i]
                    tempHistory[i] = {
                        method = entry[2] and "remove" or "add",
                        name = entry[1],
                        item = entry[3],
                        amount = entry[4],
                        label = itemLabel[entry[3]] or entry[3]
                    }
                end
                exports[GetCurrentResourceName()]:postMessage('setHistory', {
                    history = tempHistory
                })
            end
        end
    end, ...)
end

local function openVaultSelector(items, index)
    exports[GetCurrentResourceName()]:postMessage('setVaultSelector', {
        items = items,
        index = index
    })
    SetNuiFocus(true, true)
end

RegisterNUICallback('selectVault', function(data, cb)
    cb('OK')
    local index = data.index
    local item = data.item
    local config_index = data.cfgIndex
    local v = vaultCoords[config_index]
    exports[GetCurrentResourceName()]:postMessage('setVaultSelector', {})
    SetNuiFocus(false, false)
    if item == 'gangcard' then
        local myGang = exports.gangsystem:getGangData()
        if myGang and myGang.gangType == 'family' then
            item = 'familycard'
        end
    end
    local itemCount, itemLabel = checkItem(item)
    if itemCount < 1 then
        ESX.ShowNotification('คุณไม่มี ' .. itemLabel .. ' เพื่อเปิดตู้เซฟนี้', 'error')
        return
    end
    local eventName = 'nongnut_inventory:getVaultDataStore'
    -- if index == 2 then
        -- eventName = 'nongnut_inventory:getVaultIIDataStore'
    -- elseif index == 3 then
    if index == 2 then
        eventName = 'nongnut_inventory:getVaultGangDataStore'
    end
    openVault(eventName, v)
end)

exports('openGangVault', function()
    if checkItem('gangcard') < 1 then
        return false
    end
    -- local myGang = exports['gangsystem']:GetMyGang()
    -- if not myGang then
    --     return false
    -- end
    SetTimeout(250, function()
        openVault('nongnut_inventory:getVaultGangDataStore', {
            coords = GetEntityCoords(PlayerPedId()),
            radius = 2.0,
        }, true)
    end)
    return true
end)

CreateThread(function()
    repeat
        Wait(1000)
    until ESX.IsPlayerLoaded()
    local sleep
    local errorMsg = 'คุณไม่มีสิทธิ์เปิดตู้เซฟนี้'
    repeat
        sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local foundVault = false
        local vipCount = itemCount['vip_used'] or 0
        local isVip = vipCount > 0
        for k, v in pairs(vaultCoords) do
            local radius = isVip and v.vipRadius or v.radius
            if #(playerCoords - v.coords) < radius then
                Draw3DText(v.coords.x, v.coords.y, v.coords.z - 1.5, v.text, nil, 0.08, 0.08)
                if isVip and v.vipRadius then
                    Draw3DText(v.coords.x, v.coords.y, v.coords.z - 1.3, 'กด ~g~[L] ~w~เพื่อเปิดท้ายรถ', nil, 0.07, 0.07)
                end
                foundVault = true
                sleep = 0
                if IsControlJustReleased(0, 38) then
                    local playerData = ESX.GetPlayerData()
                    local canOpen = true
                    local silent = false
                    local eventName = 'nongnut_inventory:getVaultDataStore'
                    if v.job then
                        eventName = 'nongnut_inventory:getSharedDataStore'
                        -- if (playerData.job.name ~= v.job) and (playerData.job.name ~= 'admin') then
                        if playerData.job.name ~= v.job then
                            canOpen = false
                            errorMsg = 'คุณไม่มีสิทธิ์เปิดตู้เซฟนี้'
                        end
                    end
                    if v.item then
                        if type(v.item) == 'table' then
                            canOpen = false
                            silent = true
                            openVaultSelector(v.item, k)
                        else
                            local itemCount, itemLabel = checkItem(v.item)
                            if itemCount < 1 then
                                canOpen = false
                                errorMsg = 'คุณไม่มี ' .. itemLabel .. ' เพื่อเปิดตู้เซฟนี้'
                            end
                        end
                    end
                    if canOpen then
                        openVault(eventName, v)
                    else
                        if not silent then ESX.ShowNotification(errorMsg, 'error') end
                    end
                end
                if isVip and v.vipRadius and IsControlJustReleased(0, 182) then
                    exports['nongnut_garage']:openDropoffTrunk(v.trunkIndex)
                end
            end
        end
        Wait(sleep)
    until false
end)

RegisterNetEvent('nongnut_inventory:closed', function()
    vaultOpen = false
    if triggerServer then
        triggerServer = false
        TriggerServerEvent('nongnut_inventory:closeVault')
        CallJSCustomFunction('hideVaultHistory')
    end
end)

exports('isVaultOpen', function()
    return vaultOpen
end)

exports('changeStoryVaultCoords', function(newCoords, newRadius)
    vaultGangMap.coords = newCoords
    vaultGangMap.radius = newRadius
end)

exports('putItemToVault', putItem)
exports('takeItemFromVault', takeItem)

RegisterCommand('openvault', function(source, args, rawCommand)
    local storeName = args[1]
    if storeName and storeName ~= '' then
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        openVault('nongnut_inventory:admin:getSharedDataStore', {
            job = storeName,
            coords = playerCoords.xyz,
            radius = 5.0,
            admin = true
        }, storeName)
    end
end)

-- local allowVaults = {
--     {
--         index = 1,
--         radius = 4.0
--     }
-- }

-- CreateThread(function()
--     repeat 
--         for i = 1, #allowVaults do
--             local vaultMap = allowVaults[i]
--             local v = vaultCoords[vaultMap.index]
--             if not v then goto continue end
--             DrawMarker(1, v.coords.x, v.coords.y, v.coords.z - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, vaultMap.radius * 2.0, vaultMap.radius * 2.0, 1.0, 0, 255, 0, 100, false, false, false, true, false, false, false)
--             ::continue::
--         end
--         Wait(0)
--     until false
-- end)

-- registerInput('openvaultvip', 'Open Vault Vip', 'keyboard', 'L', function()
--     if checkItem('vip_used') < 1 then
--         return
--     end
--     local playerPed = PlayerPedId()
--     local playerCoords = GetEntityCoords(playerPed)
--     for i = 1, #allowVaults do
--         local vaultMap = allowVaults[i]
--         local v = vaultCoords[vaultMap.index]
--         if not v then goto continue end
--         if #(playerCoords - v.coords) < vaultMap.radius then
--             local k = vaultMap.index
--             local errorMsg = 'คุณไม่มีสิทธิ์เปิดตู้เซฟนี้'
--             local playerData = ESX.GetPlayerData()
--             local canOpen = true
--             local silent = false
--             local eventName = 'nongnut_inventory:getVaultDataStore'
--             if v.job then
--                 eventName = 'nongnut_inventory:getSharedDataStore'
--                 -- if (playerData.job.name ~= v.job) and (playerData.job.name ~= 'admin') then
--                 if playerData.job.name ~= v.job then
--                     canOpen = false
--                     errorMsg = 'คุณไม่มีสิทธิ์เปิดตู้เซฟนี้'
--                 end
--             end
--             if v.item then
--                 if type(v.item) == 'table' then
--                     canOpen = false
--                     silent = true
--                     openVaultSelector(v.item, k)
--                 else
--                     local itemCount, itemLabel = checkItem(v.item)
--                     if itemCount < 1 then
--                         canOpen = false
--                         errorMsg = 'คุณไม่มี ' .. itemLabel .. ' เพื่อเปิดตู้เซฟนี้'
--                     end
--                 end
--             end
--             if canOpen then
--                 openVault(eventName, v)
--             else
--                 if not silent then ESX.ShowNotification(errorMsg, 'error') end
--             end
--         end
--         ::continue::
--     end
-- end)