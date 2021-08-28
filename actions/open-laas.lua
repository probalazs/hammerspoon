local module = {}

function module.run()
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

return module
