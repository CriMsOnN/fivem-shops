local open = false
blip = 0

RegisterCommand("open", function() 
    open = not open
    if open then
        SendNUIMessage({
            action = "show"
        })
        SetNuiFocus(true, true)
    else
        SendNUIMessage({
            action = "close"
        })
        SetNuiFocus(false, false)
    end
end)

RegisterCommand("close", function() 
        SendNUIMessage({
            action = "close"
        })
        SetNuiFocus(false, false)
end)

Citizen.CreateThread(function() 
    while true do
        Wait(3)
        local coords = GetEntityCoords(PlayerPedId())
        local sleep = true
        local items = {}
        for k,v in pairs (Config.Shops) do
            if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.coords.x, v.coords.y, v.coords.z, true) <= 2.0 then
                sleep = false
                DrawMarker(v.marker[1].type, v.marker[1].x + 0.5, v.marker[1].y, v.marker[1].z - 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.9, 0.9, 0.9, 255, 255, 255, 255, false, true, 2, nil, nill, false)
                if GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.coords.x, v.coords.y, v.coords.z, true) <= 1.0 then
                    DrawText3D(v.coords.x + 0.5, v.coords.y, v.coords.z, "Press [~r~E~s~] to open shop")
                    if IsControlJustPressed(0, 51) then
                        TriggerServerEvent("shop:server:getItems", v.id)
                    end
                end
            end
        end
        if sleep then
            Wait(2000)
        end
    end
end)

RegisterNetEvent("shop:client:getItems")
AddEventHandler("shop:client:getItems", function(shopId, itemsStock) 
    SendNUIMessage({
        action = "show",
        items = itemsStock,
        shopId = shopId
    })
    SetNuiFocus(true, true)
end)

RegisterNetEvent("shop:client:updateStock")
AddEventHandler("shop:client:updateStock", function(item, newStock)
    print(newStock)
    SendNUIMessage({
        action = "update",
        item = item,
        stock = newStock
    })
end)

RegisterNUICallback("outofstock", function(data) 
    exports["cm_notify"]:SendAlert("error", data.message)
end)


RegisterNUICallback("buyItem", function(data) 
    --print(dump(data))
    TriggerServerEvent("shop:server:buyItem", data)
end)

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. '['..k..'] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end



-- Create Blips
Citizen.CreateThread(function() 
    for k,v in pairs(Config.Shops) do
        blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
        SetBlipSprite(blip, v.blip.sprite)
        SetBlipColour(blip, v.blip.color)
        SetBlipDisplay(blip, v.blip.display)
        SetBlipScale(blip, v.blip.scale)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.blip.name)
        EndTextCommandSetBlipName(blip)
    end
end)

DrawText3D = function(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

AddEventHandler("onResourceStop", function() 
    SetNuiFocus(false, false)
end)