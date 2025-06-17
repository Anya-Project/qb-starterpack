--[[ 
    QB-StarterPack
    Versi: 1.0.4
    Penulis: AnyaProject
    Discord: https://discord.gg/rcqQ3J6Pcf
]]--

local QBCore = nil
local npcPed = nil

CreateThread(function()
    while QBCore == nil do
        QBCore = exports['qb-core']:GetCoreObject()
        if QBCore == nil then Wait(500) end
    end
    Initialize()
end)

function Initialize()
    SpawnNPC()
    exports['qb-target']:AddTargetModel(Config.NPC.model, {
        options = {
            
            { type = 'client', event = 'qb-starterpack:client:showRules', icon = Config.Target.icon, label = Config.Target.label,
                canInteract = function()
                    local pData = QBCore.Functions.GetPlayerData()
                    return not pData.metadata['has_claimed_starterpack']
                end
            },
           
            { type = 'server', event = 'qb-starterpack:server:claimWeekly', icon = 'fas fa-calendar-check', label = 'Klaim Hadiah Mingguan',
                canInteract = function()
                    if not Config.WeeklyClaim.enabled then return false end -- Cek jika fitur aktif
                    local pData = QBCore.Functions.GetPlayerData()
                    return pData.metadata['has_claimed_starterpack']
                end
            },
        },
        distance = 2.5,
    })
end

function SpawnNPC()
    if npcPed and DoesEntityExist(npcPed) then DeleteEntity(npcPed) end
    RequestModel(GetHashKey(Config.NPC.model))
    while not HasModelLoaded(GetHashKey(Config.NPC.model)) do Wait(5) end
    local success, groundZ = GetGroundZFor_3dCoord(Config.NPC.coords.x, Config.NPC.coords.y, Config.NPC.coords.z + 1.0, false)
    local spawnZ = success and groundZ or Config.NPC.coords.z
    npcPed = CreatePed(4, GetHashKey(Config.NPC.model), Config.NPC.coords.x, Config.NPC.coords.y, spawnZ, Config.NPC.coords.w, false, true)
    FreezeEntityPosition(npcPed, true)
    SetEntityInvincible(npcPed, true)
    SetBlockingOfNonTemporaryEvents(npcPed, true)
end

function PlayClaimAnimation()
    local playerPed = PlayerPedId()
    FreezeEntityPosition(playerPed, true)
    RequestAnimDict("mp_common")
    while not HasAnimDictLoaded("mp_common") do Wait(10) end
    TaskPlayAnim(playerPed, "mp_common", "givetake1_a", 8.0, -8.0, 1500, 49, 0, false, false, false)
    PlaySoundFrontend(-1, "LOCAL_BANK_UPDATE", "DLC_HEIST_FINALE_SOUNDSET", true)
    Wait(1500)
    FreezeEntityPosition(playerPed, false)
end

RegisterNetEvent('qb-starterpack:client:showRules', function()
    local result = exports.ox_lib:alertDialog({
        header = Config.Rules.header,
        content = Config.Rules.text,
        centered = true, cancel = true,
        labels = { confirm = Config.Rules.button.submit, cancel = Config.Rules.button.cancel }
    })
    if result == 'confirm' then
        PlayClaimAnimation()
        QBCore.Functions.Notify("Terima kasih telah setuju. Sedang memproses paket Anda...", "success", 7000)
        TriggerServerEvent('qb-starterpack:server:beriPaket')
    else
        QBCore.Functions.Notify("Anda harus menyetujui peraturan untuk mengklaim paket.", "error")
    end
end)

RegisterNetEvent('qb-starterpack:client:spawnVehicle', function(vehicleModel, plate)
    print('^3[CLIENT-SIDE] MENERIMA PERINTAH SPAWN MOBIL^7')
    local playerPed = PlayerPedId()
    local spawnPoint = Config.Vehicle.spawnPoint
    QBCore.Functions.Notify("Kendaraan Anda sedang disiapkan...", "primary", 5000)
    QBCore.Functions.SpawnVehicle(vehicleModel, function(vehicle)
        SetVehicleNumberPlateText(vehicle, plate)
        SetEntityHeading(vehicle, spawnPoint.w)
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(vehicle))
        SetVehicleEngineOn(vehicle, true, true)
        QBCore.Functions.Notify("Selamat menikmati kendaraan baru Anda!", "success", 8000)
    end, spawnPoint, true)
end)