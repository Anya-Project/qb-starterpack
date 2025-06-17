
local function SendToDiscord(playerData)
 
    if not Config.Discord.enabled or Config.Discord.webhook == "url_webhook" or Config.Discord.webhook == "" then 
        return 
    end

    local playerName = playerData.PlayerData.charinfo.firstname .. " " .. playerData.PlayerData.charinfo.lastname
    local citizenId = playerData.PlayerData.citizenid
    local license = playerData.PlayerData.license 


    local embed = {
        {
            ["title"] = "✅ Starter Pack Berhasil Diklaim!",
            ["description"] = "**" .. playerName .. "** baru saja bergabung dan menerima paket pemula.",
            ["type"] = "rich",
            ["color"] = 3066993, 
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
                    ["name"] = "Lisensi Akun", 
                    ["value"] = "||" .. license .. "||", 
                    ["inline"] = false
                }
            },
            ["footer"] = {
                ["text"] = "QS Starter Pack Log"
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S.000Z")
        }
    }

   
    PerformHttpRequest(Config.Discord.webhook, function(err, text, headers) 
        if err ~= 204 and err ~= 200 then
            print('^1[qb-starterpack] Gagal mengirim log ke Discord. Error: ' .. err .. '^7')
        end
    end, 'POST', json.encode({username = "Log Server", embeds = embed}), { ['Content-Type'] = 'application/json' })
end


exports('SendDiscordLog', SendToDiscord)