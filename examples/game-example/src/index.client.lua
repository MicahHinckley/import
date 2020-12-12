local ReplicatedStorage = game:GetService("ReplicatedStorage")

local import = require(ReplicatedStorage:WaitForChild("import"))

import.addLocation(ReplicatedStorage.Client)
import.addLocation(ReplicatedStorage.Shared)

import.addPath("resource", ReplicatedStorage.Resources)

import("Hello")()
import("Bye")()

print(import.resource("Assets/Part1"))

import.resource("Assets/Part3")