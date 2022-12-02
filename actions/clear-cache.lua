cache = require('../cache')

local module = {}

module.choice = {['text'] = 'Clear cache', ['action'] = 'CLEAR_CACHE'}

function module.run() cache.clear() end

return module
