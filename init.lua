connectToVpn = require('actions.connect-to-vpn')
reloadHammerspoon = require('actions.reload-hammerspoon-config')
restartWifi = require('actions.restart-wifi')
startWork = require('actions.start-work')
stopWork = require('actions.stop-work')
openPage = require('actions.open-page')
libs = require('libs')

hs.loadSpoon('SpoonInstall')
spoon.SpoonInstall:andUse('Tunnelblick')
spoon.SpoonInstall:andUse(
    'TextClipboardHistory', {
      disable = false,
      config = { show_in_menubar = false, paste_on_select = true },
      hotkeys = { toggle_clipboard = { { 'cmd', 'shift' }, 'v' } },
      start = true
    }
)

local actions = {
  OPEN_PAGE = { text = 'Open page', module = openPage },
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
