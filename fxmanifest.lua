fx_version 'adamant'

game 'gta5'

description 'Show ID'

version '1.0.0'

client_scripts {
    'shared/config.lua',
    'client/main.lua'
}

server_scripts {
    '@async/async.lua',
    '@mysql-async/lib/MySQL.lua',
    'shared/config.lua',
    'server/main.lua'
}

ui_page { "html/ui.html" }

files {
    "html/ui.html",
    "html/css/style.css",
    "html/js/app.js",
    "html/images/*.png",
}