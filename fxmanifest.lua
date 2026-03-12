fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'percilator.'
description 'Car Rental'
version '1.0.0'

shared_scripts {
   '@ox_lib/init.lua',
   'config.lua',
   'vehicles.lua'
}

client_scripts {
   'client.lua'
}

server_scripts {
   'server.lua'
}
