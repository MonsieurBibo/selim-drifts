local driftModeEnabled = false
local currentVeh = nil
local all_part = {}
local QBCore = exports['qb-core']:GetCoreObject()



local function disableDrift(pedVehicle)
    SetDriftTyresEnabled(pedVehicle, 0)
    SetReduceDriftVehicleSuspension(pedVehicle, 0)
    driftModeEnabled = not driftModeEnabled
    for _index, value in ipairs(Config.HandleMods) do
        SetVehicleHandlingFloat(pedvehicle, "CHandlingData", value[1],
            GetVehicleHandlingFloat(pedvehicle, "CHandlingData", value[1]) + value[2] * -1)
    end
end

local function notify(message)
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0 },
        multiline = true,
        args = { "Drift Mode", message }
    })
end


function ToggleDriftMode()
    local modifier = 1
    local ped = PlayerPedId()
    local pedVehicle = GetVehiclePedIsIn(ped)
    currentVeh = pedVehicle

    if not IsPedInAnyVehicle(ped) then
        -- QBCore.Functions.Notify('You must be in a vehicle to use this command.', "primary")
        return
    end


    if driftModeEnabled then
        modifier = -1
        disableDrift(pedVehicle)
        --  notify('Drift mode is now ' ..
            -- (driftModeEnabled and "enabled" or "disabled") .. '.')
        return
    else
        driftModeEnabled = not driftModeEnabled
        -- notify('Drift mode is now ' ..
            -- (driftModeEnabled and "enabled" or "disabled") .. '.')
    end

    SetDriftTyresEnabled(pedVehicle, 1)
    SetReduceDriftVehicleSuspension(pedVehicle, 1)

    for _index, value in ipairs(Config.HandleMods) do
        SetVehicleHandlingFloat(vehicle, "CHandlingData", value[1],
            GetVehicleHandlingFloat(vehicle, "CHandlingData", value[1]) + value[2] * modifier)
    end

    Citizen.CreateThread(function()
        while driftModeEnabled do
            Citizen.Wait(0)
            if driftModeEnabled == false then break end
            if IsPedInAnyVehicle(ped) then
                if pedVehicle ~= currentVeh then
                    currentVeh = pedVehicle
                    disableDrift(pedVehicle)
                    break
                end
            else
                disableDrift(pedVehicle)
                print('broke')
                break
            end
        end
    end)
end

RegisterKeyMapping('+driftKey', 'Drifting Key', 'keyboard', Config.defaultKeybind)

RegisterCommand('+driftKey', function()
    -- key F7 has been pressed
    --   TriggerServerEvent('selim-drifts:initServer')
    ToggleDriftMode()
end)

RegisterCommand('-driftKey', function()
    -- key F7 has been pressed
    -- TriggerServerEvent('selim-drifts:initServer')
    ToggleDriftMode()
end)

RegisterNetEvent('driftmode:initClient', function() ToggleDriftMode() end)
