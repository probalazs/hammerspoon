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

local actions = {
  { text = 'Open page', module = openPage },
  { text = 'Go to meeting', module = goToMeeting },
  { text = 'Connect emarsys vpn', module = connectToVpn },
  { text = 'Start work', module = startWork },
  { text = 'Stop work', module = stopWork },
  { text = 'Reload hammerspoon config', module = reloadHammerspoon },
  { text = 'Restart WiFi', module = restartWifi },
}

local getChoices = function(actions)
  local choices = {}
  for _, action in pairs(actions) do
    table.insert(choices, { text = action.text })
  end
  return choices;
end

hs.hotkey.bind(
    { 'cmd', 'alt', 'ctrl' }, 'P',
        function() libs.showDailog(getChoices(actions), function(choice)
            for _, action in pairs(actions) do
                if action.text == choice.text then
                    action.module.run()
                end
            end
        end)
    end
)
