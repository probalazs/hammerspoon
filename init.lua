hs.urlevent.bind("reload", function()
  hs.reload()
end)

hs.urlevent.bind("console", function()
  hs.toggleConsole()
end)

hs.urlevent.bind("restart", function()
  hs.relaunch()
end)

hs.urlevent.bind("wifi-restart", function()
  hs.wifi.setPower(false)
  hs.wifi.setPower(true)
end)
