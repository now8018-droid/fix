local ESX = exports['es_extended']:getSharedObject()

local function notify(type, text)
    TriggerEvent('pNotify:SendNotification', {
        text = text,
        type = type,
        timeout = 3000,
        layout = 'bottomcenter',
        queue = 'global'
    })
end

local function getItem(itemName)
    -- local playerData = ESX.GetPlayerData()
    -- for i = 1, #playerData.inventory do
    --     local item = playerData.inventory[i]
    --     if item.name == itemName then
    --         return item
	-- 	end
	-- end
    -- return nil
    return {count = itemCount[itemName] or 0}
end

RegisterNetEvent('nongnut_inventory:initialized', function()
    --
    -- client-side usable items registry
    if not ESX.RegisterUsableItem then
        -- Placeholder or local definition if ESX doesn't support client-side usable items directly
        -- We will use a local registry that function.default.lua can access via export or global var if needed
        -- BUT, function.default.lua tries to call ESX.UseItem.
        -- Let's mock it for now so we can register items here.
        ESX.UsableItemsCallbacks = {}
        ESX.RegisterUsableItem = function(item, cb)
            ESX.UsableItemsCallbacks[item] = cb
        end
        ESX.UseItem = function(item)
            if ESX.UsableItemsCallbacks[item] then
                ESX.UsableItemsCallbacks[item]()
                return true
            end
            return false
        end
    end

    ESX.RegisterUsableItem('card_id', function()
        pcall(function()
            exports['plus_idcard']:UseIdCard()
        end)
    end)
    ESX.RegisterUsableItem('fixkit', function()
        local isStealing = false
		pcall(function()
			isStealing = exports['plus_activitycore']:GetStealingState() or false
		end)
		
		if isStealing then
			return
		end
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 2.5) and IsPedOnFoot(playerPed) then
			local vehicle, dist = ESX.Game.GetClosestVehicle()
			if DoesEntityExist(vehicle) and dist <= 2.5 then
				TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
                exports['plus_progressbar']:Progress({
                    name = 'fixkit',
                    duration = 10000,
                    label = 'กำลังซ่อม...',
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    },
                },
                function(cancelled)
                    if not cancelled then
                        if getItem('fixkit').count > 0 then
                            TriggerServerEvent('esx:removeInventoryItem', 'item_standard', 'fixkit', 1)
                            SetVehicleFixed(vehicle)
                            SetVehicleDeformationFixed(vehicle)
                            SetVehicleUndriveable(vehicle, false)
                            SetVehicleEngineOn(vehicle, true, true)
                            notify('success', 'ซ่อมพาหนะสำเร็จ')
                            pcall(function()
                                TriggerServerEvent('up_battlepass:AddMissionAmount_SV', 'quest_a:1', 1)
                            end)
                        end
                    end
				    ClearPedTasksImmediately(playerPed)
                end)
			else
				notify('error', 'ไม่พบพาหนะ')
			end
		else
			notify('error', 'ไม่พบพาหนะ')
		end
    end)
    ESX.RegisterUsableItem('car_wash', function()
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 2.5) and IsPedOnFoot(playerPed) then
			local vehicle, dist = ESX.Game.GetClosestVehicle()
			if DoesEntityExist(vehicle) and dist <= 2.5 then
				TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
                exports['plus_progressbar']:Progress({
                    name = 'car_wash',
                    duration = 5000,
                    label = 'กำลังเช็ด...',
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    },
                },
                function(cancelled)
                    if not cancelled then
                        if getItem('car_wash').count > 0 then
                            TriggerServerEvent('esx:removeInventoryItem', 'item_standard', 'car_wash', 1)
					        WashDecalsFromVehicle(vehicle, 1.0)
					        SetVehicleDirtLevel(vehicle, 0.0)
						    RemoveDecalsFromVehicle(vehicle)
                            notify('success', 'เช็ดพาหนะสำเร็จ')
                        end
                    end
				    ClearPedTasksImmediately(playerPed)
                end)
			else
				notify('error', 'ไม่พบพาหนะ')
			end
		else
			notify('error', 'ไม่พบพาหนะ')
		end
    end)
    ESX.RegisterUsableItem('ammo_revolver', function()
        if not revolverCooldown and getItem('ammo_revolver').count > 0 and not exports['nongnut_inventory']:isUseWeaponDelay() then
            local playerPed = PlayerPedId()
            local currentWeapon = GetSelectedPedWeapon(playerPed)
            local ammoData = revolverAmmo[currentWeapon]
            if ammoData then
                local currentAmmo = GetAmmoInPedWeapon(playerPed, currentWeapon)
                if currentAmmo >= ammoData.maxAmmo then
                    notify('error', 'กระสุนเต็มแล้ว')
                    return
                end
                TriggerServerEvent('esx:removeInventoryItem', 'item_standard', 'ammo_revolver', 1)
                revolverCooldown = true
                currentAmmo = math.min(currentAmmo + ammoData.ammo, ammoData.maxAmmo)
                if IsPedInAnyVehicle(playerPed, false) then
                    SetPedAmmo(playerPed, currentWeapon, currentAmmo)
                else
                    SetAmmoInClip(playerPed, currentWeapon, 0)
                    SetPedAmmo(playerPed, currentWeapon, currentAmmo)
                    MakePedReload(playerPed, currentWeapon)
                end
                SetTimeout(2000, function()
                    revolverCooldown = false
                end)
            end
        end
    end)
    ESX.RegisterUsableItem('checkcar', function()
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 2.5) and IsPedOnFoot(playerPed) then
			local vehicle, dist = ESX.Game.GetClosestVehicle()
			if DoesEntityExist(vehicle) and dist <= 2.5 then
                local plate = string.gsub(GetVehicleNumberPlateText(vehicle), '^%s*(.-)%s*$', '%1')
                ESX.TriggerServerCallback('nongnut_inventory:checkVehicleData', function(data)
                    if data then
                        local model = GetEntityModel(vehicle)
                        local label = GetDisplayNameFromVehicleModel(model)
                        local server_model = data.model
                        local server_owner = data.owner
                        
                        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'checkvehicledata',
                        {
                            title    = 'ตรวจสอบยานพาหนะ',
                            align    = 'top-right',
                            elements = {
                                {label = 'ทะเบียน: ' .. plate, value = plate},
                                {label = 'โมเดล: ' .. server_model, value = label},
                                {label = 'เจ้าของ: ' .. server_owner, value = server_owner},
                                {label = 'สถานะ: ' .. (model == GetHashKey(server_model) and 'ถูกต้อง' or 'ไม่ถูกต้อง'), value = (model == GetHashKey(server_model) and 'ถูกต้อง' or 'ไม่ถูกต้อง')},
                            }
                        }, function(data, menu)
                            -- menu.close()
                        end, function(data, menu)
                            menu.close()
                        end)
                    else
                        notify('error', 'ไม่พบข้อมูลพาหนะ')
                    end
                end, plate)
            else
                notify('error', 'ไม่พบพาหนะ')
            end
        else
            notify('error', 'ไม่พบพาหนะ')
        end
    end)
end)