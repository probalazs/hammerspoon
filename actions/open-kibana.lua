local module = {}

local getIndexes = function()
    local response = cache.getCacheOr("kibana", function()
        local _, data = hs.http.post(
                            "http://eslb.emar.sys:9200/kibana-int/dashboard/_search",
                            hs.json.encode({
                ["query"] = {["query_string"] = {["query"] = "title:*"}},
                ["size"] = 200
            }), {["Accept"] = "application/json"})
        return data
    end)
    return hs.json.decode(response).hits.hits
end

local getIndexChoices = function(indexes)
    return hs.fnutils.map(indexes, function(index)
        return {["text"] = index._id, ["id"] = libs.urlencode(index._id)}
    end)
end

function module.run()
    libs.showDailog(getIndexChoices(getIndexes()), function(choice)
        hs.urlevent.openURL(
            "http://kibana.emar.sys/#/dashboard/elasticsearch/" .. choice.id)
    end)
end

return module
