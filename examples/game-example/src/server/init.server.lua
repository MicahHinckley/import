--< Services >--
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

--< Modules >--
local Import = require(ReplicatedStorage.Import)

--< Start >---
Import.AddLocation(ServerScriptService.Server)
Import.AddLocation(ReplicatedStorage.Shared)