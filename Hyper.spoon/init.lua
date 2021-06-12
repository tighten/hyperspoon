local obj = {}
obj.__index = obj

function frontApp()
    return hs.application.frontmostApplication():bundleID()
end

function focusedWindowIs(bundle)
    return hs.window.focusedWindow():application():bundleID() == bundle
end

hyperKeys = {}

hyper = {
    appToMap = '',
}

function firstOrInsert(mappings, key)
    if (mappings[key]) then
        return mappings[key]
    end

    mappings[key] = {}
    return mappings[key]
end

function hyper:mode(mode, mappings)
    for target, action in pairs(mappings) do
        firstOrInsert(hyperKeys, mode)
        firstOrInsert(hyperKeys[mode], target)
        firstOrInsert(hyperKeys[mode][target], self.appToMap)
        hyperKeys[mode][target][self.appToMap] = action
    end
    return self
end

function hyper:app(app)
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.appToMap = app
    return o
end

hs.urlevent.bind('hyper', function(_, params)
    command = hyperKeys[params.mode][params.target][frontApp()]
    if (command == nil) then
        command = hyperKeys[params.mode][params.target]['default']
    end

    if (command ~= nil) then
        command()
    end
end)

return obj
