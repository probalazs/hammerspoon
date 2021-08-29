config = require("../config")

local module = {}

module.choice = {["text"] = "Get secrets", ["action"] = "GET_SECRETS"}

function module.run()
    local output = cache.getCacheOr("secrets", function()
        return hs.execute(
                   "kubectl get secrets -n " .. config.secrets.namespace ..
                       " -o json", true)
    end)
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

return module
