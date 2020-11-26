--< Services >--
local RunService = game:GetService("RunService")

--< Variables >--
local Modules = {}

--< Functions >--
local function GetInstanceFromPath(path, root)
    local Locations = string.split(path, "/")

    local Index = 1
    local CurrentLocation = root
    local NextLocation = CurrentLocation:FindFirstChild(Locations[Index])

    while NextLocation and Index ~= #Locations do
        Index += 1
        CurrentLocation = NextLocation
        NextLocation = CurrentLocation:FindFirstChild(Locations[Index])
    end

    local LastLocation = Locations[#Locations]

    -- If last location has a ? on the end, see if it is a descendant
    if not NextLocation and string.sub(LastLocation, #LastLocation) == "?" then
        local Location = string.sub(LastLocation, 1, #LastLocation - 1) -- Remove ?

        NextLocation = Location:FindFirstChild(Location, true)
    end

	return NextLocation
end

--< Function >--
local function Require(name)
    if Modules[name] then
        return require(Modules[name])
    else
        error("Module `" .. name .. "` does not exist.")
    end
end

--< Module >--
local Import = {}

function Import.AddPath(name, root)
    if Import[name] then
        error("Cannot add an import path with name `" .. name .. "`.")
    end

    Import[name] = function(path)
        local Result = GetInstanceFromPath(path, root)

        if Result then
            return Result
        else
            error("Could not find instance at path `" .. path .. "` in `" .. name .. "`.")
        end
    end
end

function Import.AddImportPath(name, root)
    if Import[name] then
        error("Cannot add an import path with name `" .. name .. "`.")
    end

    Import[name] = function(path)
        local Result = GetInstanceFromPath(path, root)

        if Result then
            return require(Result)
        else
            error("Could not find instance at path `" .. path .. "` in `" .. name .. "`.")
        end
    end
end

function Import.AddModule(module)
    if Modules[module.Name] == nil then
        Modules[module.Name] = module
    else
        warn("Two or more modules with name `" .. module.Name .. "` already exist. Try renaming them.")
    end
end

function Import.AddLocation(root)
    for _, child in ipairs(root:GetChildren()) do
        if child:IsA("ModuleScript") then
            Import.AddModule(child)
        else
            Import.AddLocation(child)
        end
    end
end

function Import.Client(name)
    if RunService:IsClient() then
        return Require(name)
    end
end

function Import.Server(name)
    if RunService:IsServer() then
        return Require(name)
    end
end

function Import.__call(_, name)
    return Require(name)
end

return setmetatable(Import, Import)