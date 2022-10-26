local function checkDistance()
    local src = source
    local ped = GetPlayerPed(src)
    local check = GetEntityCoords(ped)
    local distanceCheck = Config.MinDistance
        for _,v in pairs(OrangeTrees) do
            if #(check - v.coords) < distanceCheck then
                return true
            end
        return false
    end
end
  

local sourceID = GetPlayerIdentifier(source)[1]
local function LoadESXVersion()
    ESX = exports["es_extended"]:getSharedObject()

    RegisterNetEvent('tr-orangefarm:GratherOrange', function()
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local orange = math.random(Config.Picking.ReceiveItem.minAmount, Config.Picking.ReceiveItem.maxAmount)
        if checkDistance then
            xPlayer.addInventoryItem('orange', orange)
            TriggerClientEvent('esx:showNotification', src, Config.Text["PickedOranges"], "success")
        else
            return false
        end
    end)

    RegisterNetEvent('tr-orangefarm:TradingToOrangeJuice', function()
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local orange = xPlayer.getInventoryItem('orange')
        local processingAmount = Config.Processing.pressingConfig.amount
        local receivingItem = Config.Processing.pressingConfig.receiving
        if orange.count < 1 then
            TriggerClientEvent('esx:showNotification', src, Config.Text["ErrorProcessingAmount"], "error")
        end
        local amount = orange.count
        if amount >= 1 then
            amount = processingAmount
        else
            return false
        end
        if orange.count >= amount then
            xPlayer.removeInventoryItem(orange, processingAmount)
            TriggerClientEvent('esx:showNotification', src, Config.Text["OrangesProcessed"] .. processingAmount .. Config.Text["OrangesProcessed1"], "success")
            Wait(50)
            xPlayer.addInventoryItem('orange_juice', receivingItem)
        else
            TriggerClientEvent('esx:showNotification', src, Config.Text["ErrorProcessingAmount"], "error")
            return false
        end
    end)

    SellOranges = {
        orange = math.random(Config.SellPrice.Raworanges.min, Config.SellPrice.Raworanges.max)
    }

    RegisterNetEvent('tr-orangefarm:SellingRawOrange', function()
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local price = 0
        for k, v in pairs(SellOranges) do
            local orange = xPlayer.getInventoryItem(k)
            if orange and orange.count >= 1 then
                price = price + (v * orange.count)
                xPlayer.removeInventoryItem(k, orange.count)
            end
        end
        if price > 0 then
            xPlayer.addMoney(price)
            TriggerClientEvent('esx:showNotification', src, Config.Text["successfully_sold"], "success")
        else
            TriggerClientEvent('esx:showNotification', src, Config.Text["NoItem"], "error")
        end
    end)

    SellJuice = {
        orange_juice = math.random(Config.SellPrice.Juice.min, Config.SellPrice.Juice.max)
    }

    RegisterNetEvent('tr-orangefarm:SellingJuices', function()
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)
        local price = 0
        for k, v in pairs(SellJuice) do
            local orangejuice = xPlayer.getInventoryItem(k)
            if orangejuice and orangejuice.count >= 1 then
                price = price + (v * orangejuice.count)
                xPlayer.removeInventoryItem(k, orangejuice.count)
            end
        end
        if price > 0 then
            xPlayer.addMoney(price)
            TriggerClientEvent('esx:showNotification', src, Config.Text["successfully_sold1"], "success")
        else
            TriggerClientEvent('esx:showNotification', src, Config.Text["NoItem"], "error")
        end
    end)


