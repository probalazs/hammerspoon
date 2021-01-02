hs.loadSpoon("SpoonInstall")

spoon.SpoonInstall:andUse("Tunnelblick")

hs.urlevent.bind("hammerspoon-reload", function()
  hs.reload()
end)

hs.urlevent.bind("hammerspoon-console", function()
  hs.toggleConsole()
end)

hs.urlevent.bind("hammerspoon-restart", function()
  hs.relaunch()
end)

hs.urlevent.bind("wifi-restart", function()
  hs.wifi.setPower(false)
  hs.wifi.setPower(true)
end)

hs.urlevent.bind("vpn-connect", function(eventName, params)
  spoon.Tunnelblick.connection_name = params.connection
  spoon.Tunnelblick.username = params.username
  spoon.Tunnelblick.password_fn = function() return params.password end
  spoon.Tunnelblick:connect()
end)
