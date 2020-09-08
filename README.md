# Import

Importing example:
```lua
local Import = require(...)

Import.AddLocation(game.ReplicatedStorage.Source)

Import("Hello") -- requires game.ReplicatedStorage.Source.Hello
```

Importing instance at path example:
```lua
local Import = require(...)

Import.AddPath("Asset", game.ReplicatedStorage.Assets)

Import.Asset("Images/Button") -- returns game.ReplicatedStorage.Assets.Images.Button
```

Requiring module from path example:
```lua
local Import = require(...)

Import.AddImportPath("Module", game.ReplicatedStorage.Modules)

Import.Module("Extras/Bye") -- require game.ReplicatedStorage.Modules.Extras.Bye
```

Extra tip:
You can import a descendant from a path by adding a ? at the end.
Example: "Images/Button?"
