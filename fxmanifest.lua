fx_version 'adamant'
games { 'gta5' }

author "Reyghita Hafizh Firmanda"

ui_page "html/ui.html"

shared_scripts {
	"@ox_lib/init.lua",
	"@cloudv/modules/utils.lua",
	"config.lua"
}

client_scripts {
	"@cloudv/modules/playerdata.lua",
	"client.lua",
}

files {
	"html/ui.html",
	"html/rm.css",
	"html/rm.js"
}

lua54 "yes"