local PedCoords = Config.Blips.Processing.coords
local PedCoords1 = Config.Blips.Seller.coords
local PedModel = Config.PedModel

-- Blip
if Config.UseBlips then
    CreateThread(function()
        for _, v in pairs(Config.Blips) do
            local Blips = AddBlipForCoord(v.coords)
            SetBlipSprite(Blips, v.sprite)
            SetBlipDisplay(Blips, v.display)
            SetBlipColour(Blips, v.colour)
            SetBlipScale(Blips, v.scale)
            SetBlipAsShortRange(Blips, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(v.label)
            EndTextCommandSetBlipName(Blips)
        end
    end)
end

-- Peds
CreateThread(function()
    RequestModel(PedModel)
    while (not HasModelLoaded(PedModel)) do
        Wait(1)
    end
    OrangeFarmer1 = CreatePed(1, PedModel, PedCoords, false, true)
    OrangeFarmer2 = CreatePed(1, PedModel, PedCoords1, false, true)
    SetEntityInvincible(OrangeFarmer1, true)
    SetBlockingOfNonTemporaryEvents(OrangeFarmer1, true)
    FreezeEntityPosition(OrangeFarmer1, true)
    SetEntityInvincible(OrangeFarmer2, true)
    SetBlockingOfNonTemporaryEvents(OrangeFarmer2, true)
    FreezeEntityPosition(OrangeFarmer2, true)
end)

CreateThread(function()
    for _, v in pairs(OrangeTrees) do
        exports.ox_target:addBoxZone({
            coords = vec3(v.coords.x, v.coords.y, v.coords.z),
            size = v.size,
            rotation = v.heading,
            debug = false,
            options = {
                {
                    name = v.name,
                    event = 'tr-orangefarm:PickingOranges',
                    icon = 'fa-solid fa-hand',
                    label = Config.Text["PickOrange"],
                }
            }
        })
    end
end)

exports.ox_target:addBoxZone({
    coords = Config.OXTarget.processingCoords,
    size = vec3(1, 1, 4),
    rotation = Config.OXTarget.processingHeading,
    debug = false,
    options = {
        {
            name = 'ProcessingOrange',
            event = 'tr-orangefarm:ProcessOrange',
            icon = 'fa-solid fa-filter',
            label = Config.Text["ProcessingLabel"],
        },
        {
            name = 'SellingRawOranges',
            event = 'tr-orangefarm:SellRawOrange',
            icon = 'fa-solid fa-hand-holding-dollar',
            label = Config.Text["SellOrangesLabel"],
        }
    }
})

exports.ox_target:addBoxZone({
    coords = Config.OXTarget.sellingCoords,
    size = vec3(1, 1, 4),
    rotation = Config.OXTarget.sellingHeading,
    debug = false,
    options = {
        {
            name = 'selljuices',
            event = 'tr-orangefarm:SellingJuice',
            icon = 'fa-solid fa-bottle-water',
            label = Config.Text["SellJuice"],
        }
    }
})

--Orange Picking Event
RegisterNetEvent('tr-orangefarm:PickingOranges', function()
    local Ped = PlayerPedId()
    local success = lib.skillCheck({'easy', 'easy', 'easy'})
    if success then
        lib.progressCircle({
            FreezeEntityPosition(Ped, true),
            duration = 2500,
            position = 'bottom',
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
            },
            anim = {
                dict = 'missmechanic',
                clip = 'work_base'
            },
            prop = {
                model = `ng_proc_food_ornge1a`,
                pos = vec3(0.03, 0.03, 0.03),
                rot = vec3(0.0, 0.0, -1.5)
            },
        })
        TriggerServerEvent('tr-orangefarm:GratherOrange')
    else
        lib.notify({
            title = 'Orange Farm',
            description = Config.Text["FailedPickingOranges"],
            type = 'error'
        })
    end
    FreezeEntityPosition(Ped, false)
end)

--Processing Event
RegisterNetEvent('tr-orangefarm:ProcessOrange', function()
    local Ped = PlayerPedId()
    FreezeEntityPosition(Ped, true)
    if lib.progressCircle({
        duration = Config.Processing.pressingConfig.timer,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
        anim = {
            dict = 'missfam4',
            clip = 'base'
        },
        prop = {
            model = `p_amb_clipboard_01`,
            pos = vec3(0.00, 0.00, 0.00),
            rot = vec3(0.0, 0.0, -1.5)
        },
    })
    then
        TriggerServerEvent("tr-orangefarm:TradingToOrangeJuice")
    else
         lib.notify({
            title = 'Processing',
            description = Config.Text["CancelledProcessing"],
            type = 'error'
        })
    end
    FreezeEntityPosition(Ped, false)
end)

RegisterNetEvent('tr-orangefarm:SellRawOrange', function()
    local Ped = PlayerPedId()
    FreezeEntityPosition(Ped, true)
    if lib.progressCircle({
        duration = 4000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
        anim = {
            dict = 'missfam4',
            clip = 'base'
        },
        prop = {
            model = `p_amb_clipboard_01`,
            pos = vec3(0.00, 0.00, 0.00),
            rot = vec3(0.0, 0.0, -1.5)
        },
    })
    then
        TriggerServerEvent("tr-orangefarm:SellingRawOrange")
    else
        lib.notify({
            title = 'Juice Vendor',
            description = Config.Text["CancelledProcessing"],
            type = 'error'
        })
    end
    FreezeEntityPosition(Ped, false)
end)

RegisterNetEvent('tr-orangefarm:SellingJuice', function()
    local Ped = PlayerPedId()
    FreezeEntityPosition(Ped, true)
    if lib.progressCircle({
        duration = 4000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
        anim = {
            dict = 'missfam4',
            clip = 'base'
        },
        prop = {
            model = `p_amb_clipboard_01`,
            pos = vec3(0.00, 0.00, 0.00),
            rot = vec3(0.0, 0.0, -1.5)
        },
    })
    then
        TriggerServerEvent("tr-orangefarm:SellingJuices")
    else
        lib.notify({
            title = 'Juice Vendor',
            description = Config.Text["CancelledProcessing"],
            type = 'error'
        })
    end
    FreezeEntityPosition(Ped, false)
end)
