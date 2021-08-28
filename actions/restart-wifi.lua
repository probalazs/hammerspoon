local module = {}

function module.run()
    hs.wifi.setPower(false)
    hs.wifi.setPower(true)
end

return module
