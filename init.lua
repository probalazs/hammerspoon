connectToVpn = require('actions.connect-to-vpn')
reloadHammerspoon = require('actions.reload-hammerspoon-config')
restartWifi = require('actions.restart-wifi')
startWork = require('actions.start-work')
stopWork = require('actions.stop-work')
libs = require('libs')

hs.loadSpoon('SpoonInstall')
spoon.SpoonInstall:andUse('Tunnelblick')

hs.urlevent.bind(
    'open-emarsys-vpn', function(_, params) connectToVpn.run(params.connection, params.user, params.code) end
)

hs.urlevent.bind('reload-hammerspoon-config', function() reloadHammerspoon.run() end)

hs.urlevent.bind('restart-wifi', function() restartWifi.run() end)

hs.urlevent.bind('start-work', function() startWork.run() end)

hs.urlevent.bind('stop-work', function() stopWork.run() end)

local actions = {
  CONNECT_EMAPRSYS_VPN = { text = 'Connect emarsys vpn', module = connectToVpn },
  RESTART_WIFI = { text = 'Restart WiFi', module = restartWifi },
  RELOAD_HAMMERSPOON_CONFIG = { text = 'Reload hammerspoon config', module = reloadHammerspoon },
  START_WORK = { text = 'Start work', module = startWork },
  STOP_WORK = { text = 'Stop work', module = stopWork }
}

local getChoices = function(actions)
  local choices = {}
  for action, module in pairs(actions) do table.insert(choices, { text = module.text, value = action }) end
  return choices;
end

hs.hotkey.bind(
    { 'cmd', 'alt', 'ctrl' }, 'P',
        function() libs.showDailog(getChoices(actions), function(choice) actions[choice.value].module.run() end) end
)
