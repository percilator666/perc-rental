local vehicleRentals = {}

local function isSpawnLocationClear(x, y, z, radius)
    local vehicles = GetGamePool('CVehicle')
    for _, vehicle in ipairs(vehicles) do
        if DoesEntityExist(vehicle) then
            local vehiclePos = GetEntityCoords(vehicle)
            local distance = #(vector3(x, y, z) - vehiclePos)
            if distance < radius then
                return false
            end
        end
    end
    
    local objects = GetGamePool('CObject')
    for _, object in ipairs(objects) do
        if DoesEntityExist(object) then
            local objectPos = GetEntityCoords(object)
            local distance = #(vector3(x, y, z) - objectPos)
            if distance < radius then
                return false
            end
        end
    end
    
    local peds = GetGamePool('CPed')
    for _, ped in ipairs(peds) do
        if DoesEntityExist(ped) and not IsPedAPlayer(ped) then
            local pedPos = GetEntityCoords(ped)
            local distance = #(vector3(x, y, z) - pedPos)
            if distance < radius then
                return false
            end
        end
    end
    
    return true
end

lib.addCommand('checkrental', {
    help = 'Check the remaining time on your vehicle rental',
    restricted = false
}, function(source, args, raw)
    local playerRental = vehicleRentals[source]

    if playerRental then
        local remainingTime = math.ceil((playerRental.endTime - os.time()) / 60)

        if remainingTime > 0 then
            lib.notify(source, {
                icon = 'car',
                title = 'Rental Status',
                description = ('You have %d minutes remaining on your %s rental.'):format(remainingTime, playerRental.vehicleName),
                type = 'inform'
            })
        else
            lib.notify(source, {
                icon = 'car',
                title = 'Rental Expired',
                description = 'Your rental has expired. The vehicle will be deleted.',
                type = 'inform'
            })
        end
    else
        lib.notify(source, {
            icon = 'car',
            title = 'No Active Rental',
            description = 'You do not have an active vehicle rental.',
            type = 'inform'
        })
    end
end)

