config = require("config")
libs = require("libs")

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

function openProject()
    local choices = {}
    for projectFolder in hs.fs.dir(config.projects.folder) do
        if not libs.contains({".DS_Store", ".", ".."}, projectFolder) then
            table.insert(choices, {
                ["text"] = projectFolder,
                ["project"] = projectFolder
            })
        end
    end
    libs.showDailog(choices, function(choice)
        hs.execute(config.projects.editor .. " " .. config.projects.folder ..
                       "/" .. choice.project)
    end)
end

function openKibana()
    local _, response = hs.http.post(
                            "http://eslb.emar.sys:9200/kibana-int/dashboard/_search",
                            hs.json.encode({
            ["query"] = {["query_string"] = {["query"] = "title:*"}},
            ["size"] = 200
        }), {["Accept"] = "application/json"})
    local choices = {}
    for _, index in pairs(hs.json.decode(response).hits.hits) do
        table.insert(choices,
                     {["text"] = index._id, ["id"] = libs.urlencode(index._id)})
    end
    libs.showDailog(choices, function(choice)
        hs.urlevent.openURL(
            "http://kibana.emar.sys/#/dashboard/elasticsearch/" .. choice.id)
    end)
end

function getSecrets()
    local output = hs.execute("kubectl get secrets -n " ..
                                  config.secrets.namespace .. " -o json", true)
    local choices = {}
    for _, item in pairs(hs.json.decode(output).items) do
        if not libs.endsWith(item.metadata.name, "-web") and
            not libs.endsWith(item.metadata.name, "-backup") and
            not libs.endsWith(item.metadata.name, "-tls") and
            not libs.endsWith(item.metadata.name, "-jobs") and
            not libs.endsWith(item.metadata.name, "-cert") and
            not libs.startsWith(item.metadata.name, "default-token") then
            table.insert(choices, {
                ["text"] = item.metadata.name,
                ["id"] = item.metadata.name
            })
        end
    end
    libs.showDailog(choices, function(choice)
        local output = hs.execute(
                           "kubectl get secret " .. choice.id .. " -n " ..
                               config.secrets.namespace .. " -o json", true)
        local secrets = {}
        for name, value in pairs(hs.json.decode(output).data) do
            table.insert(secrets, {
                ["text"] = name,
                ["subText"] = hs.base64.decode(value)
            })
        end
        libs.showDailog(secrets, function(secret)
            hs.pasteboard.setContents(secret.subText)
        end)
    end)
end
