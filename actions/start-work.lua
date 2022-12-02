local module = {}

function module.run()
  local applicationNames = { 'zoom.us', 'Slack', 'Microsoft Outlook' }
  for index in pairs(applicationNames) do hs.application.open(applicationNames[index]) end
end

return module
