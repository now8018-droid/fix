if IsDuplicityVersion() then return end

local ESX = exports['es_extended']:getSharedObject()

local firstLoad = promise.new()
if ESX.IsPlayerLoaded() then
    firstLoad:resolve(true)
else
    local handler
    handler = RegisterNetEvent('esx:restoreLoadout', function()
        firstLoad:resolve(true)
        RemoveEventHandler(handler)
    end)
end

function Function.ChangeWeaponSkin(weaponName, skinConfig, cb)
    local skinActiveIndex = -1
    local skins = {
        { id = 'default', label = 'Default', image = weaponName }
    }
    for i = 1, #skinConfig do
        local skin = skinConfig[i]
        if (itemCount[skin.item] or 0) > 0 then
            local name = skin.name
            local isActive = HasPedGotWeaponComponent(PlayerPedId(), joaat(weaponName), joaat(name))
            skins[#skins + 1] = {id = name, label = skin.label, image = name, active = isActive}
            if isActive then
                skinActiveIndex = i
            end
        end
    end
    if skinActiveIndex == -1 then
        skins[1].active = true
    end
    cb({
        weapon = {
            name = weaponName,
            label = itemLabel[weaponName] or weaponName
        },
        skins = skins
    })
end

function Function.ChangeWeaponSkinSubmit(weaponName, skinName)
    if weaponName and skinName then
        if HasPedGotWeaponComponent(PlayerPedId(), joaat(weaponName), joaat(skinName)) then return end
        TriggerServerEvent('nongnut_inventory:changeWeapSkin', weaponName, skinName)
    end
end

RegisterNetEvent('nongnut_inventory:initialized', function()
    Citizen.Await(firstLoad)
    Wait(1000)
    local loadout = ESX.GetPlayerData().loadout
    for i = 1, #loadout do
        local weapon = loadout[i]
        local weaponName = weapon.name
        local weaponSkinConfig = Config.WeaponSkins[weaponName]
        if weaponSkinConfig then
            for j = 1, #weaponSkinConfig do
                local skin = weaponSkinConfig[j]
                local skinName = skin.name
                if HasPedGotWeaponComponent(PlayerPedId(), joaat(weaponName), joaat(skinName)) then
                    exports['nongnut_inventory']:setImageOverride(weaponName, skinName .. '.png')
                end
            end
        end
    end

    RegisterNetEvent('esx:addWeaponComponent', function(weaponName, weaponComponent)
        exports['nongnut_inventory']:setImageOverride(weaponName, weaponComponent .. '.png')
    end)
    
    RegisterNetEvent('esx:removeWeaponComponent', function(weaponName, weaponComponent, silentRemove)
        if silentRemove then return end
        exports['nongnut_inventory']:removeImageOverride(weaponName)
    end)
end)