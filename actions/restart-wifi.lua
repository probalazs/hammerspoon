local module = {}

module.choice = {["text"] = "Restart wifi", ["action"] = "RESTART_WIFI"}

function module.run()
    hs.wifi.setPower(false)
    hs.wifi.setPower(true)
end

return module
