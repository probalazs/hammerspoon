local namespace = "editor"

local module = {}

local getAllServices = function()
  local output = cache.getCacheOr(
      "secrets", function() return hs.execute("kubectl get secrets -n " .. namespace .. " -o json", true) end
  )
  return hs.json.decode(output).items
end

local getFilteredServices = function(services)
  return hs.fnutils.filter(
      services, function(service)
        return not libs.endsWith(service.metadata.name, "-web") and not libs.endsWith(service.metadata.name, "-backup") and
                   not libs.endsWith(service.metadata.name, "-tls") and
                   not libs.endsWith(service.metadata.name, "-jobs") and
                   not libs.endsWith(service.metadata.name, "-cert") and
                   not libs.startsWith(service.metadata.name, "default-token")
      end
  )
end

local getServiceChoices = function(services)
  return hs.fnutils.map(
      services, function(service) return {["text"] = service.metadata.name, ["id"] = service.metadata.name} end
  )
end

local getSecrets = function(serviceName)
  local output = hs.execute("kubectl get secret " .. serviceName .. " -n " .. namespace .. " -o json", true)
  return hs.json.decode(output).data
end

local getSecretChoices = function(secrets)
  local choices = {}
  for name, value in pairs(secrets) do table.insert(choices, {["text"] = name, ["subText"] = hs.base64.decode(value)}) end
  return choices
end

function module.run()
  local services = getFilteredServices(getAllServices())
  libs.showDailog(
      getServiceChoices(services), function(choice)

        libs.showDailog(
            getSecretChoices(getSecrets(choice.id)), function(secret)
              hs.pasteboard.setContents(secret.subText)
            end
        )
      end
  )
end

return module