lib.callback.register('perc-rental:createRental', function(source, vehicleModel, durationMinutes, paymentMethod, totalCost)
    local src = source
    local playerRental = vehicleRentals[src]
    
    if playerRental then
        return { success = false, message = 'You already have an active rental.' }
    end
    
    local duration = math.floor(tonumber(durationMinutes))
    duration = math.max(1, math.min(duration, config.maxrentaltime))
    
    if paymentMethod ~= 'cash' and paymentMethod ~= 'bank' then
        return { success = false, message = 'Invalid payment method selected.' }
    end
    
    local vehicleConfig = nil
    for _, vehicle in ipairs(config.vehicles) do
        if vehicle.model == vehicleModel then
            vehicleConfig = vehicle
            break
        end
    end
    
    if not vehicleConfig then
        return { success = false, message = 'Invalid vehicle selected.' }
    end
    
    if duration > vehicleConfig.maxduration then
        return { success = false, message = string.format('Maximum rental duration for this vehicle is %d minutes.', vehicleConfig.maxduration) }
    end
    
    local price = vehicleConfig.price * duration
    
    local playerMoney = exports.qbx_core:GetMoney(src, paymentMethod)
    if not playerMoney or playerMoney < totalCost then
        return { success = false, message = 'No funds available. Insufficient balance for this rental.' }
    end
    
    local paymentSuccess = false
    
    if paymentMethod == 'cash' then
        paymentSuccess = exports.qbx_core:RemoveMoney(src, 'cash', totalCost, 'Rented Vehicle')
    elseif paymentMethod == 'bank' then
        paymentSuccess = exports.qbx_core:RemoveMoney(src, 'bank', totalCost, 'Rented Vehicle')
    end
    
    if not paymentSuccess then
        return { success = false, message = 'Payment failed. Insufficient funds or payment method not available.' }
    end
    
    local endTime = os.time() + (duration * 60)
    local rentalPlate = 'RENTAL' .. math.random(1000, 9999)
    
    local spawnLocation = nil
    local spawnLocationFound = false
    
    for _, location in ipairs(config.locations) do
        if location.spawnLocations and #location.spawnLocations > 0 then
            for _, potentialSpawn in ipairs(location.spawnLocations) do
                if isSpawnLocationClear(potentialSpawn.x, potentialSpawn.y, potentialSpawn.z, 2.5) then
                    spawnLocation = potentialSpawn
                    spawnLocationFound = true
                    break
                end
            end
            if spawnLocationFound then break end
        end
    end
    
    if not spawnLocation then
        return { success = false, message = 'No clear spawn locations available. Please try again later.' }
    end
    
    local modelHash = GetHashKey(vehicleModel)
    local vehicle = CreateVehicle(modelHash, spawnLocation.x, spawnLocation.y, spawnLocation.z, spawnLocation.w, true, false)
    
    Wait(200)
    
    if not DoesEntityExist(vehicle) then
        return { success = false, message = 'Failed to spawn vehicle.' }
    end
    
    SetVehicleDoorsLocked(vehicle, 1)
    SetVehicleNumberPlateText(vehicle, rentalPlate)
    Entity(vehicle).state.fuel = 100

    exports.qbx_vehiclekeys:GiveKeys(src, vehicle, false)
    
    vehicleRentals[src] = {
        vehicleModel = vehicleModel,
        vehicleName = vehicleConfig.name,
        endTime = endTime,
        duration = duration,
        paymentMethod = paymentMethod,
        price = price,
        plate = rentalPlate,
        vehicle = vehicle
    }

    exports['perc-logging']:SendLog(src, 'car_rental', {
        vehicle_name = vehicleConfig.name,
        duration = duration,
        cost = totalCost,
        payment_type = paymentMethod,
        plate = rentalPlate
    })
    
    local vehicleInfo = {
        model = vehicleModel,
        plate = rentalPlate,
        coords = GetEntityCoords(vehicle),
        heading = GetEntityHeading(vehicle)
    }
    
    return {
        success = true,
        message = string.format('Rental created for %d minutes. Total cost: $%d (%s)', duration, totalCost, paymentMethod),
        vehicleModel = vehicleModel,
        endTime = endTime,
        rentalPlate = rentalPlate,
        vehicleInfo = vehicleInfo
    }
end)

lib.callback.register('perc-rental:cancelRental', function(source)
    local src = source
    local playerRental = vehicleRentals[src]
    
    if not playerRental then
        return { success = false, message = 'No active rental found.' }
    end
    
    if playerRental.vehicle then
        exports.qbx_vehiclekeys:RemoveKeys(src, playerRental.vehicle, true)
        
        if DoesEntityExist(playerRental.vehicle) then
            DeleteEntity(playerRental.vehicle)
        end
    end
    
    vehicleRentals[src] = nil
    
    TriggerClientEvent('perc-rental:deleteVehicle', src)
    
    return { success = true, message = 'Rental cancelled successfully.' }
end)

CreateThread(function()
    while true do
        local currentTime = os.time()
        local expiredPlayers = {}
        
        for src, rental in pairs(vehicleRentals) do
            if currentTime >= rental.endTime then
                table.insert(expiredPlayers, src)
            end
        end
        
        for _, src in ipairs(expiredPlayers) do
            local rental = vehicleRentals[src]
            if rental then
                TriggerClientEvent('ox_lib:notify', src, {
                    icon = 'car',
                    title = 'Rental Expired',
                    description = string.format('Your %s rental has expired. The vehicle will be deleted.', rental.vehicleName),
                    type = 'inform'
                })
                
                if rental.vehicle and DoesEntityExist(rental.vehicle) then
                    DeleteEntity(rental.vehicle)
                end
                
                TriggerClientEvent('perc-rental:deleteVehicle', src)
                
                vehicleRentals[src] = nil
            end
        end
        
        Wait(5000)
    end
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    if config.deleteonlogout and vehicleRentals[src] then
        TriggerClientEvent('perc-rental:deleteVehicle', src)
        vehicleRentals[src] = nil
    end
end)
