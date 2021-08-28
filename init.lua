config = require("config")
libs = require("libs")

hs.loadSpoon("SpoonInstall")

spoon.SpoonInstall:andUse("Tunnelblick")

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "P", function()
    local Actions = libs.enum({
        "GOTO_MEETING_ROOM", "OPEN_LAAS", "CONNECT_EMARSYS_VPN", "RESTART_WIFI"
    })
    local choices = {
        {["text"] = "Goto meeting room", ["action"] = Actions.GOTO_MEETING_ROOM},
        {
            ["text"] = "Connect emarsys vpn",
            ["action"] = Actions.CONNECT_EMARSYS_VPN
        }, {["text"] = "Laas", ["action"] = Actions.OPEN_LAAS},
        {["text"] = "Restart wifi", ["action"] = Actions.RESTART_WIFI}
    }
    libs.showDailog(choices, function(choice)
        local actions = {
            [Actions.RESTART_WIFI] = restartWifi,
            [Actions.OPEN_LAAS] = openLaas,
            [Actions.GOTO_MEETING_ROOM] = goToMeetingRoom,
            [Actions.CONNECT_EMARSYS_VPN] = connectToEmarsysVpn
        }
        actions[choice.action]()
    end)
end)

function goToMeetingRoom()
    libs.showDailog(config.meetingRooms, function(choice)
        hs.urlevent.openURL("https://emarsys.zoom.us/j/" .. choice.id)
    end)
end

function connectToEmarsysVpn()
    local _, code = hs.dialog.textPrompt("Enter the 2FA code", "")
    spoon.Tunnelblick.connection_name = config.vpn.connectionName
    spoon.Tunnelblick.username = config.vpn.username
    spoon.Tunnelblick.password_fn = function() return code end
    spoon.Tunnelblick:connect()
end

function restartWifi()
    hs.wifi.setPower(false)
    hs.wifi.setPower(true)
end

function openLaas()
    local _, response = hs.http.get(
                            "https://laas-kibana.service.emarsys.net/api/saved_objects/?type=index-pattern&fields=title&per_page=10000",
                            {["Accept"] = "application/json"})
    local choices = {}
    for _, index in pairs(hs.json.decode(response).saved_objects) do
        table.insert(choices,
                     {["text"] = index.attributes.title, ["id"] = index.id})
    end
    libs.showDailog(choices, function(choice)
        hs.urlevent.openURL(
            "https://laas-kibana.service.emarsys.net/app/kibana#/discover?_g=()&_a=(columns:!(_source),index:" ..
                choice.id ..
                ",interval:auto,query:(match_all:()),sort:!('@timestamp',desc))")
    end)
end
