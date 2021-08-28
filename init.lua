config = require("config")
libs = require("libs")

goToMeetingRoom = require("actions.go-to-meeting-room")
connectToEmarsysVpn = require("actions.connect-to-emarsys-vpn")
restartWifi = require("actions.restart-wifi")
openLaas = require("actions.open-laas")
openProject = require("actions.open-project")
openKibana = require("actions.open-kibana")
getSecrets = require("actions.get-secrets")

hs.loadSpoon("SpoonInstall")

spoon.SpoonInstall:andUse("Tunnelblick")

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "P", function()
    local Actions = libs.enum({
        "GOTO_MEETING_ROOM", "OPEN_LAAS", "CONNECT_EMARSYS_VPN", "RESTART_WIFI",
        "OPEN_PROJECT", "OPEN_KIBANA", "GET_SECRETS"
    })
    local choices = {
        {["text"] = "Goto meeting room", ["action"] = Actions.GOTO_MEETING_ROOM},
        {["text"] = "Open project", ["action"] = Actions.OPEN_PROJECT},
        {
            ["text"] = "Connect emarsys vpn",
            ["action"] = Actions.CONNECT_EMARSYS_VPN
        }, {["text"] = "Laas", ["action"] = Actions.OPEN_LAAS},
        {["text"] = "Kibana", ["action"] = Actions.OPEN_KIBANA},
        {["text"] = "Get secrets", ["action"] = Actions.GET_SECRETS},
        {["text"] = "Restart wifi", ["action"] = Actions.RESTART_WIFI}
    }
    libs.showDailog(choices, function(choice)
        local actions = {
            [Actions.RESTART_WIFI] = restartWifi,
            [Actions.OPEN_LAAS] = openLaas,
            [Actions.OPEN_KIBANA] = openKibana,
            [Actions.GOTO_MEETING_ROOM] = goToMeetingRoom,
            [Actions.OPEN_PROJECT] = openProject,
            [Actions.GET_SECRETS] = getSecrets,
            [Actions.CONNECT_EMARSYS_VPN] = connectToEmarsysVpn
        }
        actions[choice.action].run()
    end)
end)
