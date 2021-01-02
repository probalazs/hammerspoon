hs.urlevent.bind("reload", function()
  hs.reload()
end)

hs.urlevent.bind("console", function()
  hs.toggleConsole()
end)

hs.urlevent.bind("restart", function()
  hs.relaunch()
end)