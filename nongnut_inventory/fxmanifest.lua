fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'
shared_scripts {
	'@nongnut_trunkdata/config.lua',
    'config/config.lua',
    'config/config.*.lua',
    'config/functions/*.lua'
}
client_scripts {
    'client/*.lua',
    'client/modules/*.lua'
}
server_scripts{
	'@oxmysql/lib/MySQL.lua',
    'server/*.lua',
    'server/modules/*.lua'
}
ui_page {
	'html/index.html'
}
files {
	'html/**.*',
}