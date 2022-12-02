connectToVpn = require('actions.connect-to-vpn')
reloadHammerspoon = require('actions.reload-hammerspoon-config')
restartWifi = require('actions.restart-wifi')
startWork = require('actions.start-work')
stopWork = require('actions.stop-work')

hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall:andUse("Tunnelblick")

hs.urlevent.bind(
    "open-emarsys-vpn", function(_, params) connectToVpn.run(params.connection, params.user, params.code) end
)

hs.urlevent.bind("reload-hammerspoon-config", function() reloadHammerspoon.run() end)

hs.urlevent.bind("restart-wifi", function() restartWifi.run() end)

hs.urlevent.bind("start-work", function() startWork.run() end)

hs.urlevent.bind("stop-work", function() stopWork.run() end)
