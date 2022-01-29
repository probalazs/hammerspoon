local module = {}

function module.run(connectionName, username, code)
    spoon.Tunnelblick.connection_name = connectionName
    spoon.Tunnelblick.username = username
    spoon.Tunnelblick.password_fn = function() return code end
    spoon.Tunnelblick:connect()
end

return module
