# create-scope

Resource cleanup. Track Instances, connections, threads, and functions — clean them all at once by calling `scope()`.

## Install

```toml
[dependencies]
createScope = "sap0bombado/create-scope@0.1.1"
```

## API

### `createScope(size?, ...) -> (Scope, T...)`

| Param | Type | Description |
|-------|------|-------------|
| `size` | `number?` | Initial capacity |
| `...` | `T...` | Initial items to track (returned as extra values) |

### `Scope`

Callable: `scope(item) -> item` tracks an item; `scope()` cleans up all items.

Cleans items by type: Instance (`:Destroy`), RBXScriptConnection (`:Disconnect`), function (call it), thread (`task.cancel`), table (tries common cleanup methods like `:Destroy`, `:Disconnect`, etc.).

## Example

```lua
local scope = createScope()

local part = scope(Instance.new("Part"))
part.Parent = workspace

local conn = scope(RunService.Heartbeat:Connect(function(dt)
    print("Heartbeat", dt)
end))

scope(function()
    print("Custom cleanup")
end)

-- Clean everything
scope()
```

## License

MIT