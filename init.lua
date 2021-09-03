libs = require("libs")

hs.loadSpoon("SpoonInstall")

spoon.SpoonInstall:andUse("Tunnelblick")

local actions = {
    require("actions.go-to-meeting-room"), require("actions.open-page"),
    require("actions.open-project"), require("actions.connect-to-emarsys-vpn"),
    require("actions.open-laas"), require("actions.open-kibana"),
    require("actions.get-secrets"), require("actions.open-mysql-database"),
    require("actions.restart-wifi"), require("actions.get-random-team-member"),
    require("actions.clear-cache"), require("actions.reload-hammerspoon-config")
}

local getChoices = function(actions)
    local choices = {}
    for _, action in pairs(actions) do table.insert(choices, action.choice) end
    return choices;
end

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "P", function()
    libs.showDailog(getChoices(actions), function(choice)
        for _, action in pairs(actions) do
            if action.choice.action == choice.action then
                action.run()
            end
        end
    end)
end)

