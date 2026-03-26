function Function.Loop()
    local ESX = exports['es_extended']:getSharedObject()
    local nongnut_inventory = exports[GetCurrentResourceName()]
    local playerPed = PlayerPedId()
    CreateThread(function()
        -- local _BlockWeaponWheelThisFrame = BlockWeaponWheelThisFrame
        local _DisableControlAction = DisableControlAction
        local _HideHudComponentThisFrame = HideHudComponentThisFrame
        local _Wait = Citizen.Wait
        repeat
            -- _BlockWeaponWheelThisFrame()
            _DisableControlAction(0, 37, true)
            _HideHudComponentThisFrame(14)
            _Wait(0)
        until false
    end)
    CreateThread(function()
        local isInVehicle = false
        local isPedInVehicle
        repeat
            playerPed = PlayerPedId()
            isPedInVehicle = IsPedInAnyVehicle(playerPed, false)
            if isInVehicle ~= isPedInVehicle then
                nongnut_inventory:postMessage('setIsInVehicle', {
                    isInVehicle = isPedInVehicle
                })
                isInVehicle = isPedInVehicle
            end
            Wait(500)
        until false
    end)
    CreateThread(function()
        repeat
            for weaponName in pairs(playerLoadout) do
                local ammo = GetAmmoInPedWeapon(playerPed, joaat(weaponName))
                if playerLoadout[weaponName] ~= ammo then
                    playerLoadout[weaponName] = ammo
                    nongnut_inventory:postMessage('setItemCount', {
                        name = weaponName,
                        count = ammo
                    })
                end
            end
            Wait(1000)
        until false
    end)
end