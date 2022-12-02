local module = {}

function module.showDailog(choices, callback)
  local chooser = hs.chooser.new(function(choice) if choice ~= nil then callback(choice) end end)
  chooser:searchSubText(true)
  chooser:choices(choices)
  chooser:show()
end

function module.contains(list, searchedValue)
  for _, value in pairs(list) do if value == searchedValue then return true end end
  return false
end

function module.urlencode(url)
  if url == nil then return end
  url = url:gsub("\n", "\r\n")
  url = url:gsub("([^%w ])", function(char) return string.format("%%%02X", string.byte(char)) end)
  url = url:gsub(" ", "+")
  return url
end

function module.startsWith(str, start) return str:sub(1, #start) == start end

function module.endsWith(str, ending) return ending == "" or str:sub(-#ending) == ending end

return module
