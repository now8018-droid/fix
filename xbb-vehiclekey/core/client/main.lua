local ESX = nil
local STCNAME = GetCurrentResourceName()..'.'
local vehicleKey = {}
vehicleKey.__index = vehicleKey

Call = {}
Call.list = {}
Call.Id = 0

function vehicleKey.new(cfg)
    local self = setmetatable({
        Cfg = cfg,
        PlayerPedId = nil,
        isPlayerKey = {},
        isDelay = 0,
    }, vehicleKey)
    return self
end

function vehicleKey:setupCB()
    Call.Trigger = function(n,cb,...)
        Call.list[Call.Id] = cb
        TriggerServerEvent(STCNAME..'sv.Returndata', n , Call.Id, ...)
        Call.Id = ( Call.Id < 65535 ) and ( Call.Id + 1 ) or 0
    end

    self:addNewEV(STCNAME..'cl.Returndata',function(Id, ...)
        Call.list[Id](...)
        Call.list[Id] = nil
    end)
    
end

function vehicleKey:addNewEV(name,headler)
    return RegisterNetEvent(name) , AddEventHandler(name,headler)
end

function vehicleKey:setupMain()
    TriggerServerEvent(STCNAME..'sv.requestDataNEW')

    self.PlayerPedId = PlayerPedId()

    Citizen.CreateThread(function ()
        while true do
            Wait(5000)
            self.PlayerPedId = PlayerPedId()
        end
    end)

    self:addNewEV(STCNAME..'cl.requestDataNEW', function (data)
        self.isPlayerKey = data
    end)

    self:addNewEV(STCNAME..'cl.addupdateKey', function (plate)
        self.isPlayerKey[plate] = true
        pcall(function ()
            exports['nakin_allnotify']:AddNotify({type = "success", text = "ได้สร้างกุญแจรถ "..plate..""})
        end)
    end)

    self:addNewEV(STCNAME..'cl.removeKey', function (plate)
        self.isPlayerKey[plate] = nil
    end)

    self:addNewEV(STCNAME..'cl.setVehicle', function (plate)
        self:setVehicle(plate)
    end)

    CreateThread(function()
        while true do
            local isinvehicle = IsPedInAnyVehicle(self.PlayerPedId, true)
            if isinvehicle then
                if IsDisabledControlJustReleased(0, self.Cfg.getRemoteKey) then
                    self:getKeyVehicle()
                    Wait(5000)
                end
            end
            Wait(7)
        end
    end)

    RegisterKeyMapping('toggleremote', 'Use Remote Vehicle' , 'keyboard' , '')
    RegisterCommand('toggleremote',function()
        self:useKey()
    end, false)

    exports('toggle', function (plate)
        self:useKey(plate)
    end)
    
    exports('getkey' , function ()
        return self.isPlayerKey
    end)
end

function vehicleKey:loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(0)
    end
end

function vehicleKey:TriggerNuiEvent(eventName, data)
    SendNUIMessage({
        eventName = eventName,
        data = data,
    })
end

function vehicleKey:GetClosestVehicleAlternative(coords, distance)
    local vehicles = GetGamePool("CVehicle")
    local closestVehicle = nil
    local minDistance = distance
    for _, vehicle in ipairs(vehicles) do
        local vehicleCoords = GetEntityCoords(vehicle)
        local dist = #(coords - vehicleCoords)
        if dist < minDistance then
            minDistance = dist
            closestVehicle = vehicle
        end
    end
    return closestVehicle or 0
end

