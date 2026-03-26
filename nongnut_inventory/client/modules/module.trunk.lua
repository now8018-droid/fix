RegisterNetEvent('nongnut_inventory:initialized', function()
    local ESX = exports['es_extended']:getSharedObject()

    local trunkOpen = false
    -- local weightData = exports['nongnut_trunkdata']:getTrunkData()
    -- Mock or fallback for trunkdata if the export is missing
    local weightData = {}
    if GetResourceState('nongnut_trunkdata') == 'started' then
        weightData = exports['nongnut_trunkdata']:getTrunkData()
    else
        -- Fallback default weights (whitelist based) or just empty if not using whitelist
        -- If config has it, use that. If not, empty table.
        weightData = Config and Config.TrunkWeights or {}
    end

    local function openTrunk(plate)
        trunkOpen = plate
        ESX.TriggerServerCallback('nongnut_inventory:getTrunk', function(data, weight, maxWeight)
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
                exports['nongnut_inventory']:setupSecondaryInventory({
                    type = 'trunk',
                    name = plate,
                    rightTitle = 'TRUNK',
                    leftFooter = 'INVENTORY',
                    rightFooter = plate,
                    rightWeight = weight,
                    rightMaxWeight = maxWeight
                }, items, {
                    type = 'whitelist',
                    items = weightData
                })
            end
        end, plate)
    end

    local function putItem(plate, itemName, itemType, itemCount)
        ESX.TriggerServerCallback('nongnut_inventory:trunk:putItem', function(success, count, weight)
            local count = count or 0
            if success then
                exports['nongnut_inventory']:changeSecondaryItem(itemName, itemType, count)
                exports['nongnut_inventory']:changeSecondaryData({
                    rightWeight = weight
                })
                TriggerEvent('nongnut_inventory:playAnim', 'trunk')
            end
        end, plate, itemName, itemType, tonumber(itemCount))
    end

    local function takeItem(plate, itemName, itemType, itemCount)
        ESX.TriggerServerCallback('nongnut_inventory:trunk:takeItem', function(success, count, weight)
            local count = count or 0
            if success then
                if count > 0 then
                    exports['nongnut_inventory']:changeSecondaryItem(itemName, itemType, count)
                else
                    exports['nongnut_inventory']:removeSecondaryItem(itemName)
                end
                exports['nongnut_inventory']:changeSecondaryData({
                    rightWeight = weight
                })
                TriggerEvent('nongnut_inventory:playAnim', 'trunk')
            end
        end, plate, itemName, itemType, tonumber(itemCount))
    end

    local function getVehicleInFront()
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local forwardVector = GetEntityForwardVector(playerPed)
        local vehicles = GetGamePool('CVehicle')
        local closestVehicle = nil
        local closestDistance = math.huge
        for i = 1, #vehicles do
            local vehicle = vehicles[i]
            local vehicleCoords = GetEntityCoords(vehicle)
            local distance = #(playerCoords - vehicleCoords)
            if distance < 7.0 then
                local direction = (vehicleCoords - playerCoords)
                direction = direction / #direction
                local dotProduct = forwardVector.x * direction.x + forwardVector.y * direction.y
                if dotProduct > 0.6 and distance < closestDistance then
                    closestDistance = distance
                    closestVehicle = vehicle
                end
            end
        end
        return closestVehicle
    end

    local function trim(s)
        return (s:gsub('^%s*(.-)%s*$', '%1'))
    end

    registerInput('opentrunk', 'Open Trunk', 'keyboard', 'L', function()
        local vehicle = getVehicleInFront()
        if DoesEntityExist(vehicle) then
            local plate = trim(GetVehicleNumberPlateText(vehicle))
            local jobName = ESX.GetPlayerData().job.name
            if exports['nongnut_garage']:getVehicles()[plate] or (jobName == 'police' or jobName == 'council') then
                SetVehicleDoorOpen(vehicle, 5, false, false)
                openTrunk(plate)
                CreateThread(function()
                    local handler
                    handler = AddEventHandler('nongnut_inventory:closed', function()
                        trunkOpen = false
                        RemoveEventHandler(handler)
                    end)
                    repeat
                        local playerPed = PlayerPedId()
                        local playerCoords = GetEntityCoords(playerPed)
                        local vehicleCoords = GetEntityCoords(vehicle)
                        if #(playerCoords - vehicleCoords) > 5 or not DoesEntityExist(vehicle) then
                            exports['nongnut_inventory']:closeInventory()
                        end
                        Wait(500)
                    until not trunkOpen
                    SetVehicleDoorShut(vehicle, 5, false)
                end)
            else
                ESX.ShowNotification('คุณไม่ใช่เจ้าของยานพาหนะนี้!', 'error')
            end
        end
    end)

    RegisterNetEvent('nongnut_inventory:openTrunk', function(plate)
        openTrunk(plate)
    end)

    exports('openTrunk', openTrunk)
    exports('putItemToTrunk', putItem)
    exports('takeItemFromTrunk', takeItem)
end)