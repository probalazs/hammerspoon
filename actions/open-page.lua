config = require("../config")

local module = {}

module.choice = {["text"] = "Open page", ["action"] = "OPEN_PAGE"}

function module.run()

    function module.run()
        libs.showDailog(config.pages,
                        function(choice) hs.urlevent.openURL(choice.url) end)
    end
end

return module
