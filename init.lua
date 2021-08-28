libs = require("libs")

goToMeetingRoom = require("actions.go-to-meeting-room")
connectToEmarsysVpn = require("actions.connect-to-emarsys-vpn")
restartWifi = require("actions.restart-wifi")
openLaas = require("actions.open-laas")
openProject = require("actions.open-project")
openKibana = require("actions.open-kibana")
getSecrets = require("actions.get-secrets")
openMysqlDatabase = require("actions.open-mysql-database")
reloadHammerspoonConfig = require("actions.reload-hammerspoon-config")

hs.loadSpoon("SpoonInstall")

spoon.SpoonInstall:andUse("Tunnelblick")

local getChoices = function(actions)
    local choices = {}
    for _, action in pairs(actions) do table.insert(choices, action.choice) end
    return choices;
end

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "P", function()
    local actions = {
        goToMeetingRoom, openProject, connectToEmarsysVpn, openLaas, openKibana,
        getSecrets, openMysqlDatabase, restartWifi, reloadHammerspoonConfig
    }
    libs.showDailog(getChoices(actions), function(choice)
        for _, action in pairs(actions) do
            if action.choice.action == choice.action then
                action.run()
            end
        end
    end)
end)

