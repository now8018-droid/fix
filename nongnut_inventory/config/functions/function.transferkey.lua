function Function.TransferKey(plate, cb)
    local isDisabled = exports['nongnut_leasevehicle']:getData()[plate]
    local model = isDisabled and
                    exports['nongnut_leasevehicle']:getModel()[plate] or
                    exports['nongnut_garage']:getVehicles()[plate]?.modelName
    if not model then return end
    cb({
        vehicle = {
            plate = plate,
            label = plate .. ' - ' .. model:upper()
        },
        disabled = isDisabled
    })
end

function Function.TransferKeySubmit(renterId, plate, days, hours, rentalPrice)
    if not renterId or not plate or not days or not hours or not rentalPrice then
        return
    end
    TriggerServerEvent('nongnut_leasevehicle:lease', renterId, plate, days, hours, rentalPrice)
end