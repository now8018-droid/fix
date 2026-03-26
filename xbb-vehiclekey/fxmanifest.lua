shared_script "@bt_defender/module/shared.lua"

 

 

fx_version "cerulean"
lua54 'yes'
games {"gta5"}

client_scripts {
	'core/client/main.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'core/server/main.lua',
}

shared_scripts {
	'setting/setting.general.lua',
}

ui_page 'nui/index.html'

files {
	'nui/*',
	'nui/sound/*.ogg'
}
