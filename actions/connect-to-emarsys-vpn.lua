config = require("../config")

local module = {}

module.choice = {
    ["text"] = "Connect emarsys vpn",
    ["action"] = "CONNECT_EMARSYS_VPN"
}

function module.run()
    local _, code = hs.dialog.textPrompt("Enter the 2FA code", "")
    spoon.Tunnelblick.connection_name = config.vpn.connectionName
    spoon.Tunnelblick.username = config.vpn.username
    spoon.Tunnelblick.password_fn = function() return code end
    spoon.Tunnelblick:connect()
end

return module