function vehicleKey:getKeyVehicle()
    if not IsPedInAnyVehicle(self.PlayerPedId, true) then
        pcall(function ()
            exports['nakin_allnotify']:AddNotify({type = "success", text = "ท่านต้องนั่งอยู่บนรถ"})
        end)
        return
    end
    local Vehicle = GetVehiclePedIsIn(self.PlayerPedId, false)
    if not DoesEntityExist(Vehicle) then
        pcall(function ()
            exports['nakin_allnotify']:AddNotify({type = "error", text = "ไม่พบยานพาหนะ"})
        end)
        return
    end
    local plate = ESX.Math.Trim(GetVehicleNumberPlateText(Vehicle))
    if self.isPlayerKey[plate] then
        pcall(function ()
            exports['nakin_allnotify']:AddNotify({type = "success", text = "ท่านมีกุญแจรถอยู่แล้ว"})
        end)
        return
    end
    TriggerServerEvent(STCNAME..'sv.getVehicleData' , plate)
end

function vehicleKey:setVehicle(plate)
    for k,v in ipairs(GetGamePool('CVehicle')) do
        local vehicle = GetVehicleIndexFromEntityIndex(v)
        local vehiclePlate = GetVehicleNumberPlateText(vehicle)  

        if ESX.Math.Trim(plate) == ESX.Math.Trim(vehiclePlate) then
            local vehicleStatus = GetVehicleDoorLockStatus(vehicle)
            if vehicleStatus == 1 then
                SetVehicleDoorsLocked(vehicle, 2)
                for i = 0, 5 do
                    SetVehicleDoorShut(vehicle, i, false)
                end
            else
                SetVehicleDoorsLocked(vehicle, 1)
            end
        end
    end
end

function vehicleKey:useCarKeyAction(vehicle, plate)
    local vehicleStatus = GetVehicleDoorLockStatus(vehicle)
    self:loadAnimDict("anim@mp_player_intmenu@key_fob@")
    TaskPlayAnim(self.PlayerPedId, 'anim@mp_player_intmenu@key_fob@', 'fob_click', 3.0, 3.0, -1, 49, 0, false, false, false)
    NetworkRequestControlOfEntity(vehicle)

    local playerControl = GetPlayerServerId(NetworkGetEntityOwner(vehicle))
    if GetPlayerServerId(PlayerId()) ~= playerControl then
        TriggerServerEvent(STCNAME..'sv.setVehicle', playerControl, plate)
    end

    SetEntityDrawOutline(vehicle, true)
    if vehicleStatus == 1 then
        SetEntityDrawOutlineColor(245, 23, 23, 1)
        SetVehicleDoorsLocked(vehicle, 2)
        self:TriggerNuiEvent('playsound' , {
            type = 'lock'
        })
        for i = 0, 5 do
            SetVehicleDoorShut(vehicle, i, false)
        end
        pcall(function ()
            exports['nakin_allnotify']:AddNotify({type = "success", text = "ล็อคยานพาหนะสำเร็จ"})
        end)
    else
        SetEntityDrawOutlineColor(23, 245, 23, 1)
        SetVehicleDoorsLocked(vehicle, 1)
        self:TriggerNuiEvent('playsound' , {
            type = 'unlock'
        })
        pcall(function ()
            exports['nakin_allnotify']:AddNotify({type = "error", text = "ปลดล็อคยานพาหนะสำเร็จ"})
        end)
    end
    SetVehicleLights(vehicle, 2)
    Wait(250)
    SetVehicleLights(vehicle, 1)
    Wait(200)
    SetVehicleLights(vehicle, 0)
    Wait(300)
    ClearPedTasks(self.PlayerPedId)
    SetEntityDrawOutline(vehicle, false)
end

function vehicleKey:useKeyIncar()
    local Vehicle = GetVehiclePedIsIn(self.PlayerPedId, false)
    if not DoesEntityExist(Vehicle) then
        pcall(function ()
            exports['nakin_allnotify']:AddNotify({type = "error", text = "ไม่พบยานพาหนะ"})
        end)
        return
    end
    local plate = ESX.Math.Trim(GetVehicleNumberPlateText(Vehicle))
    if not self.isPlayerKey[plate] then
        pcall(function ()
            exports['nakin_allnotify']:AddNotify({type = "error", text = "ไม่พบกุญแจรถ"})
        end)
        return
    end
    self:useCarKeyAction(Vehicle, plate)
