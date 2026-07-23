# create-signal

Fast, lightweight event emitter for Luau.

## Install

```toml
[dependencies]
createSignal = "sap0bombado/create-signal@1.3.0"
```

## API

### `createSignal<T...>() -> Signal<T...>`

Creates a new signal.

### `Signal<T...>`

| Method | Signature | Description |
|--------|-----------|-------------|
| `connect` | `(callback: (T...) -> ()) -> Connection` | Register a listener |
| `once` | `(callback: (T...) -> ()) -> Connection` | Register a one-shot listener |
| `fire` | `(...: T...) -> ()` | Fire the signal |
| `wait` | `() -> T...` | Yield until the signal fires |
| `disconnectAll` | `() -> ()` | Remove all listeners |
| `destroy` | `() -> ()` | Disconnect all and clear the signal |

### `Connection`

| Field/Method | Type | Description |
|-------------|------|-------------|
| `connected` | `boolean` | Whether the connection is still active |
| `disconnect` | `() -> ()` | Disconnect this listener |

## Example

```lua
local signal = createSignal<<(string, number)>>()

signal:connect(function(name, age)
    print(name, age)
end)

signal:fire("John", 23)
```