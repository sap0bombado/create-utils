## Basic Usage
```luau
local createInput = require("@pkg/createInput")

createInput(Enum.KeyCode OR Enum.UserInputType, Enum.UserInputState?, gameProcessed?): createSignal.Signal

local conn = createInput(Enum.UserInputType.MouseButton1, Enum.UserInputState.End, ):connect(function(inputObject: InputObject)
    print('Click! ', inputObject)
end)
```

## Install
Add as a Wally dependency:

```toml
createInput = "sap0bombado/create-input@0.1.0"
```