local module = {}

module.choice = {
    ["text"] = "Reload hammerspoon config",
    ["action"] = "RELOAD_HAMMERSPOON_CONFIG"
}

function module.run() hs.reload() end

return module
