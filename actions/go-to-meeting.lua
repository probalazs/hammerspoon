config = require('../config')

local module = {}

function module.run()
  libs.showDailog(
      config.meetingRooms, function(choice) hs.urlevent.openURL('https://emarsys.zoom.us/j/' .. choice.id) end
  )
end

return module
