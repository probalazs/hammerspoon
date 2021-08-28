config = require("../config")
libs = require("../libs")

local module = {}

module.choice = {
    ["text"] = "Open mysql database",
    ["action"] = "OPEN_MYSQL_DATABASE"
}

function module.run()
    local output = hs.execute(
                       "ssh -t devmgmt1 '/usr/local/sbin/database.sh -l'", true)
    local choices = {}
    for line in output:gmatch("([^\n]*)\n?") do
        if libs.startsWith(line, "  ") then
            table.insert(choices,
                         {["text"] = line:gsub("^%s*(.-)%(.*%)%s*$", "%1")})
        end
    end
    libs.showDailog(choices, function(choice)
        hs.osascript.applescript([[
          tell application "]] .. config.terminal .. [["
            create window with default profile command "]] ..
                                     "ssh -t devmgmt1 '/usr/local/sbin/database.sh " ..
                                     choice.text .. "'" .. [["
          end tell
        ]])
    end)
end

return module
