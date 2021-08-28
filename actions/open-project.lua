config = require("../config")

local module = {}

function module.run()
    local choices = {}
    for projectFolder in hs.fs.dir(config.projects.folder) do
        if not libs.contains({".DS_Store", ".", ".."}, projectFolder) then
            table.insert(choices, {
                ["text"] = projectFolder,
                ["project"] = projectFolder
            })
        end
    end
    libs.showDailog(choices, function(choice)
        hs.execute(config.projects.editor .. " " .. config.projects.folder ..
                       "/" .. choice.project)
    end)
end

return module
