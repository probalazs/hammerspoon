local libs = {}

function libs.enum (tbl)
  local length = #tbl
  for i = 1, length do
    local v = tbl[i]
    tbl[v] = i
  end
  return tbl
end

function libs.showDailog (choices, callback)
  local chooser = hs.chooser.new(function (choice)
    if choice ~= nil
    then
      callback(choice)
    end
  end)
  chooser:searchSubText(true)
  chooser:choices(choices)
  chooser:show()
end

return libs