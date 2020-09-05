--< Services >--
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--< Modules >--
local Import = require(ReplicatedStorage:WaitForChild("Import"))

--< Start >---
Import.AddLocation(ReplicatedStorage.Client)
Import.AddLocation(ReplicatedStorage.Shared)

Import.AddPath("Resource", ReplicatedStorage.Resources)

Import("Hello")()
Import("Bye")()

print(Import.Resource("Assets/Part1"))

Import.Resource("Assets/Part3")