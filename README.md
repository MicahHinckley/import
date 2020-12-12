# Import

Importing example:
```lua
local import = require(...)

import.addLocation(game.ReplicatedStorage.Source)

import("Hello") -- requires game.ReplicatedStorage.Source.Hello
```

Importing instance at path example:
```lua
local import = require(...)

import.addPath("asset", game.ReplicatedStorage.Assets)

import.asset("Images/Button") -- returns game.ReplicatedStorage.Assets.Images.Button
```

Requiring module from path example:
```lua
local import = require(...)

import.addImportPath("module", game.ReplicatedStorage.Modules)

import.module("Extras/Bye") -- require game.ReplicatedStorage.Modules.Extras.Bye
```

Extra tip:
You can import a descendant from a path by adding a ? at the end.
Example: "Images/Button?"
