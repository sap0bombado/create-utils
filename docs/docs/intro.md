# create-utils

Collection of lightweight Luau utility libraries for Roblox.

Each library exports a single `create*` factory function — no classes, no inheritance, just closures and tables.

---

## Libraries

### [create-signal](./create-signal)
Fast event emitter with `connect`, `once`, `fire`, `wait`, and cleanup.

### [create-scope](./create-scope)
Resource cleanup. Track Instances, connections, threads, and functions — clean them all at once.

### [create-pool](./create-pool)
Object pool. Pre-allocate and reuse objects to reduce GC pressure.

### [create-input](./create-input)
Roblox `UserInputService` wrapper. Get a `Signal` that fires only for the input you specify.

### [create-throttle](./create-throttle)
Time-based rate limiter with dynamic interval.

---

## Install

Add individual libraries to your `wally.toml`:

```toml
[dependencies]
createSignal = "sap0bombado/create-signal@1.3.0"
createScope = "sap0bombado/create-scope@0.1.1"
createPool = "sap0bombado/create-pool@0.3.1"
createInput = "sap0bombado/create-input@0.1.1"
createThrottle = "sap0bombado/create-throttle@0.2.0"
```

---

## License

MIT © Diego Bandeira