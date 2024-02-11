fx_version 'cerulean'
game 'gta5'

author 'Selim'
description 'A small drift addon'
version '0.0.1'

lua54 "yes"


shared_script {
	'config.lua'
}

client_script {
	'client/main.lua'
}
server_script {
	'server/main.lua'
}