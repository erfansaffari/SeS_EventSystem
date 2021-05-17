fx_version 'bodacious'
game 'gta5'

description 'New Event System By Faridz'
author '<FaridZ/>#9360'
version '1.0.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@essentialmode/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua'
}

dependencies {
	'mysql-async',
	'essentialmode'
}

