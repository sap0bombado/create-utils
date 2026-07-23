# create-throttle

Time-based rate limiter. Call `throttle()` — returns `true` if enough time has elapsed, `false` otherwise.

## Install

```toml
[dependencies]
createThrottle = "sap0bombado/create-throttle@0.2.0"
```

## API

### `createThrottle(interval, timeFunction?) -> Throttle`

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `interval` | `number` | — | Minimum seconds between allowed calls |
| `timeFunction` | `() -> number` | `os.clock` | Time source |

### `Throttle`

Callable: `throttle() -> boolean` checks if allowed; `throttle(newInterval)` changes the interval.

First call always returns `true`.

## Example

```lua
local throttle = createThrottle(2)

while true do
    task.wait(0.2)
    if throttle() then
        print("Action allowed")
    end
end

-- Change interval dynamically
throttle(0.5)
```

## License

MIT