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
