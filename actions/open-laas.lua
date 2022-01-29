cache = require("..cache")

module.choice = {["text"] = "Laas", ["action"] = "OPEN_LAAS"}

local getIndexes = function()
    local response = cache.getCacheOr("laas", function()
        local _, data = hs.http.get(
                            "https://laas-kibana.service.emarsys.net/api/saved_objects/?type=index-pattern&fields=title&per_page=10000",
                            {["Accept"] = "application/json"})
        return data
    end)
    return hs.json.decode(response).saved_objects
end

local getIndexChoices = function(indexes)
    return hs.fnutils.map(indexes, function(index)
        return {
            ["text"] = index.attributes.title,
            ["id"] = libs.urlencode(index.id)
        }
    end)
end

function module.run()
    libs.showDailog(getIndexChoices(getIndexes()), function(choice)
        hs.urlevent.openURL(
            "https://laas-kibana.service.emarsys.net/app/kibana#/discover?_g=()&_a=(columns:!(_source),index:" ..
                choice.id ..
                ",interval:auto,query:(match_all:()),sort:!('@timestamp',desc))")
    end)
end

return module
