# create-signal

Fast, lightweight event emitter for Luau.

Benchmarked vs SignalPlus:

| Operation | createSignal | SignalPlus |
|-----------|-------------|------------|
| create | 128ns | 141ns |
| connect | 444ns | 678ns |
| fire (1 listener) | 769ns | 823ns |
| fire (10 listeners) | 7884ns | 7800ns |
| disconnect | 156ns | 233ns |

## Install

```toml
[dependencies]
createSignal = "sap0bombado/create-signal@1.4.2"
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
| `wait` | `() -> T...` | Yield until the signal fires, returns the args |
| `disconnectAll` | `() -> ()` | Remove all listeners |
| `destroy` | `() -> ()` | Disconnect all and clear the signal table |

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

