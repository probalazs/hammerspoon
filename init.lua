connectToVpn = require('actions.connect-to-vpn')
reloadHammerspoon = require('actions.reload-hammerspoon-config')
restartWifi = require('actions.restart-wifi')
startWork = require('actions.start-work')
stopWork = require('actions.stop-work')
openPage = require('actions.open-page')
goToMeeting = require('actions.go-to-meeting')
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
spoon.SpoonInstall:andUse(
    'Seal', {
      hotkeys = { show = { { 'cmd', 'alt', 'ctrl', 'shift' }, 'space' } },
      fn = function(seal)
        seal:loadPlugins({ 'apps', 'calc', 'useractions' })
        seal.plugins.apps.appSearchPaths = {
          '/Applications', '/System/Applications', '~/Applications', '/Developer/Applications'
        }
        seal.plugins.useractions.actions = {
          ['Open page'] = { fn = openPage.run },
          ['Go to meeting'] = { fn = goToMeeting.run },
          ['Connect to vpn'] = { fn = connectToVpn.run },
          ['Start work'] = { fn = startWork.run },
          ['Stop work'] = { fn = stopWork.run },
          ['Reload hammerspoon config'] = { fn = reloadHammerspoon.run },
          ['Restart WiFi'] = { fn = restartWifi.run }
        }
        seal:refreshAllCommands()
        seal.plugins.apps:restart()
      end,
      start = true
    }
)
