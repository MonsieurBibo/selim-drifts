RegisterCommand("driftmode", function(source, args, rawCommand)
    local source = source
    if source ~= nil then
        checkPermission(source)
    else
        print("Someone or something tried to run cmd: driftmode")
    end
end)

RegisterServerEvent('driftmode:initServer', function()
    local source = source
    if source ~= nil then
        checkPermission(source)
    else
        print("Someone or something tried to init driftmode:initServer")
    end
end)

function checkPermission(source)
    TriggerClientEvent('driftmode:initClient', source)
end
