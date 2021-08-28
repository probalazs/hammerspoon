config = require("../config")

local module = {}

module.choice = {
    ["text"] = "Goto meeting room",
    ["action"] = "GOTO_MEETING_ROOM"
}

function module.run()
    libs.showDailog(config.meetingRooms, function(choice)
        hs.urlevent.openURL("https://emarsys.zoom.us/j/" .. choice.id)
    end)
end

return module
