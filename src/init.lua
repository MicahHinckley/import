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
    if modules[name] then
        return require(modules[name])
    else
        error("Module `" .. name .. "` does not exist.")
    end
end

--< Module >--
local Import = {}

function Import.addPath(name, root)
    if Import[name] then
        error("Cannot add an import path with name `" .. name .. "`.")
    end

    Import[name] = function(path)
        local result = getInstanceFromPath(path, root)

        if result then
            return result
        else
            error("Could not find instance at path `" .. path .. "` in `" .. name .. "`.")
        end
    end
end

function Import.addImportPath(name, root)
    if Import[name] then
        error("Cannot add an import path with name `" .. name .. "`.")
    end

    Import[name] = function(path)
        local result = getInstanceFromPath(path, root)

        if result then
            return require(result)
        else
            error("Could not find instance at path `" .. path .. "` in `" .. name .. "`.")
        end
    end
end

function Import.addModule(module)
    if modules[module.Name] == nil then
        modules[module.Name] = module
    else
        warn("Two or more modules with name `" .. module.Name .. "` already exist. Try renaming them.")
    end
end

function Import.addLocation(root)
    for _, child in ipairs(root:GetChildren()) do
        if child:IsA("ModuleScript") then
            Import.addModule(child)
        else
            Import.addLocation(child)
        end
    end
end

function Import.client(name)
    if RunService:IsClient() then
        return requireByName(name)
    end
end

function Import.server(name)
    if RunService:IsServer() then
        return requireByName(name)
    end
end

function Import.__call(_, name)
    return requireByName(name)
end

return setmetatable(Import, Import)