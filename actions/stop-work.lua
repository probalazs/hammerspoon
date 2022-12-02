local module = {}

function module.run()
  local applicationNames = { 'zoom.us', 'Slack', 'Microsoft Outlook' }
  for applicationIndex in pairs(applicationNames) do
    local application = hs.application.get(applicationNames[applicationIndex])
    if application ~= nil then application:kill() end
  end
end

return module
