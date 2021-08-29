local module = {}

module.choice = {["text"] = "Kibana", ["action"] = "OPEN_KIBANA"}

function module.run()
    local response = cache.getCacheOr("kibana", function()
        local _, data = hs.http.post(
                            "http://eslb.emar.sys:9200/kibana-int/dashboard/_search",
                            hs.json.encode({
                ["query"] = {["query_string"] = {["query"] = "title:*"}},
                ["size"] = 200
            }), {["Accept"] = "application/json"})
        return data
    end)
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

return module
