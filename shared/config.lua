--[[ 
    QB-StarterPack
    version: 1.0.4
    author: AnyaProject
    Discord: https://discord.gg/anyaproject
]]--

Config = {}

Config.Inventory = 'qb'  -- Pilih 'qb' atau 'ox' sesuai dengan inventory yang digunakan

-- Pengaturan NPC
Config.NPC = {
    model = 's_m_y_swat_01',
    coords = vector4(-239.88, -989.92, 29.29, 249.91),
}

-- Pengaturan Target (interaksi)
Config.Target = {
    label = 'Klaim Paket Pemula',
    icon = 'fas fa-gift',
}

-- ITEM Starter Pack
Config.StarterPack = {
    Money = { cash = 5000, bank = 10000 },
    Items = {
        { name = 'phone', amount = 1 },
        { name = 'water_bottle', amount = 5 },
        { name = 'sandwich', amount = 5 },
    }
}


Config.Vehicle = {
    enabled = true,
    model = 'sultan',
    spawnMethod = 'spawn', -- Opsi: 'spawn' atau 'garage'
    garage = 'pillboxgarage', -- Nama garasi jika spawnMethod = 'garage'
    spawnPoint = vector4(-225.5, -961.65, 29.2, 155.29), -- Lokasi spawn jika spawnMethod = 'spawn'
}


-- Pesan Notifikasi
Config.Pesan = {
    sukses = 'Selamat! Anda telah menerima paket Starterpack Anda.',
    sudah_klaim = 'Anda sudah pernah mengklaim paket ini.',
}

-- Konfigurasi untuk UI Peraturan / Rules UI
Config.Rules = {
    header = "PERATURAN KOTA",
    text = "Selamat datang di kota kami! Sebelum melanjutkan, harap baca dan setujui peraturan di bawah ini:\n\n" ..
           "1. **Dilarang RDM & VDM:** Dilarang keras membunuh atau menabrak pemain lain tanpa alasan roleplay yang jelas.\n\n" ..
           "2. **Fear RP:** Hargai nyawa Anda. Jika Anda ditodong senjata, Anda harus bersikap takut dan mengikuti perintah.\n\n" ..
           "3. **Metagaming & Powergaming:** Dilarang menggunakan informasi dari luar game (OOC) ke dalam game (IC).\n\n" ..
           "Dengan menekan tombol 'Setuju', Anda mengonfirmasi bahwa Anda telah membaca, memahami, dan akan mematuhi semua peraturan yang berlaku di kota ini.",
    button = {
        submit = "Setuju & Klaim",
        cancel = "Tolak"
    }
}

-- Konfigurasi Log Discord
Config.Discord = {
    enabled = false, --false untuk menonaktifkan log
    webhook = "Url_webhook" 
}

-- Konfigurasi Klaim Mingguan / Weekly Claim
Config.WeeklyClaim = {
    enabled = true,
    cooldown_days = 7,
    itemsToGive = 2, 
    RewardPool = {
        { name = 'sandwich', amount = 5 },
        { name = 'water_bottle', amount = 5 },
        { name = 'lockpick', amount = 3 },
        { name = 'advancedlockpick', amount = 1 },
        { name = 'bandage', amount = 4 },
        { name = 'money-roll', amount = 1 }, 
        { name = 'goldbar', amount = 1 }, 
    },
    Pesan = {
        sukses = "Anda berhasil mengklaim hadiah mingguan Anda! Sampai jumpa minggu depan.",
        tunggu = "Anda baru bisa mengklaim lagi dalam: ",
        penuh = "Inventaris Anda penuh! Coba lagi nanti.",
    }
}