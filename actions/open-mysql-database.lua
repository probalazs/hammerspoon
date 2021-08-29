config = require("../config")
libs = require("../libs")

local module = {}

module.choice = {
    ["text"] = "Open mysql database",
    ["action"] = "OPEN_MYSQL_DATABASE"
}

local getAllDatabases = function()
    local output = cache.getCacheOr("databases", function()
        return hs.execute("ssh -t devmgmt1 '/usr/local/sbin/database.sh -l'",
                          true)
    end)
    local databases = {}
    for database in output:gmatch("([^\n]*)\n?") do
        table.insert(databases, database)
    end
    return databases
end

local getFilteredDatabases = function(databases)
    return hs.fnutils.filter(databases, function(database)
        return libs.startsWith(database, "  ")
    end)
end

local getDatabaseChoices = function(databases)
    return hs.fnutils.map(databases, function(database)
        return {["text"] = database:gsub("^%s*(.-)%(.*%)%s*$", "%1")}
    end)
end

local openTerminal = function(database)
    hs.osascript.applescript([[
    tell application "]] .. config.terminal .. [["
      create window with default profile command "]] ..
                                 "ssh -t devmgmt1 '/usr/local/sbin/database.sh " ..
                                 database .. "'" .. [["
    end tell
  ]])
end

function module.run()
    local filteredDatabases = getFilteredDatabases(getAllDatabases())
    libs.showDailog(getDatabaseChoices(filteredDatabases),
                    function(choice) openTerminal(choice.text) end)
end

return module
