config = require("../config")

local module = {}

module.choice = {
    ["text"] = "Get random team member",
    ["action"] = "GET_RANDOM_TEAM_MEMBER"
}

function module.run()
    local index = math.random(0 ~ (#config.teamMembers - 1))
    hs.alert.show(config.teamMembers[index])
end

return module
