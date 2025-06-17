

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'AnyaProject'
description 'Starter Pack QBcore'
version '1.0.4-tested'


dependencies {
    'qb-core',
    'qb-target',
    'ox_lib',
    'oxmysql'
}

shared_script 'shared/config.lua'

client_script 'client/main.lua'


server_scripts {
    '@oxmysql/lib/MySQL.lua', 
    
    'server/sv_discord.lua',
    'server/main.lua'
}