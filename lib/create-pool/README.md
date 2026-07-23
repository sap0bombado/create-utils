# create-pool

Object pool.

## Install

```toml
[dependencies]
createPool = "sap0bombado/create-pool@0.3.1"
```

## API

### `createPool<T>(preAllocSize, createFn, resetFn?) -> Pool<T>`

| Param | Type | Description |
|-------|------|-------------|
| `preAllocSize` | `number` | Initial pool capacity |
| `createFn` | `() -> T` | Factory for new objects |
| `resetFn` | `((T) -> ())?` | Optional reset function called on return |

### `Pool<T>`

Callable: `pool() -> T` acquires an object; `pool(obj)` returns it.

| Method | Signature | Description |
|--------|-----------|-------------|
| `pool()` | `() -> T` | Acquire an object |
| `pool(obj)` | `(T) -> ()` | Return an object to the pool |
| `collect` | `() -> { T }` | Get the underlying pool table |
| `clear` | `() -> ()` | Empty the pool |

## Example

```lua
local pool = createPool(32, function()
    return Instance.new("Part")
end, function(part)
    part.Parent = nil
    part.Position = Vector3.zero
end)

local part = pool()
part.Position = Vector3.new(0, 10, 0)
pool(part)

-- Cleanup
for _, v in pool:collect() do
    v:Destroy()
end
pool:clear()
```

## License

MIT