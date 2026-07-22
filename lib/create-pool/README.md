## Basic Usage
```luau
--!strict
local createPool = require("@pkg/createPool")

local pool = createPool(
	32, -- preAlloc size

	-- create function
	function()
		return Instance.new("Part")
	end,
	-- optional reset function
	function(part: Part)
		part.Parent = nil
		part.Position = Vector3.zero
	end
)

-- Acquire an object from the pool
local part = pool()
part.Position = Vector3.new(0, 10, 0)

-- Return the object back to the pool
pool(part)

-- Reuse the same object later
local reusedPart = pool()
print(reusedPart.Position) -- 0, 0, 0

-- Cleanup Pool:
for _, part in pool:collect() do
	task.defer(part.Destroy, part)
end
pool:clear()

```

## Install
Add as a Wally dependency:
```toml
createPool = "sap0bombado/create-pool@0.3.1"
```