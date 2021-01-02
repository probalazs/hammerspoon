hs.urlevent.bind("wifi-restart", function()
  hs.wifi.setPower(false)
  hs.wifi.setPower(true)
end)
