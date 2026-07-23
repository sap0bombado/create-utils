# create-scope

RAII-style resource cleanup. Track Instances, connections, threads, functions, and tables with cleanup methods — then clean them all at once by calling `scope()` with no arguments.

## Install

```toml
[dependencies]
createScope = "sap0bombado/create-scope@0.1.1"
```

## API

### `createScope(size?, ...) -> (Scope, T...)`

| Param | Type | Description |
|-------|------|-------------|
| `size` | `number?` | Pre-allocate memory for N items |
| `...` | `T...` | Initial items to track (returned as extra values) |

### `Scope`

Callable: `scope(item) -> item` tracks an item; `scope()` cleans up all items.

Cleanup dispatch order:

1. **Table** — tries `:Destroy()`, `:Clear()`, `:Delete()`, `:StopAll()`, `:Stop()`, `:DisconnectAll()`, `:Disconnect()`, `:Unbind()`, `:RemoveAll()`, `:Remove()` (case-insensitive first-letter variant too)
2. **Instance** — calls `:Destroy()`
3. **RBXScriptConnection** — calls `:Disconnect()`
4. **function** — calls it directly
5. **thread** — calls `task.cancel()`
6. Unknown — warns with traceback

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