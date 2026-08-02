# create-input

Roblox `UserInputService` wrapper. Get a `Signal` that fires only for the input you specify.

## Install

```toml
[dependencies]
createInput = "sap0bombado/create-input@0.1.1"
```

**Dependencies:** `create-signal@1.3.0`, `create-scope@0.1.1`

## API

### `createInput(input, state?, gameProcessed?) -> Signal<InputObject>`

| Param | Type | Default | Description |
|-------|------|---------|-------------|
| `input` | `Enum.KeyCode \| Enum.UserInputType` | (required) | Key or input type |
| `state` | `Enum.UserInputState?` | `Begin` | Input state to match |
| `gameProcessed` | `boolean?` | `false` | Include game-processed inputs |

Returns a `Signal<InputObject>` with `.connect()`, `.once()`, `.fire()`, `.wait()`, `.disconnectAll()`.

## Example

```lua
local onJump = createInput(Enum.KeyCode.Space)
onJump:connect(function(inputObject)
    print("Jump!")
end)

local onClick = createInput(Enum.UserInputType.MouseButton1, Enum.UserInputState.End)
onClick:connect(function()
    print("Click released")
end)
```
