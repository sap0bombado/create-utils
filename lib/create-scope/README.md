## Basic Usage
```luau
local createScope = require("@pkg/createScope")

-- Create a scope (optionally pass the alloc size and/or initial items)
local scope, part = createScope(6, Instance.new("Part"), ...)

-- Track an Instance (will call :Destroy())
local part = scope(Instance.new("Part"))
part.Parent = workspace

-- Track a connection directly (will call :Disconnect())
local conn = scope(RunService.Heartbeat:Connect(function(dt)
	print("Heartbeat", dt)
end))

-- Track a cleanup function (will be called)
scope(function()
	print("Custom cleanup ran")
end)

-- Track a thread
local thread = scope(task.spawn(function()
	while true do
		task.wait(1)
	end
end))

-- When you're done, call with no args to clean everything
scope()
```

## Install
Add as a Wally dependency:
```toml
createScope = "sap0bombado/create-scope@0.1.1"
```