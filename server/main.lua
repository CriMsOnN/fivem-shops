ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent("shop:server:getItems")
AddEventHandler("shop:server:getItems", function(shopId) 
    local _source = source
    local shopItems = {}
    MySQL.Async.fetchAll("SELECT item, label, price, description, stock FROM shops WHERE shop_id = @shop_id", {
        ["shop_id"] = shopId,
    }, function(result) 
        if result ~= nil then
            for k,v in pairs(result) do
                table.insert(shopItems, {
                    hash = v.item,
                    stock = v.stock,
                    description = v.description,
                    name = v.label,
                    price = v.price, 
                })
            end
            TriggerClientEvent("shop:client:getItems", _source, shopId, shopItems)
        end
    end)
end)

updateStock = function(source, shopid, item, newStock)
    MySQL.Async.execute("UPDATE shops SET stock = @stock WHERE shop_id = @shop_id AND item = @item", {
        ["stock"] = newStock,
        ["shop_id"] = shopid,
        ["item"] = item
    }, function(rows) 
        if rows then
            TriggerClientEvent("shop:client:updateStock", source, item, newStock)
        end
    end)
end

removeStock = function(source, shopid, item, amount)
    MySQL.Async.fetchAll("SELECT * FROM shops WHERE shop_id = @shop_id AND item = @item", {
        ["shop_id"] = shopid,
        ["item"] = item
    }, function(result) 
        if result[1] ~= nil then
            local newStock = result[1].stock - amount
            updateStock(source, shopid, item, newStock)
        end
    end)
    -- MySQL.Async.execute("UPDATE shops SET stock = @stock WHERE shop_id = @shop_id AND item = @item", {
    --     ["stock"] = stock,
    --     ["shop_id"] = tonumber(shopid),
    --     ["item"] = item
    -- }, function(rows) 
    --     if rows then
    --         TriggerClientEvent("shop:client:updateStock", source, item, stock)
    --     end
    -- end)
    -- MySQL.Async.fetchAll("SELECT * FROM shops WHERE shop_id = @shop_id", {
    --     ["shop_id"] = shopid
    -- }, function(result) 
    --     if result[1] ~= nil then
    --         local newStock = tonumber(result[1].stock) - tonumber(amount)
    --         print(newStock)
    --         MySQL.Async.execute("UPDATE shops SET stock = @stock WHERE shop_id = @shop_id AND item = @item", {
    --             ["stock"] = newStock,
    --             ["shop_id"] = tonumber(shopid),
    --             ["item"] = item
    --         }, function(rows) 
    --             if rows then
    --                 print("works")
    --             end
    --         end)
    --         -- MySQL.Async.execute("UPDATE shops SET stock = @stock WHERE shop_id = @shop_id AND item = @item",{
    --         --     ["stock"] = tonumber(newStock),
    --         --     ["shop_id"] = tonumber(shopid),
    --         --     ["item"] = item
    --         -- }, function(result) 
    --         --     TriggerClientEvent("shop:client:updateStock", source, item, newStock)
    --         -- end)
    --     end
    -- end)
end



RegisterServerEvent("shop:server:buyItem")
AddEventHandler("shop:server:buyItem", function(data) 
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local money = xPlayer.getMoney()
    local price = data["itemPrice"]
    local itemHash = data["itemHash"]
    local amount = data["amount"]
    local shopid = data["shopid"]
    local stock = data["itemStock"]
    local item = xPlayer.getInventoryItem(itemHash)
    if tonumber(money) >= tonumber(price) then
        if xPlayer.canCarryItem(itemHash, amount) then
            xPlayer.addInventoryItem(itemHash, tonumber(amount))
            TriggerClientEvent("cm_notify:client:SendAlert", _source, {type="success", text="You successfully bought " .. data["name"]}, 5000)
            removeStock(_source, shopid, itemHash, tonumber(amount))
        else
            TriggerClientEvent("cm_notify:client:SendAlert", _source, {type="error", text="You cant carry more"}, 5000)
        end
    else
        TriggerClientEvent("cm_notify:client:SendAlert", _source, {type="error", text="You dont have the money"}, 5000)
    end

end)


RegisterCommand("test", function(source, args, raw) 
    print(dump(shopItems))
end)

AddEventHandler("onResourceStart", function(resource) 
    if GetCurrentResourceName() ~= resource then return end
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