local module = {}

local isFolderExist = function(folder)
    local fileHandle, strError = io.open(folder .. "\\*.*", "r")
    if fileHandle ~= nil then
        io.close(fileHandle)
        return true
    end
    return not string.match(strError, "No such file or directory")
end

local getFileContent = function(path)
    local file = io.open(path, "rb")
    if not file then return nil end
    local content = file:read("*a")
    file:close()
    return content
end

local setFileContent = function(path, content)
    local file = io.open(path, "w")
    file:write(content)
    file:close()
end

local getCacheFolder = function()
    return hs.fs.temporaryDirectory() .. "hs-" .. os.date("%Y%m%d")
end

local setCache = function(file, content)
    local folder = getCacheFolder()
    if not isFolderExist(folder) then hs.fs.mkdir(folder) end
    setFileContent(folder .. "/" .. file, content)
end

local getCache = function(file)
    return getFileContent(getCacheFolder() .. "/" .. file)
end

function module.clear() hs.execute("rm -rf " .. getCacheFolder()) end

function module.getCacheOr(cacheKey, callback)
    local cachedContent = getCache(cacheKey)
    if cachedContent ~= nil then return cachedContent end
    local data = callback()
    setCache(cacheKey, data)
    return data
end

return module
