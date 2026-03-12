local currentRental = nil
local rentalVehicle = nil
local vehicleImages = {}
local warningSent = false

CreateThread(function()
    Wait(100)
    if carrental and carrental.vehicleImages then
        vehicleImages = carrental.vehicleImages
    end
end)

CreateThread(function()
    for _, location in ipairs(carrental.locations) do
        local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
        SetBlipSprite(blip, location.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, location.blip.scale)
        SetBlipColour(blip, location.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(location.blip.name)
        EndTextCommandSetBlipName(blip)
    end
end)

CreateThread(function()
    for _, location in ipairs(carrental.locations) do
        local modelHash = GetHashKey(location.ped)
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Wait(10)
        end

        local ped = CreatePed(4, modelHash, location.coords.x, location.coords.y, location.coords.z - 1, location.heading, false, true)
        SetEntityHeading(ped, location.heading)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        TaskStartScenarioInPlace(ped, location.scenario, 0, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetModelAsNoLongerNeeded(modelHash)

        exports.ox_target:addLocalEntity(ped, {
            {
                name = 'carrental_' .. location.name:gsub('%s+', '_'):lower(),
                icon = 'fa-solid fa-car',
                label = 'Rent a Vehicle',
                distance = 2.0,
                onSelect = function()
                    OpenRentalMenu()
                end
            }
        })
    end
end)

function OpenRentalMenu()
    local menuOptions = {}

    for _, vehicle in ipairs(carrental.vehicles) do
        local vehicleImage = nil
        if vehicleImages and vehicleImages[vehicle.model] then
            vehicleImage = vehicleImages[vehicle.model]
        end
        
        local vehicleIcon = 'fa-solid fa-car'
        if vehicle.type then
            if vehicle.type == 'bike' then
                vehicleIcon = 'fa-solid fa-bicycle'
            elseif vehicle.type == 'motorcycle' then
                vehicleIcon = 'fa-solid fa-motorcycle'
            elseif vehicle.type == 'truck' then
                vehicleIcon = 'fa-solid fa-truck'
            elseif vehicle.type == 'boat' then
                vehicleIcon = 'fa-solid fa-ship'
            elseif vehicle.type == 'plane' then
                vehicleIcon = 'fa-solid fa-plane'
            elseif vehicle.type == 'helicopter' then
                vehicleIcon = 'fa-solid fa-helicopter'
            end
        end
        
        table.insert(menuOptions, {
            title = vehicle.name,
            icon = vehicleIcon,
            description = string.format('Price: $%d per minute | Max: %d minutes', vehicle.price, vehicle.maxduration),
            event = 'carrental:selectVehicle',
            image = vehicleImage,
            args = {model = vehicle.model, name = vehicle.name, price = vehicle.price, maxDuration = vehicle.maxduration}
        })
    end

    if currentRental then
        table.insert(menuOptions, {
            title = 'Cancel Rental',
            description = 'Cancel your current rental',
            event = 'carrental:cancelMenu'
        })
    end

    lib.registerContext({
        id = 'carrental_menu',
        title = 'Car Rental',
        options = menuOptions
    })

    lib.showContext('carrental_menu')
end

RegisterNetEvent('carrental:selectVehicle', function(data)
    local paymentMethod = lib.inputDialog('Rent ' .. data.name, {
        { type = 'select', label = 'Payment Method', required = true, default = 'bank', options = {
            { label = 'Bank', value = 'bank' },
            { label = 'Cash', value = 'cash' }
        }},
        { type = 'select', label = 'Rental Duration', required = true, default = '5', options = {
            { label = '5 minutes', value = '5' },
            { label = '10 minutes', value = '10' },
            { label = '15 minutes', value = '15' },
            { label = '20 minutes', value = '20' },
            { label = '30 minutes', value = '30' },
            { label = '45 minutes', value = '45' },
            { label = '60 minutes', value = '60' },
            { label = '90 minutes', value = '90' },
            { label = '120 minutes', value = '120' }
        }}
    })

    if paymentMethod and paymentMethod[1] and paymentMethod[2] then
        local method = paymentMethod[1]
        local durationChoice = paymentMethod[2]
        local duration = tonumber(durationChoice)

        if duration and duration > 0 and duration <= data.maxDuration then
            local totalCost = data.price * duration
            local result = lib.callback.await('carrental:createRental', false, data.model, duration, method, totalCost)

            if result and result.success then
                currentRental = {
                    vehicleModel = data.model,
                    vehicleName = data.name,
                    endTime = result.endTime,
                    duration = duration,
                    plate = result.rentalPlate
                }
                
                lib.notify({
                    icon = 'car',
                    title = 'Rental Created',
                    description = result.message,
                    type = 'success'
                })
            else
                local errorMessage = 'Unknown error occurred'
                if result and result.message then
                    errorMessage = result.message
                elseif not result then
                    errorMessage = 'Failed to create rental - (invalid model)'
                end
                
                lib.notify({
                    icon = 'car',
                    title = 'Rental Failed',
                    description = errorMessage,
                    type = 'error'
                })
            end
        end
    end
end)

RegisterNetEvent('carrental:cancelMenu', function()
    local confirm = lib.inputDialog('Cancel Rental', {
        { type = 'select', label = 'Are you sure you want to cancel your rental?', required = true, default = 'yes', options = {
            { label = 'Yes', value = 'yes' },
            { label = 'No', value = 'no' }
        }}
    })

    if confirm and confirm[1] == 'yes' then
        local result = lib.callback.await('carrental:cancelRental', false)

        if result and result.success then
            currentRental = nil
            rentalVehicle = nil

            lib.notify({
                icon = 'car',
                title = 'Rental Cancelled',
                description = result.message,
                type = 'success'
            })
        else
            local errorMessage = 'Unknown error occurred'
            if result and result.message then
                errorMessage = result.message
            elseif not result then
                errorMessage = 'Failed to cancel rental - (invalid model)'
            end
            
            lib.notify({
                icon = 'car',
                title = 'Cancellation Failed',
                description = errorMessage,
                type = 'error'
            })
        end
    end
end)

RegisterNetEvent('carrental:deleteVehicle', function()
    if rentalVehicle and DoesEntityExist(rentalVehicle) then
        DeleteEntity(rentalVehicle)
        rentalVehicle = nil
    end

    currentRental = nil
end)

CreateThread(function()
    while true do
        Wait(5000)

        if currentRental then
            local currentTime = GetCloudTimeAsInt()
            local remainingTime = currentRental.endTime - currentTime

            if remainingTime <= 0 then
                TriggerEvent('carrental:deleteVehicle')
                lib.notify({
                    icon = 'car',
                    title = 'Rental Expired',
                    description = 'Your rental has expired. The vehicle has been returned.',
                    type = 'inform'
                })
                warningSent = false
            elseif remainingTime <= 180 and not warningSent then
                warningSent = true
                lib.notify({
                    icon = 'car',
                    title = 'Rental Warning',
                    description = ('Your rental expires in %d minutes.'):format(math.ceil(remainingTime / 60)),
                    type = 'warning'
                })
            end
        end
    end
end)

AddEventHandler('onPlayerDeath', function()
    if rentalVehicle and DoesEntityExist(rentalVehicle) then
        DeleteEntity(rentalVehicle)
        rentalVehicle = nil
    end
end)
