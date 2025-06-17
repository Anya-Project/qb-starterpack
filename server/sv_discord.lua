-- server/sv_discord.lua
-- File ini HANYA berisi semua logika yang berhubungan dengan Discord.

-- Fungsi untuk mengirim pesan ke Discord Webhook
local function SendToDiscord(playerData)
    -- Cek apakah fitur diaktifkan dan URL webhook sudah diisi
    if not Config.Discord.enabled or Config.Discord.webhook == "URL_WEBHOOK_KAMU_DI_SINI" or Config.Discord.webhook == "" then 
        return 
    end

    local playerName = playerData.PlayerData.charinfo.firstname .. " " .. playerData.PlayerData.charinfo.lastname
    local citizenId = playerData.PlayerData.citizenid
    local license = playerData.PlayerData.license -- Ini adalah identifier unik per akun, bagus untuk dilog

    -- Membuat 'embed' (pesan dengan format khusus yang cantik)
    local embed = {
        {
            ["title"] = "✅ Starter Pack Berhasil Diklaim!",
            ["description"] = "**" .. playerName .. "** baru saja bergabung dan menerima paket pemula.",
            ["type"] = "rich",
            ["color"] = 3066993, -- Warna hijau
            ["fields"] = {
                {
                    ["name"] = "Nama Karakter",
                    ["value"] = playerName,
                    ["inline"] = true
                },
                {
                    ["name"] = "Citizen ID",
                    ["value"] = citizenId,
                    ["inline"] = true
                },
                {
                    ["name"] = "Lisensi Akun", -- Menambahkan ini sangat berguna untuk admin
                    ["value"] = "||" .. license .. "||", -- Menggunakan spoiler agar tidak terlalu panjang
                    ["inline"] = false
                }
            },
            ["footer"] = {
                ["text"] = "QS Starter Pack Log"
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S.000Z")
        }
    }

    -- Mengirim data ke URL webhook
    PerformHttpRequest(Config.Discord.webhook, function(err, text, headers) 
        if err ~= 204 and err ~= 200 then
            print('^1[qb-starterpack] Gagal mengirim log ke Discord. Error: ' .. err .. '^7')
        end
    end, 'POST', json.encode({username = "Log Server", embeds = embed}), { ['Content-Type'] = 'application/json' })
end

-- Membuat 'export' agar fungsi ini bisa dipanggil dari file lain
exports('SendDiscordLog', SendToDiscord)