end

function vehicleKey:useKeyOutcar()
    local coords = GetEntityCoords(self.PlayerPedId)
    local Vehicle = self:GetClosestVehicleAlternative(coords, self.Cfg.distance)
    if not DoesEntityExist(Vehicle) then
        pcall(function ()
            exports['nakin_allnotify']:AddNotify({type = "error", text = "ไม่พบยานพาหนะ"})
        end)
		return
	end
    local plate = ESX.Math.Trim(GetVehicleNumberPlateText(Vehicle))
    if not self.isPlayerKey[plate] then
        pcall(function ()
            exports['nakin_allnotify']:AddNotify({type = "error", text = "ไม่พบกุญแจรถ"})
        end)
        return
    end
    self:useCarKeyAction(Vehicle, plate)
end

function vehicleKey:useKeyIncarByPlate(isPlate)
    local Vehicle = GetVehiclePedIsIn(self.PlayerPedId, false)
    if not DoesEntityExist(Vehicle) then
        pcall(function ()
            exports['nakin_allnotify']:AddNotify({type = "error", text = "ไม่พบยานพาหนะ"})
        end)
        return
    end
    local plate = ESX.Math.Trim(GetVehicleNumberPlateText(Vehicle))
    if isPlate ~= plate then
        pcall(function ()
            exports['nakin_allnotify']:AddNotify({type = "error", text = "ไม่พบกุญแจรถ"})
        end)
        return
    end
    if not self.isPlayerKey[plate] then
        pcall(function ()
            exports['nakin_allnotify']:AddNotify({type = "error", text = "ไม่พบกุญแจรถ"})
        end)
        return
    end
    self:useCarKeyAction(Vehicle, plate)
end

function vehicleKey:useKeyOutcarByPlate(isPlate)
    local coords = GetEntityCoords(self.PlayerPedId)
    local Vehicle = self:GetClosestVehicleAlternative(coords, self.Cfg.distance)
    if not DoesEntityExist(Vehicle) then
        pcall(function ()
            exports['nakin_allnotify']:AddNotify({type = "error", text = "ไม่พบยานพาหนะ"})
        end)
		return
	end
    local plate = ESX.Math.Trim(GetVehicleNumberPlateText(Vehicle))
    if isPlate ~= plate then
        pcall(function ()
            exports['nakin_allnotify']:AddNotify({type = "error", text = "ไม่พบกุญแจรถ"})
        end)
        return
    end
    if not self.isPlayerKey[plate] then
        pcall(function ()
            exports['nakin_allnotify']:AddNotify({type = "error", text = "ไม่พบกุญแจรถ"})
        end)
        return
    end
    self:useCarKeyAction(Vehicle, plate)
end

function vehicleKey:useKey(plate)
    if IsPedDeadOrDying(PlayerPedId()) then
        return
    end
    if self.isDelay and self.isDelay > GetGameTimer() then
        return
    end
    self.isDelay = GetGameTimer() + self.Cfg.delayuse
    if plate then
        if IsPedInAnyVehicle(self.PlayerPedId, true) then
            self:useKeyIncarByPlate(plate)
            return
        end
        self:useKeyOutcarByPlate(plate)
        return
    end
    if IsPedInAnyVehicle(self.PlayerPedId, true) then
        self:useKeyIncar()
        return
    end
    self:useKeyOutcar()
end

function vehicleKey:setup()
    while ESX == nil do
		TriggerEvent(self.Cfg.eventroute['getSharedObject'], function(obj) ESX = obj end)
		Wait(0)
    end
	while NetworkIsPlayerActive(PlayerId()) ~= 1 do
		Wait(0)
	end
	while not ESX or not ESX.IsPlayerLoaded() do
        Wait(0)
    end
    self.PlayerPedId = PlayerPedId()
    self:setupCB()
    self:setupMain()
end

if not IsDuplicityVersion() then
    local carKey = vehicleKey.new(setting)
    carKey:setup()
end