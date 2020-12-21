local RunService = game:GetService("RunService")

local modules = {}

local function getInstanceFromPath(path, root)
    local locations = string.split(path, "/")

    local index = 1
    local currentLocation = root
    local nextLocation = currentLocation:FindFirstChild(locations[index])

    while nextLocation and index ~= #locations do
        index += 1
        currentLocation = nextLocation
        nextLocation = currentLocation:FindFirstChild(locations[index])
    end

    local lastLocation = locations[#locations]

    -- If last location has a ? on the end, see if it is a descendant.
    if not nextLocation and string.sub(lastLocation, #lastLocation) == "?" then
        local Location = string.sub(lastLocation, 1, #lastLocation - 1) -- Remove ? from location.

        nextLocation = Location:FindFirstChild(Location, true)
    end

	return nextLocation
end

local function requireByName(name)
    if modules[name] ~= nil then
        return require(modules[name])
    else
        error("Module `" .. name .. "` does not exist.")
    end
end

local import = {}

function import.addPath(name, root)
    if import[name] ~= nil then
        error("Cannot add an import path with name `" .. name .. "`.")
    end

    import[name] = function(path)
        local result = getInstanceFromPath(path, root)

        if result ~= nil then
            return result
        else
            error("Could not find instance at path `" .. path .. "` in `" .. name .. "`.")
        end
    end
end

function import.addImportPath(name, root)
    if import[name] ~= nil then
        error("Cannot add an import path with name `" .. name .. "`.")
    end

    import[name] = function(path)
        local result = getInstanceFromPath(path, root)

        if result ~= nil then
            return require(result)
        else
            error("Could not find instance at path `" .. path .. "` in `" .. name .. "`.")
        end
    end
end

function import.addModule(module)
    if modules[module.Name] == nil then
        modules[module.Name] = module
    else
        warn("Two or more modules with name `" .. module.Name .. "` already exist. Try renaming them.")
    end
end

function import.addLocation(root)
    for _, child in ipairs(root:GetChildren()) do
        if child:IsA("ModuleScript") then
            import.addModule(child)
        else
            import.addLocation(child)
        end
    end
end

function import.descendant(parent, path)
    local module = getInstanceFromPath(path, parent)

    if module ~= nil then
        return require(module)
    end
end

function import.client(name)
    if RunService:IsClient() then
        return requireByName(name)
    end
end

function import.server(name)
    if RunService:IsServer() then
        return requireByName(name)
    end
end

function import.__call(_, name)
    return requireByName(name)
end

return setmetatable(import, import)