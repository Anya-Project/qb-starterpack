--[[ 
    QB-StarterPack
    Versi: 1.0.4
    Penulis: AnyaProject
    Discord: https://discord.gg/rcqQ3J6Pcf
]]--

local QBCore = exports['qb-core']:GetCoreObject()


local function GenerateCustomPlate()
    local plate = ""; local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"; local nums = "0123456789"
    for i = 1, 3 do plate = plate .. chars:sub(math.random(1, #chars), math.random(1, #chars)) end; plate = plate .. " "
    for i = 1, 3 do plate = plate .. nums:sub(math.random(1, #nums), math.random(1, #nums)) end; return plate:upper()
end

RegisterNetEvent('qb-starterpack:server:beriPaket', function()
    local src = source; local Player = QBCore.Functions.GetPlayer(src)
    if not Player or Player.PlayerData.metadata['has_claimed_starterpack'] then return end
    
    local itemsGiven = {}
    local success = true
    for _, itemData in ipairs(Config.StarterPack.Items) do
      
        local itemAdded = false
        if Config.Inventory == 'qb' then
            itemAdded = Player.Functions.AddItem(itemData.name, itemData.amount)
        elseif Config.Inventory == 'ox' then
            itemAdded = exports.ox_inventory:AddItem(src, itemData.name, itemData.amount)
        end
  

        if itemAdded then 
            table.insert(itemsGiven, {name = itemData.name, amount = itemData.amount})
        else 
            success = false; TriggerClientEvent('QBCore:Notify', src, 'Inventaris Anda penuh! Klaim dibatalkan.', 'error', 7000); break 
        end
    end

    if success then
        if Config.StarterPack.Money.cash > 0 then Player.Functions.AddMoney('cash', Config.StarterPack.Money.cash, 'claimed-starterpack') end
        if Config.StarterPack.Money.bank > 0 then Player.Functions.AddMoney('bank', Config.StarterPack.Money.bank, 'claimed-starterpack') end
        if Config.Vehicle.enabled then
            local vehicleModel = Config.Vehicle.model; local plate = GenerateCustomPlate()
            if Config.Vehicle.spawnMethod == 'spawn' then
                MySQL.insert('INSERT INTO player_vehicles (citizenid, vehicle, hash, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?)', {Player.PlayerData.citizenid, vehicleModel, GetHashKey(vehicleModel), plate, Config.Vehicle.garage, 0}, function() TriggerClientEvent('qb-starterpack:client:spawnVehicle', src, vehicleModel, plate) end)
            elseif Config.Vehicle.spawnMethod == 'garage' then
                MySQL.insert('INSERT INTO player_vehicles (citizenid, vehicle, hash, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?)', {Player.PlayerData.citizenid, vehicleModel, GetHashKey(vehicleModel), plate, Config.Vehicle.garage, 1})
                local vehicleLabel = QBCore.Shared.Vehicles[vehicleModel] and QBCore.Shared.Vehicles[vehicleModel].name or vehicleModel
                local garageLabel = QBCore.Shared.Garages[Config.Vehicle.garage] and QBCore.Shared.Garages[Config.Vehicle.garage].label or Config.Vehicle.garage
                TriggerClientEvent('QBCore:Notify', src, "Sebuah " .. vehicleLabel .. " (" .. plate .. ") telah dikirim ke " .. garageLabel .. " Anda.", "success", 10000)
            end
        end
        Player.Functions.SetMetaData('has_claimed_starterpack', true); Player.Functions.Save()
        exports['qb-starterpack']:SendDiscordLog(Player)
        TriggerClientEvent('QBCore:Notify', src, Config.Pesan.sukses, 'success', 8000)
    else 
        for _, itemData in ipairs(itemsGiven) do 
       
            if Config.Inventory == 'qb' then
                Player.Functions.RemoveItem(itemData.name, itemData.amount)
            elseif Config.Inventory == 'ox' then
                exports.ox_inventory:RemoveItem(src, itemData.name, itemData.amount)
            end
         
        end 
    end
end)

RegisterNetEvent('qb-starterpack:server:claimWeekly', function()
    local src = source; local Player = QBCore.Functions.GetPlayer(src)
    if not Player or not Config.WeeklyClaim.enabled then return end
    local cooldownSeconds = Config.WeeklyClaim.cooldown_days * 24 * 60 * 60
    local nextClaimTime = Player.PlayerData.metadata['next_weekly_claim'] or 0
    local currentTime = os.time()
    if currentTime < nextClaimTime then
        local timeLeft = nextClaimTime - currentTime; local days = math.floor(timeLeft / 86400); local hours = math.floor((timeLeft % 86400) / 3600); local minutes = math.floor((timeLeft % 3600) / 60)
        local message = string.format("%d hari, %d jam, dan %d menit", days, hours, minutes)
        TriggerClientEvent('QBCore:Notify', src, Config.WeeklyClaim.Pesan.tunggu .. message, "error", 7000); return
    end
    local rewards = {}; local pool = {}; for k, v in pairs(Config.WeeklyClaim.RewardPool) do table.insert(pool, v) end
    for i = 1, Config.WeeklyClaim.itemsToGive do
        if #pool > 0 then local randomIndex = math.random(1, #pool); table.insert(rewards, pool[randomIndex]); table.remove(pool, randomIndex) end
    end
    for _, itemData in ipairs(rewards) do
      
        local itemAdded = false
        if Config.Inventory == 'qb' then
            itemAdded = Player.Functions.AddItem(itemData.name, itemData.amount)
        elseif Config.Inventory == 'ox' then
            itemAdded = exports.ox_inventory:AddItem(src, itemData.name, itemData.amount)
        end
      

        if not itemAdded then
            for _, givenItem in ipairs(rewards) do 
            
                if Config.Inventory == 'qb' then
                    Player.Functions.RemoveItem(givenItem.name, givenItem.amount)
                elseif Config.Inventory == 'ox' then
                    exports.ox_inventory:RemoveItem(src, givenItem.name, givenItem.amount)
                end
            end
            TriggerClientEvent('QBCore:Notify', src, Config.WeeklyClaim.Pesan.penuh, "error", 7000); return
        end
    end
    Player.Functions.SetMetaData('next_weekly_claim', currentTime + cooldownSeconds); Player.Functions.Save()
    TriggerClientEvent('QBCore:Notify', src, Config.WeeklyClaim.Pesan.sukses, "success", 7000)
end)