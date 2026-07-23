# create-utils

[![Docs](https://img.shields.io/badge/docs-site-green)](https://sap0bombado.github.io/create-utils/)

Collection of lightweight Luau utility libraries for Roblox.

Each library exports a single `create*` factory function that returns a callable object — no classes, no inheritance, just closures and tables.

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

## Libraries

| Library | Version | Description |
|---------|---------|-------------|
| [create-signal](lib/create-signal) | 1.3.0 | Fast Signal implementation |
| [create-scope](lib/create-scope) | 0.1.1 | Cleanup resource |
| [create-pool](lib/create-pool) | 0.3.1 | Object pool |
| [create-input](lib/create-input) | 0.1.1 | Roblox UserInputService Wrapper |
| [create-throttle](lib/create-throttle) | 0.2.0 | Rate limiter |

## License

MIT © Diego Bandeira