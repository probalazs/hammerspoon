config = require('../config')

local module = {}

function module.run()
  function module.run() libs.showDailog(config.pages, function(choice) hs.urlevent.openURL(choice.url) end) end
end

return module
